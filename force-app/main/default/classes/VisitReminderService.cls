/**
 * Marks due visits and creates reminder tasks.
 * MIGRATION: A — Scheduled-triggered Flow or scheduled path.
 */
public with sharing class VisitReminderService {
    public static Integer remindDue(Date asOf) {
        List<Visit__c> due = [
            SELECT Id, Lead__c, Sales_Representative__c, Planned_Date__c, Reminder_Sent__c, OwnerId
            FROM Visit__c
            WHERE Status__c = 'Planned' AND Reminder_Sent__c = false AND Planned_Date__c <= :asOf
            LIMIT 200
        ];
        List<Task> tasks = new List<Task>();
        for (Visit__c v : due) {
            v.Reminder_Sent__c = true;
            v.Status__c = 'Reminded';
            tasks.add(new Task(
                Subject = 'Visit reminder',
                ActivityDate = v.Planned_Date__c,
                WhatId = v.Id,
                Status = 'Not Started',
                Priority = 'High'
            ));
        }
        if (!due.isEmpty()) {
            update due;
        }
        if (!tasks.isEmpty()) {
            insert tasks;
        }
        return due.size();
    }
}
