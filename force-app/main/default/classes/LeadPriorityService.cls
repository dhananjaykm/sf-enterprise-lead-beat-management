/**
 * Hard-coded priority rules duplicated in VF controller (intentional debt).
 * MIGRATION: A — Record-Triggered Flow Decision + Assignment.
 */
public with sharing class LeadPriorityService {
    public static void apply(List<Lead> records) {
        for (Lead l : records) {
            if (l.Customer_Segment__c == 'GOLD' || l.Source_Channel__c == 'Partner') {
                l.Routing_Priority__c = 'Critical';
            } else if (l.Customer_Segment__c == 'SILVER') {
                l.Routing_Priority__c = 'High';
            }
        }
    }

    // Duplicated rule used by Visualforce (do not DRY — debt).
    public static String consolePriority(String segment) {
        if (segment == 'GOLD') {
            return 'Critical';
        }
        return 'Medium';
    }
}
