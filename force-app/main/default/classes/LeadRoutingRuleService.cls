/**
 * Config-driven routing via Lead_Routing_Rule__c.
 * MIGRATION: A/B — rule lookup is Flow-friendly; keep CMDT/custom object as data.
 */
public with sharing class LeadRoutingRuleService {
    public static Map<Id, Lead_Routing_Rule__c> resolve(List<Lead> leads) {
        List<Lead_Routing_Rule__c> rules = [
            SELECT Id, Priority__c, Region__c, Product_Interest__c, Segment__c, Territory__c, Is_Active__c
            FROM Lead_Routing_Rule__c
            WHERE Is_Active__c = true
            ORDER BY Priority__c ASC
        ];
        Map<Id, Lead_Routing_Rule__c> byLead = new Map<Id, Lead_Routing_Rule__c>();
        for (Lead l : leads) {
            for (Lead_Routing_Rule__c rule : rules) {
                if (matches(l, rule)) {
                    byLead.put(l.Id, rule);
                    break;
                }
            }
        }
        return byLead;
    }

    private static Boolean matches(Lead l, Lead_Routing_Rule__c rule) {
        Boolean productOk = String.isBlank(rule.Product_Interest__c) || rule.Product_Interest__c == l.Product_Interest__c;
        Boolean segmentOk = rule.Segment__c == 'ANY' || rule.Segment__c == l.Customer_Segment__c;
        return productOk && segmentOk;
    }
}
