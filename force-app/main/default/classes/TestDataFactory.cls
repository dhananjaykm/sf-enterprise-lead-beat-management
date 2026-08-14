/**
 * Shared test data factory. Tests must not use SeeAllData=true.
 */
@IsTest
public class TestDataFactory {
    public static User createUser(String alias) {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        String unique = alias + String.valueOf(Crypto.getRandomInteger());
        User u = new User(
            Alias = alias.left(8),
            Email = unique + '@example.invalid',
            EmailEncodingKey = 'UTF-8',
            LastName = alias,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = p.Id,
            UserName = unique + '@example.invalid'
        );
        insert u;
        return u;
    }

    public static Account createAccount(String name) {
        Account a = new Account(Name = name);
        insert a;
        return a;
    }


    public static Territory__c createTerritory(String code) {
        Territory__c t = new Territory__c(Code__c = code, Region__c = 'South', City__c = 'Chennai', State__c = 'TN', Is_Active__c = true);
        insert t;
        return t;
    }

    public static Sales_Representative__c createRep(Id userId, Id territoryId) {
        Sales_Representative__c r = new Sales_Representative__c(
            User__c = userId, Territory__c = territoryId, Capacity__c = 20, Open_Lead_Count__c = 0, Is_Active__c = true
        );
        insert r;
        return r;
    }

    public static Beat__c createBeat(Id territoryId, Id repId) {
        Beat__c b = new Beat__c(Territory__c = territoryId, Sales_Representative__c = repId, Day_of_Week__c = 'Monday', Status__c = 'Active', Is_Active__c = true);
        insert b;
        return b;
    }

    public static Lead createLead(String company) {
        Lead l = new Lead(LastName = company, Company = company, Status = 'Open - Not Contacted', City = 'Chennai', State = 'TN');
        insert l;
        return l;
    }

}
