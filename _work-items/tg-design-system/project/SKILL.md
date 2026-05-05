# Designing in the Travel Guard system

Use this when the user asks for any Travel Guard design — landing page, plan-comparison screen, marketing email, claim flow, sales-channel collateral, etc. **Read this before you start.** Most of the rules below aren’t encoded in the tokens; they’re what makes a design feel *Travel Guard* instead of generic-blue-insurance.

## What this project gives you

- `colors_and_type.css` — all design tokens (colors, type, spacing, radii, shadows) plus reset and semantic classes. **Always link this.**
- `brand/` — logos (`logo-tg-navy.svg`, `logo-tg-white.svg`), brand icons, brand patterns (`pattern-topographic.svg`, `pattern-waves.svg`).
- `preview/` — specimen cards demonstrating each primitive (buttons, forms, plan tiles, hero, accordion, alerts). **Lift patterns from these directly when building new pages.**

## Step one: link the foundation

Every new HTML file starts with:

```html
<link rel="stylesheet" href="colors_and_type.css">
```

That gives you `--tg-navy`, `--zurich-blue`, the Midnight neutral ramp, the type scale, the spacing scale, the radii, and the shadow tokens.

## Hard rules

### Color
- **Headings are TG Navy** (`#003D6E`) on light, **white** on dark. Don’t use Zurich Blue for headings — it’s for CTAs and links.
- **CTAs are Zurich Blue** (`#2167AE`) for primary action, **white pill on TG Navy** when on dark hero, **Deep Sea Green** (`#005F62`) for the secondary brand action (File a Claim, urgent destructive flows).
- **One accent per composition.** If you’re using Amber for the “Most Popular” ribbon, don’t also use Watermelon and Lagoon nearby. Pick one accent and let it carry the moment.
- **Body text is Midnight** (`#1C252E`), secondary text is `--midnight-50`. Don’t use Zurich Blue or the gradients for body copy.
- **Backgrounds.** White is default. `#F1F6FB` (Glacier 50) is the alternating section bg. TG Navy is reserved for hero, footer, and the quote band.

### Type
- **One H1 per page.** Section headers are H2.
- **Eyebrow → H2 → tagline** is the canonical section opener. Eyebrow is uppercase Bold Zurich Blue, +0.1em tracking. Tagline is Light Italic, gray, smaller than the H2.
- **Italic only for taglines.** Never italicize body, never italicize headlines.
- **All-caps only for eyebrows and small section labels** (≤24px). Never set H1/H2/H3 in caps.
- **Noto Sans is the brand face.** Don’t substitute Inter, Roboto, or system stacks unless the user explicitly asks for a fallback.

### Layout
- Page is `max-width: 1280px` with `padding: 0 32px`. Sections are `padding: 96px 0` on desktop.
- Cards: `border: 1px solid #E6E7E8`, `border-radius: 4px`, `padding: 24–28px`, hover lifts to `--sh-card-hover`.
- Buttons are full-pill (`border-radius: 40px`), `1.5px` stroke, default size `padding: 10px 22px / 16px`, gap to icon `8px`.
- Form fields are `44px` tall with `4px` radius and a Glacier focus ring (`box-shadow: 0 0 0 3px #E4EDF8`). Always pair with a Bold 14px label above.

### Hero pattern (the signature move)
The Travel Guard hero is unmistakable and should be reused for any landing or category page:
1. **Full-bleed photo or brand gradient** as the background.
2. **Topographic SVG pattern at ~25% opacity**, anchored bottom-right, scaled ~700px wide.
3. **A 92%-opacity TG Navy card** (max-width ~620px) sitting left, with:
   - breadcrumb in 70%-white, 13px,
   - H1 in 38–56px white Bold,
   - one Light Italic 24/30 tagline in 95%-white,
   - one or two pill CTAs (white-pill primary + ghost secondary).

Lift the markup straight out of `preview/comp-hero.html`.

### Plan & coverage tiles
- 3-column grid on desktop, 1-column on mobile.
- Featured tile gets a `6px` Amber top border, `2px` lift on hover, and a small uppercase Amber ribbon top-right.
- Price is 36–42px Bold TG Navy with secondary-gray “per traveler” next to it.
- Feature list uses a solid green-`#039855` circle + white-checkmark bullet (don’t use emoji or Unicode checks).

### Imagery
- Real travel photography preferred. When unavailable, compose a brand gradient + topographic pattern overlay.
- The four named gradients map to vibes: **Tropics** = beach/warm; **Golden Hour** = adventure/sunset; **Dusk** = nightlife/cities; **Woodland** = nature/outdoors.

## Don’ts

- **No emoji.** Anywhere. Use SVG icons or text.
- **No drop shadows on text.**
- **No gradient text fills.**
- **No left-border accent cards** (the AI-slop info-card trope).
- **No three-color CTA gradients.** CTAs are flat fills.
- **No “bento” grids of stat tiles** unless the user explicitly asks. Travel Guard pages tell a single linear story.
- **No filler stats** (“98% of travelers say…”, “2 minute quote”, “24/7”). If a number isn’t real and source-able, leave it out.
- **No “Trusted by” logo bars** unless the user asks — Travel Guard is a B2C insurance brand, not a SaaS product.

## Working with the user

If the user gives you a screenshot of an existing Travel Guard page and asks you to redesign it:
1. Identify which patterns from the UI kit it’s already using (hero, plan tiles, accordion).
2. Match the existing tone — don’t make it suddenly playful.
3. Offer 2–3 options: one that stays close to the existing system, one that pushes a single dimension (more imagery, bolder type, accent reshuffle), one that experiments more freely (different layout rhythm, novel gradient use).

If the user asks for something the system doesn’t cover (a dashboard, a claim-detail screen, a sales rep portal):
- Build new components in the same vocabulary — 4px radius, 1px Midnight-15 borders, Noto Sans, Zurich Blue actions, Glacier focus rings.
- Add them to the project as new files; don’t modify `colors_and_type.css` unless adding a new token.
