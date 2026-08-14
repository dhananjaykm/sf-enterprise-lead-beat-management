@IsTest
private class InvocableApexTest {

    @IsTest
    static void createVisit() {
        Lead l = new Lead(LastName = 'I', Company = 'C', Status = 'Open - Not Contacted');
        insert l;
        CreateVisitInvocable.Request r = new CreateVisitInvocable.Request();
        r.leadId = l.Id;
        Test.startTest();
        List<CreateVisitInvocable.Response> out = CreateVisitInvocable.createVisits(new List<CreateVisitInvocable.Request>{ r });
        Test.stopTest();
        System.assertNotEquals(null, out[0].visitId);
    }

}
