# United + Travel Guard Co-Branded Policy Confirmation Email — Build Handoff

## Goal
Restyle `united/tmp/policy-confirmation.html` (currently TG/digdrct branding) into a **co-branded United Airlines + Travel Guard** policy confirmation email using United's brand identity — colors, fonts, and feel — while keeping the same content structure and Handlebars variables.

Figma reference: https://www.figma.com/design/1TFzWPErTki2hFoIEUjMzB/Customer-Journey-Emails?node-id=423-4608&m=dev

---

## United Brand Colors (extracted from united.com CSS)

| Token | Hex | Usage |
|-------|-----|-------|
| United Navy | `#002244` | Header bg, section headings, footer |
| United Blue (CTA) | `#1414D2` | Buttons, links |
| Hero Gradient | `#000000` → `#002244` | Header/hero gradient (black to navy) |
| Body text | `#333333` | Paragraph text |
| Background | `#F5F5F5` | Email body bg |
| White | `#FFFFFF` | Content areas |
| Section dividers | `#CCCCCC` | Replacing TG's blue-tint `#CADBF2` dividers |

## United Font Stack
- **Primary**: `'Noto Sans', Arial, sans-serif` (email-safe fallback for United's proprietary NeuePlak)
- Google Fonts: `https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;600;700&display=swap`
- **Replaces**: `'Source Sans Pro', 'Avenir Next', 'Calibri', sans-serif`

---

## Logo Assets

| Logo | URL | Notes |
|------|-----|-------|
| United globe | `https://www.united.com/2500e4e62233fbfe8ac6.unitedLogoNew.svg` | SVG — needs PNG fallback for Outlook via `<!--[if mso]>` conditional |
| TG white | `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/logo-travel-guard-white.png` | 238px wide in Zurich templates |

---

## Key Changes

### 1. Header / Hero Area
**Current**: Solid `#001CA3` blue bg with TG logo image, then separate hero image below.

**New**: Co-branded header with gradient background + travel image.
- **Top bar**: United Navy `#002244` with both logos side-by-side:
  - Left: United globe logo (white/light version)
  - Right: Travel Guard logo (white version)
- **Hero area**: CSS gradient from `#000000` (top) to `#002244` (bottom), with the existing beach hero image positioned on the right side
- **Headline text**: White, left-aligned over the gradient
- **VML fallback**: Solid `#002244` bg for Outlook (gradient not supported)

### 2. Color Replacements (throughout template)

| Element | Old (TG) | New (United) |
|---------|----------|--------------|
| Header bg | `#001CA3` | gradient or `#002244` |
| Section headings (Policy Details, etc.) | `#001871` | `#002244` |
| Links | `#1352DE` | `#1414D2` |
| CTA button bg | `#1352DE` | `#1414D2` |
| Section divider borders | `#CADBF2` | `#CCCCCC` |
| Footer bg | `#001871` | `#002244` |
| Dark footer bg | `#00114F` | `#001122` |
| Body text | `#343741` | `#333333` |
| Email body bg | `#F7F9FB` | `#F5F5F5` |
| Policy details box bg | `#F7F9FB` | `#F5F5F5` |
| Assistance section bg | `#F7F9FB` | `#F5F5F5` |

### 3. Font Replacement
- Replace all `'Source Sans Pro', 'Avenir Next', 'Calibri', sans-serif` → `'Noto Sans', Arial, sans-serif`
- Update Google Fonts `<link>` and `@import` to load Noto Sans instead of Source Sans Pro
- Keep same weights: 400 (regular) and 600 (semi-bold/bold)

### 4. Footer Updates
- Social media icons: use United-hosted versions from `container.travelguard.com/content/dam/tg-documents/united/icons/` (facebook_logo.png, instagram_logo.png, youtube_logo.png)
- Decorative bar: use `container.travelguard.com/content/dam/tg-documents/united/images/emails/straight-progress-teal-faded.png`
- Review CTA section bg: `#001122`

### 5. CTA Buttons
- Background: `#1414D2`
- Keep border-radius: 25px (pill shape)

### 6. cmpid Tracking
- **Remove all `?cmpid=...` parameters** from links — no cmpid tracking necessary for this template

---

## Preserve (No Changes)
- All Handlebars variables (`{{policyDetail-*}}`, `{{traveler-count}}`, `{{is-missouri-*}}`, etc.)
- Content text/copy
- Table-based layout structure
- Mobile responsive CSS breakpoints and classes
- MSO conditionals and VML namespaces
- Preheader text and `&zwnj;&nbsp;` padding
- Dark mode `@media (prefers-color-scheme: dark)` (update color values to match new palette)

---

## File to Modify
- `united/tmp/policy-confirmation.html`

## Reference Files
- `digdrct/us/en/policy-confirmation.html` — original TG structure (517 lines, full reference)
- `united/us/en/pre-trip.html` — existing United email with hosted image URLs, social icons, layout patterns

## Hosted Images Available

| Image | URL |
|-------|-----|
| Hero (beach) | `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/gettyimages-155391689-cropped2@2x.jpg` |
| Assistance article | `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/gettyimages-650855441-170667a@2x.jpg` |
| Packing tips article | `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/GettyImages-1469671468@2x.jpg` |
| Social: Facebook | `https://container.travelguard.com/content/dam/tg-documents/united/icons/facebook_logo.png` |
| Social: Instagram | `https://container.travelguard.com/content/dam/tg-documents/united/icons/instagram_logo.png` |
| Social: YouTube | `https://container.travelguard.com/content/dam/tg-documents/united/icons/youtube_logo.png` |
| Decorative teal bar | `https://container.travelguard.com/content/dam/tg-documents/united/images/emails/straight-progress-teal-faded.png` |
| Phone icon | `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Phone@2x.png` |
| Chat icon | `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Outlined-03-Communication-Chat@2x.png` |

---

## Verification Checklist
- [ ] Open modified HTML in browser — compare light mode rendering against Figma
- [ ] Check dark mode rendering
- [ ] Verify all Handlebars variables are intact and unchanged
- [ ] Test mobile responsive layout at < 600px
- [ ] Confirm all image URLs resolve (no broken images)
- [ ] Verify gradient renders in WebKit/Blink (Outlook gets solid fallback)
- [ ] Confirm no `cmpid` params remain on links
