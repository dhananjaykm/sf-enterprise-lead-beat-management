trigger BeatMemberTrigger on Beat_Member__c (before insert, before update) {
    for (Beat_Member__c m : Trigger.new) {
        if (m.Sequence__c == null) {
            m.Sequence__c = 99;
        }
    }
}
