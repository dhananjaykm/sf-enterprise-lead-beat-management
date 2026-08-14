/**
 * In-org notifications / chatter-less email stubs.
 * MIGRATION: A — Flow Send Email / Custom Notification.
 */
public with sharing class LeadNotificationService {
    public static void notifyReps(List<Lead_Assignment__c> assignments) {
        Set<Id> repIds = new Set<Id>();
        for (Lead_Assignment__c a : assignments) {
            if (a.Sales_Representative__c != null) {
                repIds.add(a.Sales_Representative__c);
            }
        }
        Map<Id, Sales_Representative__c> reps = new Map<Id, Sales_Representative__c>([
            SELECT Id, User__c FROM Sales_Representative__c WHERE Id IN :repIds
        ]);
        List<Task> tasks = new List<Task>();
        for (Lead_Assignment__c a : assignments) {
            Sales_Representative__c r = reps.get(a.Sales_Representative__c);
            if (r == null || r.User__c == null) {
                continue;
            }
            tasks.add(new Task(
                Subject = 'New lead assigned',
                OwnerId = r.User__c,
                WhoId = a.Lead__c,
                Status = 'Not Started',
                Priority = 'Normal',
                ActivityDate = Date.today()
            ));
        }
        if (!tasks.isEmpty()) {
            insert tasks;
        }
    }
}
