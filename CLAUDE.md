# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains HTML email templates for travel insurance products across multiple brands and international markets. All templates are static HTML files — there is no build system, bundler, or compilation step for the email templates themselves.

## Repository Structure

| Directory | Brand | Description |
|-----------|-------|-------------|
| `tg/` | Travel Guard / Zurich | US market (customer journey, BAU, travel tips, holiday, sponsor emails) + international (CA, IT, MY, SG), agent templates, certificates |
| `row/` | Zurich Travel Guard | "Rest of World" policy confirmations (16 countries, multi-language) |
| `expedia/` | Expedia Travel Insurance | Policy confirmations across 7 countries (US, CA, MX, NZ, IT, HK, SG) |
| `qantas/` | Qantas Travel Insurance | NZ and AU lifecycle emails (confirmation, pre-trip, cancel, void, AMT expiry, medical, save-quote) |
| `jetstar/` | Jetstar Travel Insurance | AU, NZ, SG markets |
| `united/` | United Airlines | US, BE, CA markets |
| `admin/` | Travel Guard | US admin/internal templates |
| `agents/` | Travel Guard | Agent-facing templates (US, CA) |
| `digdrct/` | Travel Guard | Digital direct templates (US, CA, IT, MY, SG) |
| `_api-testing/` | — | Email HTML extractor utility for Thunder Client API responses |
| `_work-items/` | — | Work item tracking and reference documents |

Each brand directory has its own `CLAUDE.md` or `claude.md` with brand-specific details (colors, variables, templates, status). Always read the relevant subdirectory docs before working on templates.

## MCP Servers
- Figma MCP (`mcp__figma__get_design_context`) is actively used — if connection fails, suggest user run `claude mcp list` to verify status before proceeding
- GitHub MCP is configured but may need token refresh — guide user to re-authenticate if connection drops

## Shared Technical Patterns

All email templates across brands share these conventions:

- **Table-based layouts** for Outlook compatibility — never use `<div>` for structural layout
- **Inline CSS** for critical styles (Gmail strips `<style>` blocks from body)
- **600px max-width** desktop, `@media (max-width: 600px)` mobile breakpoint
- **Handlebars templating** (`{{variableName}}`) for dynamic content — never modify these
- **MSO conditionals** (`<!--[if mso]>...<![endif]-->`) for Outlook-specific rendering
- **VML namespaces** in `<html>` tag for Outlook vector graphics support
- **`role="presentation"`** on all layout tables for accessibility
- **Preheader** text via hidden `<div>` with `&zwnj;&nbsp;` padding (see Preheader Padding below)
- **Dark mode** support via `@media (prefers-color-scheme: dark)` and Gmail's `[data-ogsc]` selectors

### Preheader Padding Hack

The `&zwnj;&nbsp;` (zero-width joiner + non-breaking space) entities are repeated 20 times after the preheader text inside a hidden `<div>`. This fills the email client's preview snippet area with invisible characters, preventing it from pulling in body content (like table headers or Handlebars variable names) after the preheader message. Always include this padding in preheader divs.

### Dark Mode Gotcha

Only use `.body-bg` on the outer email container. Do NOT apply `.content-bg` or `.dark-text` to white content areas — this turns them dark gray (#2d2d2d) and makes text invisible. These classes are only for elements in the outer body area (preheader row, body background).

### Mobile Responsive Gotcha

When converting `<td>` to `display: block; width: 100%` on mobile, always add `box-sizing: border-box !important` — otherwise padding causes horizontal overflow.

### Keep in Mind

- When updating email templates, always compare dark mode styles across ALL template variants to ensure consistency
- Watch for duplicate class attributes on HTML elements — email clients handle these unpredictably
- After any template edit, visually diff the dark mode AND light mode rendering against reference templates

When modifying any email template, always check for and preserve:
1. Background color consistency behind logos
2. Dark mode class attributes (check for duplicate class attrs)
3. Consistency with sibling regional templates (ROW, Singapore, Zurich, etc.)

## Component Library

Templates can be built from components in the external project at `/responsive-modular-email-templates/build/html/`:
- **Wrappers:** `wrappers/default.html`, `full-width.html`, `outlook.html`
- **Columns:** `columns/1col.html`, `2col.html`, `3col.html`
- **Components:** `button`, `text`, `heading`, `img-1col`, `img-full-width`, `icon-left/right/top`, `ul`, `ul-checked`, `ol`, `quote`, `social`, `video`

The component library uses Grunt: `npm install && grunt` (dev server) or `grunt inline` (build only).

## API Testing / Email Preview

```bash
cd _api-testing && npm run watch
```

Or use the `/watch-email` skill in Claude Code. Saves Thunder Client JSON responses to `_api-testing/response/`, extracts the `body` field to `_api-testing/build/email.html`, and auto-opens in browser.

## Figma Workflow (TG Zurich US only)

The `tg/us/zurich/` templates are built from Figma designs. See `tg/us/zurich/claude.md` for the full design-to-HTML mapping table and Figma links. Key notes:
- Icons should be exported manually from Figma as PNG at 2x — automated SVG-to-PNG conversion produces poor results
- Figma SVG exports may contain `fill="var(--fill-0, #color)"` that needs manual replacement before conversion
- Hero images use a split-background pattern: `linear-gradient(to bottom, #003d6e 50%, #ffffff 50%)` with VML fallback for Outlook

## Brand Color Reference (Zurich / Travel Guard)

Used across `tg/`, `row/`, `expedia/`:

| Color | Hex | Usage |
|-------|-----|-------|
| TG Navy | `#003d6e` | Headers, primary backgrounds |
| Zurich Blue | `#0076be` | Links, accents |
| Zurich Blue Dark | `#005b94` | Secondary blue |
| Seafoam/Teal | `#64c5b9` | CTAs, accent borders |
| Background | `#f1f6fb` | Email body background |
| Body text | `#1c252e` or `#343741` | Paragraph text |

## Rebranding Context

The project is in an ongoing transition from **AIG Travel** to **Travel Guard / Zurich** branding:
- Replace AIG logos with Travel Guard + Zurich logos
- Change "AIG Travel" references to "Travel Guard"
- Convert legacy `{Variable}` placeholders to `{{policyDetail-variable}}` Handlebars format
- Update contact emails from `@aig.com` to `@zurich.com`
- See `row/CLAUDE.md` for the full rebranding rules

## Key Constraints

When updating existing templates:
- **DO NOT** modify HTML table structure, CSS, Handlebars variables, or image dimensions
- **ONLY** update text content, links, email addresses, phone numbers, and legal copy
- Always preserve `tel:` link format for phone numbers (no spaces/dashes in href)
- Campaign tracking uses `cmpid` URL parameter: `emc-tgdirect-{market}-{lang}-{category}-{emailname}`

## Target Email Clients

iPhone Mail, Android Mail, Gmail (web + mobile apps), Apple Mail, Outlook 2016


