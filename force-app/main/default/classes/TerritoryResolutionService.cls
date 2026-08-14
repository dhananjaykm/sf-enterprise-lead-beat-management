/**
 * Maps city/state to Territory__c.
 * MIGRATION: A — Get Records on Territory by City/State is a before/after-save Flow.
 */
public with sharing class TerritoryResolutionService {
    public static Map<Id, Territory__c> resolve(List<Lead> leads) {
        Set<String> cities = new Set<String>();
        Set<String> states = new Set<String>();
        for (Lead l : leads) {
            if (String.isNotBlank(l.City)) {
                cities.add(l.City);
            }
            if (String.isNotBlank(l.State)) {
                states.add(l.State);
            }
        }
        List<Territory__c> territories = [
            SELECT Id, Code__c, City__c, State__c, Region__c
            FROM Territory__c
            WHERE Is_Active__c = true AND (City__c IN :cities OR State__c IN :states)
        ];
        Map<Id, Territory__c> result = new Map<Id, Territory__c>();
        for (Lead l : leads) {
            for (Territory__c t : territories) {
                if ((t.City__c != null && t.City__c == l.City) || (t.State__c != null && t.State__c == l.State)) {
                    result.put(l.Id, t);
                    l.Territory_Code__c = t.Code__c;
                    break;
                }
            }
        }
        return result;
    }
}
