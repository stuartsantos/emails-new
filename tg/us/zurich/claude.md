# Zurich Email Project

## Project Overview
Create responsive HTML emails for Zurich Travel Insurance customer journey campaigns using Figma designs as reference.

## Email Client Targets
- iPhone Mail app (latest iOS)
- Android Mail app (latest)
- Gmail mobile apps (iOS and Android)
- Desktop Gmail (web)
- Desktop Apple Mail
- Desktop Outlook 2016 (with fallbacks)

## Responsive Requirements
- Desktop max-width: 600px
- Mobile breakpoint: `@media (max-width: 600px)`
- Full-width on mobile devices

## Dark Mode Requirements
- Ensure text legibility when dark mode is enabled on mobile
- Use dark mode CSS classes: `.body-bg`, `.content-bg`, `.dark-text`, `.dark-text-secondary`
- Framework includes support for:
  - `@media (prefers-color-scheme: dark)`
  - Gmail dark mode (`[data-ogsc]`)
  - Outlook.com dark mode (`[data-ogsb]`)

## Design to HTML Mapping

| HTML File | Figma Design | Category |
|-----------|--------------|----------|
| cruise-season-2026.html | [Seasonal Update](https://www.figma.com/design/DAZ409npFBAoynGcoJ7GpY/BAU-Emails?node-id=2002-1917&m=dev) | BAU |
| six-month-bag.html | [6-mo Follow up Baggage](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=782-2922&m=dev) | Customer Journey |
| six-month-trip-can.html | [6-mo Follow up Trip Can](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=781-91&m=dev) | Customer Journey |
| six-month-med.html | [6-mo Follow up Medical](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=782-2690&m=dev) | Customer Journey |
| twelve-month.html | [12-mo Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=610-853&m=dev) | Customer Journey |
| eighteen-month.html | [18-mo Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=610-3731&m=dev) | Customer Journey |
| two-year.html | [2-yr Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=610-3894&m=dev) | Customer Journey |

## Template Framework Reference
Use components from: `/responsive-modular-email-templates/build/html/`

### Available Components
**Wrappers:**
- `wrappers/default.html` - Standard email wrapper with preheader, dark mode support, MSO conditionals
- `wrappers/full-width.html` - Full-width layout variant
- `wrappers/outlook.html` - Outlook-specific optimizations

**Headers:**
- `headers/img.html` - Image header
- `headers/aig.html` - AIG logo header (light)
- `headers/aig-white.html` - AIG logo header (dark background)
- `headers/aig-motion.html` - Animated gradient header

**Columns:**
- `columns/1col.html` - Single column layout
- `columns/2col.html` - Two column layout (stacks on mobile)
- `columns/3col.html` - Three column layout (stacks on mobile)

**Components:**
- `components/button.html` - CTA button (Outlook compatible)
- `components/text.html` - Body text block
- `components/heading.html` - Section heading
- `components/subheading.html` - Section subheading
- `components/img-1col.html` - Single column image
- `components/img-full-width.html` - Full-width image
- `components/icon-left.html` - Icon with text (icon left)
- `components/icon-right.html` - Icon with text (icon right)
- `components/icon-top.html` - Icon with text (icon above)
- `components/ul.html` - Unordered list
- `components/ul-checked.html` - Checklist style list
- `components/quote.html` - Pull quote
- `components/social.html` - Social media icons
- `components/video.html` - Video thumbnail with link

## Coding Standards

### Required
1. All images MUST have `alt` attributes (use `alt=""` for decorative images)
2. Use table-based layouts for Outlook compatibility
3. Inline all styles (Gmail strips `<style>` from body)
4. Use MSO conditionals for Outlook-specific fixes: `<!--[if mso]>...<![endif]-->`
5. Include hidden preheader text using the div technique
6. Add `role="presentation"` to layout tables for accessibility
7. Use font stack: `'Source Sans Pro', 'Avenir Next', 'Calibri', sans-serif`

### Meta Tags (included in wrappers)
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="x-apple-disable-message-reformatting">
<meta name="format-detection" content="telephone=no, date=no, address=no, email=no">
<meta name="color-scheme" content="light dark">
<meta name="supported-color-schemes" content="light dark">
```

### Outlook Considerations
- `box-shadow` not supported (graceful degradation)
- `border-radius` not supported (graceful degradation)
- Use MSO conditional tables to enforce widths
- Google Fonts may not load - always provide fallbacks

## Testing Checklist
- [ ] iPhone Mail (light mode)
- [ ] iPhone Mail (dark mode)
- [ ] Gmail iOS app (light mode)
- [ ] Gmail iOS app (dark mode)
- [ ] Gmail Android app
- [ ] Desktop Gmail (web)
- [ ] Apple Mail (desktop)
- [ ] Outlook 2016 (Windows)
- [ ] All links functional
- [ ] All images have alt text
- [ ] Preheader text displays correctly

---

## Completed Work

### Customer Journey Emails (Jan 2026)
All 6 customer journey emails have been built from Figma designs:

| Email | Status | Notes |
|-------|--------|-------|
| six-month-bag.html | Complete | Baggage claims stats (7,529 total with breakdown), testimonial section |
| six-month-med.html | Complete | Medical expense stats (16,050 claims, $2,575.36 avg), Consumer Reports citation |
| six-month-trip-can.html | Complete | Two-column stats (120,159 trip can + 53,840 trip inconvenience) |
| twelve-month.html | Complete | Split header design (purple/pink gradient), assistance services + packing tips blocks |
| eighteen-month.html | Complete | Plan picker illustration, "Compare Plans" CTA |
| two-year.html | Complete | Shield icon header, numbered benefits list, dual testimonials |

### Image Assets
All images stored in `img/` folder:
- **Logos**: `logo-travel-guard-color.png`, `logo-travel-guard-white.png` (converted from SVG with CSS variables replaced)
- **Hero images**: `hero-baggage.jpg`, `hero-medical.jpg`, `hero-trip-can.jpg`, `hero-12month.jpg`, `hero-18month.jpg`, `hero-2year.jpg`
- **Icons**: `icon-phone.png`, `icon-quote.png`, `icon-review.png`, `icon-shield.png`, `icon-facebook.png`, `icon-instagram.png`, `icon-youtube.png`, `icon-tiktok.png`
- **Content images**: `img-assistance.jpg`, `img-packing.jpg`, `img-picking-plan.png`

### Known Issues & Solutions
1. **Figma SVG exports with CSS variables**: When exporting logos from Figma, they may contain `fill="var(--fill-0, #color)"`. Convert to PNG using:
   ```bash
   sed -i '' 's/var(--fill-0, #003D6E)/#003D6E/g' logo.svg
   sips -s format png -Z 476 logo.svg --out logo.png
   ```

2. **Campaign tracking**: All CTAs use `cmpid` parameter format: `emc-tgdirect-us-en-fulfillment-{emailname}`

3. **Mobile centering in HTML emails**: Using `text-align: center` on nested table elements is unreliable. Instead, add a class to the container table (e.g., `centeronmobile`) and apply:
   ```css
   @media screen and (max-width: 600px) {
     table.centeronmobile { width: 75% !important; margin: 0 auto !important; }
   }
   ```
   This constrains the table width and uses `margin: auto` to center it horizontally.

### Follow-up Items
- [ ] **six-month-bag.html**: Request hero background image from UX designer. The Figma design has a background image in the hero area that isn't surfacing as an exportable image asset.
- [ ] **twelve-month.html**: Request full header image from UX designer. The Figma design has a diagonal/angled edge where the purple section overlays the beach photo. For Outlook compatibility, this needs to be exported as a single composed image with the diagonal edge baked in (purple gradient + logo + text + angled photo as one image).
- [ ] **eighteen-month.html**: Request full header image from UX designer. The Figma design has a curved edge where the navy section meets the hero photo. For Outlook compatibility, this needs to be exported as a single composed image with the curve baked in (navy + logo + text + curved photo as one image).
- [ ] **two-year.html**: Request CTA box image from UX designer. The "Get My Quote" callout has a woman-on-plane image with a curved left edge (mask effect). For Outlook compatibility, this needs to be exported with the curved edge baked into the image.

### Recent Fixes (Jan 2026)

**cruise-season-2026.html:**
- Fixed logo: Changed to `logo-travel-guard-white.png` for navy background
- Fixed dotted border: Changed from `1px dashed` to `2px dotted` under logo
- Fixed quote icon aspect ratio: Removed fixed height, use `height: auto`
- Fixed Coverages/Services layout:
  - Desktop: Two-column layout (heading left, list right) with `padding-left: 40px` on list cells
  - Mobile: Stacked and centered using CSS:
    ```css
    .features-cell { padding-left: 80px !important; padding-right: 80px !important; }
    .features-heading { padding-left: 0 !important; padding-right: 0 !important; }
    .features-heading table { margin-left: auto !important; margin-right: auto !important; }
    ```

**six-month-bag.html:**
- Fixed dotted border: Changed from `1px dashed` to `2px dotted` under logo
- Fixed quote icon: Re-exported from Figma, fixed `preserveAspectRatio` and CSS variables, removed fixed height
- Fixed stats breakdown centering: Added `margin: 30px auto 0 auto` to center table
- Fixed mobile stats layout: Updated CSS for centered stacking of numbers above descriptions

**six-month-med.html:**
- Fixed dotted border: Changed from `1px dashed` to `2px dotted`
- Fixed dollar amount color: Changed from green (`#007a3d`) to red (`#af0827`) to match Figma

**six-month-trip-can.html:**
- Fixed dotted border: Changed from `1px dashed` to `2px dotted`

**twelve-month.html:**
- Fixed dotted border: Changed from `1px dashed` to `2px dotted`
- Fixed circular images: Cropped `img-assistance.jpg` and `img-packing.jpg` to squares, added explicit `width` and `height` attributes
- Fixed social media icons: Made dimensions square (26×26 for Facebook, 24×24 for others)

**eighteen-month.html:**
- Fixed dotted border: Changed from `1px dashed` to `2px dotted`
- Fixed phone icon: Re-exported from Figma SVG, fixed CSS variables and `preserveAspectRatio`, converted to PNG

**two-year.html:**
- Fixed dotted border: Changed from `1px dashed` to `2px dotted`
- Fixed quote icons (2 instances): Same fix as other emails
- Fixed header shield icon: Replaced CSS table approximation with proper shield PNG (31×55px)
- Fixed header layout: Moved dotted border from between shield/text to between text/logo
- Fixed social media icons: Made dimensions square (26×26 for Facebook, 24×24 for others)
- Fixed mobile header: Added `centeronmobile` class with responsive CSS for proper centering on mobile (logo above, shield and text stacked below)

### Color Reference
- Navy (TG Navy): `#003d6e`
- Zurich Blue Dark: `#005b94`
- Zurich Blue: `#0076be`
- Nightsky Purple: `#302261`
- Seafoam/Teal: `#64c5b9`
- Cyan accent: `#66cbe1`
- Snowmelt border: `#9cc7e6`
- Pink (gradient): `#db5989`
- Red (highlight): `#af0827`
- Body text: `#1c252e` or `#343741`

### Font Stack
Primary: `'Noto Sans', 'Source Sans Pro', Arial, sans-serif`
