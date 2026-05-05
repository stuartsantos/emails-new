# Travel Guard Design System

A working web design system for Travel Guard (CoverMore branding, 2025), reconstructed from the **Travel Guard Styles 2025.fig** source. This project gives you ready-to-use CSS tokens, brand assets, and component primitives — all wired together so you can drop new designs into the system.

---

## CONTENT FUNDAMENTALS

**Who Travel Guard is.** Travel Guard sells travel insurance to U.S. residents (50 states + DC). Plans cover trip cancellation, medical expenses, lost baggage, evacuation, and 24/7 traveler assistance. Underwritten by National Union Fire Insurance Company of Pittsburgh, PA. Travel Guard is part of CoverMore (Zurich Insurance Group) — that’s why the primary blue is called *Zurich Blue*.

**Voice & tone.**
- **Reassuring, not alarmist.** Lead with what’s possible (“Travel covered. Trips earned.”), not what could go wrong.
- **Clear, never breezy.** Insurance language has to be precise — “Trip Cancellation,” “Pre-Existing Medical Conditions,” “Cancel For Any Reason” are proper-noun product features, not casualisms.
- **Action-oriented.** CTAs are verbs: *Get a Quote*, *File a Claim*, *Manage Your Plan*, *Compare Plans*.
- **Italic taglines.** A signature voice device: a one-line italic kicker under a bold H1, often phrased as a value statement (“*Your trip investment won’t protect itself.*”). Use sparingly — once per hero/section, never stacked.

**Audience.** Adults 25–65 booking leisure or business travel: cruisers, family vacationers, frequent business travelers, international adventurers. Skews higher-income; insurance buyers are detail-readers, so don’t hide the fine print.

**What we never do.** No emoji. No “fun” insurance jokes. No cartoon mascots. No stock-photo collages of people in airports laughing at phones. No gradients on body text.

---

## VISUAL FOUNDATIONS

### Colors

The palette is structured in three tiers, plus semantic states. Token names and hex values are defined in `colors_and_type.css`.

**Primary — TG brand blues.** TG Navy `#003D6E` is the default heading and dark-surface color and the hero overlay. Zurich Blue `#2167AE` is the primary CTA, link, and accent. Snowmelt `#9CC7E6` and Glacier `#E4EDF8` are light accents used as section backgrounds and the focus ring. Night Sky `#302261` is a deep accent for richer compositions.

**Secondary — travel-inspired accents.** Jungle, Lagoon, Seafoam, Deep Sea Green, Amber, Terra Cotta, Watermelon, Sun Flare, Lavender Mist, Stone, Sand. Use one accent per composition to flag a single piece of content (a featured plan ribbon, a category tag, a callout illustration). Never mix three or more accent hues in the same view.

**Neutrals.** A 7-step Midnight ramp from `#1C252E` (body text) to `#F6F6F6` (subtle bg). Body text is `--midnight`, secondary text is `--midnight-50`, placeholder text and disabled UI is `--midnight-30`/`--midnight-15`, dividers are `--midnight-10`.

**Semantic states.** Each of `info`, `success`, `warning`, `error` has 50/200/500-or-600/900 ramps, used for inline alerts, validation, and status badges. Info reuses Zurich Blue for consistency with brand.

**Gradients.** Four named gradient pairs — *Tropics*, *Golden Hour*, *Dusk*, *Woodland* — for color-blocked backgrounds and category landing tiles. Always 135° corner-to-corner. Don’t put body text directly on gradients; use a solid card.

### Typography

**Type family.** Travel Guard’s primary face is **Noto Sans**, with **Source Sans 3** as the body alt. The CSS imports both from Google Fonts.

**Roles and sizes.** A simplified scale that maps to how the Figma file actually uses type:

| Role | Class | Spec |
|---|---|---|
| H1 (hero) | `.tg-h1` / `<h1>` | 38px / 1.15, Noto Sans Bold, navy or white |
| H2 (section) | `.tg-h2` / `<h2>` | 30px / 1.2, Noto Sans Bold, navy |
| H3 | `.tg-h3` / `<h3>` | 24px / 1.25, Noto Sans SemiBold, navy |
| H4 | `.tg-h4` / `<h4>` | 18px / 1.4, SemiBold, navy |
| Tagline | `.tg-tagline` | 24px / 30, Light Italic — the signature subhead |
| Eyebrow | `.tg-eyebrow` | 24px Bold, uppercase, +0.1em tracking, Zurich Blue |
| Body | `.tg-body` / `<p>` | 16px / 24, Regular |
| Small body | `.tg-body--sm` | 14px / 20, Regular, secondary color |
| Caption | `.tg-caption` | 12px / 16, secondary color |

**Rules of thumb.**
- One H1 per page. Section headers are H2, never H1 again.
- Eyebrow + H2 + tagline is the canonical section-opener stack.
- Italic light is **only** for taglines — never body, never headlines.
- All-caps is reserved for eyebrows and small section labels (≤24px).

### Spacing, radii, shadows

**Spacing scale.** A 4-pt base extended with the brand’s discrete steps: `4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 50 / 60 / 80 / 100 / 150 px`, exposed as `--sp-1` through `--sp-37`. Section padding is `96px` top/bottom on desktop. Card internal padding is `24–28px`. Form-row gap is `16px`.

**Radii.** The system is intentionally low-radius. Cards and inputs are `4px` (`--r-card`/`--r-sm`). Buttons are full-pill `40px` (`--r-pill`). Heroes and large containers stay at `4px`. Don’t introduce in-between values.

**Borders.** `1px solid --midnight-15` is the default thin border. Use `1px solid --snowmelt-blue` for blue-tinted callouts. Featured plan tiles get a `6px` top border in `--amber`.

**Shadows.** Three elevations + a brand hover: `--sh-1` (resting cards), `--sh-2` (menus), `--sh-3` (popovers/modals), `--sh-card-hover` (a tinted navy shadow used for plan-tile hover). Don’t stack shadows.

---

## ICONOGRAPHY & BRAND ASSETS

The `brand/` folder holds the ready-to-link SVGs used across the system:

| File | Purpose |
|---|---|
| `brand/logo-tg-navy.svg` | Primary wordmark on light backgrounds |
| `brand/logo-tg-white.svg` | Reverse wordmark for TG Navy and dark hero overlays |
| `brand/icon-mappin-navy.svg` | Brand map-pin mark (use with `filter: invert` for white/sand variants) |
| `brand/icon-speech-bubbles.svg` | Speech-bubble mark for Help / Advisor Connect |
| `brand/pattern-topographic.svg` | Concentric contour pattern, TG Navy ground — for hero accents |
| `brand/pattern-waves.svg` | Layered sine waves, Glacier ground — for section dividers |

**Imagery.** Travel Guard photography is travel-aspirational: planes, mountains, coastlines, people *experiencing* destinations rather than posing in them. When you don’t have real assets, use a 135° brand gradient (Tropics for warm regions, Dusk for adventure, Woodland for nature) plus the topographic pattern at ~25% opacity as a placeholder background.

**UI iconography.** Inline UI icons (form, navigation, coverage tiles) are 22–24px line icons, 2px stroke, `stroke-linecap: round`, `stroke-linejoin: round`, in Zurich Blue or Midnight.

---

## FILES IN THIS PROJECT

| Path | What it is |
|---|---|
| `colors_and_type.css` | Single source-of-truth: design tokens, type scale, semantic classes, native-element defaults |
| `brand/` | Logos, brand icons, brand patterns (SVG) |
| `preview/` | Atomic specimen cards rendered in the **Design System** tab — colors, type, spacing, brand, components |
| `SKILL.md` | Project skill — how to use this system correctly when designing new pages |
| `README.md` | This file |

## How to use it

1. Link `colors_and_type.css` from any new HTML file.
2. Use the `--tg-*` tokens for color, the `.tg-*` classes for type, the `--sp-*` and `--r-*` tokens for layout.
3. Copy component patterns out of the `preview/` cards — buttons, plan tiles, hero, forms, accordion, alerts are all production-ready.
4. Pull logos and patterns from `brand/`.
5. Read `SKILL.md` before designing — it spells out the rules that aren’t obvious from the tokens alone.
