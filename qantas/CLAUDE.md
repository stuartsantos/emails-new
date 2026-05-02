# CLAUDE.md — Qantas

HTML email templates for Qantas Travel Insurance, NZ and AU markets. Templates handle the full policy lifecycle from purchase confirmation through expiry.

**For shared technical patterns** (DOCTYPE, meta tags, MSO conditional, Google Fonts, dark mode, layout, preheader, gotchas), see the **root `/CLAUDE.md`**. **Qantas does NOT use the Zurich color palette or Noto Sans font** — see brand-specific overrides below.

## Status

- **NZ:** AIG → Zurich underwriter transition complete (January 2026)
- **AU:** AIG → Zurich underwriter transition complete

## Directory Structure

```
qantas/
├── nz/en/
│   └── nz-revisions/        # Completed Zurich transition templates
│       ├── policy-confirmation.html
│       ├── pre-trip.html
│       ├── cancel.html
│       ├── void.html
│       ├── amt-expiry.html
│       └── docs/            # Source Word documents
└── au/en/
    ├── {original templates} # policy-confirmation, pre-trip, cancel, void, amt-expiry, medical, save-quote
    └── au-revisions/        # Completed Zurich transition templates (same set)
```

## Email Template Types

| Template | Trigger / Purpose |
|----------|-------------------|
| Policy Confirmation | Sent immediately after purchase. Includes policy details, coverage summary, travel alerts, cooling-off notice |
| Pre-Trip | Reminder before travel dates. Emergency contact info, alert banner, portal access |
| Cancel | Cancellation confirmation with refund info if applicable |
| Void | Sent when payment/processing fails |
| AMT Expiry | Annual Multi-Trip renewal reminder |
| Medical (AU only) | Medical claim notification |
| Save Quote (AU only) | Saved-quote follow-up with purchase CTA |

## Handlebars Variables

```handlebars
{{policyDetail-primaryInsured-firstName}}           # Customer first name
{{policyDetail-policyNumber}}                       # Policy number
{{policyDetail-productName}}                        # Product tier (e.g., Comprehensive)
{{policyDetail-effective::date::dd MMM yyyy}}       # Policy start date
{{policyDetail-expiration::date::dd MMM yyyy}}      # Policy end date
{{destinations-csv}}                                 # Destination list
```

**Conditional display blocks:**

```handlebars
{{is-amt-product::visible::start}}
  Content only shown for Annual Multi-Trip products
{{is-amt-product::visible::end}}

{{is-amadeus::visible::start}}
  Content only shown for Amadeus booking system
{{is-amadeus::visible::end}}
```

## Brand Overrides

**Color palette (Qantas — NOT Zurich):**

| Element | Hex | Usage |
|---------|-----|-------|
| Primary Red | `#E40000` | Links, phone numbers, primary CTAs |
| Background Grey | `#F4F5F6` | Email body background |
| Content White | `#FFFFFF` | Content sections |
| Alert Yellow | `#FCEBCD` | Important information banners |
| Teal Accent | `#A0E0DF`, `#E9F9F9` | Policy details highlight sections |
| Text Dark | `#333333` | Primary body text |
| Text Grey | `#666666` | Secondary text, disclaimers |

**Note:** Qantas templates use a different document structure than the Zurich-branded brands. Some use a stricter XHTML 1.0 Transitional DOCTYPE rather than the HTML5 + VML xmlns pattern documented in root CLAUDE.md. When editing, preserve whatever structure the existing template uses.

## NZ Underwriter Transition (Completed)

The NZ market transitioned from **AIG Insurance New Zealand Limited** to **Zurich Australian Insurance Limited** as the underwriting partner. Updates applied across all NZ customer-facing templates:

1. **Underwriter information**
   - Old: AIG Insurance New Zealand Limited
   - New: Zurich Australian Insurance Limited ACN 000 296 640

2. **Contact email migration**
   - Customer Service: `qantascustomerservice@aig.com` → `qantascustomerservice@zurich.com`
   - Emergency Assistance: `qantasinsuranceassistance@aig.com` → `qantasinsuranceassistance@zurich.com`
   - Claims: `qantasinsuranceclaims@aig.com` → `qantasinsuranceclaims@zurich.com`

3. **Content improvements**
   - Enhanced travel alert messaging (Level 4 — Do Not Travel advisory)
   - Clarified portal access instructions
   - Added timezone indicators (NZT) for phone support hours
   - Improved cooling-off period clarity ("within 21 days of purchase")
   - Updated void email messaging (from "insufficient Qantas Points" to "difficulty processing your transaction")
   - Complete footer rewrite with Zurich legal information and Auckland address

4. **Footer legal information**
   - New address: Level 9, 29 Customs Street West, Auckland
   - Updated legal disclaimers and underwriter details

## AU Market

The same comprehensive revision was applied to AU templates. AU includes two extra templates not present in NZ: `medical.html` and `save-quote.html`.

## Source Document Workflow

1. Marketing/legal provides updated `.docx` files
2. Place in the relevant `docs/` subfolder
3. Extract content from Word doc
4. Update corresponding HTML template text only — never modify HTML structure or Handlebars
5. Verify Handlebars placeholders remain intact
6. Cross-reference with sibling-market templates for consistency
