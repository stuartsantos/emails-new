# CLAUDE.md — Expedia

HTML email templates for **Expedia Travel Insurance** across multiple international markets. 22 active policy-confirmation templates organized by country/language.

For shared technical patterns (DOCTYPE, meta tags, MSO conditional, Google Fonts, dark mode CSS, layout, preheader, font stack, Zurich brand colors, gotchas), see the **root `/CLAUDE.md`**. This file covers only Expedia-specific content.

## Directory Structure

```
expedia/
├── us/en/                    # United States
├── ca/en/, ca/fr/            # Canada (en/fr)
├── mx/es/                    # Mexico
├── nz/en/                    # New Zealand
├── hk/en/                    # Hong Kong
├── sg/en/                    # Singapore
├── ie/en/                    # Ireland
├── it/it/                    # Italy
├── at/de/                    # Austria
├── be/{fr,nl}/               # Belgium
├── ch/{de,fr,it}/            # Switzerland
├── de/de/                    # Germany
├── dk/da/                    # Denmark
├── es/es/                    # Spain
├── fi/fi/                    # Finland
├── fr/fr/                    # France
├── nl/nl/                    # Netherlands
├── no/nb/                    # Norway
└── se/sv/                    # Sweden
```

## Handlebars Variables

```
{{policyDetail-policyNumber}}              # Policy number
{{policyDetail-primaryInsured-firstName}}  # Customer first name
{{policyDetail-primaryInsured-lastName}}   # Customer last name
{{policyDetail-productName}}               # Product name
{{ViewPolicyURL}}                          # Policy portal link
{{CustomerServicesContactNumber}}          # Support phone
{{ClaimsEmailAddress}}                     # Claims email
```

`us/en` additionally injects its partner header logo through a token rather than a
hardcoded `<img>` — the only template in the repo that does:

```
{{Image_AIGGlobalLogoHeader}}              # Partner logo, second header cell (us/en only)
```

The ESP supplies the whole tag, including `alt` text. The AIG-era token name is the ESP's
and cannot be changed from this repo — it is an internal identifier, never rendered to the
customer, so it is not a rebranding violation. The QA scripts strip `{{handlebars}}` before
the AIG branding check for exactly this reason; see the note in the root `CLAUDE.md`.

## Logo Usage

Four header-logo strategies are in use across the 22 active templates. New templates should follow the EU/ROW pattern (CM_Travel_Guard_v_RGB.png @ 200px) unless a regional partner agreement requires otherwise.

| Strategy | Logo URL(s) | Width | Markets |
|----------|-------------|-------|---------|
| EU/ROW (default for new templates) | `.../travel-guard/us/en/CM_Travel_Guard_v_RGB.png` | 200px | at/de, ch/de, ch/fr, ch/it, de/de, dk/da, es/es, fi/fi, fr/fr, it/it, nl/nl, no/nb, se/sv |
| Travel Guard header (legacy 600px) | `.../travel-guard/us/en/tg_logo_header.png` | 600px | be/fr, be/nl, ca/en, ca/fr, mx/es, sg/en |
| Zurich-only (jetstar path) | `.../jetstar/au/en/images/emails/zurich-logo.png` | 200px | hk/en, nz/en |
| US co-brand (split TG + injected partner logo) | `.../travel-guard/us/en/travel-guard-logo-blue.png` (200px) + `{{Image_AIGGlobalLogoHeader}}` in the second cell | — | us/en |

For logo tables, use empty class `class=""` to prevent mobile scaling from `.header img` rule.

## Footer

`us/en` is the **only** Expedia template with a social footer — the other 21 end at the
legal copy. Its footer follows the modernized `digdrct/us/en/policy-confirmation.html`
pattern, not the Expedia legacy one: a single full-width bar with a navy → Zurich-blue
gradient (`#003d6e` → `#0076be`, 99deg), heading and four social icons centered.

Do not reintroduce the two-column footer or the `straight-progress-teal-faded@2x.png`
chevron image it used to sit beside — the pattern read as a rendering artifact at 600px
content width (August 2026). That image is still live in 44 legacy templates elsewhere in
the repo; this note applies to Expedia only.

digdrct's "How did we do? Leave us a review!" row is deliberately **omitted** here: the
purchase was made through Expedia, so a Travel Guard review CTA is off-context on a partner
template.

## Editing Constraints

**DO NOT modify:** HTML table structure, CSS styles, Handlebars syntax, image dimensions.
**ONLY update:** text content, email addresses, phone numbers, URLs, legal/footer copy.

These constraints govern routine copy, translation and link work. A structural rebuild —
like the `us/en` footer above — happens only on an explicit request for one.
