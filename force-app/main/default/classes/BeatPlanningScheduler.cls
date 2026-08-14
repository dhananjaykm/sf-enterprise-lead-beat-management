/**
 * Generates Beat_Day__c rows for the coming week.
 * MIGRATION: A — Scheduled-triggered Flow candidate for simple generation; optimizer stays Apex.
 */
public with sharing class BeatPlanningScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        List<Beat__c> beats = [
            SELECT Id, Day_of_Week__c, Is_Active__c FROM Beat__c WHERE Is_Active__c = true
        ];
        List<Beat_Day__c> days = new List<Beat_Day__c>();
        Date start = Date.today();
        for (Integer i = 0; i < 7; i++) {
            Date d = start.addDays(i);
            String dow = datetime.newInstance(d, Time.newInstance(8, 0, 0, 0)).format('EEEE');
            for (Beat__c b : beats) {
                if (b.Day_of_Week__c == dow) {
                    days.add(new Beat_Day__c(Beat__c = b.Id, Planned_Date__c = d, Status__c = 'Planned'));
                }
            }
        }
        if (!days.isEmpty()) {
            insert days;
        }
    }
}
