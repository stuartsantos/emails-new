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
- **Outer body area** (dark background in dark mode):
  - Use `.body-bg` on the body and outer container table
  - Use `.dark-text` on preheader text row (above main content) so text becomes white in dark mode
  - Use `.dark-link` on preheader links so they become white in dark mode (blue links lack contrast on dark background)
- **White content areas** (should stay white in dark mode):
  - **Do NOT use** `.content-bg` on white background tables - this causes them to turn dark gray (#2d2d2d)
  - **Do NOT use** `.dark-text` on text inside white content areas - this would make text white on white
- Framework includes support for:
  - `@media (prefers-color-scheme: dark)`
  - Gmail dark mode (`[data-ogsc]`)
  - Outlook.com dark mode (`[data-ogsb]`)

## Folder Structure
```
zurich/
├── img/                    # Shared image assets
├── docs/                   # Source Word documents for content
├── fulfillment/            # Customer journey emails
├── holiday/                # Holiday-themed emails
├── seasonal-update/        # Seasonal BAU emails
├── sponsor/                # Sponsorship emails (Zurich Classic)
└── travel-tips/            # Travel tips emails (monthly series)
```

Note: All HTML files reference images using `../img/` relative paths.

## Design to HTML Mapping

### Customer Journey (Fulfillment)

| HTML File | Figma Design |
|-----------|--------------|
| fulfillment/save-quote-followup.html | [Save Quote](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=4-179&m=dev) |
| fulfillment/two-week-post-trip.html | [2-wk Post Trip](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=498-1830&m=dev) |
| fulfillment/two-month-followup.html | [2-mo Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=491-1252&m=dev) |
| fulfillment/six-month-bag.html | [6-mo Follow up Baggage](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=782-2922&m=dev) |
| fulfillment/six-month-trip-can.html | [6-mo Follow up Trip Can](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=781-91&m=dev) |
| fulfillment/six-month-med.html | [6-mo Follow up Medical](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=782-2690&m=dev) |
| fulfillment/twelve-month.html | [12-mo Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=610-853&m=dev) |
| fulfillment/eighteen-month.html | [18-mo Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=610-3731&m=dev) |
| fulfillment/two-year.html | [2-yr Follow up](https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=610-3894&m=dev) |

### BAU / Seasonal

| HTML File | Figma Design |
|-----------|--------------|
| seasonal-update/cruise-season-2026.html | [Seasonal Update](https://www.figma.com/design/DAZ409npFBAoynGcoJ7GpY/BAU-Emails?node-id=2002-1917&m=dev) |

### Holiday Emails

| HTML File | Notes |
|-----------|-------|
| holiday/cruise-day.html | Take a Cruise Day ([Figma](https://www.figma.com/design/DAZ409npFBAoynGcoJ7GpY/BAU-Emails?node-id=2001-318&focus-id=2002-2037&m=dev)) |
| holiday/national-park-week.html | National Park Week — base template for holiday series |
| holiday/solo-vacation.html | Solo Vacation Day |
| holiday/national-tourism-day-2026.html | National Tourism Day (May 7) |
| holiday/national-road-trip-day-2026.html | National Road Trip Day (May 22) |
| holiday/cheap-flight-day-2026.html | Cheap Flight Day (Aug 23) |
| holiday/labor-day-2026.html | Labor Day |
| holiday/thanksgiving-2026.html | Thanksgiving |
| holiday/travel-tuesday-2026.html | Travel Tuesday (Dec 1) |
| holiday/holiday-2026.html | Holiday/Christmas |
| holiday/new-years-2027.html | New Year's 2027 |

### Sponsor Emails

| HTML File | Figma Design |
|-----------|--------------|
| sponsor/zurich-classic.html | [Zurich Classic Sweepstakes](https://www.figma.com/design/q9c6YIC6aFzxIqr6ailozB/Zurich-Classic?node-id=1-1291&m=dev) |
| sponsor/zurich-classic-usatoday1.html | Zurich Classic USA Today ad #1 |
| sponsor/zurich-classic-usatoday2.html | Zurich Classic USA Today ad #2 |

### Travel Tips (Monthly Series)

| HTML File | Topic |
|-----------|-------|
| travel-tips/travel-tips-02-26.html | Money Saving Travel Tips ([Figma](https://www.figma.com/design/DAZ409npFBAoynGcoJ7GpY/BAU-Emails?node-id=2001-318&focus-id=2002-1709&m=dev)) |
| travel-tips/travel-tips-03-26.html | March 2026 tips |
| travel-tips/travel-tips-04-26.html | April 2026 tips — canonical reference template |
| travel-tips/travel-tips-05-26.html | Family Road Trip & Game Tips |
| travel-tips/travel-tips-06-26.html | Tips to Help Avoid Pickpockets in Europe |
| travel-tips/travel-tips-07-26.html | Top Tips for Family Summer Travel |
| travel-tips/travel-tips-08-26.html | Tips if You Have a Medical Emergency Abroad |
| travel-tips/travel-tips-09-26.html | Tips for Natural Disaster Safety |
| travel-tips/travel-tips-10-26.html | Tips for Managing Medication on the Go |
| travel-tips/travel-tips-11-26.html | Tips to Help Get Through TSA Quickly |
| travel-tips/travel-tips-12-26.html | Safety Tips for Frequent Flyers |

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
5. Include hidden preheader text using the div technique with `&zwnj;&nbsp;` padding (repeat 20x after preheader text — fills the email client's preview snippet with invisible characters so it doesn't pull in body content like table headers or variable names)
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
- After edits, check if any local image paths can be replaced with published absolute URLs cross-referencing other templates

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

All templates listed in the Design-to-HTML Mapping above are complete. Key milestones:

- **Jan 2026**: Initial 6 customer journey fulfillment emails + cruise-day, zurich-classic, travel-tips-02-26
- **Feb 2026**: save-quote-followup, two-week-post-trip, two-month-followup; dark mode fix applied across all 12 templates
- **Mar 2026**: Travel tips 03-26, 04-26 (established as canonical reference template); holiday series base templates (national-park-week, solo-vacation); sponsor emails (zurich-classic-usatoday1/2)
- **Mar–ongoing 2026**: Monthly travel tips (05-26 through 12-26), holiday email series (8 emails from national-tourism-day through new-years-2027)

### Image Assets
All images stored in `img/` folder (47 assets). Key categories:
- **Logos**: `logo-travel-guard-color.png`, `logo-travel-guard-color-new.png`, `logo-travel-guard-white.png`
- **Hero images**: Per-email hero images (e.g., `hero-baggage.jpg`, `hero-cruise.jpg`, `email-hero_12month-followup.png`, etc.)
- **Icons**: Navy (`icon-phone.png`, `icon-quote.png`, `icon-send.png`, etc.) and green variants (`icon-send-green.png`, `icon-quote-green.png`) for travel-tips emails
- **Decorative**: `plane-border.png`, `top_plane-teal.png`, `bottom_plane-teal.png`
- **Content images**: `img-assistance.jpg`, `img-packing.jpg`, `img-picking-plan.png`, `img-golf-trip.jpg`, etc.

### Color-Specific Icon Variants
- **Green (#a5d069)**: `icon-send-green.png`, `icon-quote-green.png` — used in travel-tips emails
- **Pink (#edacc4)**: `icon-star.png` — used in holiday emails (e.g., cruise-day.html)

### Hosted Reusable Assets (travelguard.com CDN)
These assets are hosted on the Travel Guard website and should be used across all emails where applicable. Use these URLs instead of local `../img/` paths for production emails.

**Logos:**
- White logo: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/logo-travel-guard-white.png`
- Color logo (blue): `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/travel-guard-logo-blue.png` (238px wide — used in newer fulfillment templates; older 6-mo templates mistakenly use `documents.travelguard.com` subdomain)

**Social Media Icons** (use in all emails):
- Facebook: `https://www.travelguard.com/content/dam/travelguard/us/images/email/shared/icon-fb.png` (30×30)
- Instagram: `https://www.travelguard.com/content/dam/travelguard/us/images/email/shared/icon-ig.png` (28×28)
- YouTube: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/youtube_social_circle_red@2x.png` (28×28)
- TikTok: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/tiktok@2x.png` (28×28)

**Icons - Navy (#003d6e):**
- Phone (small, 18×18): `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-phone.png`
- Phone 24/7: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-phone-24.png` (52×54)
- Quote: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-quote.png` (48px)
- Send/paper airplane: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Send@2x.png` (20px)
- Education: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/education@2x.png` (28px)
- Play: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Play@2x.png` (12px)
- Review/chat: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Outlined-03-Communication-Chat@2x.png` (19-21px)

**Icons - Green (#a5d069)** (for travel-tips emails):
- Send/paper airplane: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-send-green.png` (14×14)
- Quote: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-quote-green.png` (48px)

**Video Thumbnail:**
- What is travel insurance: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/video-thumbnail-tips.png` (500px wide)

**Emails using hosted URLs:** All fulfillment emails, cruise-day, cruise-season-2026, and travel-tips series use CDN-hosted assets for logos, social icons, and shared icons. The two-week-post-trip and two-month-followup templates are fully CDN-hosted (including hero images).

**Assets still using local `../img/` paths:** Email-specific hero images, `logo-travel-guard-color.png`, `icon-shield.png`, `icon-ship-cyan.png`, `icon-ship-navy.png`, and some content images (`img-assistance.jpg`, `img-packing.jpg`, `img-picking-plan.png`). Holiday email hero images are TBD from design team.

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

6. **Mobile overflow on `display: block` table cells with padding**: When a `<td>` is converted to `display: block; width: 100%` on mobile, any padding is added ON TOP of the 100% width (default `content-box` model), causing horizontal overflow. **Solution**: Always add `box-sizing: border-box !important` when using `display: block !important; width: 100% !important` on table cells in responsive CSS.

7. **Dark mode breaks white content areas (Feb 2026)**: The dark mode classes `.content-bg` and `.dark-text` were causing white content areas to turn dark gray (#2d2d2d) in dark mode, making text illegible. **Solution**: Remove `class="content-bg"` from all white background tables and `class="dark-text"` / `class="dark-text-secondary"` from text elements within white content areas. Only use `.body-bg` on the outer email container. This fix was applied to all 12 templates in the zurich folder.

### Open Follow-up Items
- [ ] **six-month-bag.html**: Request hero background image from UX designer
- [ ] **save-quote-followup.html**: Progress arrow (`plane-border.png`) needs refinement from UX designer
- [ ] **Holiday email hero images**: All 2026 holiday emails use placeholder hero image paths — awaiting assets from design team

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
All links (not just CTAs) use `cmpid` parameter with format: `emc-tgdirect-us-en-{category}-{emailname}`
- Holiday emails: `emc-tgdirect-us-en-holiday-{emailname}` (e.g., `takeacruiseday`, `roadtripdaymay26`, `thanksgiving26`)
- Travel Tips emails: `emc-tgdirect-us-en-traveltips-{mon}26` (e.g., `feb`, `jun26`, `dec26`)
- BAU emails: `emc-tgdirect-us-en-bau-cruiseseason`
- Fulfillment emails: `emc-tgdirect-us-en-fulfillment-{emailname}`
- Sponsor emails: `emc-tgdirect-us-en-sponsor-{emailname}`

### Font Stack
Primary: `'Noto Sans', 'Source Sans Pro', Arial, sans-serif`
