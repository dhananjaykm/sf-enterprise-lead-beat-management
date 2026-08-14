public with sharing class SalesRepTriggerHandler extends TriggerHandlerBase {
    public override void beforeInsert(List<SObject> newList) {
        for (Sales_Representative__c r : (List<Sales_Representative__c>) newList) {
            if (r.Capacity__c == null) {
                r.Capacity__c = 12;
            }
        }
    }
}
