public with sharing class BeatSelector {
    public static List<Beat__c> activeByTerritory(Set<Id> territoryIds) {
        if (territoryIds == null || territoryIds.isEmpty()) {
            return new List<Beat__c>();
        }
        return [
            SELECT Id, Territory__c, Sales_Representative__c, Day_of_Week__c, Status__c, Max_Stops__c, Is_Active__c
            FROM Beat__c
            WHERE Territory__c IN :territoryIds AND Is_Active__c = true AND Status__c = 'Active'
        ];
    }
}
