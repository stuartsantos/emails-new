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

## HTML Email Patterns

**Structure:** Table-based layout (600px max-width) with inline CSS. Uses `<style>` block for responsive media queries.

**Mobile breakpoint:** `@media (max-width: 600px)` - columns stack, padding adjusts

**Key CSS classes:**
- `.wrapper`, `.section` - Main containers (100% width on mobile)
- `.col-1`, `.col-2`, `.col-3` - Column layouts
- `.mobile-none` - Hide on mobile
- `.mobile-ta-c` - Center text on mobile
- `.icon-left`, `.icon-right` - Icon placement patterns

**Font stack:** `'Source Sans Pro', 'Avenir Next', 'Calibri', sans-serif`

**Brand colors (Travel Guard/AIG):**
- Navy: `#003D6E`
- Cobalt Blue: `#1352DE`
- Border accent: `#9CC7E6`
- Background: `#F1F6FB`

Full color palette documented in CSS comments within templates (see color comment block for cyan, orange, green, yellow, purple, teal, gray, steel, red, warm-gray variants).

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
