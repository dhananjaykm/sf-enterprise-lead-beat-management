trigger VisitOutcomeTrigger on Visit_Outcome__c (after insert) {
    Set<Id> visitIds = new Set<Id>();
    for (Visit_Outcome__c o : Trigger.new) {
        visitIds.add(o.Visit__c);
    }
    List<Visit__c> visits = [SELECT Id, Status__c FROM Visit__c WHERE Id IN :visitIds];
    for (Visit__c v : visits) {
        v.Status__c = 'Completed';
    }
    update visits;
}
