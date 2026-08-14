@IsTest
private class AsyncApexTest {

    @IsTest
    static void scoringBatch() {
        insert new Lead(LastName = 'B', Company = 'C', Status = 'Open - Not Contacted');
        Test.startTest();
        Database.executeBatch(new LeadScoringBatch(), 50);
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Lead]);
    }

    @IsTest
    static void schedulers() {
        Test.startTest();
        String cron = '0 0 5 * * ?';
        System.schedule('beat-plan', cron, new BeatPlanningScheduler());
        System.schedule('visit-rem', cron, new VisitReminderScheduler());
        Test.stopTest();
        System.assertEquals(2, [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.Name IN ('beat-plan','visit-rem')]);
    }

}
