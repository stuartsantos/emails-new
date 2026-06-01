---
name: row-modernize
description: Modernize a ROW policy confirmation template using the canonical reference skeleton
allowed-tools: Read, Edit, Write, Bash(open:*)
---

Modernize a ROW (Rest of World) policy confirmation email template. Takes a legacy AIG-format template or raw translated text and outputs a fully modernized Travel Guard template using the canonical reference skeleton.

## Workflow & content-fidelity rules (read first)

These govern every ROW edit and override convenience:

1. **Itemize before editing.** Build an itemized table of every non-Handlebars
   content change (text, links, phones, emails, sections added/removed) and
   present it via AskUserQuestion before touching the file. Never silently fix
   or infer content.
2. **Source wording is verbatim.** Use the source's existing translated copy
   exactly. Never substitute the reference skeleton's English/skeleton phrasing
   for content that already exists in the target language.
3. **Edit workflow:** plan → itemized table → AskUserQuestion → plan file →
   sequential Edits → parallel QA (git diff + browser open + `/content-check`).

## 1. Locate the target file

Accept a file path argument (e.g., `/row-modernize row/xx/en/policy-confirmation.html`).

If no argument is provided, find the most recently modified `policy-confirmation.html` under `row/`:

```bash
find row/ -name "policy-confirmation.html" -not -path "row/_template/*" | head -20
```

Then pick the one with the newest modification time. Confirm the target file with the user before proceeding.

## 2. Read references

Read these files to understand the target structure and rules:

| File | Purpose |
|------|---------|
| `row/_template/row-reference.html` | Canonical HTML skeleton — use as the structural base |
| `row/CLAUDE.md` | Rebranding rules, market variations, color reference, partner→market lists |

## 3. Read and analyze the input file

Read the target file and classify it:

- **Legacy AIG template** — has `{Variable}` placeholders (single braces), AIG branding/logos, older HTML structure
- **Raw translated text** — minimal HTML shell with translated content but no email template structure
- **Partially modernized** — already has some modern structure but needs completion or fixes

Note the language from the file path (e.g., `row/de/de/` → German, `row/be/fr/` → Belgian French).

## 4. Extract content from the input

Pull out all translatable/market-specific content:

- **Preheader text** (hidden preview text)
- **Thank-you banner text** (Section 3 — navy banner)
- **Greeting line** and salutation style
- **Residency disclaimer** (if present — es/es, fr/fr, it/it have these)
- **Section headings** (What am I covered for?, Eligibility, Customer service, Emergency, Claims, Cancellation)
- **Section body text** — all paragraph content within each section
- **Contact details** — phone numbers, email addresses, operating hours (these are usually Handlebars variables)
- **Sign-off** — "Safe travels!" equivalent in the target language
- **Legal/footer content** (if present)
- **All Handlebars variables** already in `{{...}}` format — preserve these exactly
- **All legacy variables** in `{...}` format — these will be converted in step 5

## 5. Build the modernized template

Start from the `row/_template/row-reference.html` skeleton and populate it:

### HTML setup
- Set `<html lang="XX">` to the correct language code (en, fr, de, nl, es, pt, cs, it)
- Set `<title>` to "Policy Confirmation [Country Name]"
- Keep dark mode enabled for all markets except Singapore (sg/en uses `light only`)

### Section-by-section population

Insert extracted content into each of the 12 sections documented in the reference template:

1. **Preheader** — translated preview text + `&zwnj;&nbsp;` padding (20 repetitions after text)
2. **Logo** — Travel Guard logo (same for all markets, already in reference)
3. **Split header** — translated thank-you text on navy background
4. **Greeting** — customer name + thank-you + policy number + view policy link
5. **What am I covered for?** — product name + coverage details
6. **Eligibility reminders** — residency or purchase-date requirements
7. **Customer service** — phone, hours, email
8. **Emergency overseas** — 24/7 assistance phone (+ email if source has it)
9. **Claims** — claims phone, hours, email
10. **Alternative policy links** — `{{AltViewPolicyLinks}}` (market-dependent — include unless the market omits it, e.g. Italy it/en + it/it removed it entirely)
11. **Sign-off** — translated farewell + "Travel Guard" in bold navy
12. **Footer** — empty for most markets; legal text for Singapore

### Activate optional sections when the source content warrants it:
- **Cancellation policy** (ch/de and ch/fr) — uncomment the cancellation section
- **Residency disclaimer** (es/es, fr/fr, it/it) — uncomment in greeting section
- **MFA eRegister notice** (sg/en) — uncomment the MFA section
- **Legal footer** (sg/en) — uncomment footer content

### Convert legacy variables

Apply these mappings:

| Legacy `{Variable}` | Modern `{{handlebars}}` |
|---------------------|------------------------|
| `{PolicyNumber}` | `{{policyDetail-policyNumber}}` |
| `{FirstName}` | `{{policyDetail-primaryInsured-firstName}}` |
| `{LastName}` | `{{policyDetail-primaryInsured-lastName}}` |
| `{ProductName}` | `{{ProductNamePlaceHolder}}` |
| `{PlanName}` | `{{policyDetail-planDescription}}` |
| `{ResidencyCountry}` | `{{policyDetail-address-country}}` |
| `{InceptionDate}` | `{{policyDetail-departure}}` |
| `{ExpiryDate}` | `{{policyDetail-return}}` |
| `{DepartureDate}` | `{{policyDetail-departure}}` |
| `{TotalPremium}` | `{{productDetail-amounts-TotalPremium}}` |

Also convert any contact-related legacy variables:
- `{CustomerServicesContactNumber}` → `{{CustomerServicesContactNumber}}`
- `{CustomerServicesEmailAddress}` → `{{CustomerServicesEmailAddress}}`
- `{AssistanceServicesContactNumber}` → `{{AssistanceServicesContactNumber}}`
- `{AssistanceServicesEmailAddress}` → `{{AssistanceServicesEmailAddress}}`
- `{ClaimsContactNumber}` → `{{ClaimsContactNumber}}`
- `{ClaimsEmailAddress}` → `{{ClaimsEmailAddress}}`
- `{ClaimsOperatingHours}` → `{{ClaimsOperatingHours}}`
- `{CustomerServiceOperatingHours}` → `{{CustomerServiceOperatingHours}}`
- `{ViewPolicyURL}` → `{{ViewPolicyURL}}`
- `{AltViewPolicyLinks}` → `{{AltViewPolicyLinks}}`

### Apply rebranding rules (AIG → Travel Guard)

1. **Logo** — already handled (reference template has Travel Guard logo)
2. **Opening thank-you** — remove "from AIG Travel" entirely
   - Before: `Thank you for choosing a Travel Guard® Insurance Policy from AIG Travel!`
   - After: `Thank you for choosing a Travel Guard® Insurance Policy!`
3. **Emergency section** — change "AIG Travel" to "Travel Guard"
   - Before: `Call AIG Travel any time on ...`
   - After: `Call Travel Guard any time on ...`
4. **Sign-off** — change "AIG Travel" to "Travel Guard"

## 6. Write the output

Write the modernized template back to the same file path, overwriting the input.

## 7. Verify (run in parallel)

Run these together:

```bash
open row/{country}/{lang}/policy-confirmation.html
```

- **Browser** — visually diff light + dark mode against a sibling ROW template.
- **git diff** — confirm only intended content changed.
- **`/content-check`** — verify every itemized change from the source was
  applied correctly and nothing was inferred or dropped.

## 8. Report results

Summarize what was done:

- **Input type:** legacy AIG / raw text / partially modernized
- **Language:** detected language and market
- **Sections populated:** list which sections have content
- **Variables used:** list all `{{...}}` variables in the output
- **Optional sections activated:** cancellation, residency disclaimer, MFA, legal footer
- **Rebranding changes applied:** list any AIG → Travel Guard text replacements made
- **Content that couldn't be mapped:** flag any source content that didn't fit neatly into a reference section

## Quality checklist

Before finishing, verify:

- [ ] `<html lang="...">` matches the template language
- [ ] `<title>` is set appropriately
- [ ] Dark mode CSS is present (unless Singapore)
- [ ] All 12 sections from reference template are present (even if some are commented out)
- [ ] No legacy `{SingleBrace}` variables remain — all converted to `{{doubleBrace}}`
- [ ] No AIG branding remains — logo, text, sign-off all say Travel Guard
- [ ] `role="presentation"` on all layout tables
- [ ] Inline styles preserved on all elements (Gmail strips `<style>` blocks)
- [ ] Responsive breakpoint CSS at 600px is present
- [ ] Font stack is `'Noto Sans', 'Source Sans Pro', Arial, sans-serif`
- [ ] Link color is `#1352DE` for email links (or `#0076be` for Singapore)
- [ ] Preheader div includes `&zwnj;&nbsp;` padding (20 repetitions after text)
- [ ] `{{ViewPolicyURL}}` is present in the greeting section
- [ ] `{{AltViewPolicyLinks}}` is present in Section 10 *unless* the market omits it (e.g. Italy)
- [ ] Sign-off uses bold navy `#003D6E` for "Travel Guard"
