/**
 * Selector layer for Lead queries.
 * MIGRATION: G — selectors are not Flow; consuming services may be.
 */
public with sharing class LeadSelector {
    public static List<Lead> byIds(Set<Id> ids) {
        if (ids == null || ids.isEmpty()) {
            return new List<Lead>();
        }
        return [
            SELECT Id, Name, Status, Rating, City, State, PostalCode, OwnerId,
                   Territory_Code__c, Beat__c, Lead_Score_Value__c, Assignment_Status__c,
                   Product_Interest__c, Customer_Segment__c, Visit_Due_Date__c,
                   Duplicate_Flag__c, Routing_Priority__c, Working_Hours_Eligible__c,
                   Source_Channel__c, Enrichment_Status__c, Company, Email, Phone
            FROM Lead
            WHERE Id IN :ids
        ];
    }

    public static List<Lead> unassigned(Integer rowLimit) {
        return [
            SELECT Id, City, State, Product_Interest__c, Customer_Segment__c, Source_Channel__c, Routing_Priority__c
            FROM Lead
            WHERE Assignment_Status__c IN ('New', 'Routed')
            ORDER BY CreatedDate ASC
            LIMIT :rowLimit
        ];
    }
}
