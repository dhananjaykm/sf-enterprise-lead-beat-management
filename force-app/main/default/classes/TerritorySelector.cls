public with sharing class TerritorySelector {
    public static List<Territory__c> active() {
        return [
            SELECT Id, Code__c, Region__c, State__c, City__c, Is_Active__c, Manager__c
            FROM Territory__c
            WHERE Is_Active__c = true
        ];
    }

    public static Territory__c byCode(String code) {
        List<Territory__c> rows = [
            SELECT Id, Code__c, Region__c, State__c, City__c
            FROM Territory__c
            WHERE Code__c = :code AND Is_Active__c = true
            LIMIT 1
        ];
        return rows.isEmpty() ? null : rows[0];
    }
}
