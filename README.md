# Travel Insurance Email Templates

HTML email templates for travel insurance products across multiple brands and international markets.

## Brands & Markets

| Directory | Brand | Markets | Templates |
|-----------|-------|---------|-----------|
| `tg/` | Travel Guard / Zurich | US, CA, IT, MY, SG + Agents | ~134 |
| `row/` | Zurich Travel Guard | 14 countries (AT, BE, CA, CH, CZ, DE, ES, FR, IT, NL, NZ, PT, SG, UK, US) | 29 |
| `expedia/` | Expedia Travel Insurance | US, CA, MX, NZ, IT, HK, SG | 15 |
| `qantas/` | Qantas Travel Insurance | AU, NZ | 24 |
| `jetstar/` | Jetstar Travel Insurance | AU, NZ, SG | 10 |
| `united/` | United Airlines | US, CA, BE | 7 |

Multi-language support where applicable (e.g. Belgium: en/fr/nl, Switzerland: de/en/fr, Canada: en/fr).

## Template Types

- **Policy confirmations** — sent after purchase (all brands)
- **Customer journey** — welcome, follow-up, save-quote, post-trip (TG)
- **Lifecycle** — pre-trip reminders, cancellations, void, AMT expiry (Qantas, Jetstar)
- **BAU campaigns** — seasonal updates, travel tips, holiday promos (TG)
- **Agent communications** — agent-facing templates (TG)

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
│   ├── us/aig/              # Legacy AIG templates (archive)
│   ├── us/zurich/           # Modern Zurich templates (Figma-designed)
│   │   ├── fulfillment/     # Customer journey emails
│   │   ├── holiday/         # Holiday campaign emails
│   │   ├── seasonal-update/ # Seasonal BAU emails
│   │   └── travel-tips/     # Travel safety tips
│   ├── ca/en/               # Canada
│   ├── it/it/               # Italy
│   ├── my/en/               # Malaysia
│   ├── sg/en/               # Singapore
│   ├── agents/              # Agent templates
│   └── admin/               # Admin templates
├── row/
│   └── {country}/{language}/policy-confirmation.html
├── expedia/
│   └── {country}/{language}/policy-confirmation.html
├── qantas/
│   ├── au/                  # Australia
│   └── nz/                  # New Zealand
├── jetstar/
│   ├── au/                  # Australia
│   ├── nz/                  # New Zealand
│   └── sg/                  # Singapore
├── united/
│   ├── us/en/               # United States
│   ├── ca/en/               # Canada
│   └── be/{fr,nl}/          # Belgium
└── api-testing/             # Email preview utility
```

## API Testing / Email Preview

Extract email HTML from Thunder Client API responses for browser preview:

```bash
cd api-testing && npm run watch
```

1. Make an API call in Thunder Client
2. Save the response JSON to `api-testing/response/`
3. The watcher extracts the `body` field and opens the email in your browser

A browser-based fallback (`api-testing/extract.html`) is available for environments without Node.js.

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
| ROW (14 countries) | Complete |
| Expedia | Complete |
| Qantas NZ | Complete |
| Qantas AU | Planned |
| Jetstar | In progress |
| United | Complete |

## Documentation

Each brand directory has its own docs with brand-specific colors, variables, and template status:

- [`tg/us/zurich/claude.md`](tg/us/zurich/claude.md) — Figma workflow, dark mode, hero image patterns
- [`row/CLAUDE.md`](row/CLAUDE.md) — ROW markets, rebranding rules, modernization status
- [`expedia/CLAUDE.md`](expedia/CLAUDE.md) — Expedia template structure, Handlebars variables
- [`qantas/claude.md`](qantas/claude.md) — Lifecycle emails, underwriter transition context
- [`api-testing/CLAUDE.md`](api-testing/CLAUDE.md) — Thunder Client integration workflow
