/**
 * Nightly rescoring of open leads.
 * MIGRATION: E — Batch Apex / high-volume. Not Flow.
 */
public with sharing class LeadScoringBatch implements Database.Batchable<SObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, AnnualRevenue, NumberOfEmployees, Source_Channel__c, Product_Interest__c, Customer_Segment__c
            FROM Lead
            WHERE IsConverted = false
        ]);
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        LeadScoringService.score(scope);
        for (Lead l : scope) {
            l.Lead_Score_Value__c = ScoringMathEngine.recursiveDecay(l.Lead_Score_Value__c, 4);
        }
        update scope;
    }
    public void finish(Database.BatchableContext bc) {
        ApplicationLogger.info('LeadScoringBatch', 'completed ' + bc.getJobId());
    }
}
