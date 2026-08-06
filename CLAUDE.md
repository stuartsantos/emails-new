# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains HTML email templates for travel insurance products across multiple brands and international markets. All templates are static HTML files — there is no build system, bundler, or compilation step for the email templates themselves.

## Repository Structure

| Directory | Brand | Description |
|-----------|-------|-------------|
| `tg/` | Travel Guard / Zurich | US market (customer journey, BAU, travel tips, holiday, sponsor emails) + international (CA, IT, MY, SG), agent templates, certificates |
| `row/` | Zurich Travel Guard | "Rest of World" policy confirmations (25 countries, multi-language) |
| `expedia/` | Expedia Travel Insurance | Policy confirmations across 19 markets (US, CA, MX, NZ, IT, HK, SG, EU markets) |
| `qantas/` | Qantas Travel Insurance | NZ and AU lifecycle emails (confirmation, pre-trip, cancel, void, AMT expiry, medical, save-quote) |
| `jetstar/` | Jetstar Travel Insurance | AU, NZ, SG markets |
| `united/` | United Airlines | CA market only — US moved under `row/us/en/` in the August 2026 ROW consolidation |
| `admin/` | Travel Guard | US admin/internal templates |
| `agents/` | Travel Guard | Agent-facing templates (US, CA) |
| `digdrct/` | Travel Guard | Digital direct templates (US, CA, IT, MY, SG) |
| `_work-items/` | — | Work item tracking and reference documents |

Each brand directory has its own `CLAUDE.md` with brand-specific details (Handlebars variables, logo URLs, market lists, brand-only colors, status). Always read the relevant subdirectory docs before working on templates.

**Documentation conventions:** Root `CLAUDE.md` holds shared patterns; brand `CLAUDE.md` files hold only what's unique per brand. Don't duplicate. Filename is uppercase `CLAUDE.md` everywhere.

## MCP Servers

| Server | Type | Status notes |
|--------|------|--------------|
| claude.ai Figma (`mcp__claude_ai_Figma__*`) | Remote | Primary Figma integration — use for design context, screenshots, Code Connect |
| figma (`mcp__figma__*`) | Local SSE (port 3845) | Secondary/legacy Figma — often fails to connect; prefer claude.ai Figma |
| github (`mcp__github__*`) | HTTP | GitHub Copilot MCP — may need token refresh if connection drops |
| chrome-devtools (`mcp__chrome-devtools__*`) | npx | **Preferred for browser automation** — Chrome DevTools automation |
| claude-in-chrome (`mcp__claude-in-chrome__*`) | Browser extension | DOM-aware browser automation; load tools via ToolSearch before use. Use only when chrome-devtools can't do the job (e.g., needs persistent extension session) |
| postman / claude.ai Postman Full | npx + Remote | Dual Postman servers; read instructions resource before use |
| claude.ai Gmail (`mcp__claude_ai_Gmail__*`) | Remote | Gmail read/draft |
| claude.ai Google Calendar (`mcp__claude_ai_Google_Calendar__*`) | Remote | Calendar read/write |
| claude.ai Intuit TurboTax | Remote | Tax assistant tools |
| claude.ai Microsoft 365 | Remote | Needs authentication before use |
| claude.ai Adobe Customer Journey Analytics (`mcp__claude_ai_Adobe_Customer_Journey_Analytics__*`) | Remote | CJA reporting — **read `../cja/CLAUDE.md` before use** (data view IDs, mandatory bot/internal-traffic segments, bootstrap flow) |

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

## Design System Reference (TG)

Authoritative TG brand source (CoverMore 2025): **`../tg-brand/design-system/`** — generated from `Travel Guard Styles 2025.fig` via Claude Design.

> **Shared repo:** `tg-brand` is a standalone sibling repo (`github.com/stuartsantos/tg-brand`), wired in here as a Claude Code additional working directory. It is **read-only** from this project — edit brand assets in `tg-brand` itself, never copy them back in. The Adobe CJA reference is likewise its own sibling repo, `../cja`.

- `../tg-brand/design-system/README.md` — content fundamentals, voice & tone, visual foundations
- `../tg-brand/design-system/project/SKILL.md` — hard rules and don'ts when designing in the system
- `../tg-brand/design-system/project/colors_and_type.css` — canonical token file (colors, type, spacing, radii, shadows)
- `../tg-brand/design-system/project/preview/` — atomic specimen HTMLs (buttons, hero, plan tiles, accordion, alerts, type, color, spacing)

This is a **web** design system (1280px page width, 96px section padding, hover states, full-pill buttons). Tokens, voice/tone, and the don'ts list translate directly to email work; web-only layout rules do not.

### Brand asset inventory

Primary brand SVGs (use these as the canonical source — convert to PNG for emails per Figma export workflow):

| Asset | Path | Purpose |
|---|---|---|
| TG wordmark navy | `../tg-brand/design-system/project/brand/logo-tg-navy.svg` | Primary on light bg |
| TG wordmark white | `../tg-brand/design-system/project/brand/logo-tg-white.svg` | Reverse on TG Navy / dark hero |
| Map-pin navy | `../tg-brand/design-system/project/brand/icon-mappin-navy.svg` | Brand mark; `filter: invert` for white/sand |
| Speech-bubbles | `../tg-brand/design-system/project/brand/icon-speech-bubbles.svg` | Help / Advisor Connect |
| Pattern — topographic | `../tg-brand/design-system/project/brand/pattern-topographic.svg` | Hero accent on TG Navy |
| Pattern — waves | `../tg-brand/design-system/project/brand/pattern-waves.svg` | Section dividers on Glacier |

Secondary asset set (line icons + extra logo variants + product screenshot):

| Asset | Path |
|---|---|
| Brand icons (headset, map, map-pin, palm, plane, shield, speech) | `../tg-brand/design-system/project/assets/brand-icons/` |
| Logo variants (color, black, white, wordmark, wordmark-white) | `../tg-brand/design-system/project/assets/logo/` |
| Patterns (topographic-island, topographic-sand) | `../tg-brand/design-system/project/assets/patterns/` |
| Product screenshot | `../tg-brand/design-system/project/assets/imagery/product-screenshot.png` |

Hosted CDN equivalents (already baked into emails) live in `tg/us/zurich/CLAUDE.md`.

### Token → email-hex cross-reference

Every key design-system CSS token mapped to the literal hex value used in email HTML. Where the design system differs from the existing email-template value, both are shown — see the migration note below.

| Token | Design system | Email templates today | Notes |
|---|---|---|---|
| `--tg-navy` | `#003D6E` | `#003d6e` | Headers, primary bg ✓ |
| `--zurich-blue` | **`#2167AE`** | **`#0076be`** | Heading + CTA accent — **mismatch, see below** |
| `--zurich-blue-dark` | **`#0E4E88`** | **`#005b94`** | Hover / secondary blue — **mismatch, see below** |
| `--snowmelt-blue` | `#9CC7E6` | `#9cc7e6` | Pale accent, focus ring ✓ |
| `--glacier-blue` | `#E4EDF8` | `#e4edf8` | Section bg ✓ |
| `--glacier-blue-50` | `#F1F6FB` | `#f1f6fb` | Email body bg ✓ |
| `--night-sky` | `#302261` | `#302261` | Deep accent ✓ |
| `--midnight` | `#1C252E` | `#1c252e` | Primary body text ✓ |
| `--midnight-50` | `#555B62` | (not yet used) | Secondary text — bring in for future copy |
| `--midnight-30` | `#8D9296` | (not yet used) | Placeholder / disabled |
| `--midnight-15` | `#C6C8CB` | (not yet used) | Borders / disabled UI |
| `--midnight-10` | `#E6E7E8` | (not yet used) | Divider |
| `--jungle` | `#A5D069` | `#a5d069` | Travel-tips accents ✓ |
| `--lagoon` | `#66CBE1` | `#66cbe1` | Cyan accent ✓ |
| `--seafoam` | `#64C5B9` | `#64c5b9` | CTA / accent borders ✓ |
| `--watermelon` | `#DB5989` | `#db5989` | Pink ✓ |
| `--amber` | `#FFC709` | (not yet used) | Featured-plan top border (NEW) |
| `--terra-cotta` | `#F15F40` | (not yet used) | Warm accent (NEW) |
| `--deep-sea-green` | `#005F62` | (not yet used) | Secondary CTA — File a Claim (NEW) |
| `--fg-link` | `#0076BE` | `#0076be` | Anchor link blue ✓ — preserved by design system |
| `--grad-tropics` | `linear-gradient(135deg, #64C5B9 → #66CBE1)` | — | Beach / warm |
| `--grad-golden-hour` | `linear-gradient(135deg, #FFC709 → #F15F40)` | — | Adventure / sunset |
| `--grad-dusk` | `linear-gradient(135deg, #DB5989 → #302261)` | — | Cities / nightlife |
| `--grad-woodland` | `linear-gradient(135deg, #A5D069 → #005F62)` | — | Outdoors / nature |

✓ = design system and email-template values agree.

### Color migration note

The design system promotes **`#2167AE`** as the canonical Zurich Blue (headings + primary CTA accent), and reserves the old **`#0076BE`** as a separate `--fg-link` token for anchors. Existing email templates use `#0076be` for both roles in 66 HTML files, including the existing **Anchor color pinning** rule below.

**Status:** awaiting decision — see `_work-items/tg-color-migration.md` for the proposed audit. Until that runs, the existing `#0076be` rule in this file remains in force for anchors and accents alike.

## Common gotchas

### Dark mode gotcha
Only use `.body-bg` on the outer email container. Do **NOT** apply `.content-bg` or `.dark-text` to white content areas — this turns them dark gray (#2d2d2d) and makes text invisible. These classes are only for elements in the outer body area (preheader row, body background).

### Dark mode contrast ratio gotcha
When any element switches to a dark background (e.g., `.body-bg` → `#1a1a1a`), check the contrast ratio of all text within that area. Text colors that work fine on the light `#f1f6fb` body background — such as `#343741` (body text gray) — can fail WCAG AA (4.5:1 minimum) on dark backgrounds. Example: `#343741` on `#1a1a1a` is ~2.9:1, which is unreadable. Audit any element you apply `.body-bg` to and either add `.dark-text` / `.dark-text-secondary` to its text children, or reconsider whether the dark background is appropriate at all (e.g., keeping the outer wrapper at `#f1f6fb` rather than `#1a1a1a` avoids the problem entirely when a blue logo or light-colored footer text sits in that area).

### Mobile responsive gotcha
When converting `<td>` to `display: block; width: 100%` on mobile, always add `box-sizing: border-box !important` — otherwise padding causes horizontal overflow.

### Outlook gradient fallback
Any `linear-gradient` td/div needs a `bgcolor` attribute + leading `background-color` style + a VML `<v:rect>` gradient — otherwise new Outlook renders the body grey. See `tg/us/zurich/CLAUDE.md` for the split-background hero pattern.

### Anchor color pinning
Pin every `<a href>` with inline `style="color: #0076be;"` (brand blue). Email clients auto-adjust unstyled anchors to off-brand colors in dark mode. Without inline pinning, dark-mode rendering can break brand consistency (April 2026 sweep — see commit `9773f12`).

### Two-column header image gap
In the split header (image cell + navy thank-you banner), the image cell must carry an explicit width so auto table-layout can't hand it extra space — otherwise a `margin: auto` image floats with a white gap on each side. The gap is invisible when the banner text is long but obvious when it's short (e.g. the Arabic/RTL templates). Fix: put `width="235"` + `width: 235px` on the image `<td>`, add `font-size: 0; line-height: 0` to kill inline whitespace, and give the `<img>` `width: 235px; max-width: 235px` with **no** `margin: auto`. Reference pattern: `digdrct/us/en/policy-confirmation.html` (the hero cell). Applied to all ROW Qatar Airways templates + both `row/_template/` skeletons (June 2026).

## QA Tooling

Two existing scripts cover the same checks I keep manually grepping for during sweeps. Use them before reinventing one-off greps.

| Script | When it runs | What it checks |
|--------|--------------|----------------|
| `.claude/scripts/validate-email-html.sh` | PostToolUse hook on every Edit/Write to `*.html` | Per-file validation: blocks the operation and returns issues to Claude |
| `.claude/scripts/batch-qa.sh` | Manual sweep — `./batch-qa.sh [scope]` | Batch validation across all templates → writes `.claude/reports/qa-report.md` |

**14 categories of checks:** duplicate class attrs, AIG branding, `@aig.com` emails, legacy `{Variable}` placeholders, missing Gmail dark mode `[data-ogsc]`, dark-mode gotcha (`.content-bg`/`.dark-text` on white areas), missing `.body-bg` class, missing `<img alt>`, relative image paths, tables missing `role="presentation"`, mismatched MSO conditionals, UAT/QA URLs, missing `box-sizing` for mobile blocks, missing preheader `&zwnj;&nbsp;` padding.

Scope examples: `./batch-qa.sh row`, `./batch-qa.sh expedia`, `./batch-qa.sh tg/us/zurich`. Files can be excluded via `.claude/qa-exclude.txt`.

**Handlebars token names are exempt from the branding checks.** Both scripts strip
`{{...}}` before testing for AIG branding and legacy `{Variable}` placeholders. Token names
are ESP-side identifiers that never reach the customer, and some are AIG-era names we don't
control (e.g. `{{Image_AIGGlobalLogoHeader}}` in `expedia/us/en/`). Only visible copy counts
as a branding issue — don't "fix" a token name to satisfy a QA check, and don't widen these
regexes to cover token names again.

Use the `/batch-qa` skill in Claude Code as a convenience wrapper.

### Keep in mind
- Compare dark mode styles across ALL template variants when updating any one
- Watch for duplicate class attributes on HTML elements — email clients handle these unpredictably
- After any template edit, visually diff dark mode AND light mode against reference templates
- Background color consistency behind logos
- Consistency with sibling regional templates (ROW, Singapore, Zurich, etc.)

## Retiring a template

Git history is the archive — there is no `_archive/` directory and templates are not kept
around "just in case". When a template stops being live:

1. **Delete it** with `git rm`. Do not rename it to `-old`, leave it beside its replacement,
   or park it under a new suffix.
2. **Update `.claude/qa-exclude.txt` in the same commit.** Every path in that file must
   resolve to a real file — it is the repo's primary "this template is not live" signal, and
   it is worthless once it points at things that no longer exist.
3. **Record it in a dated manifest** under `_work-items/` (e.g.
   `legacy-cleanup-2026-08.md`): the deleted paths, one line of why each went, and the
   removal commit SHA. List the files in the commit body too, so the commit is
   self-describing.

Recovering a deleted template — note the `^`, since the recorded SHA is the commit that
*removed* the file, so its last living content is in that commit's parent:

```bash
git show <SHA>^:path/to/file.html            # read it without restoring
git checkout <SHA>^ -- path/to/file.html     # restore it
git log --diff-filter=D --name-only --oneline  # find deletions when you don't know the path
```

**Never name a live file `-new`, `-redesign`, or `xxx-`.** The canonical template for a
market is `policy-confirmation.html`; if a rebuild replaces it, rename the new file into
place and delete the old one rather than shipping both.

This was not a hypothetical. Three markets had shipped a rebuild alongside the file it
replaced, leaving the plain name pointing at the stale copy — `digdrct/us/en` and
`digdrct/sg/en` (`-new.html` was PROD), and `jetstar/sg/en` (`-redesign.html` was the only
usable file; the plainly-named one was an unrenderable fragment). All three were resolved in
the August 2026 cleanup. The cost was that no one could tell which file was live without
reading git history.

Past cleanups: [`_work-items/legacy-cleanup-2026-08.md`](_work-items/legacy-cleanup-2026-08.md).

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
