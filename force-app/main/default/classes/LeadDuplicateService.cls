/**
 * Simple duplicate flag by email/company. Not a matching engine.
 * MIGRATION: A — Flow Get Records + Decision could flag duplicates; keep Apex if fuzzy match is added.
 */
public with sharing class LeadDuplicateService {
    public static void flagDuplicates(List<Lead> records) {
        Set<String> emails = new Set<String>();
        Set<String> companies = new Set<String>();
        for (Lead l : records) {
            if (String.isNotBlank(l.Email)) {
                emails.add(l.Email.toLowerCase());
            }
            if (String.isNotBlank(l.Company)) {
                companies.add(l.Company.toLowerCase());
            }
        }
        Map<String, Id> existingEmail = new Map<String, Id>();
        if (!emails.isEmpty()) {
            for (Lead existing : [
                SELECT Id, Email FROM Lead WHERE Email IN :emails
            ]) {
                if (existing.Email != null) {
                    existingEmail.put(existing.Email.toLowerCase(), existing.Id);
                }
            }
        }
        for (Lead l : records) {
            if (l.Email != null && existingEmail.containsKey(l.Email.toLowerCase()) && existingEmail.get(l.Email.toLowerCase()) != l.Id) {
                l.Duplicate_Flag__c = true;
            }
        }
    }
}
