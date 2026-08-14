/**
 * Chooses an active beat in the resolved territory for the weekday.
 * MIGRATION: A — Get Records + Decision. Capacity overflow is B (Invocable).
 */
public with sharing class BeatResolutionService {
    public static Map<Id, Beat__c> resolve(List<Lead> leads, Map<Id, Territory__c> territories) {
        Set<Id> territoryIds = new Set<Id>();
        for (Territory__c t : territories.values()) {
            territoryIds.add(t.Id);
        }
        List<Beat__c> beats = BeatSelector.activeByTerritory(territoryIds);
        String today = datetime.now().format('EEEE');
        Map<Id, Beat__c> result = new Map<Id, Beat__c>();
        for (Lead l : leads) {
            Territory__c t = territories.get(l.Id);
            if (t == null) {
                continue;
            }
            for (Beat__c b : beats) {
                if (b.Territory__c == t.Id && (b.Day_of_Week__c == today || b.Day_of_Week__c == null)) {
                    result.put(l.Id, b);
                    l.Beat__c = b.Id;
                    break;
                }
            }
        }
        return result;
    }
}
