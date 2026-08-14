/**
 * Mock marketing-cloud / enrichment HTTP callout.
 * MIGRATION: C — Flow orchestration + Invocable Apex callout. Do not put HTTP in Flow.
 */
public with sharing class LeadIntegrationService {
    public class EnrichmentResult {
        public String status;
        public Integer firmographicScore;
    }

    public static EnrichmentResult enrich(Lead l) {
        HttpRequest req = new HttpRequest();
        Integration_Settings__c settings = Integration_Settings__c.getInstance();
        String endpoint = settings != null && settings.Marketing_Endpoint__c != null
            ? settings.Marketing_Endpoint__c
            : 'https://example.invalid/marketing/enrich';
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setTimeout(Integer.valueOf(settings != null && settings.Timeout_Ms__c != null ? settings.Timeout_Ms__c : 5000));
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{"email":"' + String.valueOf(l.Email) + '"}');
        Http http = new Http();
        try {
            HTTPResponse res = http.send(req);
            EnrichmentResult result = new EnrichmentResult();
            result.status = res.getStatusCode() == 200 ? 'Enriched' : 'Failed';
            result.firmographicScore = 50;
            return result;
        } catch (Exception ex) {
            throw new IntegrationException('Enrichment failed: ' + ex.getMessage());
        }
    }
}
