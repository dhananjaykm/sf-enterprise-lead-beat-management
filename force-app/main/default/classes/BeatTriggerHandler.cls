public with sharing class BeatTriggerHandler extends TriggerHandlerBase {
    public override void beforeInsert(List<SObject> newList) {
        for (Beat__c b : (List<Beat__c>) newList) {
            if (String.isBlank(b.Status__c)) {
                b.Status__c = 'Draft';
            }
            if (b.Max_Stops__c == null) {
                b.Max_Stops__c = 20;
            }
        }
    }
}
