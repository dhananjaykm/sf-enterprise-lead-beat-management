/**
 * Invocable for future Screen Flow / autolaunched Flow.
 * MIGRATION: B — do not rewrite; call from Flow as an Action.
 */
public with sharing class CreateVisitInvocable {
    public class Request {
        @InvocableVariable(required=true)
        public Id leadId;
        @InvocableVariable
        public Date plannedDate;
    }
    public class Response {
        @InvocableVariable
        public Id visitId;
    }
    @InvocableMethod(label='Create Visit' description='Creates a planned visit for a lead')
    public static List<Response> createVisits(List<Request> requests) {
        List<Visit__c> visits = new List<Visit__c>();
        for (Request r : requests) {
            visits.add(new Visit__c(
                Lead__c = r.leadId,
                Planned_Date__c = r.plannedDate == null ? Date.today().addDays(1) : r.plannedDate,
                Status__c = 'Planned',
                Priority__c = 'Medium'
            ));
        }
        insert visits;
        List<Response> out = new List<Response>();
        for (Visit__c v : visits) {
            Response resp = new Response();
            resp.visitId = v.Id;
            out.add(resp);
        }
        return out;
    }
}
