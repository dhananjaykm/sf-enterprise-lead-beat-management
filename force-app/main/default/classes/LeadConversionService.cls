/**
 * Converts qualified leads and stamps visit outcomes.
 * MIGRATION: B — Screen/record-triggered Flow + convertLead Apex Invocable.
 */
public with sharing class LeadConversionService {
    public static Database.LeadConvertResult convert(Id leadId, Id accountId) {
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadId);
        if (accountId != null) {
            lc.setAccountId(accountId);
        }
        lc.setConvertedStatus(convertedStatus());
        return Database.convertLead(lc);
    }

    private static String convertedStatus() {
        LeadStatus status = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        return status.MasterLabel;
    }
}
