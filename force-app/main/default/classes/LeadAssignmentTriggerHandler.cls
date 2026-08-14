public with sharing class LeadAssignmentTriggerHandler extends TriggerHandlerBase {
    public override void afterInsert(List<SObject> newList) {
        LeadNotificationService.notifyReps((List<Lead_Assignment__c>) newList);
    }
}
