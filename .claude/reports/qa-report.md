# Email Template QA Report

**Scanned:** all brands (95 templates)
**Date:** 2026-02-15 21:54 UTC
**Pass:** 4 | **Warn:** 45 | **Fail:** 46 | **Total issues:** 265

## Summary by Issue Type

| Issue | Files Affected | Priority |
|-------|---------------|----------|
| Missing box-sizing for mobile | 86 | LOW |
| Missing img alt attributes | 73 | MED |
| Missing role=presentation | 41 | LOW |
| AIG branding references | 41 | HIGH |
| Relative image paths | 10 | MED |
| UAT/QA environment URLs | 6 | HIGH |
| @aig.com email domains | 6 | HIGH |
| Legacy {Variable} format | 2 | MED |

## Results by Brand

### expedia/ (8 files: 0 pass, 1 warn, 7 fail)

- ❌ `expedia/ca/en/policy-confirmation.html` — Missing alt on 2 img(s);UAT/QA env URL (L252);Missing box-sizing:border-box for mobile
- ❌ `expedia/ca/fr/policy-confirmation.html` — Missing alt on 3 img(s);UAT/QA env URL (L252);Missing box-sizing:border-box for mobile
- ⚠️ `expedia/hk/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ❌ `expedia/it/en/policy-confirmation.html` — Legacy {vars} (L286,316);Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ❌ `expedia/mx/es/policy-confirmation.html` — AIG branding (L324);Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ❌ `expedia/nz/en/policy-confirmation.html` — Missing alt on 3 img(s);UAT/QA env URL (L256,330);Missing box-sizing:border-box for mobile
- ❌ `expedia/sg/en/policy-confirmation.html` — Missing alt on 2 img(s);UAT/QA env URL (L256,274,306);Missing box-sizing:border-box for mobile
- ❌ `expedia/us/en/policy-confirmation.html` — Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile

### jetstar/ (10 files: 0 pass, 0 warn, 10 fail)

- ❌ `jetstar/au/en/cancel.html` — AIG branding (L5,14,22,23,24);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `jetstar/au/en/policy-confirmation.html` — AIG branding (L5,14,22,23,24);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `jetstar/au/en/post-trip.html` — AIG branding (L5,14,22,23,24);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `jetstar/au/en/pre-trip.html` — AIG branding (L5,14,22,23,24);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `jetstar/nz/en/cancel.html` — AIG branding (L5,14,22,23,24);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `jetstar/nz/en/policy-confirmation.html` — AIG branding (L5,14,22,23,24);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `jetstar/nz/en/post-trip.html` — AIG branding (L5,14,22,23,24);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `jetstar/nz/en/pre-trip.html` — AIG branding (L5,14,22,23,24);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `jetstar/sg/en/policy-confirmation-redesign.html` — AIG branding (L14,22,23,24,224);@aig.com email (L349,349);Missing alt on 2 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `jetstar/sg/en/policy-confirmation.html` — AIG branding (L2,8,31,40,40);@aig.com email (L40,40);Legacy {vars} (L5,5,9);Relative img path (1);Missing role=presentation (3 tables);UAT/QA env URL (L11)

### qantas/ (13 files: 0 pass, 0 warn, 13 fail)

- ❌ `qantas/au/en/amt-expiry.html` — AIG branding (L14,22,23,24,176);Missing alt on 1 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/au/en/au-revisions/amt-expiry.html` — AIG branding (L14,22,23,24);Missing alt on 1 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/au/en/au-revisions/cancel.html` — AIG branding (L14,22,23,24);Missing alt on 1 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/au/en/au-revisions/medical.html` — AIG branding (L14,22,23,24);Missing alt on 1 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/au/en/au-revisions/policy-confirmation.html` — AIG branding (L14,22,23,24,579);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/au/en/au-revisions/pre-trip.html` — AIG branding (L14,22,23,24,565);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/au/en/au-revisions/save-quote.html` — AIG branding (L14,22,23,24,1006);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/au/en/au-revisions/void.html` — AIG branding (L14,22,23,24);Missing alt on 1 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/nz/en/nz-revisions/amt-expiry.html` — AIG branding (L14,22,23,24);Missing alt on 1 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/nz/en/nz-revisions/cancel.html` — AIG branding (L14,22,23,24);Missing alt on 1 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/nz/en/nz-revisions/policy-confirmation.html` — AIG branding (L14,22,23,24);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/nz/en/nz-revisions/pre-trip.html` — AIG branding (L14,22,23,24);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `qantas/nz/en/nz-revisions/void.html` — AIG branding (L14,22,23,24);Missing alt on 1 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile

### row/ (28 files: 1 pass, 27 warn, 0 fail)

- ⚠️ `row/at/de/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/at/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/be/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/be/fr/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/be/nl/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/ca/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/ca/fr/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/ch/de/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/ch/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/ch/fr/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/cz/cs/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/cz/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/de/de/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/de/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/es/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/es/es/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/fr/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/fr/fr/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/it/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/it/it/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/nl/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/nl/nl/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/nz/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/pt/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/pt/pt/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/sg/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile
- ⚠️ `row/uk/en/policy-confirmation.html` — Missing alt on 2 img(s);Missing box-sizing:border-box for mobile

### tg/ (32 files: 2 pass, 17 warn, 13 fail)

- ❌ `tg/admin/us/en/policy-confirmation.html` — AIG branding (L14,22,23,24,182);Missing alt on 4 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/admin/us/en/save-quote.html` — AIG branding (L14,22,23,24);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/agents/us/en/policy-confirmation.html` — AIG branding (L14,22,23,24,182);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/agents/us/en/save-quote.html` — AIG branding (L14,22,23,24);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/ca/en/annual-followup.html` — AIG branding (L14,22,23,24,824);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ⚠️ `tg/ca/en/policy-confirmation.html` — AIG branding (L457,457,476,476);Missing role=presentation (1 tables)
- ❌ `tg/ca/en/post-trip.html` — AIG branding (L14,22,23,24,629);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/ca/en/save-quote.html` — AIG branding (L14,22,23,24);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/it/it/policy-confirmation.html` — AIG branding (L14,22,23,24,145);@aig.com email (L276,276,280,280,286);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/my/en/cancel.html` — AIG branding (L14,22,23,24,208);@aig.com email (L212,212);Missing alt on 2 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/my/en/policy-confirmation.html` — AIG branding (L14,22,23,24,182);@aig.com email (L276,276,281,281,285);Missing alt on 3 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/sg/en/cancel.html` — AIG branding (L14,22,23,24);Missing alt on 2 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/sg/en/policy-confirmation-new.html` — AIG branding (L14,22,23,24);Missing alt on 2 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `tg/sg/en/policy-confirmation.html` — AIG branding (L14,22,23,24);Missing alt on 2 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/fulfillment/eighteen-month.html` — Relative img path (3);Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/fulfillment/six-month-bag.html` — Relative img path (3);Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/fulfillment/six-month-med.html` — Relative img path (2);Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/fulfillment/six-month-trip-can.html` — Relative img path (2);Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/fulfillment/twelve-month.html` — Relative img path (4);Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/fulfillment/two-month-followup.html` — Relative img path (1)
- ⚠️ `tg/us/zurich/fulfillment/two-week-post-trip.html` — Relative img path (5)
- ⚠️ `tg/us/zurich/fulfillment/two-year.html` — Relative img path (5)
- ⚠️ `tg/us/zurich/holiday/cruise-day.html` — Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/holiday/solo-vacation.html` — Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/seasonal-update/cruise-season-2026.html` — Relative img path (5);Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/sponsor/zurich-classic-usatoday1.html` — Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/sponsor/zurich-classic-usatoday2.html` — Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/sponsor/zurich-classic.html` — Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/travel-tips/travel-tips-02-26.html` — Missing box-sizing:border-box for mobile
- ⚠️ `tg/us/zurich/travel-tips/travel-tips-03-26.html` — Missing box-sizing:border-box for mobile

### united/ (4 files: 1 pass, 0 warn, 3 fail)

- ❌ `united/new-policy-confirmation.html` — AIG branding (L14,22,23,24,182);@aig.com email (L256,256,261,261);Missing alt on 3 img(s);Missing role=presentation (5 tables);UAT/QA env URL (L222,267,268);Missing box-sizing:border-box for mobile
- ❌ `united/us/en/post-trip.html` — AIG branding (L14,22,23,24,221);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile
- ❌ `united/us/en/pre-trip.html` — AIG branding (L14,22,23,24);Missing alt on 5 img(s);Missing role=presentation (5 tables);Missing box-sizing:border-box for mobile

---

*Generated by batch-qa.sh — run `.claude/scripts/batch-qa.sh` to refresh.*
