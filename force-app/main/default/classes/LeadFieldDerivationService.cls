/**
 * Before-save field defaults. Deliberately simple.
 * MIGRATION: A — Direct Flow Candidate (before-save record-triggered).
 */
public with sharing class LeadFieldDerivationService {
    public static void derive(List<Lead> records) {
        for (Lead l : records) {
            if (String.isBlank(l.Assignment_Status__c)) {
                l.Assignment_Status__c = 'New';
            }
            if (String.isBlank(l.Routing_Priority__c)) {
                l.Routing_Priority__c = String.isBlank(l.Rating) ? 'Medium' : (l.Rating == 'Hot' ? 'High' : 'Low');
            }
            if (String.isBlank(l.Customer_Segment__c) && l.AnnualRevenue != null) {
                if (l.AnnualRevenue >= 10000000) {
                    l.Customer_Segment__c = 'GOLD';
                } else if (l.AnnualRevenue >= 1000000) {
                    l.Customer_Segment__c = 'SILVER';
                } else {
                    l.Customer_Segment__c = 'BRONZE';
                }
            }
            if (l.Visit_Due_Date__c == null && l.Assignment_Status__c == 'Assigned') {
                l.Visit_Due_Date__c = Date.today().addDays(3);
            }
        }
    }
}
