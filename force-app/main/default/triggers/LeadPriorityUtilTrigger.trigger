/**
 * Legacy pattern: trigger calls a static utility directly (technical debt).
 * MIGRATION: inspect the utility, not this shell.
 */
trigger LeadPriorityUtilTrigger on Lead (before insert, before update) {
    LeadAssignmentUtil.stampPriority(Trigger.new);
}
