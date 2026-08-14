public with sharing class LeadTriggerHandler extends TriggerHandlerBase {
    public override void beforeInsert(List<SObject> newList) {
        List<Lead> leads = (List<Lead>) newList;
        LeadFieldDerivationService.derive(leads);
        LeadPriorityService.apply(leads);
        LeadDuplicateService.flagDuplicates(leads);
    }

    public override void beforeUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {
        List<Lead> leads = (List<Lead>) newList;
        LeadFieldDerivationService.derive(leads);
        LeadPriorityService.apply(leads);
    }

    public override void afterInsert(List<SObject> newList) {
        List<Lead> leads = (List<Lead>) newList;
        LeadScoringService.score(leads);
        LeadAssignmentService.assignLeads(leads);
        VisitPlanningService.plan(leads);
        LeadAuditService.audit('afterInsert', new List<Id>(new Map<Id, Lead>(leads).keySet()));
        TriggerHandlerBase.bypassTriggers = true;
        try {
            update leads;
        } finally {
            TriggerHandlerBase.bypassTriggers = false;
        }
    }

    public override void afterUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {
        List<Lead> toVisit = new List<Lead>();
        for (Lead l : (List<Lead>) newList) {
            Lead oldLead = (Lead) oldMap.get(l.Id);
            if (oldLead.Assignment_Status__c != 'Assigned' && l.Assignment_Status__c == 'Assigned') {
                toVisit.add(l);
            }
        }
        if (!toVisit.isEmpty()) {
            VisitPlanningService.plan(toVisit);
        }
    }
}
