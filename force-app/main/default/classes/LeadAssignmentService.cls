/**
 * Orchestrates classification → territory → beat → capacity → assignment record.
 * MIGRATION: D — orchestration is record-triggered Flow; capacity/scoring stay Apex.
 */
public with sharing class LeadAssignmentService {
    public static void assignLeads(List<Lead> newList) {
        List<Lead> eligible = new List<Lead>();
        for (Lead l : newList) {
            if (l.Assignment_Status__c == 'New' || l.Assignment_Status__c == 'Routed' || l.Id == null) {
                eligible.add(l);
            }
        }
        if (eligible.isEmpty()) {
            return;
        }
        Map<Id, Territory__c> territories = TerritoryResolutionService.resolve(eligible);
        Map<Id, Beat__c> beats = BeatResolutionService.resolve(eligible, territories);
        Map<Id, Sales_Representative__c> reps = SalesRepCapacityService.pick(eligible, beats);
        List<Lead_Assignment__c> assignments = new List<Lead_Assignment__c>();
        List<Lead_Assigned__e> events = new List<Lead_Assigned__e>();
        for (Lead l : eligible) {
            if (!reps.containsKey(l.Id)) {
                continue;
            }
            Sales_Representative__c rep = reps.get(l.Id);
            Beat__c beat = beats.get(l.Id);
            Territory__c ter = territories.get(l.Id);
            assignments.add(new Lead_Assignment__c(
                Lead__c = l.Id,
                Sales_Representative__c = rep.Id,
                Beat__c = beat == null ? null : beat.Id,
                Territory__c = ter == null ? null : ter.Id,
                Status__c = 'Assigned',
                Assigned_On__c = Datetime.now(),
                Reason__c = 'Rule engine assignment'
            ));
            events.add(new Lead_Assigned__e(
                Lead_Id__c = String.valueOf(l.Id),
                Rep_Id__c = String.valueOf(rep.Id),
                Priority__c = l.Routing_Priority__c
            ));
        }
        if (!assignments.isEmpty()) {
            insert assignments;
        }
        if (!events.isEmpty()) {
            EventBus.publish(events);
        }
        ApplicationLogger.info('LeadAssignmentService', 'Assigned ' + assignments.size() + ' leads');
    }
}
