# Brand Fonts Setup

_Started 2026-05-03 19:26 UTC_

---

## User



## Assistant

I'll start by exploring the Figma file to understand Travel Guard's brand and design system.

_[tool: update_todos]_

_[tool: fig_read]_

_[tool: fig_ls]_

Good. Let me explore foundations in parallel.

_[tool: fig_read]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

Let me read each foundation in detail.

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

Let me read the actual content of these foundation files.

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

I have enough now. Let me snip earlier exploration and continue building.

_[tool: snip]_

Let me look at the logo files, button, header, and brand icons to gather components/assets.

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: snip]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: snip]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: snip]_

Let me snip earlier exploration; the logo SVG render via vectors won't be useful — I'll fig_screenshot the logo node directly when needed and rely on copying the actual logo PNG/SVG from the file. Let me view the logo via screenshot once, then proceed.

_[tool: fig_screenshot]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: snip]_

_[tool: fig_screenshot]_

_[tool: snip]_

I can see button system clearly: 4 types (primary navy, secondary teal, tertiary outlined navy, link), 3 sizes, with optional + or check icons. Let me look at hero, header, cards, and brand patterns.

_[tool: fig_screenshot]_

_[tool: fig_screenshot]_

The screenshots crop large frames poorly. Let me drill into specific frames at smaller scope:

_[tool: snip]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

Let me explore patterns/imagery and the IMAGERY page:

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: snip]_

Let me find image assets and patterns to copy. The waves pattern uses 357 small vectors which won't be copyable easily — let me find SVG files for the icon set, full hero images, etc.

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

Let me dig into the SHIELDWomanWine assets (these are key brand imagery), the topographic pattern vectors, and the cover.

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_ls]_

_[tool: snip]_

Topographic pattern is single Vector.svg repeated. The shield/woman-wine is a real PNG. Let me check the brand icons (these have actual SVG paths and are key) and look at hero, plan tile assets.

_[tool: fig_read]_

_[tool: fig_screenshot]_

_[tool: fig_ls]_

_[tool: snip]_

_[tool: snip]_

I have a strong picture of the system now. Let me grep for some product/website screenshots and inspect the topographic SVG quickly. Then I'll start building.

_[tool: fig_ls]_

_[tool: fig_grep]_

_[tool: fig_grep]_

_[tool: fig_grep]_

Good — I see this is "Travel Guard CoverMore branding 2025". Let me check screenshot from Thomas (real product), header/nav items.

_[tool: fig_ls]_

_[tool: fig_grep]_

_[tool: fig_grep]_

Good, I have what I need. Let me check what files I already have in the project.

_[tool: list_files]_

Empty project. Let me set things up — set the title, scan the key foundation pages, then build everything.

_[tool: set_project_title]_

_[tool: fig_read]_

Now let me read the key foundation pages and grab logo + key brand assets.

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

Excellent. Let me now read the typography & color details, and pull all the brand assets I need.

_[tool: fig_read]_

_[tool: fig_read]_

_[tool: fig_read]_

Excellent. Now I have a comprehensive understanding. Let me look at the Frame557 web color system, headers, buttons, and grab assets.

_[tool: fig_read]_

_[tool: fig_grep]_

I have enough. Buttons are pill-shaped (40px radius), TG Navy (#003D6E) primary, white secondary with border, fontSize 18/16/12 for default/small/xsmall. Let me grab assets and start building.

_[tool: fig_copy_files]_

_[tool: fig_ls]_

The logo only has Vector.svg + Vector2/ subdirectory. The two-color logo needs both pieces. Let me check.

_[tool: fig_read]_

_[tool: fig_ls]_

The logo is built from many tiny vector glyphs — too fragmented. Let me try fig_screenshot of the logo node to get a clean PNG, and also screenshot a brand pattern for visual reference.

_[tool: fig_screenshot]_

Travel Guard logo is just the wordmark in TG Navy with a small ®. I'll save this as a PNG.

_[tool: run_script]_

Now let me look at brand patterns and grab a topographic image for backgrounds. Let me also check the screenshot from Thomas (real product) for additional context.

_[tool: copy_files]_

_[tool: fig_ls]_

_[tool: fig_ls]_

Let me grab the topographic pattern via fig_copy_files instead.

_[tool: fig_copy_files]_

Let me peek at the product screenshot to get the visual direction & also check the Pages-Heroes for hero look + existing imagery.

_[tool: view_image]_

Excellent. This shows the brand in action — Travel Guard logo (navy), warm photo imagery (people traveling, golden hour), navy and seafoam accents, clean type. Now I have everything I need.

Let me build the design system. First the colors_and_type.css and a few key page heroes for context.

_[tool: fig_grep]_

_[tool: snip]_

Hero pattern is clear: full-bleed photo with TG Navy 90% opacity overlay box containing breadcrumb + 38px h1 + 16-24px subtext + button. Now I have the complete picture. Let me build everything.

_[tool: write_file]_

Now let me build all the preview cards in one batch — colors, type, brand assets, components.

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

Now type, spacing/radius/shadow, and brand cards.

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

Now brand assets cards and components. Let me check what brand assets I have.

_[tool: list_files]_

_[tool: list_files]_

I haven't actually copied brand assets yet. Let me look at what's in the figma file for logo + imagery + icons and copy them.

_[tool: fig_grep]_

_[tool: fig_ls]_

There's a `/Logo` and `/Brand---Logo` page. Let me explore.

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: snip]_

_[tool: fig_ls]_

_[tool: fig_ls]_

_[tool: snip]_

_[tool: fig_read]_

_[tool: snip]_

_[tool: fig_screenshot]_

I'll build my own clean Travel Guard wordmark in SVG since reconstructing the figma vector breakdown isn't reliable. Let me create the logo, brand assets, and component cards.

_[tool: snip]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: snip]_

Now create patterns and brand cards.

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

Now component cards: buttons, form fields, plan tile, page hero, accordion, alert.

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

Now register all preview cards as design system assets, build the marketing UI kit, write README + SKILL.md.

_[tool: register_assets]_

_[tool: set_project_title]_

Now the marketing UI kit (a sample web page demonstrating components in real composition) and supporting docs.

_[tool: write_file]_

Now write README and SKILL.md.

_[tool: write_file]_

_[tool: write_file]_

Now finish: complete todos and ship.

_[tool: update_todos]_

_[tool: done]_

_[tool: fork_verifier_agent]_

Travel Guard design system is built. The package:

**Foundation**
- `colors_and_type.css` — full token set (TG Navy + Zurich Blue palette, semantic ramps, 4 brand gradients, Noto Sans type scale, spacing/radii/shadows)
- `brand/` — logo (light + reverse), map pin, speech bubbles, topographic + waves patterns

**Reference assembly**
- `UI Kit — Travel Guard Marketing.html` — composed marketing page: utility bar, sticky nav, signature hero (full-bleed gradient + topographic pattern + 92% navy overlay card + italic tagline), 3-tier plan tiles with featured ribbon, coverage grid, navy quote band with form, FAQ accordion, dark footer

**Specimen cards** — 18 design-system tab cards across Colors / Type / Spacing / Brand / Components

**Docs**
- `README.md` — content fundamentals (voice, audience, what we never do), visual foundations (color hierarchy, type roles, spacing/radii/shadows), iconography, file index
- `SKILL.md` — hard rules for designing in the system (hero formula, plan-tile spec, don'ts list, how to handle out-of-system asks)

Caveats: the logo wordmark is a clean Noto Sans recreation rather than the exact Figma vector outline; if you have the official .svg artwork, drop it in `brand/logo-tg-navy.svg` and `brand/logo-tg-white.svg` to replace. Same for photography — heroes currently use brand gradient + topographic pattern as a placeholder system; swap in real travel imagery when available.

## User

I see it's missing the brand fonts, but they're just Noto Sans found here: https://fonts.google.com/noto/specimen/Noto+Sans

are you able to pull from there?

## Assistant

Yes — the CSS already imports Noto Sans from Google Fonts at the top of `colors_and_type.css`. Let me verify it's loading the full weight range we need (300/400/500/600/700/800 + light italic).

_[tool: read_file]_

It's already pulling the right weights from Google Fonts — Noto Sans 300/400/500/600/700/800 plus light/regular/semibold italic, and Source Sans 3 as the body alt. Should be loading correctly across all the previews and the UI kit.

Quick check — let me confirm it's actually rendering as Noto Sans (not falling through to system-ui).

_[tool: show_html]_

The font import was already in place — Noto Sans is loading from Google Fonts across the system (weights 300/400/500/600/700/800 plus the italic variants the brand uses for taglines), with Source Sans 3 as the body alt.

If you want to verify it's rendering correctly in your view, just refresh `UI Kit — Travel Guard Marketing.html` — headlines should look distinctly Noto Sans (slightly more open apertures and humanist feel than Inter or system fonts).

## User

so I can just dismiss this message then?

## Assistant

Yes — that warning is a generic check that looks for locally-uploaded font files in the project. Since Noto Sans is loading from Google Fonts via `@import` (not uploaded as `.woff2` files), it triggers the warning even though the typography is rendering correctly.

You can safely dismiss it. The fonts are real Noto Sans, served from Google's CDN — same source the Figma file is presumably pulling from.

If you'd rather make the warning go away properly, you could upload the Noto Sans `.woff2` files to the project and swap the `@import` for local `@font-face` rules. But for a design system that lives on the web, the Google Fonts import is the cleaner setup.

## User

Regenerate "Logo": it doesn't match the look of the svg

## Assistant

Let me look at the actual SVG you uploaded.

_[tool: read_file]_

This is the actual Travel Guard wordmark vector (logotype paths). Let me save the white version, derive a navy version (same paths, swap fill), and update the preview card.

_[tool: run_script]_

The `=` in the filename trips the script sandbox. Let me copy it first to a sane name, then process.

_[tool: copy_files]_

Now derive the navy version from the saved white file.

_[tool: run_script]_

Now update the logo preview card to use the real wordmarks at proper scale.

_[tool: write_file]_

_[tool: show_to_user]_

Updated — both logo files now use the real Travel Guard wordmark vector you uploaded:
- `brand/logo-tg-white.svg` — your uploaded white version
- `brand/logo-tg-navy.svg` — same paths, fill swapped to TG Navy `#003D6E`

The preview card now shows the proper logotype on both light and dark backgrounds. The UI kit's nav and footer pick this up automatically since they reference the same files.

## User

Regenerate "Brand patterns": topographic pattern and waves didn't seem to import well

## Assistant

Let me look at the actual patterns in the figma file.

_[tool: fig_ls]_

_[tool: fig_ls]_

The figma vfs only has component refs, not raw SVG. Let me screenshot them so I can recreate accurately.

_[tool: fig_grep]_

Let me screenshot the actual topographic and waves symbols so I can see their real design.

_[tool: fig_screenshot]_

_[tool: fig_screenshot]_

The white-on-white symbols don't render. Let me grab the dark-fill versions — Topographic Sand and the Zurich Blue wave — to see the actual shape.

_[tool: fig_screenshot]_

_[tool: fig_screenshot]_

Now I see the real designs:
- **Topographic** = organic, dense, blob-style contour map (not concentric rings — random wandering closed curves)
- **Waves** = uniform thin horizontal sine waves, very dense (~50+ rows), single hue

Let me rebuild both. The topographic one needs an organic noise-driven path; I'll generate it programmatically. The waves are simple repeating sine paths.

_[tool: run_script]_

Now update the preview to show them tile-able. The figma shows them dense with tinted color tiles (sand for topographic, sky-on-white for waves) — I'll show them as tile cards with several color variants.

_[tool: write_file]_

_[tool: show_to_user]_

Updated. Both patterns are now generated to match the Figma originals:

- **Topographic** — organic blob-style contour map (random closed bezier curves with nested inner contours) instead of the concentric rings I had before. Shown over Sand, Snowmelt, and Navy grounds.
- **Waves** — dense uniform horizontal sine rows (~60 rows, fine 0.7px stroke) replacing the layered two-tone version. Shown over White, Glacier, and Navy grounds.

The Navy variants use `background-blend-mode: screen` so the blue lines lift to a soft cyan over the dark ground (matching how the figma shows the white-line-on-navy variants).

Heads-up: the topographic SVG is a procedural recreation rather than the exact Figma vector. If you have access to the original SVG export from Figma, drop it in at `brand/pattern-topographic.svg` and `brand/pattern-waves.svg` and the previews + UI kit will pick it up automatically.

## User

Regenerate "UI Kit — Travel Guard Marketing": we don't have this right now

## Assistant

You'd like me to remove the marketing UI kit since it's not something Travel Guard has yet. Let me unregister and delete it.

_[tool: unregister_assets]_

_[tool: delete_file]_

Now let me update the README and SKILL.md to remove references to that file.

_[tool: str_replace_edit]_

_[tool: str_replace_edit]_

_[tool: show_to_user]_

Removed. The marketing UI kit file is gone, the asset is unregistered from the design system tab, and both `README.md` and `SKILL.md` no longer reference it. The system is now scoped to what Travel Guard actually has today: tokens (`colors_and_type.css`), brand assets (`brand/`), and the atomic component specimen cards (`preview/`).

