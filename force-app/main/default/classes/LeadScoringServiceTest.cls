@IsTest
private class LeadScoringServiceTest {

    @IsTest
    static void scoresLead() {
        Lead l = new Lead(LastName = 'Score', Company = 'Co', Status = 'Open - Not Contacted', AnnualRevenue = 5000000);
        insert l;
        List<Lead> rows = [SELECT Id, AnnualRevenue, NumberOfEmployees, Source_Channel__c, Product_Interest__c, Customer_Segment__c, Lead_Score_Value__c FROM Lead WHERE Id = :l.Id];
        Test.startTest();
        LeadScoringService.score(rows);
        Test.stopTest();
        System.assert(rows[0].Lead_Score_Value__c != null);
    }

    @IsTest
    static void mathEngineNotFlow() {
        System.assert(ScoringMathEngine.recursiveDecay(10, 3) != null);
        System.assertEquals(0, ScoringMathEngine.optimizeBeatLoad(new List<Decimal>(), 2));
    }

}
