# Travel Insurance Email Templates

HTML email templates for travel insurance products across multiple brands and international markets.

## Brands & Markets

| Directory | Brand | Markets | Templates |
|-----------|-------|---------|-----------|
| `tg/` | Travel Guard / Zurich | US (AIG archive + Zurich) | ~141 |
| `digdrct/` | Travel Guard — digital direct | US, CA, IT, MY, SG | 16 |
| `agents/` | Travel Guard — agent-facing | US, CA | 3 |
| `admin/` | Travel Guard — admin/internal | US | 2 |
| `row/` | Zurich Travel Guard | 24 countries (AE, AT, BE, BH, CA, CH, CZ, DE, ES, FR, GB, IE, IT, KW, LB, NL, NO, NZ, OM, PT, QA, SE, SG, US) | 48 |
| `expedia/` | Expedia Travel Insurance | 19 markets (AT, BE, CA, CH, DE, DK, ES, FI, FR, HK, IE, IT, MX, NL, NO, NZ, SE, SG, US) | 23 |
| `qantas/` | Qantas Travel Insurance | AU, NZ | 24 |
| `jetstar/` | Jetstar Travel Insurance | AU, NZ, SG | 9 |
| `united/` | United Airlines | CA | 1 |

Multi-language support where applicable (e.g. Belgium: en/fr/nl, Switzerland: de/en/fr, Canada: en/fr).

## Template Types

- **Policy confirmations** — sent after purchase (all brands)
- **Customer journey** — welcome, follow-up, save-quote, post-trip (TG)
- **Lifecycle** — pre-trip reminders, cancellations, void, AMT expiry (Qantas, Jetstar, digdrct)
- **BAU campaigns** — seasonal updates, travel tips, holiday promos (TG)
- **Agent communications** — agent-facing templates (`agents/`)

## Technical Stack

All templates are **static HTML files** — no build system, bundler, or compilation step.

- **Table-based layouts** for Outlook compatibility
- **Inline CSS** for Gmail (strips `<style>` blocks from body)
- **600px max-width** desktop / `@media (max-width: 600px)` mobile breakpoint
- **Handlebars templating** (`{{variableName}}`) for dynamic content
- **Dark mode** via `@media (prefers-color-scheme: dark)` + Gmail `[data-ogsc]` selectors
- **MSO conditionals** and **VML** for Outlook-specific rendering
- **Google Fonts** — Noto Sans (conditionally loaded, excluded from Outlook)

### Target Email Clients

iPhone Mail, Android Mail, Gmail (web + mobile), Apple Mail, Outlook 2016

## Project Structure

```
├── tg/
│   └── us/
│       ├── aig/             # Legacy AIG templates (archive)
│       └── zurich/          # Modern Zurich templates (Figma-designed)
│           ├── fulfillment/     # Customer journey emails
│           ├── holiday/         # Holiday campaign emails
│           ├── seasonal-update/ # Seasonal BAU emails
│           ├── sponsor/         # Sponsorship emails (Zurich Classic)
│           └── travel-tips/     # Travel safety tips
├── digdrct/                 # Digital-direct lifecycle (US, CA, IT, MY, SG)
│   └── {market}/{language}/
├── agents/                  # Agent-facing templates (US, CA)
│   └── {market}/en/
├── admin/                   # Admin / internal templates (US)
│   └── us/en/
├── row/
│   └── {country}/{language}/policy-confirmation.html
├── expedia/
│   └── {market}/{language}/policy-confirmation.html
├── qantas/
│   ├── au/                  # Australia
│   └── nz/                  # New Zealand
├── jetstar/
│   ├── au/                  # Australia
│   ├── nz/                  # New Zealand
│   └── sg/                  # Singapore
└── united/
    └── ca/en/               # Canada (US moved under row/us/en/, Aug 2026)
```

## Component Library

An external component library at `/responsive-modular-email-templates/` provides reusable building blocks:

- **Wrappers** — default, full-width, Outlook
- **Columns** — 1-col, 2-col, 3-col layouts
- **Components** — button, heading, text, image, lists, quote, social, icon, video

```bash
cd /responsive-modular-email-templates
npm install && grunt        # Dev server with live reload
grunt inline                # Build only
```

## Related Repositories

Shared and adjacent work lives in sibling repos alongside this one. Several were split out of the former `_work-items/` folder (July 2026, git history preserved); where noted they're wired into this project as Claude Code additional working directories and referenced read-only.

| Repo (sibling path) | What it holds | Previously |
|---------------------|---------------|------------|
| `../tg-brand` | Canonical Travel Guard / Zurich design system — tokens, voice & tone, brand assets. Edit here, never copy back in. | `_work-items/tg-design-system/` |
| `../cja` | Adobe Customer Journey Analytics reporting reference — data views, mandatory segments, bootstrap flow. | `_work-items/cja/` |
| `../seo-geo` | JSON-LD schema markup, KPI reports, and schema audit (SEO/GEO). | `_work-items/json/` |
| `../qa-test-harness` | Playwright QA harness for the travelguard.com purchase path — also holds the PP-rebuild BRD talking points. | `_work-items/brd/` |
| `../responsive-modular-email-templates` | Component library (see [Component Library](#component-library) above). | — |

`_work-items/` now holds only email-specific working notes (`work-items.md`, `tg-color-migration.md`).

## Brand Colors (Zurich / Travel Guard)

| Color | Hex | Usage |
|-------|-----|-------|
| TG Navy | `#003d6e` | Headers, primary backgrounds |
| Zurich Blue | `#0076be` | Links, accents |
| Zurich Blue Dark | `#005b94` | Secondary blue |
| Seafoam/Teal | `#64c5b9` | CTAs, accent borders |
| Background | `#f1f6fb` | Email body background |
| Body text | `#1c252e` | Paragraph text |

## Rebranding Status

The project is transitioning from **AIG Travel** to **Travel Guard / Zurich** branding:

| Brand | Status |
|-------|--------|
| TG US (Zurich) | Complete |
| ROW (24 countries) | Complete |
| Expedia | Complete |
| Qantas NZ | Complete |
| Qantas AU | Planned |
| Jetstar | In progress |
| United | Complete |

## Documentation

Shared patterns live in the root doc; each brand directory has its own docs with brand-specific colors, variables, and template status:

- [`CLAUDE.md`](CLAUDE.md) — repo-wide patterns, brand colors, design-system reference, QA tooling
- [`tg/us/zurich/CLAUDE.md`](tg/us/zurich/CLAUDE.md) — Figma workflow, dark mode, hero image patterns
- [`row/CLAUDE.md`](row/CLAUDE.md) — ROW markets, rebranding rules, modernization status (see also [`row/row-instructions.md`](row/row-instructions.md))
- [`expedia/CLAUDE.md`](expedia/CLAUDE.md) — Expedia template structure, Handlebars variables
- [`qantas/CLAUDE.md`](qantas/CLAUDE.md) — Lifecycle emails, underwriter transition context
- [`digdrct/digdrct-instructions.md`](digdrct/digdrct-instructions.md) — Digital-direct templates (US, CA, IT, MY, SG)
