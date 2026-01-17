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
