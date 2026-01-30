# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This directory contains HTML email templates for Zurich Travel Guard "Rest of World" (ROW) travel insurance markets. Templates are organized by country and language, primarily handling policy confirmation emails.

## Directory Structure

```
row/
├── {country}/
│   └── {language}/
│       └── policy-confirmation.html
├── README.md          # Handlebars variable mapping reference
```

**Markets:** be (Belgium), ca (Canada), ch (Switzerland), cz (Czech Republic), de (Germany), fr (France), it (Italy), nz (New Zealand), pt (Portugal), uk (United Kingdom)

**Multi-language countries:** Belgium (en/fr/nl), Canada (en/fr), Switzerland (de/en/fr)

## Handlebars Templating

Templates use Handlebars-style variables for dynamic content. See README.md for the mapping from legacy format to new format.

**Common variables:**
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
```

## HTML Email Template Structure

### DOCTYPE and Namespaces

Templates use VML/Office namespaces for Outlook compatibility:

```html
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
```

### Required Meta Tags

```html
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="x-apple-disable-message-reformatting">
<meta name="format-detection" content="telephone=no, date=no, address=no, email=no">
<meta name="color-scheme" content="light dark">
<meta name="supported-color-schemes" content="light dark">
```

### MSO Conditional for Outlook

```html
<!--[if mso]>
<noscript>
  <xml>
    <o:OfficeDocumentSettings>
      <o:PixelsPerInch>96</o:PixelsPerInch>
    </o:OfficeDocumentSettings>
  </xml>
</noscript>
<![endif]-->
```

### Google Fonts (Conditional Loading)

```html
<!--[if !mso]><!-->
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
<!--<![endif]-->
```

Plus `@import` fallback in CSS for broader client support.

### CSS Reset and Dark Mode

Templates include:
- CSS reset for consistent rendering across email clients
- Dark mode support via `@media (prefers-color-scheme: dark)`
- Gmail-specific dark mode via `[data-ogsc]` selectors
- Classes: `.body-bg`, `.content-bg`, `.dark-text`, `.dark-text-secondary`

### Layout Structure

- **Wrapper:** 620px max-width, centered
- **Spacers:** 10px on each side
- **Content:** 600px effective width
- **Mobile breakpoint:** `@media (max-width: 600px)`

### Key CSS Classes

- `.wrapper`, `.section` - Main containers (100% width on mobile)
- `.col-1`, `.col-2`, `.col-3` - Column layouts
- `.mobile-none` - Hide on mobile
- `.mobile-ta-c` - Center text on mobile
- `.icon-left`, `.icon-right` - Icon placement patterns
- `.body-bg` - Body background (dark mode aware)
- `.content-bg` - Content background (dark mode aware)

### Accessibility

All layout tables use `role="presentation"` for screen reader compatibility.

### Preheader

```html
<div style="display: none; max-height: 0; overflow: hidden; mso-hide: all;">
  Preheader text here
  &zwnj;&nbsp;&zwnj;&nbsp;... <!-- Zero-width joiners for padding -->
</div>
```

## Font Stack

```css
font-family: 'Noto Sans', 'Source Sans Pro', Arial, sans-serif;
```

## Color Reference (Zurich / Travel Guard)

```
- Navy (TG Navy): #003d6e
- Zurich Blue Dark: #005b94
- Zurich Blue: #0076be
- Nightsky Purple: #302261
- Seafoam/Teal: #64c5b9
- Cyan accent: #66cbe1
- Snowmelt border: #9cc7e6
- Pink (watermelon): #db5989
- Pink light (watermelon50): #edacc4
- Green (jungle): #a5d069
- Glacier blue: #e4edf8
- Red (highlight): #af0827
- Body text: #1c252e or #343741
- Background: #f1f6fb
```

## Logo Usage

- **Travel Guard + Zurich logo:** `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/CM_Travel_Guard_v_RGB.png` (200px width, max-width: 200px)

## Rebranding Rules (AIG Travel → Travel Guard)

When converting legacy templates to the modern format, apply these branding changes:

1. **Logo** → Replace any AIG logo with the new Travel Guard + Zurich logo (see above)

2. **Opening thank you line** → Remove "from AIG Travel" entirely
   - Before: `Thank you for choosing a Travel Guard® Insurance Policy from AIG Travel!`
   - After: `Thank you for choosing a Travel Guard® Insurance Policy!`

3. **Emergency contact section** → Change "AIG Travel" to "Travel Guard"
   - Before: `Call AIG Travel any time on {AssistanceServicesContactNumber}`
   - After: `Call Travel Guard any time on {{AssistanceServicesContactNumber}}`

4. **Signature/sign-off** → Change "AIG Travel" to "Travel Guard"
   - Before: `AIG Travel`
   - After: `Travel Guard`

**Additional modernization steps:**
- Convert placeholder format: `{Variable}` → `{{policyDetail-variable}}`
- Remove `&zwnj;&nbsp;` entities from preheaders
- Update HTML structure to modern responsive template with dark mode support

## Template Modernization Status

All ROW policy confirmation templates have been updated to the modern responsive format with Travel Guard branding.

**Modernized templates (January 2026):**

| Country | Languages | Notes |
|---------|-----------|-------|
| at (Austria) | de, en | |
| be (Belgium) | en, fr, nl | be/nl was created from scratch (file was empty) |
| ch (Switzerland) | de, en, fr | ch/fr includes cancellation policy section |
| cz (Czech Republic) | cz, en | cz/cz had modern format, only needed rebrand |
| de (Germany) | de, en | |
| fr (France) | en, fr | fr/fr includes France residency disclaimer |
| nl (Netherlands) | en, nl | |
| pt (Portugal) | en, pt | Fixed typo "fposso" → "posso" in pt/pt |

**Already modern (not modified in this update):**
- ca (Canada): en, fr
- it (Italy): en, it
- nz (New Zealand): en
- uk (United Kingdom): en

**Content variations by language:**
- **Belgian French (be/fr)** uses different terminology than France French (fr/fr): "Attestation d'Assurance" vs "Certificat d'assurance", "Termes de Votre Police" vs "Conditions Générales"
- **Swiss French (ch/fr)** includes additional "policy cancellation" section not in other templates
- **Czech (cz/cz)** eligibility section focuses on purchase date requirements rather than residency

## Component Library Reference

Templates can use components from `/responsive-modular-email-templates/build/html/`. The library provides:

- **Wrappers:** default, full-width, outlook
- **Columns:** 1col, 2col, 3col layouts
- **Components:** button, heading, text, image, lists (ul, ul-checked, ol), quote, social, icon-left/right/top, video

See `/responsive-modular-email-templates/claude.md` for full architecture and build instructions.

## Development Workflow

When updating templates:

1. **Content only** - Update text, links, contact info; preserve HTML structure
2. **Preserve Handlebars** - Never modify `{{...}}` variables
3. **Test responsiveness** - Verify at 600px breakpoint
4. **Check inline styles** - Gmail strips `<style>` blocks; critical styles must be inline
5. **Avoid long URLs** - Unbreakable strings can force containers wider

**Email client targets:** iPhone Mail, Android Mail, Gmail (web/mobile), Apple Mail, Outlook 2016

## Build Process (Component Library)

The responsive-modular-email-templates project uses Grunt for compilation:

```bash
cd /responsive-modular-email-templates
npm install
grunt          # Development server with live reload
grunt inline   # Build only (SCSS compile + CSS inline)
```

Output goes to `build/html/` with all CSS inlined.
