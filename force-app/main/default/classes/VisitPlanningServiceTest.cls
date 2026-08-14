@IsTest
private class VisitPlanningServiceTest {

    @IsTest
    static void plansVisit() {
        Lead l = new Lead(LastName = 'V', Company = 'C', Status = 'Open - Not Contacted', Assignment_Status__c = 'Assigned');
        insert l;
        l.Assignment_Status__c = 'Assigned';
        Test.startTest();
        VisitPlanningService.plan(new List<Lead>{ l });
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Visit__c WHERE Lead__c = :l.Id]);
    }

    @IsTest
    static void reminderNegativeNoneDue() {
        Test.startTest();
        Integer n = VisitReminderService.remindDue(Date.today().addDays(-30));
        Test.stopTest();
        System.assertEquals(0, n);
    }

}
