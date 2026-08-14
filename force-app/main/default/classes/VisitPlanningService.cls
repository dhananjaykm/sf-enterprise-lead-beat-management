/**
 * Creates planned visits after assignment.
 * MIGRATION: A — after-save Flow Create Records + scheduled path for reminder.
 */
public with sharing class VisitPlanningService {
    public static List<Visit__c> plan(List<Lead> leads) {
        List<Visit__c> visits = new List<Visit__c>();
        for (Lead l : leads) {
            if (l.Id == null || l.Assignment_Status__c != 'Assigned') {
                continue;
            }
            Date due = l.Visit_Due_Date__c == null ? Date.today().addDays(2) : l.Visit_Due_Date__c;
            if (DateUtil.isWeekend(due)) {
                due = DateUtil.addBusinessDays(due, 1);
            }
            visits.add(new Visit__c(
                Lead__c = l.Id,
                Beat__c = l.Beat__c,
                Planned_Date__c = due,
                Status__c = 'Planned',
                Priority__c = l.Routing_Priority__c
            ));
        }
        if (!visits.isEmpty()) {
            insert visits;
        }
        return visits;
    }
}
