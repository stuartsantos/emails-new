# Expedia EMEA — Handoff

## Overview

Building 12 new European market policy confirmation emails for Expedia Travel Insurance. Each market has a legacy AIG-branded stub (raw HTML) plus a `.docx` file with updated Travel Guard-branded content. The AT/de template is the reference skeleton — copy it as the base and replace content from each market's docx. AT/de, BE/fr, and BE/nl were already complete before this work began.

## Progress Tracker

| # | Template | Group | Status |
|---|----------|-------|--------|
| 1 | DK/da | A (simple) | DONE |
| 2 | FI/fi | A (simple) | DONE |
| 3 | NL/nl | A (simple) | pending |
| 4 | NO/no | A (simple) | pending |
| 5 | SE/sv | A (simple + Viktig info) | pending |
| 6 | DE/de | C (car rental) | pending |
| 7 | ES/es | C (car rental + postal) | pending |
| 8 | IE/en | D (car rental + cancel, English) | pending |
| 9 | CH/de | B (car rental + cancel) | pending |
| 10 | CH/fr | B (car rental + cancel) | pending |
| 11 | CH/it | B (car rental + cancel) | pending |
| 12 | FR/fr | B (car rental + cancel + regulatory) | pending |

## Template Groups

```
Group A: Simple (no car rental, no cancellation) — 3 remaining
  NL/nl, NO/no, SE/sv
  Structure: intro → coverage → eligibility → pre-trip → contact (3 items) → sign-off
  Note: content order may vary per docx (e.g. DK/da had coverage → pre-trip → eligibility)
  SE adds unique "Viktig information" section at end

Group B: Car rental + cancellation — 4 templates
  CH/de, CH/fr, CH/it, FR/fr
  Structure: intro → coverage → eligibility (general + travel + car rental) → pre-trip → contact (4 items: questions, emergency, claims, cancellation) → sign-off
  FR adds regulatory footer

Group C: Car rental, no cancellation — 2 templates
  DE/de, ES/es
  Structure: intro → coverage → eligibility (general + travel + car rental) → pre-trip → contact (3 items) → sign-off
  ES adds unique postal address paragraph after intro

Group D: Car rental + cancellation, English — 1 template
  IE/en (empty file, build from scratch using docx only)
  Structure: same as Group B but English
```

## Content Flags

| Template | Flag |
|----------|------|
| ES/es | Unique postal address paragraph after intro (signed copy to Zurich Insurance Europe AG) |
| DK/da | Unique health card ("sundhedskort") eligibility requirement |
| SE/sv | Unique "Viktig information" paragraph about premium payment obligation |
| FR/fr | Regulatory footer about Cover-More Blue Insurance Services Limited |
| Key Tips URLs (car rental) | Use `policy.qa.travelguard.com/mypolicy/{country}` |

## HTML Skeleton Patterns

Reference: `expedia/at/de/policy-confirmation.html` (309 lines) — copy as base for each template.

**Section heading** (for coverage and contact headings):
```html
<table role="presentation" class="head" style="...width: 100%; text-align: left; margin-bottom: 16px;">
  <tr>
    <td class="spacer" style="...padding: 16px 0; font-size: 18px; font-weight: bold; color: #003D6E; border-bottom: 1px solid #9CC7E6;">{HEADING}</td>
  </tr>
</table>
```

**Text block**:
```html
<table role="presentation" class="text" style="...width: 100%; margin: 0 auto; line-height: 1.5;">
  <tr>
    <td class="spacer" style="...font-size: 16px; ...padding-bottom: 25px;">{CONTENT}</td>
  </tr>
</table>
```

**Eligibility reminders** — red bold heading + ul:
```html
<b style="color: #af0827;">HEADING TEXT</b>
<ul><li>...</li></ul>
```
For car rental markets, add after travel insurance list:
```html
<b>Car Rental Protection (translated)</b>
<ul><li>...</li><li>Key Tips link</li></ul>
```

**Contact info** — inline Q&A (NOT HTML tables):
```html
<b style="color: #003D6E;">Question text</b><br>
Answer with <b><a href="tel:+XXXX">+XX XX XXXX</a></b> and <a href="mailto:...">email</a><br>
<br>
```

## Rebranding Rules (stubs → final)

When cross-referencing stubs:
- `AIG Travel` → `Travel Guard` in sign-off
- AIG logo → `CM_Travel_Guard_v_RGB.png` at 200px centered
- `{XX}.expcustsvc@aig.com` → use email from docx (typically `expedia@cs.covermoreeurope.com`)
- Old `{Variable}` → `{{policyDetail-variable}}` Handlebars format

## Build Process Per Template

1. Extract docx: `pandoc expedia/{country}/{lang}/policy-conf.docx -t markdown`
2. Copy AT/de skeleton as base
3. Update `lang=`, `<title>`, preheader, hero banner
4. Replace body content from docx using AT/de HTML patterns
5. Map variables to `{{policyDetail-*}}` format
6. Set correct URLs, phone numbers with `tel:` links
7. Add country-specific sections
8. Set sign-off from docx

## Variable Mapping

| Docx Variable | HTML Handlebars |
|---------------|----------------|
| `{FirstName}` / `{{Policy Holder First Name}}` | `{{policyDetail-primaryInsured-firstName}}` |
| `{LastName}` / `{{Policy Holder Last Name}}` | `{{policyDetail-primaryInsured-lastName}}` |
| `{PolicyNumber}` / `{{Policy Number}}` | `{{policyDetail-policyNumber}}` |
| `{ProductName}` / `{{Product Name}}` | `{{policyDetail-productName}}` |

## URL Patterns

| Type | Pattern |
|------|---------|
| Policy portal | `https://policy.qa.travelguard.com/mypolicy/{country}` (QA) |
| Policy portal (CH) | `https://policy.qa.travelguard.com/mypolicy/ch/{lang}` (QA) |
| Claims | Per docx (typically `https://claims.covermoreeurope.com/expedia`) |
| Key Tips (car rental) | `https://policy.qa.travelguard.com/mypolicy/{country}` (QA) |
| Zendesk | `https://covermore-europe-expedia.zendesk.com/hc/` |

## Session Decisions

- **Policy portal links**: Use **QA** domain (`policy.qa.travelguard.com`) for all policy portal "click here" links, not prod
- **Content order**: Follow docx section ordering (e.g. DK/da and FI/fi have coverage → pre-trip → eligibility, which differs from AT/de's coverage → eligibility → pre-trip)
- **Claims URLs**: Use docx URLs verbatim (several use `claims.covermoreeurope.com/expedia` instead of `claims.travelguard.com/myclaim/{country}`)
- **Eligibility formatting**: Single red bold heading (`<b style="color: #af0827;">`) + `<ul>` bullets, matching AT/de pattern but adapted to each market's content structure
- **Contact section**: Some docx files don't include the `{{policyDetail-policyNumber}}` variable in the contact Q&A — kept verbatim per docx

## Reference Files

- AT/de skeleton: `expedia/at/de/policy-confirmation.html` (309 lines)
- BE/fr completed: `expedia/be/fr/policy-confirmation.html` (302 lines)
- BE/nl completed: `expedia/be/nl/policy-confirmation.html` (302 lines)
- Followup items: `expedia/followup.md`

## Verification Checklist (per template)

1. All `{{policyDetail-*}}` variables correct (no old `{Variable}` format)
2. All URLs match patterns (policy portal on QA, claims per docx, zendesk)
3. Phone numbers have `tel:` links with no spaces/dashes in href
4. `lang=` attribute matches language code
5. Content matches docx verbatim
6. `class="body-bg"` on `<body>` tag
7. No old AIG branding ("AIG Travel", "@aig.com", AIG logo URL)
8. Sign-off from docx (translated "Safe travels!" + bold "Travel Guard")

## Modified Files (this session)

- `expedia/dk/da/policy-confirmation.html` — rebuilt from AT/de skeleton + DK/da docx content
- `expedia/fi/fi/policy-confirmation.html` — rebuilt from AT/de skeleton + FI/fi docx content
- `expedia/followup.md` — created, tracks items kept verbatim per docx that may need review
- `expedia/handoff.md` — created and updated
- `.claude/skills/handoff/SKILL.md` — new /handoff skill (project-level)
- `~/.claude/skills/handoff/SKILL.md` — new /handoff skill (user-level)

## Plan File

The original plan was created in `.claude/plans/` during this session but has since been cleaned up. The full plan context is captured in this handoff document. Key plan details:
- 12 templates total, 4 groups (A: simple, B: car rental + cancellation, C: car rental only, D: English)
- Docx files are the **source of truth** — content must be verbatim, no corrections without asking
- Stubs are cross-reference only (old AIG branding, outdated phone/email/URLs)

## Open Questions

See `expedia/followup.md` for items kept verbatim per docx that may need review:
1. NL/nl email `expedia@covermoreeurope.com` — missing `cs.` subdomain
2. CH/it "CHGF 200,000" — likely typo for "CHF 200,000"
3. DK/da claims URL uses `claims.covermoreeurope.com` instead of `claims.travelguard.com`

## Next Steps

1. Resume at **NL/nl** (template #3, Group A simple)
2. Extract docx: `pandoc expedia/nl/nl/policy-conf.docx -t markdown`
3. Copy AT/de skeleton, replace content from docx, apply all rules from Key Decisions & Rules above
4. After each template, stop and ask the user before proceeding to the next
