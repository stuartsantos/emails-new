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

## Folder Structure
```
zurich/
├── img/                    # Shared image assets
├── fulfillment/            # Customer journey emails
├── holiday/                # Holiday-themed emails
├── seasonal-update/        # Seasonal BAU emails
└── travel-tips/            # Travel tips emails
```

Note: All HTML files reference images using `../img/` relative paths.

## Design to HTML Mapping

| HTML File | Figma Design | Category |
|-----------|--------------|----------|
| seasonal-update/cruise-season-2026.html | [Seasonal Update](https://www.figma.com/design/DAZ409npFBAoynGcoJ7GpY/BAU-Emails?node-id=2002-1917&m=dev) | BAU |
| holiday/cruise-day.html | [Take a Cruise Day](https://www.figma.com/design/DAZ409npFBAoynGcoJ7GpY/BAU-Emails?node-id=2001-318&focus-id=2002-2037&m=dev) | Holiday |
| holiday/zurich-classic.html | [Zurich Classic Sweepstakes](https://www.figma.com/design/q9c6YIC6aFzxIqr6ailozB/Zurich-Classic?node-id=1-1291&m=dev) | Holiday |
| travel-tips/travel-tips-02-26.html | [Travel Safety Tips](https://www.figma.com/design/DAZ409npFBAoynGcoJ7GpY/BAU-Emails?node-id=2001-318&focus-id=2002-1709&m=dev) | Travel Tips |
| fulfillment/six-month-bag.html | [6-mo Follow up Baggage](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=782-2922&m=dev) | Customer Journey |
| fulfillment/six-month-trip-can.html | [6-mo Follow up Trip Can](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=781-91&m=dev) | Customer Journey |
| fulfillment/six-month-med.html | [6-mo Follow up Medical](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=782-2690&m=dev) | Customer Journey |
| fulfillment/twelve-month.html | [12-mo Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=610-853&m=dev) | Customer Journey |
| fulfillment/eighteen-month.html | [18-mo Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=610-3731&m=dev) | Customer Journey |
| fulfillment/two-year.html | [2-yr Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=610-3894&m=dev) | Customer Journey |

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

### Hero Image Pattern (Split Background)
Most templates use a hero image that overlaps the navy header and white body - the navy background extends 50% down the hero image. Use this pattern:

```html
<!-- Title on Navy Background -->
<table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #003d6e;">
  <tr>
    <td align="center" style="padding: 15px 30px 20px 30px;">
      <h1 style="...color: #ffffff;">Title Here</h1>
    </td>
  </tr>
</table>

<!-- Hero Image - Overlapping navy and white -->
<table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%">
  <tr>
    <td align="center" style="background: linear-gradient(to bottom, #003d6e 50%, #ffffff 50%); padding: 0 30px 30px 30px;">
      <!--[if mso]>
      <v:rect xmlns:v="urn:schemas-microsoft-com:vml" fill="true" stroke="false" style="width:540px;height:150px;">
        <v:fill type="solid" color="#003d6e"/>
        <v:textbox inset="0,0,0,0">
      <![endif]-->
      <img src="../img/hero-image.jpg" alt="..." width="540" class="hero-img" style="display: block; max-width: 540px; width: 100%; height: auto;">
      <!--[if mso]>
        </v:textbox>
      </v:rect>
      <![endif]-->
    </td>
  </tr>
</table>
```

Key points:
- Use `linear-gradient(to bottom, #003d6e 50%, #ffffff 50%)` on the td containing the hero image
- Include MSO conditional VML for Outlook compatibility
- The hero image sits on top of this gradient, creating the split-background effect

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

### BAU Emails (Jan 2026)

| Email | Status | Notes |
|-------|--------|-------|
| holiday/cruise-day.html | Complete | "Take a Cruise Day" holiday email, pink accent (#db5989/#edacc4), assistance services section, social hashtag #TakeACruiseDaywithTG |
| holiday/zurich-classic.html | Complete | "Zurich Classic Sweepstakes" golf-themed email, cyan accent (#9cc7e6), three prize tiers (Grand Prize, First Place, Second Place), golf trip promo section with circular image, sweepstakes dates Feb 9 - Mar 22, 2026 |
| travel-tips/travel-tips-02-26.html | Complete | "Money Saving Travel Tips", green accent (#a5d069), numbered tips list, video library section, testimonial. Uses green icon variants: `icon-send-green.png`, `icon-quote-green.png` |

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
- **Hero images**: `hero-baggage.jpg`, `hero-medical.jpg`, `hero-trip-can.jpg`, `hero-12month.jpg`, `hero-18month.jpg`, `hero-2year.jpg`, `hero-cruise.jpg`, `hero-cruise-day.png`, `hero-travel-tips.png`, `hero-zurich-classic.jpg`, `email-hero_12month-followup.png`, `email-hero_18month-followup.png`, `email-hero_24month-followup.png`
- **Icons**: `icon-phone.png`, `icon-phone-24.png`, `icon-quote.png`, `icon-quote-green.png`, `icon-review.png`, `icon-shield.png`, `icon-star.png`, `icon-send.png`, `icon-send-green.png`, `icon-education.png`, `icon-play.png`, `icon-facebook.png`, `icon-instagram.png`, `icon-youtube.png`, `icon-tiktok.png`
- **Content images**: `img-assistance.jpg`, `img-packing.jpg`, `img-picking-plan.png`, `img-golf-trip.jpg`, `video-thumbnail.jpg`, `video-thumbnail-tips.png`

### Color-Specific Icon Variants
Some emails require icons in specific accent colors:
- **Green (#a5d069)**: `icon-send-green.png`, `icon-quote-green.png` - used in travel-tips emails
- **Pink (#edacc4)**: `icon-star.png` - used in holiday emails (e.g., cruise-day.html)

### Hosted Reusable Assets (travelguard.com CDN)
These assets are hosted on the Travel Guard website and should be used across all emails where applicable. Use these URLs instead of local `../img/` paths for production emails.

**Logo:**
- White logo: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/logo-travel-guard-white.png`

**Social Media Icons** (use in all emails):
- Facebook: `https://www.travelguard.com/content/dam/travelguard/us/images/email/shared/icon-fb.png` (30×30)
- Instagram: `https://www.travelguard.com/content/dam/travelguard/us/images/email/shared/icon-ig.png` (28×28)
- YouTube: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/youtube_social_circle_red@2x.png` (28×28)
- TikTok: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/tiktok@2x.png` (28×28)

**Icons - Navy (#003d6e):**
- Phone 24/7: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-phone-24.png` (52×54)
- Send/paper airplane: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Send@2x.png` (20px)
- Education: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/education@2x.png` (28px)
- Play: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Play@2x.png` (12px)
- Review/chat: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Outlined-03-Communication-Chat@2x.png` (19-21px)

**Icons - Green (#a5d069)** (for travel-tips emails):
- Send/paper airplane: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-send-green.png` (14×14)
- Quote: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-quote-green.png` (48px)

**Video Thumbnail:**
- What is travel insurance: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/video-thumbnail-tips.png` (500px wide)

**Emails using hosted URLs:**
- `holiday/cruise-day.html` ✓
- `travel-tips/travel-tips-02-26.html` ✓
- `fulfillment/six-month-bag.html` ✓
- `fulfillment/six-month-med.html` ✓
- `fulfillment/six-month-trip-can.html` ✓
- `fulfillment/twelve-month.html` ✓
- `fulfillment/eighteen-month.html` ✓
- `fulfillment/two-year.html` ✓
- `seasonal-update/cruise-season-2026.html` ✓

**Assets still using local paths** (no hosted equivalent available):
- Hero images (email-specific)
- `logo-travel-guard-color.png`
- `icon-phone.png` (small phone icon)
- `icon-quote.png` (navy quote icon)
- `icon-shield.png`
- `icon-ship-cyan.png`, `icon-ship-navy.png`
- Content images (`img-assistance.jpg`, `img-packing.jpg`, `img-picking-plan.png`)

### Known Issues & Solutions
1. **Figma SVG exports with CSS variables**: When exporting logos from Figma, they may contain `fill="var(--fill-0, #color)"`. Convert to PNG using:
   ```bash
   sed -i '' 's/var(--fill-0, #003D6E)/#003D6E/g' logo.svg
   sips -s format png -Z 476 logo.svg --out logo.png
   ```

2. **Mobile centering in HTML emails**: Using `text-align: center` on nested table elements is unreliable. Instead, add a class to the container table (e.g., `centeronmobile`) and apply:
   ```css
   @media screen and (max-width: 600px) {
     table.centeronmobile { width: 75% !important; margin: 0 auto !important; }
   }
   ```
   This constrains the table width and uses `margin: auto` to center it horizontally.

3. **Figma icon exports**: The Figma MCP tool exports icons as SVG files, but converting these to PNG using macOS tools (`qlmanage`, `sips`) often results in broken or poorly rendered images, especially for icons with light colors or transparency. **Workaround**: Have the user manually export icons directly from Figma as PNG files:
   - In Figma, select the icon node
   - In the right panel under "Export", add PNG export at 2x scale
   - Download and save to the `img/` folder

4. **Right-aligning images in table cells**: When an image is narrower than its containing `<td>`, add `align="right"` to the td to push the image flush to the right edge. This is commonly needed for header hero images that should sit against the right side of the email.
   ```html
   <td width="320" valign="top" align="right" class="header-img">
     <img src="../img/hero.png" alt="" width="289" style="display: block;">
   </td>
   ```

### Follow-up Items
- [ ] **six-month-bag.html**: Request hero background image from UX designer. The Figma design has a background image in the hero area that isn't surfacing as an exportable image asset.
- [x] **twelve-month.html**: Composed header image added (`email-hero_12month-followup.png`)
- [x] **eighteen-month.html**: Composed header image added (`email-hero_18month-followup.png`)
- [x] **two-year.html**: Composed CTA box image added (`email-hero_24month-followup.png`)

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
- Pink (watermelon): `#db5989`
- Pink light (watermelon50): `#edacc4`
- Green (jungle): `#a5d069`
- Glacier blue: `#e4edf8`
- Red (highlight): `#af0827`
- Body text: `#1c252e` or `#343741`

### Campaign Tracking
All CTAs use `cmpid` parameter with format: `emc-tgdirect-us-en-{category}-{emailname}`
- Holiday emails: `emc-tgdirect-us-en-holiday-takeacruiseday`
- Travel Tips emails: `emc-tgdirect-us-en-traveltips-feb`
- BAU emails: `emc-tgdirect-us-en-bau-cruiseseason`
- Fulfillment emails: `emc-tgdirect-us-en-fulfillment-{emailname}`

### Font Stack
Primary: `'Noto Sans', 'Source Sans Pro', Arial, sans-serif`
