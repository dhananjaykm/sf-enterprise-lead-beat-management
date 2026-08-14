/**
 * Writes application logs for assignment mutations.
 * MIGRATION: E — retain Apex (or use Event Monitoring / big objects, not Flow).
 */
public with sharing class LeadAuditService {
    public static void audit(String action, List<Id> leadIds) {
        ApplicationLogger.info('LeadAuditService', action + ' count=' + (leadIds == null ? 0 : leadIds.size()));
    }
}
