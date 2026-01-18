# Qantas Travel Insurance Email Templates

## Project Overview

This directory contains HTML email templates for Qantas Travel Insurance across different markets (New Zealand and Australia). The templates handle various customer communications throughout the policy lifecycle, from purchase confirmation to expiry notifications.

### Current Status

**New Zealand Market (NZ)**: Completed underwriter transition revisions (AIG → Zurich)
**Australia Market (AU)**: Revisions planned - will follow the same process as NZ

## Market Structure

```
qantas/
├── nz/
│   └── en/
│       └── nz-revisions/     # Completed Zurich transition updates
│           ├── policy-confirmation.html
│           ├── pre-trip.html
│           ├── cancel.html
│           ├── void.html
│           ├── amt-expiry.html
│           └── docs/          # Source Word documents
└── au/                        # AU market (revisions coming soon)
```

## Email Template Types

| Template | Trigger/Purpose | Key Features |
|----------|----------------|--------------|
| **Policy Confirmation** | Sent immediately after purchase | Includes policy details, coverage summary, important travel alerts, cooling-off period notice |
| **Pre-Trip** | Reminder sent before travel dates | Emergency contact info, travel alert banner, portal access links |
| **Cancel** | Policy cancellation confirmation | Cancellation details, refund information (if applicable) |
| **Void** | Transaction processing failure | Notifies customer of payment/processing issues |
| **AMT Expiry** | Annual Multi-Trip policy renewal reminder | Expiry date, renewal call-to-action |

## Recent NZ Revisions Context

### Underwriter Transition (Completed for NZ)
The New Zealand market underwent a complete transition from **AIG Insurance New Zealand Limited** to **Zurich Australian Insurance Limited** as the underwriting partner. This required updates across all customer-facing email templates.

#### Key Changes Implemented:
1. **Underwriter Information**
   - Old: AIG Insurance New Zealand Limited
   - New: Zurich Australian Insurance Limited ACN 000 296 640

2. **Contact Email Migration**
   - Customer Service: `qantascustomerservice@aig.com` → `qantascustomerservice@zurich.com`
   - Emergency Assistance: `qantasinsuranceassistance@aig.com` → `qantasinsuranceassistance@zurich.com`
   - Claims: `qantasinsuranceclaims@aig.com` → `qantasinsuranceclaims@zurich.com`

3. **Content Improvements**
   - Enhanced travel alert messaging (Level 4 - Do Not Travel advisory)
   - Clarified portal access instructions
   - Added timezone indicators (NZT) for phone support hours
   - Improved cooling-off period clarity ("within 21 days of purchase")
   - Updated void email messaging (from "insufficient Qantas Points" to "difficulty processing your transaction")
   - Complete footer rewrite with Zurich legal information and Auckland address

4. **Footer Legal Information**
   - New address: Level 9, 29 Customs Street West, Auckland
   - Updated legal disclaimers and underwriter details

### AU Market - Coming Soon
The same comprehensive revision process will be applied to the Australia market templates, transitioning to Zurich as the underwriter with corresponding contact and legal information updates.

## Code/Design Patterns

### 1. Handlebars Templating System
All templates use Handlebars-style variables for dynamic content insertion:

```handlebars
{{policyDetail-primaryInsured-firstName}}           # Customer's first name
{{policyDetail-policyNumber}}                       # Policy number
{{policyDetail-productName}}                        # Product tier (Comprehensive, etc.)
{{policyDetail-effective::date::dd MMM yyyy}}       # Policy start date
{{policyDetail-expiration::date::dd MMM yyyy}}      # Policy end date
{{destinations-csv}}                                 # Destination list
```

**Conditional Display Blocks:**
```handlebars
{{is-amt-product::visible::start}}
  Content only shown for Annual Multi-Trip products
{{is-amt-product::visible::end}}

{{is-amadeus::visible::start}}
  Content only shown for Amadeus booking system
{{is-amadeus::visible::end}}
```

### 2. HTML Email Structure Pattern
All templates follow a consistent structure:

1. **DOCTYPE and Email Client Meta Tags**
   ```html
   <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
   <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
     <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
   ```

2. **Table-Based Layout** (for email client compatibility)
   - Outer container table (width: 100%)
   - Content wrapper table (max-width: 600px)
   - Nested tables for sections

3. **Inline CSS + Style Block**
   - Critical styles inline for Outlook compatibility
   - Supplementary styles in `<style>` block for modern clients
   - Mobile responsive media queries

4. **Section Structure:**
   - Header (Qantas logo)
   - Hero/Title section
   - Important information banner (where applicable)
   - Main content sections
   - Call-to-action buttons
   - Footer (legal, contact, social links)

### 3. Responsive Design Pattern
Templates use a mobile-first approach with media queries:

```css
@media only screen and (max-width: 600px) {
  .mobile-full-width {
    width: 100% !important;
  }
  .mobile-padding {
    padding: 10px !important;
  }
  .mobile-hide {
    display: none !important;
  }
}
```

### 4. Brand Color Consistency
All templates use standardized Qantas brand colors:

| Element | Color Code | Usage |
|---------|-----------|--------|
| Primary Red | `#E40000` | Links, phone numbers, primary CTAs |
| Background Grey | `#F4F5F6` | Email body background |
| Content White | `#FFFFFF` | Content sections |
| Alert Yellow | `#FCEBCD` | Important information banners |
| Teal Accent | `#A0E0DF`, `#E9F9F9` | Policy details highlight sections |
| Text Dark | `#333333` | Primary body text |
| Text Grey | `#666666` | Secondary text, disclaimers |

### 5. Accessibility Patterns
- Semantic HTML where possible within email constraints
- Alt text on all images (especially Qantas logo)
- Sufficient color contrast ratios
- Clear link text (no "click here")
- Phone numbers with `tel:` links for mobile

## Development Guidelines

### Content Updates
When updating content:
1. **Source of Truth**: Always refer to the Word documents in `/docs/` subfolder
2. **Text Only**: Only update text content, not HTML structure
3. **Handlebars Preservation**: Never modify or remove Handlebars variables
4. **Brand Consistency**: Maintain consistent tone and terminology across templates

### Technical Constraints
**DO NOT modify:**
- HTML table structure or nesting
- CSS styles (inline or in `<style>` blocks)
- Handlebars templating syntax `{{...}}`
- Image dimensions or spacing
- Layout padding/margins

**ONLY update:**
- Text content within HTML tags
- Email addresses and phone numbers
- Links (URLs)
- Legal disclaimers and footer content

### Testing Checklist
Before finalizing any template updates:
- [ ] Verify Handlebars variables are intact
- [ ] Check all links (http/https, email, tel)
- [ ] Validate email addresses
- [ ] Confirm phone numbers with correct international format
- [ ] Test rendering in major email clients (Outlook, Gmail, Apple Mail)
- [ ] Mobile responsive check
- [ ] Compare with source Word document for accuracy
- [ ] Cross-reference with other market templates for consistency

## Source Document Workflow

1. **Receive Word Documents**: Marketing/legal provides updated .docx files
2. **Place in `/docs/` folder**: Store source documents alongside HTML templates
3. **Extract Content**: Copy updated text from Word docs
4. **Apply to HTML**: Update corresponding HTML template text only
5. **Verify Variables**: Ensure Handlebars placeholders remain correct
6. **Document Changes**: Update README with change summary

## Version Control Notes

All templates are tracked in git. When committing changes:
- Use descriptive commit messages referencing the market (NZ/AU) and change type
- Include reference to source documents if applicable
- Tag major transitions (e.g., "AIG to Zurich transition - NZ complete")

## Upcoming Work

### Australia Market Revisions (Planned)
Following the successful completion of NZ market updates, the same comprehensive revision process will be applied to the Australia (AU) market:

- Underwriter transition updates
- Contact information migration
- Content improvements and clarifications
- Legal footer updates
- Consistent improvements from NZ learnings

The AU revisions will follow the same technical constraints, design patterns, and quality standards established for the NZ market.

## Contact & Support

For questions about:
- **Template content/copy**: Consult marketing team and source Word documents
- **Technical implementation**: Refer to this document and existing NZ templates
- **Brand guidelines**: Qantas brand team
- **Legal/compliance**: Legal team approval required for footer and disclaimer changes

---

**Last Updated**: NZ revisions completed January 2026 | AU revisions planned
