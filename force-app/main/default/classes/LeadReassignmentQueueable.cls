/**
 * Async reassignment of overloaded reps.
 * MIGRATION: B — could become asynchronous Flow / orchestration + invocable; high volume stays Queueable.
 */
public with sharing class LeadReassignmentQueueable implements Queueable {
    private Set<Id> leadIds;
    public LeadReassignmentQueueable(Set<Id> leadIds) {
        this.leadIds = leadIds;
    }
    public void execute(QueueableContext ctx) {
        List<Lead> leads = LeadSelector.byIds(leadIds);
        for (Lead l : leads) {
            l.Assignment_Status__c = 'Routed';
        }
        LeadAssignmentService.assignLeads(leads);
        update leads;
    }
}
