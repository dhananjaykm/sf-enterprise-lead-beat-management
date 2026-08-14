@IsTest
private class LeadAssignmentServiceTest {

    @IsTest
    static void assignsLeadPositive() {
        User u = TestDataFactory.createUser('lb1');
        System.runAs(u) {
            Territory__c t = TestDataFactory.createTerritory('CHN-S');
            Sales_Representative__c r = TestDataFactory.createRep(u.Id, t.Id);
            TestDataFactory.createBeat(t.Id, r.Id);
            Test.startTest();
            Lead l = TestDataFactory.createLead('AquaMart');
            Test.stopTest();
            Lead stored = [SELECT Assignment_Status__c, Territory_Code__c FROM Lead WHERE Id = :l.Id];
            System.assertNotEquals(null, stored.Territory_Code__c);
        }
    }

    @IsTest
    static void bulkInsert() {
        User u = TestDataFactory.createUser('lb2');
        System.runAs(u) {
            Territory__c t = TestDataFactory.createTerritory('CHN-N');
            Sales_Representative__c r = TestDataFactory.createRep(u.Id, t.Id);
            TestDataFactory.createBeat(t.Id, r.Id);
            List<Lead> leads = new List<Lead>();
            for (Integer i = 0; i < 200; i++) {
                leads.add(new Lead(LastName = 'L' + i, Company = 'Co' + i, Status = 'Open - Not Contacted', City = 'Chennai'));
            }
            Test.startTest();
            insert leads;
            Test.stopTest();
            System.assertEquals(200, [SELECT COUNT() FROM Lead WHERE Id IN :leads]);
        }
    }

}
