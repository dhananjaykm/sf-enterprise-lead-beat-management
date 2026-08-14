# sf-enterprise-lead-beat-management

Legacy **pro-code** Salesforce implementation for field-sales lead assignment and beat planning.

This org historically solved routing, scoring, visit planning, and reassignment with Apex, Visualforce, Aura, and LWC. **No Salesforce Flow metadata is included.**

## Business scenario

A distribution company assigns inbound leads (web, call center, campaigns, partners, mobile) onto territorial **beats**. Representatives visit prospects according to beat-day plans.

```
Lead Created → Classification → Territory → Beat → Capacity → Scoring → Assignment → Visit → Outcome
```

## What this repo is for

A reverse-engineering POC that asks: *which of this Apex/UI can become Salesforce Flow, and which must remain Apex?*

Ground truth lives in `migration/ground-truth/`.

## Deploy

```bash
sf org create scratch -f config/project-scratch-def.json -a lead-beat
sf project deploy start -o lead-beat
sf org assign permset -n Lead_Beat_Operations -o lead-beat
python3 scripts/seed-data/generate_seed.py
sf data import tree -p scripts/seed-data/sample/import-plan.json -o lead-beat
```

## Architecture

See `docs/architecture.md`. Tests: `sf apex run test --test-level RunLocalTests`.
