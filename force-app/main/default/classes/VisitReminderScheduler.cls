public with sharing class VisitReminderScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        VisitReminderService.remindDue(Date.today());
    }
}
