# Qantas NZ Email Templates - Revisions

This folder contains revised HTML email templates for Qantas Travel Insurance (New Zealand market).

## Overview

These templates were updated to reflect the transition from **AIG Insurance New Zealand Limited** to **Zurich Australian Insurance Limited** as the underwriter for Qantas Travel Insurance in New Zealand.

## Email Templates

| File | Description | Status |
|------|-------------|--------|
| `policy-confirmation.html` | Policy confirmation email sent after purchase | Updated |
| `pre-trip.html` | Pre-trip reminder email | Updated |
| `cancel.html` | Policy cancellation confirmation | Updated |
| `void.html` | Dishonor/void notification (transaction processing issue) | Updated |
| `amt-expiry.html` | Annual Multi-Trip policy expiry reminder | Updated |

## Key Changes (All Templates)

### Underwriter Transition
- **Old**: AIG Insurance New Zealand Limited
- **New**: Zurich Australian Insurance Limited ACN 000 296 640

### Contact Information Updates
| Type | Old | New |
|------|-----|-----|
| Customer Service Email | qantascustomerservice@aig.com | qantascustomerservice@zurich.com |
| Emergency Assistance Email | qantasinsuranceassistance@aig.com | qantasinsuranceassistance@zurich.com |
| Claims Email | qantasinsuranceclaims@aig.com | qantasinsuranceclaims@zurich.com |

### Content Updates (varies by template)
1. **Important Information Banner** (policy-confirmation, pre-trip): Updated to reference "Level 4 - Do Not Travel" advisory and added link to travel alerts
2. **Policy Portal Links** (policy-confirmation, pre-trip): Changed from "log in to our policy portal" to "visit the Qantas Insurance website and log in to the policy portal"
3. **Claims Portal Links** (policy-confirmation, pre-trip): Changed from "log in to our claims portal" to "visit the Qantas Insurance website and log in to the claims portal"
4. **Cooling-off Period** (policy-confirmation): Added "of purchase" for clarity ("within 21 days of purchase")
5. **Travel Dates Note** (policy-confirmation): Added new note about checking policy dates if flights get rescheduled
6. **Help While Travelling** (policy-confirmation, pre-trip): Removed "AIG Travel's" reference, updated to "our worldwide emergency assistance team"
7. **Phone Hours**: Added "NZT" timezone clarification across all applicable templates
8. **AMT Expiry Message**: Added "eligible" to trips and "Please visit our website to get a quick quote today."
9. **Void Email**: Changed from "insufficient Qantas Points" to "difficulty processing your transaction"
10. **Footer Disclaimer**: Complete rewrite with new Zurich legal text and address (Level 9, 29 Customs Street West, Auckland)

## Technical Notes

### Handlebars Variables
The templates use Handlebars-style variables for dynamic content:
- `{{policyDetail-primaryInsured-firstName}}` - Customer's first name
- `{{policyDetail-policyNumber}}` - Policy number
- `{{policyDetail-productName}}` - Product name (e.g., "Comprehensive")
- `{{policyDetail-effective::date::dd MMM yyyy}}` - Policy start date
- `{{policyDetail-expiration::date::dd MMM yyyy}}` - Policy end date
- `{{destinations-csv}}` - Comma-separated list of destinations
- `{{is-amt-product::visible::start/end}}` - Conditional display for AMT products
- `{{is-amadeus::visible::start/end}}` - Conditional display for Amadeus bookings

### Design Constraints
When editing these templates:
- Do NOT modify HTML structure or table layouts
- Do NOT change CSS styles (inline or in `<style>` blocks)
- Do NOT alter Handlebars templating syntax
- Only update text content as specified in source documents

### Source Documents
Content updates should come from the Word documents in the `docs/` subfolder.

## Brand Colors
The templates use Qantas brand colors:
- Primary Red: `#E40000` (links, phone numbers)
- Background: `#F4F5F6` (email body)
- Content Background: `#FFFFFF`
- Yellow Banner: `#FCEBCD` (important information)
- Teal Accent: `#A0E0DF`, `#E9F9F9` (policy details section)
