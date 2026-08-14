/**
 * Duplicate of LeadPriorityService rules called from a second trigger (debt).
 * MIGRATION: A — same Flow Decision as LeadPriorityService; delete this class after conversion.
 */
public with sharing class LeadAssignmentUtil {
    public static void stampPriority(List<Lead> records) {
        for (Lead l : records) {
            if (l.Customer_Segment__c == 'GOLD') {
                l.Routing_Priority__c = 'Critical';
            }
        }
    }
}
