public with sharing class NotifySalesRepInvocable {
    public class Request {
        @InvocableVariable(required=true)
        public Id leadId;
        @InvocableVariable
        public String message;
    }
    @InvocableMethod(label='Notify Sales Rep')
    public static void notify(List<Request> requests) {
        List<Task> tasks = new List<Task>();
        for (Request r : requests) {
            tasks.add(new Task(
                Subject = String.isBlank(r.message) ? 'Lead notification' : r.message,
                WhoId = r.leadId,
                Status = 'Not Started',
                ActivityDate = Date.today()
            ));
        }
        insert tasks;
    }
}
