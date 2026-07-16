# CLAUDE.md — ROW

ROW = Zurich Travel Guard "Rest of World." This directory holds policy-confirmation templates organized by country and language.

For shared technical patterns (DOCTYPE, meta tags, MSO conditional, Google Fonts loading, dark mode CSS, layout, preheader, font stack, brand colors, gotchas), see the **root `/CLAUDE.md`**. This file covers only ROW-specific content.

## Directory Structure

```
row/
├── _template/
│   ├── row-reference.html          # Canonical structural skeleton (LTR)
│   └── row-reference-rtl.html      # RTL/Arabic variant of the skeleton
└── {country}/
    └── {language}/
        └── policy-confirmation.html
```

**Markets:** ae (UAE), at (Austria), be (Belgium), bh (Bahrain), ca (Canada), ch (Switzerland), cz (Czech Republic), de (Germany), es (Spain), fr (France), gb (United Kingdom), ie (Ireland), it (Italy), kw (Kuwait), lb (Lebanon), nl (Netherlands), no (Norway), nz (New Zealand), om (Oman), pt (Portugal), qa (Qatar), se (Sweden), sg (Singapore), us (United States)

**Multi-language countries:** Austria (de/en), Bahrain (en/ar), Belgium (en/fr/nl), Canada (en/fr), Switzerland (de/en/fr), UAE (en/ar), Kuwait (en/ar), Norway (en/nb), Oman (en/ar), Qatar (en/ar), Sweden (en/sv)

**RTL (Arabic) markets:** ae, bh, kw, om, qa each have an `ar/` template built on `_template/row-reference-rtl.html` — see [RTL templates](#rtl-arabic-templates) below.

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
{{CustomerServicesURL}}                    # Support website URL
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

- **Travel Guard + Zurich logo:** `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/CM_Travel_Guard_v_RGB.png` (200px width) — default for ROW templates.
- Several Qatar Airways markets use the **underwriter's own logo** instead, each hosted on the CDN and referenced by absolute URL (applied to both en and ar):

| Market | Underwriter (provisional) | Hosted logo URL |
|--------|---------------------------|-----------------|
| ae | LIVA | `https://policy.travelguard.com/content/dam/site-images-docs/ae/LIVA_UAE_Logo.png` (140px) |
| bh | GIG Bahrain | `https://www.travelguard.com/content/dam/tg-documents/qatar/gig-logo-bh.png` (180px) |
| kw | GIG | `https://www.travelguard.com/content/dam/tg-documents/qatar/giga-logo-kt.png` |
| lb | GIG | `https://www.travelguard.com/content/dam/tg-documents/qatar/gig-logo-lb.png` |
| om | Sukoon | `https://www.travelguard.com/content/dam/tg-documents/qatar/sukoon-logo.png` |
| qa | Qatar General Insurance | `https://www.travelguard.com/content/dam/tg-documents/qatar/qa-gen-logo.png` |

> The BH/KW/LB/OM/QA logos live in the CDN folder `/content/dam/tg-documents/qatar/`. The local PNG copies under `row/{country}/` are source assets only — templates reference the hosted URLs, not the local files. The underwriter names (and therefore `alt` text) are provisional and need confirmation.

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

**United-under-ROW prototype (July 2026):** `us/en/policy-confirmation-united-composite.html` is a draft composite merging the existing United US fulfillment copy (World Service Center, online claims, self-service, cancellation notice) into the standard ROW template structure, per the proposal in `_work-items/united-under-row.md`. It's a static first-pass merge, not yet the hybrid Handlebars (`{{#if}}`-flagged) model the spec describes — see that doc for open questions before promoting it to the real template.

**Already modern (not modified):** ca (en, fr) — note ca/en is a deliberate plain-HTML stub; it (en, it), nz (en), sg (en)

**Modernized subsequently:** ie (en) — expanded CSS formatting, dark mode, full responsive layout; gb (en) — renamed from uk/ (ISO 3166-1 alpha-2)

**Modernized June 2026 (Qatar Airways partner onboarding):**

| Country | Languages | Notes |
|---------|-----------|-------|
| ae (UAE) | en, ar | **LIVA** underwriter logo (not Travel Guard); ar is RTL |
| kw (Kuwait) | en, ar | ar is RTL |
| lb (Lebanon) | en | English only; customer-service + claims are email-only (no phone) |
| no (Norway) | en, nb | 3-bullet Website/Email/Telephone contact block + `{{ClaimsURL}}` claims line |
| om (Oman) | en, ar | ar is RTL |
| qa (Qatar) | en, ar | ar is RTL |
| se (Sweden) | en, sv | 3-bullet contact block; sv retains a market-specific "Viktig information" liability notice |

**Added July 2026 (Qatar Airways, later market):**

| Country | Languages | Notes |
|---------|-----------|-------|
| bh (Bahrain) | en, ar | **GIG Bahrain** underwriter logo (not Travel Guard); ar is RTL and uses the `ترافل جارد` brand rendering (same as ae) |

All Qatar Airways templates have the `{{AltViewPolicyLinks}}` section **removed** (per partner requirement). The same removal was applied to the existing **ch (Switzerland)** templates (de, en, fr) for this partner.

### RTL (Arabic) templates

Arabic templates (`ae/ar`, `bh/ar`, `kw/ar`, `om/ar`, `qa/ar`) are built on `_template/row-reference-rtl.html`. RTL-specific conventions:

- `<html lang="ar" dir="rtl">` + `dir="rtl"` / `direction: rtl` on the body and content containers; body text cells use `text-align: right`.
- Font: **Noto Sans Arabic** loaded first, Latin Noto Sans as fallback — stack `'Noto Sans Arabic', 'Noto Sans', 'Source Sans Pro', Arial, sans-serif`.
- **Split header is mirrored** — navy thank-you banner on the right, photo on the left (banner `<td>` ordered first under `dir=rtl`).
- Bullet lists use `padding-right` (not `padding-left`).
- **Bidi isolation:** wrap LTR data (phone numbers, emails, policy numbers, URLs) in `<span dir="ltr">` so digits/punctuation don't reorder inside Arabic text.
- Brand name uses each market's **base-content Arabic rendering** (not Latinised): `حراس السفر` for kw/om/qa, `ترافل جارد` for ae and bh. The legacy AIG company reference (`أيه آي جي`) in the assistance line was de-branded to that market's brand term. **Arabic copy is pending native-speaker / QA-team review.**

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
| Qatar (planning set) | AT, BE, CZ, DE, ES, FR, IT, KT, LB, NL, NO, OM, QT, SE, UE, UK |
| **Qatar Airways** (delivered, Jun–Jul 2026) | ae, bh, ch, kw, lb, no, om, qa, se |

> Note: the older Emirates/Qatar partner rows use legacy market codes (`UE`=UAE, `QT`=Qatar, `KT`=Kuwait). The delivered Qatar Airways templates use ISO folder codes: **`ae`** (UAE), **`qa`** (Qatar), **`kw`** (Kuwait), **`bh`** (Bahrain). The Kuwait CDN logo asset keeps its original filename `giga-logo-kt.png`; Bahrain (added July 2026) uses `gig-logo-bh.png`.

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
