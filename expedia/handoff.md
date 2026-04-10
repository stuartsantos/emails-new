# Expedia EMEA — Handoff

## Status

**First pass complete.** All 13 templates have been built. Next session will focus on edits, followup items, and bug fixes — see `expedia/followup.md` for the full list of items pending client review.

## Overview

Building 12 new European market policy confirmation emails for Expedia Travel Insurance. Each market has a legacy AIG-branded stub (raw HTML) plus a `.docx` file with updated Travel Guard-branded content. The AT/de template is the reference skeleton — copy it as the base and replace content from each market's docx. AT/de, BE/fr, and BE/nl were already complete before this work began.

## Progress Tracker

| # | Template | Group | Status |
|---|----------|-------|--------|
| 1 | DK/da | A (simple) | DONE |
| 2 | FI/fi | A (simple) | DONE |
| 3 | NL/nl | A (simple) | DONE |
| 4 | NO/no | A (simple) | DONE |
| 5 | SE/sv | A (simple + Viktig info) | DONE |
| 6 | DE/de | C (car rental) | DONE |
| 7 | ES/es | C (car rental + postal) | DONE |
| 8 | IE/en | D (car rental + cancel, English) | DONE |
| 9 | CH/de | B (car rental + cancel) | DONE |
| 10 | CH/fr | B (car rental + cancel) | DONE |
| 11 | CH/it | B (car rental + cancel) | DONE |
| 12 | FR/fr | B (car rental + cancel + regulatory) | DONE |
| 13 | IT/it | C (car rental) | DONE |

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

**Eligibility reminders** — bold heading (color only if docx specifies it) + ul:
```html
<b>HEADING TEXT</b>  <!-- plain black unless docx has color — AT/de has FF0000 (red) -->
<ul><li>...</li></ul>
```
For car rental markets, add product sub-headings (use `#003D6E` if docx has any blue color on them):
```html
<b style="color: #003D6E;">Travel Insurance (translated)</b>
<ul><li>...</li></ul>
<b style="color: #003D6E;">Car Rental Protection (translated)</b>
<ul><li>...</li><li>Key Tips link</li></ul>
```

**Key Tips link** (car rental — only if present in docx, verify formatting in XML):
```html
<a href="https://policy.qa.travelguard.com/mypolicy/{country}" style="color: #003D6E;">&#9432; <b>Key Tips translated text</b></a>
```

**Contact info** — inline Q&A (NOT HTML tables):
```html
<b style="color: #003D6E;">Question text</b><br>
Answer with <b><a href="tel:+XXXX">+XX XX XXXX</a></b> and <a href="mailto:...">email</a><br>
<br>
```

**Sign-off**:
```html
Sign-off phrase (translated "Safe travels!")<br>
<b style="color: #003D6E;">Travel Guard</b>
```

## Rebranding Rules (stubs → final)

When cross-referencing stubs:
- `AIG Travel` → `Travel Guard` in sign-off
- AIG logo → `CM_Travel_Guard_v_RGB.png` at 200px centered
- `{XX}.expcustsvc@aig.com` → use email from docx (typically `expedia@cs.covermoreeurope.com`)
- Old `{Variable}` → `{{policyDetail-variable}}` Handlebars format

## Color Extraction Notes

- **pandoc strips all formatting** — only bold/italic/links survive. Never rely on pandoc output for colors, underlines, or font sizes. Pandoc does flag underlines as `[text]{.underline}` — always scan for these in the output.
- **Underlined non-linked text**: render as `<i>` (italics), not `<u>`. Underlines on non-links look like broken links. Underlined text that is already a hyperlink stays as-is. **Exception**: if the underlined text already has `<b>` or a color applied, just drop the underline entirely — no `<i>` needed.
- **XML inspection limitations**: Colors can be set three ways in docx XML:
  1. Directly on the run: `<w:color w:val="...">` inside `<w:rPr>`
  2. Via a named character/paragraph style: `<w:rStyle>` or `<w:pStyle>` — must check `word/styles.xml` for the style definition
  3. Via numbering definitions (list styles) — must check `word/numbering.xml`
- **Multiple occurrences**: Always check ALL occurrences of a keyword — the first hit may be a different context (e.g. intro paragraph vs. eligibility sub-heading). Use `finditer` not `find`.
- **Context window**: Always use at least 600 chars before the search term — colors are often set on paragraph properties (`w:pPr`) which appear before the run text and are missed with smaller windows.
- **Split runs**: A single visible heading may be split across multiple XML runs with different color values (e.g. "IMPORTANT " in one run with no color, "ELIGIBILITY REMINDERS:" in the next with FF0000). Always read enough context to capture all runs in the heading.
- **Key Tips**: Do NOT automatically render as a hyperlink. Only add `<a href>` if the docx XML contains an actual `<w:hyperlink>` element. If bold only → `<b>` black. If bold + blue color → `<b style="color: #003D6E;">`. Never infer a link.

## Build Process Per Template

1. Extract docx: `pandoc expedia/{country}/{lang}/policy-conf.docx -t markdown`
2. Run comprehensive color scan on `word/document.xml`:
   ```python
   python3 -c "
   import re
   with open('word/document.xml', 'r') as f:
       xml = f.read()
   runs = re.findall(r'<w:r[ >].*?</w:r>', xml, re.DOTALL)
   for run in runs:
       color_m = re.search(r'<w:color w:val=\"([^\"]+)\"', run)
       text_m = re.search(r'<w:t[^>]*>([^<]+)</w:t>', run)
       if color_m and text_m:
           color, text = color_m.group(1), text_m.group(1).strip()
           if color not in ('000000', 'auto') and text:
               print(f'  [{color}] {text!r}')
   "
   ```
3. Check for hyperlinks: `grep -c '<w:hyperlink' word/document.xml`
4. Flag all inferences to user before building (hero, preheader, list type changes, missing `.com`, etc.)
5. Copy AT/de skeleton as base
6. Update `lang=`, `<title>`, preheader, hero banner
7. Replace body content from docx using AT/de HTML patterns
8. Map variables to `{{policyDetail-*}}` format
9. Set correct URLs, phone numbers with `tel:` links
10. Add country-specific sections
11. Set sign-off from docx
12. Log any inferences or fixes in `followup.md`

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
- **Eligibility formatting**: Bold heading + `<ul>` bullets. Heading color matches docx — only use red (`<b style="color: #af0827;">`) if the source docx explicitly sets a red color on that run; otherwise plain `<b>` (black). AT/de docx has `FF0000`; DK/da, FI/fi, NL/nl do not. Verify by inspecting `word/document.xml` for `<w:color w:val="...">` on the heading run
- **Contact section**: Some docx files don't include the `{{policyDetail-policyNumber}}` variable in the contact Q&A — kept verbatim per docx
- **Hero banner text**: Docx files don't always have an explicit hero heading. Group A templates had a standalone bold word (e.g. "Rejseforsikring") right after the logo image — use that verbatim. DE/de, ES/es, IE/en, CH/de, CH/fr had no explicit hero text — inferred from body content. Always flag inferences to user before proceeding.
- **Inferences**: Any content not explicitly stated in the docx (hero banner, preheader, list type changes, formatting fixes) must be flagged to the user for approval before or immediately after writing. Log all inferences in `followup.md`.
- **Blank lines in pandoc table cells**: Represent paragraph breaks in the docx — render as `<br>` line breaks between the content blocks.
- **Zendesk URL line break**: Check whether the URL is on its own line or inline — varies per template. Follow docx structure exactly.
- **Underlined text rendering**: Underlined non-link text → `<i>`. Rules:
  - Underlined portion within a longer bold/colored line → `<b><i>text</i></b>` so it stands out from surrounding formatting
  - Entire run is bold+underlined with nothing to stand out from → drop underline, just use `<b>` or color
  - Plain underline only → `<i>`
  - Underlined hyperlink → leave as-is
- **Color extraction — always run comprehensive scan first**: Before building any template, run the full color scan script (see Build Process) to get a complete map of all colored runs. Never spot-check only known terms.
- **Key Tips (car rental)**: Only add `<a href>` if docx XML has an actual `<w:hyperlink>` element. CH/de and CH/fr had no hyperlinks in XML → rendered as bold blue text only: `<b style="color: #003D6E;">&#9432; [translated text]</b>`

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

- `expedia/dk/da/policy-confirmation.html` — rebuilt
- `expedia/fi/fi/policy-confirmation.html` — rebuilt
- `expedia/nl/nl/policy-confirmation.html` — rebuilt
- `expedia/no/no/policy-confirmation.html` — rebuilt
- `expedia/se/sv/policy-confirmation.html` — rebuilt
- `expedia/de/de/policy-confirmation.html` — rebuilt
- `expedia/es/es/policy-confirmation.html` — rebuilt
- `expedia/ie/en/policy-confirmation.html` — built from scratch
- `expedia/ch/de/policy-confirmation.html` — rebuilt
- `expedia/ch/fr/policy-confirmation.html` — rebuilt
- `expedia/ch/it/policy-confirmation.html` — rebuilt
- `expedia/fr/fr/policy-confirmation.html` — rebuilt
- `expedia/it/it/policy-confirmation.html` — rebuilt
- `expedia/followup.md` — created and updated
- `expedia/handoff.md` — created and updated

## Plan File

The original plan was created in `.claude/plans/` during this session but has since been cleaned up. The full plan context is captured in this handoff document. Key plan details:
- 12 templates total, 4 groups (A: simple, B: car rental + cancellation, C: car rental only, D: English)
- Docx files are the **source of truth** — content must be verbatim, no corrections without asking
- Stubs are cross-reference only (old AIG branding, outdated phone/email/URLs)

## Open Questions / Next Steps

All 12 templates are built. Remaining work is likely edits, followups, and bug fixes:

- See `expedia/followup.md` for 13 items pending client review (typos, formatting decisions, verbatim quirks across multiple templates)
- Notable items: NL/nl email missing `cs.` subdomain (item 1), CHGF typo in CH/it (item 2), CH/de numbered list converted to bullets (item 10), CH/fr missing `.com` fixed (item 12), CH/it claims paragraph break merged (item 13)
- IT/it inferences to confirm with client: hero banner text ("Assicurazione Viaggio"), preheader, "Fare clic qui" rendered as link to policy portal (no `<w:hyperlink>` in docx XML)
- If any template needs a content correction after client review, use the docx + this handoff as the source of truth and re-apply the fix verbatim
