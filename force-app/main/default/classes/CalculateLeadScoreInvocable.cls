public with sharing class CalculateLeadScoreInvocable {
    public class Request {
        @InvocableVariable(required=true)
        public Id leadId;
    }
    public class Response {
        @InvocableVariable
        public Decimal score;
    }
    @InvocableMethod(label='Calculate Lead Score')
    public static List<Response> calculate(List<Request> requests) {
        Set<Id> ids = new Set<Id>();
        for (Request r : requests) {
            ids.add(r.leadId);
        }
        List<Lead> leads = LeadSelector.byIds(ids);
        LeadScoringService.score(leads);
        update leads;
        Map<Id, Lead> byId = new Map<Id, Lead>(leads);
        List<Response> out = new List<Response>();
        for (Request r : requests) {
            Response resp = new Response();
            resp.score = byId.get(r.leadId) == null ? 0 : byId.get(r.leadId).Lead_Score_Value__c;
            out.add(resp);
        }
        return out;
    }
}
