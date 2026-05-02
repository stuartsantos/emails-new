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

## Logo Usage

Four header-logo strategies are in use across the 22 active templates. New templates should follow the EU/ROW pattern (CM_Travel_Guard_v_RGB.png @ 200px) unless a regional partner agreement requires otherwise.

| Strategy | Logo URL(s) | Width | Markets |
|----------|-------------|-------|---------|
| EU/ROW (default for new templates) | `.../travel-guard/us/en/CM_Travel_Guard_v_RGB.png` | 200px | at/de, ch/de, ch/fr, ch/it, de/de, dk/da, es/es, fi/fi, fr/fr, it/it, nl/nl, no/nb, se/sv |
| Travel Guard header (legacy 600px) | `.../travel-guard/us/en/tg_logo_header.png` | 600px | be/fr, be/nl, ca/en, ca/fr, mx/es, sg/en |
| Zurich-only (jetstar path) | `.../jetstar/au/en/images/emails/zurich-logo.png` | 200px | hk/en, nz/en |
| US co-brand (split TG + Expedia) | `.../travel-guard/us/en/travel-guard-logo-blue.png` (200px) + `.../travel-guard/us/en/expedia-logo_fulfillment.png` (120px) | — | us/en |

For logo tables, use empty class `class=""` to prevent mobile scaling from `.header img` rule.

## Editing Constraints

**DO NOT modify:** HTML table structure, CSS styles, Handlebars syntax, image dimensions.
**ONLY update:** text content, email addresses, phone numbers, URLs, legal/footer copy.
