public with sharing class VisitTriggerHandler extends TriggerHandlerBase {
    public override void afterUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {
        List<Task> followUps = new List<Task>();
        for (Visit__c v : (List<Visit__c>) newList) {
            Visit__c oldV = (Visit__c) oldMap.get(v.Id);
            if (oldV.Status__c != 'Completed' && v.Status__c == 'Completed') {
                followUps.add(new Task(
                    Subject = 'Post-visit follow-up',
                    WhatId = v.Id,
                    ActivityDate = Date.today().addDays(2),
                    Status = 'Not Started'
                ));
            }
        }
        if (!followUps.isEmpty()) {
            insert followUps;
        }
    }
}
