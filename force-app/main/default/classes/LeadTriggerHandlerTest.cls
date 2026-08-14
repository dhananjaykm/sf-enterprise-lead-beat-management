@IsTest
private class LeadTriggerHandlerTest {

    @IsTest
    static void beforeInsertDerives() {
        Lead l = new Lead(LastName = 'D', Company = 'C', Status = 'Open - Not Contacted', Rating = 'Hot');
        insert l;
        Lead stored = [SELECT Routing_Priority__c, Assignment_Status__c FROM Lead WHERE Id = :l.Id];
        System.assertNotEquals(null, stored.Assignment_Status__c);
    }

}
