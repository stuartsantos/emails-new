# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains HTML email templates for travel insurance products across multiple brands and international markets. All templates are static HTML files — there is no build system, bundler, or compilation step for the email templates themselves.

## Repository Structure

| Directory | Brand | Description |
|-----------|-------|-------------|
| `tg/` | Travel Guard / Zurich | US market (customer journey, BAU, travel tips, holiday, sponsor emails) + international (CA, IT, MY, SG), agent templates, certificates |
| `row/` | Zurich Travel Guard | "Rest of World" policy confirmations (16 countries, multi-language) |
| `expedia/` | Expedia Travel Insurance | Policy confirmations across 19 markets (US, CA, MX, NZ, IT, HK, SG, EU markets) |
| `qantas/` | Qantas Travel Insurance | NZ and AU lifecycle emails (confirmation, pre-trip, cancel, void, AMT expiry, medical, save-quote) |
| `jetstar/` | Jetstar Travel Insurance | AU, NZ, SG markets |
| `united/` | United Airlines | US, BE, CA markets |
| `admin/` | Travel Guard | US admin/internal templates |
| `agents/` | Travel Guard | Agent-facing templates (US, CA) |
| `digdrct/` | Travel Guard | Digital direct templates (US, CA, IT, MY, SG) |
| `_work-items/` | — | Work item tracking and reference documents |

Each brand directory has its own `CLAUDE.md` with brand-specific details (Handlebars variables, logo URLs, market lists, brand-only colors, status). Always read the relevant subdirectory docs before working on templates.

## MCP Servers

| Server | Type | Status notes |
|--------|------|--------------|
| claude.ai Figma (`mcp__claude_ai_Figma__*`) | Remote | Primary Figma integration — use for design context, screenshots, Code Connect |
| figma (`mcp__figma__*`) | Local SSE (port 3845) | Secondary/legacy Figma — often fails to connect; prefer claude.ai Figma |
| github (`mcp__github__*`) | HTTP | GitHub Copilot MCP — may need token refresh if connection drops |
| chrome-devtools (`mcp__chrome-devtools__*`) | npx | Chrome DevTools automation |
| claude-in-chrome (`mcp__claude-in-chrome__*`) | Browser extension | DOM-aware browser automation; load tools via ToolSearch before use |
| postman / claude.ai Postman Full | npx + Remote | Dual Postman servers; read instructions resource before use |
| claude.ai Gmail (`mcp__claude_ai_Gmail__*`) | Remote | Gmail read/draft |
| claude.ai Google Calendar (`mcp__claude_ai_Google_Calendar__*`) | Remote | Calendar read/write |
| claude.ai Intuit TurboTax | Remote | Tax assistant tools |
| claude.ai Microsoft 365 | Remote | Needs authentication before use |

If any server fails, run `claude mcp list` to check current health before troubleshooting.

## Shared Technical Patterns

All email templates across brands share these conventions. Brand CLAUDE.md files cover only what's unique per brand — patterns below apply repo-wide unless a brand explicitly overrides.

### Document head

DOCTYPE with VML/Office namespaces for Outlook:

```html
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
```

Required meta tags:

```html
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="x-apple-disable-message-reformatting">
<meta name="format-detection" content="telephone=no, date=no, address=no, email=no">
<meta name="color-scheme" content="light dark">
<meta name="supported-color-schemes" content="light dark">
```

MSO conditional for Outlook PixelsPerInch:

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

Google Fonts (conditional + `@import` fallback for clients that ignore the link):

```html
<!--[if !mso]><!-->
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
<!--<![endif]-->
```

### CSS reset and dark mode

Templates include a CSS reset and dark mode support via `@media (prefers-color-scheme: dark)` plus Gmail's `[data-ogsc]` selectors. Standard dark-mode classes:

- `.body-bg` — outer body background (dark mode aware)
- `.content-bg` — content background (dark mode aware)
- `.dark-text`, `.dark-text-secondary` — text color overrides for dark mode

### Layout structure

- **Wrapper:** 620px max-width, centered
- **Spacers:** 10px on each side
- **Content:** 600px effective width
- **Mobile breakpoint:** `@media (max-width: 600px)`

### Key CSS classes

- `.wrapper`, `.section` — main containers (100% width on mobile)
- `.col-1`, `.col-2`, `.col-3` — column layouts (stack on mobile)
- `.mobile-none` — hide on mobile
- `.mobile-ta-c` — center text on mobile
- `.icon-left`, `.icon-right` — icon placement patterns

### Preheader hidden div

```html
<div style="display: none; max-height: 0; overflow: hidden; mso-hide: all;">
  Preheader text here
  &zwnj;&nbsp;&zwnj;&nbsp;... <!-- repeat 20x -->
</div>
```

The `&zwnj;&nbsp;` (zero-width joiner + non-breaking space) entities are repeated **20 times** after the preheader text. This fills the email client's preview snippet area with invisible characters, preventing it from pulling in body content (like table headers or Handlebars variable names) after the preheader message.

### Accessibility

All layout tables use `role="presentation"` for screen reader compatibility.

### Font stack

```css
font-family: 'Noto Sans', 'Source Sans Pro', Arial, sans-serif;
```

(Qantas overrides this — see `qantas/CLAUDE.md`.)

### Other shared rules

- **Table-based layouts** for Outlook compatibility — never use `<div>` for structural layout
- **Inline CSS** for critical styles (Gmail strips `<style>` blocks from body)
- **Handlebars templating** (`{{variableName}}`) for dynamic content — never modify these
- **MSO conditionals** (`<!--[if mso]>...<![endif]-->`) for Outlook-specific rendering

## Brand Color Reference (Zurich / Travel Guard)

Used across `tg/`, `row/`, `expedia/`. Qantas has its own palette in `qantas/CLAUDE.md`.

| Color | Hex | Usage |
|-------|-----|-------|
| TG Navy | `#003d6e` | Headers, primary backgrounds |
| Zurich Blue | `#0076be` | Links, accents |
| Zurich Blue Dark | `#005b94` | Secondary blue |
| Nightsky Purple | `#302261` | — |
| Seafoam/Teal | `#64c5b9` | CTAs, accent borders |
| Cyan accent | `#66cbe1` | — |
| Snowmelt border | `#9cc7e6` | Section dividers |
| Pink (watermelon) | `#db5989` | — |
| Pink light | `#edacc4` | — |
| Green (jungle) | `#a5d069` | Travel-tips accents |
| Glacier blue | `#e4edf8` | — |
| Red (highlight) | `#af0827` | Eligibility callouts |
| Background | `#f1f6fb` | Email body background |
| Body text | `#1c252e` or `#343741` | Paragraph text |

## Common gotchas

### Dark mode gotcha
Only use `.body-bg` on the outer email container. Do **NOT** apply `.content-bg` or `.dark-text` to white content areas — this turns them dark gray (#2d2d2d) and makes text invisible. These classes are only for elements in the outer body area (preheader row, body background).

### Mobile responsive gotcha
When converting `<td>` to `display: block; width: 100%` on mobile, always add `box-sizing: border-box !important` — otherwise padding causes horizontal overflow.

### Outlook gradient fallback
Any `linear-gradient` td/div needs a `bgcolor` attribute + leading `background-color` style + a VML `<v:rect>` gradient — otherwise new Outlook renders the body grey. See `tg/us/zurich/CLAUDE.md` for the split-background hero pattern.

### Anchor color pinning
Pin every `<a href>` with inline `style="color: #0076be;"` (brand blue). Email clients auto-adjust unstyled anchors to off-brand colors in dark mode. Without inline pinning, dark-mode rendering can break brand consistency (April 2026 sweep — see commit `9773f12`).

### Keep in mind
- Compare dark mode styles across ALL template variants when updating any one
- Watch for duplicate class attributes on HTML elements — email clients handle these unpredictably
- After any template edit, visually diff dark mode AND light mode against reference templates
- Background color consistency behind logos
- Consistency with sibling regional templates (ROW, Singapore, Zurich, etc.)

## Component Library

Templates can be built from components in the external project at `/responsive-modular-email-templates/build/html/`:
- **Wrappers:** `wrappers/default.html`, `full-width.html`, `outlook.html`
- **Columns:** `columns/1col.html`, `2col.html`, `3col.html`
- **Components:** `button`, `text`, `heading`, `img-1col`, `img-full-width`, `icon-left/right/top`, `ul`, `ul-checked`, `ol`, `quote`, `social`, `video`

The component library uses Grunt: `npm install && grunt` (dev server) or `grunt inline` (build only).

## Figma Workflow (TG Zurich US only)

The `tg/us/zurich/` templates are built from Figma designs. See `tg/us/zurich/CLAUDE.md` for the full design-to-HTML mapping table, hosted CDN asset URLs, and Figma links. Key notes:
- Icons should be exported manually from Figma as PNG at 2x — automated SVG-to-PNG conversion produces poor results
- Figma SVG exports may contain `fill="var(--fill-0, #color)"` that needs manual replacement before conversion
- Hero images use a split-background pattern: `linear-gradient(to bottom, #003d6e 50%, #ffffff 50%)` with VML fallback for Outlook

## Rebranding Context

The project is in an ongoing transition from **AIG Travel** to **Travel Guard / Zurich** branding:
- Replace AIG logos with Travel Guard + Zurich logos
- Change "AIG Travel" references to "Travel Guard"
- Convert legacy `{Variable}` placeholders to `{{policyDetail-variable}}` Handlebars format
- Update contact emails from `@aig.com` to `@zurich.com`
- See `row/CLAUDE.md` for the full ROW rebranding rules and per-template status

## Key Constraints

When updating existing templates:
- **DO NOT** modify HTML table structure, CSS, Handlebars variables, or image dimensions
- **ONLY** update text content, links, email addresses, phone numbers, and legal copy
- Always preserve `tel:` link format for phone numbers (no spaces/dashes in href)
- Campaign tracking uses `cmpid` URL parameter: `emc-tgdirect-{market}-{lang}-{category}-{emailname}`

## Target Email Clients

iPhone Mail, Android Mail, Gmail (web + mobile apps), Apple Mail, Outlook 2016
