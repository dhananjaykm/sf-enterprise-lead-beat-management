public with sharing class LeadQualificationExtension {
    private final ApexPages.StandardController std;
    public String derivedSummary { get; set; }
    public LeadQualificationExtension(ApexPages.StandardController std) {
        this.std = std;
        Lead l = (Lead) std.getRecord();
        derivedSummary = LeadPriorityService.consolePriority(l.Customer_Segment__c);
    }
    public PageReference saveRelated() {
        std.save();
        return std.view();
    }
}
