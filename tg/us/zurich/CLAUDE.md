# CLAUDE.md — TG Zurich (US)

Responsive HTML emails for Zurich Travel Insurance customer journey, BAU, holiday, sponsor, and travel-tips campaigns. Built from Figma designs.

For shared technical patterns (DOCTYPE, meta tags, MSO conditional, Google Fonts, dark mode CSS, layout, preheader, font stack, brand color palette, gotchas), see the **root `/CLAUDE.md`**. This file covers TG-Zurich-specific content: Figma-to-HTML mapping, hosted CDN assets, hero-image pattern, and known-issue workarounds.

**Brand source of truth:** `_work-items/tg-design-system/` is the bundled CoverMore-2025 Travel Guard design system (tokens, voice & tone, brand assets, do/don'ts). Skim `project/SKILL.md` before designing a new template — it spells out the rules that aren't obvious from the tokens alone. Root `/CLAUDE.md` has the asset inventory and token cross-reference.

## Folder Structure

```
zurich/
├── img/                    # Shared image assets (47 files)
├── docs/                   # Source Word documents for content
├── fulfillment/            # Customer journey emails
├── holiday/                # Holiday-themed emails
├── seasonal-update/        # Seasonal BAU emails
├── sponsor/                # Sponsorship emails (Zurich Classic)
└── travel-tips/            # Travel tips emails (monthly series)
```

All HTML files reference local images using `../img/` relative paths. Production emails should use the hosted CDN URLs documented below where available.

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
| holiday/world-tourism-day-2026.html | World Tourism Day (Sep 27) |
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

## Component Library

Templates reuse components from `/responsive-modular-email-templates/build/html/`. See root `/CLAUDE.md` for the inventory.

## Hero Image Pattern (Split Background)

Most TG templates use a hero image that overlaps the navy header and white body — the navy background extends 50% down the hero image:

```html
<!-- Title on Navy Background -->
<table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #003d6e;">
  <tr>
    <td align="center" style="padding: 15px 30px 20px 30px;">
      <h1 style="...color: #ffffff;">Title Here</h1>
    </td>
  </tr>
</table>

<!-- Hero Image — Overlapping navy and white -->
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
- `linear-gradient(to bottom, #003d6e 50%, #ffffff 50%)` on the td containing the hero image
- MSO conditional VML for Outlook compatibility
- After edits, check if local image paths can be replaced with hosted CDN URLs (cross-reference other templates)

## Hosted Reusable Assets (travelguard.com CDN)

Use these URLs instead of local `../img/` paths for production emails.

**Logos:**
- White logo: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/logo-travel-guard-white.png`
- Color logo (blue, 238px): `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/travel-guard-logo-blue.png` (used in newer fulfillment templates; older 6-mo templates mistakenly use `documents.travelguard.com` subdomain)

**Social Media Icons:**
- Facebook: `https://www.travelguard.com/content/dam/travelguard/us/images/email/shared/icon-fb.png` (30×30)
- Instagram: `https://www.travelguard.com/content/dam/travelguard/us/images/email/shared/icon-ig.png` (28×28)
- YouTube: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/youtube_social_circle_red@2x.png` (28×28)
- TikTok: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/tiktok@2x.png` (28×28)

**Icons — Navy (#003d6e):**
- Phone (small, 18×18): `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-phone.png`
- Phone 24/7: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-phone-24.png` (52×54)
- Quote: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-quote.png` (48px)
- Send/paper airplane: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Send@2x.png` (20px)
- Education: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/education@2x.png` (28px)
- Play: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Play@2x.png` (12px)
- Review/chat: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Outlined-03-Communication-Chat@2x.png` (19–21px)

**Icons — Green (#a5d069)** (travel-tips emails):
- Send/paper airplane: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-send-green.png` (14×14)
- Quote: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-quote-green.png` (48px)

**Icons — Pink (#edacc4)** (holiday emails like cruise-day): `icon-star.png`

**Video Thumbnail:**
- "What is travel insurance": `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/video-thumbnail-tips.png` (500px wide)

**Coverage:** All fulfillment, cruise-day, cruise-season-2026, and travel-tips emails use CDN-hosted assets for logos, social icons, and shared icons. The two-week-post-trip and two-month-followup templates are fully CDN-hosted (including hero images).

**Still using local `../img/` paths:** email-specific hero images, `logo-travel-guard-color.png`, `icon-shield.png`, `icon-ship-cyan.png`, `icon-ship-navy.png`, `img-assistance.jpg`, `img-packing.jpg`, `img-picking-plan.png`. Holiday email hero images are TBD from design team.

## Known Issues & Solutions (TG-specific)

1. **Figma SVG exports with CSS variables**: when exporting logos from Figma, they may contain `fill="var(--fill-0, #color)"`. Convert to PNG via:
   ```bash
   sed -i '' 's/var(--fill-0, #003D6E)/#003D6E/g' logo.svg
   sips -s format png -Z 476 logo.svg --out logo.png
   ```

2. **Mobile centering in HTML emails**: `text-align: center` on nested table elements is unreliable. Add a class to the container table (e.g., `centeronmobile`) and apply:
   ```css
   @media screen and (max-width: 600px) {
     table.centeronmobile { width: 75% !important; margin: 0 auto !important; }
   }
   ```

3. **Figma icon exports**: Figma MCP exports icons as SVG, but converting to PNG via macOS tools (`qlmanage`, `sips`) often produces broken or poorly rendered images. **Workaround**: have the user manually export from Figma as PNG at 2x scale.

4. **Right-aligning images in table cells**: when an image is narrower than its containing `<td>`, add `align="right"` to the td:
   ```html
   <td width="320" valign="top" align="right" class="header-img">
     <img src="../img/hero.png" alt="" width="289" style="display: block;">
   </td>
   ```

## Voice & Tone (from design system)

Paraphrased from `_work-items/tg-design-system/README.md` and `project/SKILL.md`. Read those for full detail.

- **Reassuring, not alarmist.** Lead with what's possible ("Travel covered. Trips earned."), not what could go wrong.
- **Clear, never breezy.** Insurance language has to be precise — *Trip Cancellation*, *Pre-Existing Medical Conditions*, *Cancel For Any Reason* are proper-noun product features, not casualisms.
- **Action-verb CTAs:** *Get a Quote*, *File a Claim*, *Manage Your Plan*, *Compare Plans*.
- **Italic taglines** are a signature voice device — a one-line italic kicker under a bold heading. Use sparingly: once per hero/section, never stacked.
- **Audience:** adults 25–65, US 50 states + DC, detail-readers — don't hide the fine print.

## Don'ts (from design system)

- No emoji — anywhere. Use SVG icons or text.
- No drop shadows on text.
- No gradient text fills.
- No left-border accent cards (the AI-slop info-card trope).
- No three-color CTA gradients — CTAs are flat fills.
- No filler stats ("98% of travelers say…", "2 minute quote", "24/7") unless real and source-able.
- No "Trusted by" logo bars — Travel Guard is a B2C insurance brand, not a SaaS product.
- No "fun" insurance jokes, cartoon mascots, or stock-photo collages of people in airports laughing at phones.

## Open Follow-up Items

- [ ] **six-month-bag.html**: request hero background image from UX
- [ ] **save-quote-followup.html**: progress arrow (`plane-border.png`) needs refinement from UX
- [ ] **Holiday email hero images**: all 2026 holiday emails use placeholder hero image paths — awaiting assets from design team. `World Tourism Day.jpg` now available in `docs/` — needs wiring into `holiday/world-tourism-day-2026.html`

## Campaign Tracking

All links (not just CTAs) use the `cmpid` parameter, format `emc-tgdirect-us-en-{category}-{emailname}`:

| Category | Pattern |
|----------|---------|
| Holiday | `emc-tgdirect-us-en-holiday-{emailname}` (e.g., `takeacruiseday`, `roadtripdaymay26`, `thanksgiving26`) |
| Travel Tips | `emc-tgdirect-us-en-traveltips-{mon}26` (e.g., `feb`, `jun26`, `dec26`) |
| BAU | `emc-tgdirect-us-en-bau-cruiseseason` |
| Fulfillment | `emc-tgdirect-us-en-fulfillment-{emailname}` |
| Sponsor | `emc-tgdirect-us-en-sponsor-{emailname}` |
