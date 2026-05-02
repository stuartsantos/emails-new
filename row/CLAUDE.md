# CLAUDE.md — ROW

ROW = Zurich Travel Guard "Rest of World." This directory holds policy-confirmation templates organized by country and language.

For shared technical patterns (DOCTYPE, meta tags, MSO conditional, Google Fonts loading, dark mode CSS, layout, preheader, font stack, brand colors, gotchas), see the **root `/CLAUDE.md`**. This file covers only ROW-specific content.

## Directory Structure

```
row/
├── _template/
│   └── row-reference.html         # Canonical structural skeleton
└── {country}/
    └── {language}/
        └── policy-confirmation.html
```

**Markets:** at (Austria), be (Belgium), ca (Canada), ch (Switzerland), cz (Czech Republic), de (Germany), es (Spain), fr (France), ie (Ireland), it (Italy), nl (Netherlands), nz (New Zealand), pt (Portugal), sg (Singapore), uk (United Kingdom), us (United States)

**Multi-language countries:** Austria (de/en), Belgium (en/fr/nl), Canada (en/fr), Switzerland (de/en/fr)

## Handlebars Variables

Common variables across ROW templates:

```
{{policyDetail-policyNumber}}              # Policy number
{{policyDetail-primaryInsured-firstName}}  # Customer first name
{{policyDetail-primaryInsured-lastName}}   # Customer last name
{{policyDetail-address-country}}           # Residency country
{{policyDetail-productName}}               # Product name
{{CustomerServicesContactNumber}}          # Support phone
{{CustomerServicesEmailAddress}}           # Support email
{{ClaimsContactNumber}}                    # Claims phone
{{ClaimsEmailAddress}}                     # Claims email
{{AssistanceServicesContactNumber}}        # Emergency assistance phone
{{AssistanceServicesEmailAddress}}         # Emergency assistance email
{{ViewPolicyURL}}                          # Policy portal link
{{CustomerServiceOperatingHours}}          # Service hours
{{ClaimsOperatingHours}}                   # Claims hours
{{AltViewPolicyLinks}}                     # Alternative policy viewing links
{{ProductNamePlaceHolder}}                 # Product/plan name
```

Legacy `{Variable}` (single-brace) placeholders should be converted to the modern `{{policyDetail-variable}}` Handlebars form.

## Logo

- **Travel Guard + Zurich logo:** `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/CM_Travel_Guard_v_RGB.png` (200px width)
- All 28 ROW templates use this exact logo URL.

## Rebranding Rules (AIG Travel → Travel Guard)

When converting legacy templates to the modern format:

1. **Logo** → Replace any AIG logo with the Travel Guard + Zurich logo above
2. **Opening thank you line** → Remove "from AIG Travel" entirely
   - Before: `Thank you for choosing a Travel Guard® Insurance Policy from AIG Travel!`
   - After: `Thank you for choosing a Travel Guard® Insurance Policy!`
3. **Emergency contact section** → Change "AIG Travel" to "Travel Guard"
   - Before: `Call AIG Travel any time on {AssistanceServicesContactNumber}`
   - After: `Call Travel Guard any time on {{AssistanceServicesContactNumber}}`
4. **Signature/sign-off** → "AIG Travel" → "Travel Guard"
5. **Email domains** → `@aig.com` → `@zurich.com`

## Template Modernization Status

All ROW policy confirmation templates have been updated to the modern responsive format with Travel Guard branding.

**Modernized in January 2026:**

| Country | Languages | Notes |
|---------|-----------|-------|
| at (Austria) | de, en | |
| be (Belgium) | en, fr, nl | be/nl was created from scratch (file was empty) |
| ch (Switzerland) | de, en, fr | ch/de and ch/fr include cancellation policy section |
| cz (Czech Republic) | cz, en | cz/cz had modern format, only needed rebrand |
| de (Germany) | de, en | |
| es (Spain) | en, es | es/es includes Spain residency disclaimer |
| fr (France) | en, fr | fr/fr includes France residency disclaimer |
| nl (Netherlands) | en, nl | |
| pt (Portugal) | en, pt | Fixed typo "fposso" → "posso" in pt/pt |
| us (United States) | en | US-specific content (World Service Center, claims online link, self-service page) |

**Already modern (not modified):** ca (en, fr) — note ca/en is a deliberate plain-HTML stub; ie (en), it (en, it), nz (en), sg (en), uk (en)

## Content variations by language

- **Belgian French (be/fr)** uses different terminology than France French (fr/fr): "Attestation d'Assurance" vs "Certificat d'assurance", "Termes de Votre Police" vs "Conditions Générales"
- **Swiss French (ch/fr)** and **Swiss German (ch/de)** include an additional "policy cancellation" section not in other templates
- **Czech (cz/cz)** eligibility section focuses on purchase date requirements rather than residency
- **Singapore (sg/en)** is light-mode-only — `color-scheme: light` instead of `light dark`, no dark-mode classes; greeting uses "Dear {firstName}," (no lastName); includes MFA eRegister notice and legal/regulatory footer

## Partner Reference

Markets covered per partner:

| Partner | Markets |
|---------|---------|
| LHGROUP | AT, BE, CH, DE, ES, FR, IT, NL, PT, UK |
| United | BE, CH, DE, ES, FR, IE, IT, PT |
| Emirates | AT, BA, BE, CA, CZ, DE, DK, ES, FR, GR, HG, IE, IT, KT, LB, MT, NL, NO, NZ, OM, PL, PT, QT, SA, SE, SG, SZ, UE, UK, ZA |
| Qatar | AT, BE, CZ, DE, ES, FR, IT, KT, LB, NL, NO, OM, QT, SE, UE, UK |

Live deployed template URLs (per language):

| Lang | URL |
|------|-----|
| EN | https://documents.travelguard.com/content/templates/row/gb/en/policy-confirmation.html |
| IT | https://documents.travelguard.com/content/templates/row/it/it/policy-confirmation.html |
| FR | https://documents.travelguard.com/content/templates/row/fr/fr/policy-confirmation.html |
| PT | https://documents.travelguard.com/content/templates/row/pt/pt/policy-confirmation.html |
| DE | https://documents.travelguard.com/content/templates/row/de/de/policy-confirmation.html |
| NL | https://documents.travelguard.com/content/templates/row/nl/nl/policy-confirmation.html |
| CS | https://documents.travelguard.com/content/templates/row/cz/cs/policy-confirmation.html |
