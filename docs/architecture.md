# Architecture

## Patterns present (intentional mix)

1. Trigger → Handler → Service (Lead)
2. Trigger → Utility (LeadPriorityUtilTrigger → LeadAssignmentUtil) — debt
3. Selector → Service (LeadSelector, BeatSelector)
4. Queueable / Batch / Schedulable / @future
5. Invocable Apex (not yet called by Flow)
6. Visualforce consoles and wizards
7. Aura dashboards
8. LWC grids, including Flow-screen-ready components with no Flow deployed

## Layers

- Domain objects: Territory, Beat, Beat Member/Day, Sales Representative, Lead Assignment/Score, Visit
- Automation: Apex only
- Integration: `LeadIntegrationService` mock HTTP
- Audit: `ApplicationLogger` + `Application_Log__c`
