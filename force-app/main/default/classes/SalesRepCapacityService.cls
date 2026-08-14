/**
 * Workload-aware rep selection.
 * MIGRATION: B — Flow can orchestrate; capacity math stays Invocable Apex if volume is high.
 */
public with sharing class SalesRepCapacityService {
    public static Map<Id, Sales_Representative__c> pick(List<Lead> leads, Map<Id, Beat__c> beats) {
        Set<Id> beatReps = new Set<Id>();
        for (Beat__c b : beats.values()) {
            if (b.Sales_Representative__c != null) {
                beatReps.add(b.Sales_Representative__c);
            }
        }
        Map<Id, Sales_Representative__c> reps = new Map<Id, Sales_Representative__c>([
            SELECT Id, User__c, Territory__c, Capacity__c, Open_Lead_Count__c, Is_Active__c,
                   Working_Hours_Start__c, Working_Hours_End__c, Segment_Specialty__c
            FROM Sales_Representative__c
            WHERE Is_Active__c = true
        ]);
        Map<Id, Sales_Representative__c> assigned = new Map<Id, Sales_Representative__c>();
        Integer hour = Datetime.now().hour();
        for (Lead l : leads) {
            Beat__c beat = beats.get(l.Id);
            Sales_Representative__c chosen;
            if (beat != null && beat.Sales_Representative__c != null) {
                chosen = reps.get(beat.Sales_Representative__c);
            }
            if (chosen == null) {
                chosen = leastLoaded(reps.values(), l, hour);
            }
            if (chosen != null && chosen.Open_Lead_Count__c < chosen.Capacity__c) {
                assigned.put(l.Id, chosen);
                l.OwnerId = chosen.User__c;
                l.Assignment_Status__c = 'Assigned';
                l.Working_Hours_Eligible__c = hour >= chosen.Working_Hours_Start__c && hour <= chosen.Working_Hours_End__c;
            }
        }
        return assigned;
    }

    private static Sales_Representative__c leastLoaded(List<Sales_Representative__c> reps, Lead l, Integer hour) {
        Sales_Representative__c best;
        for (Sales_Representative__c r : reps) {
            if (!r.Is_Active__c) {
                continue;
            }
            if (best == null || r.Open_Lead_Count__c < best.Open_Lead_Count__c) {
                best = r;
            }
        }
        return best;
    }
}
