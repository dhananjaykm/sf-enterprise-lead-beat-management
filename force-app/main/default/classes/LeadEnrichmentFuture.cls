/**
 * Historical @future callout pattern.
 * MIGRATION: C — Invocable + async Flow path; HTTP remains Apex.
 */
public with sharing class LeadEnrichmentFuture {
    @future(callout=true)
    public static void enrichAsync(Set<Id> leadIds) {
        for (Lead l : LeadSelector.byIds(leadIds)) {
            try {
                LeadIntegrationService.EnrichmentResult r = LeadIntegrationService.enrich(l);
                l.Enrichment_Status__c = r.status;
            } catch (Exception ex) {
                l.Enrichment_Status__c = 'Failed';
                ApplicationLogger.error('LeadEnrichmentFuture', 'enrich failed', ex);
            }
        }
    }
}
