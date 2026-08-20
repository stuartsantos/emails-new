# MEA header logo → `{{Image_AIGGlobalLogoHeader}}`

**Status:** `bh` converted (August 2026). The rest of MEA is **deliberately not converted** — do not sweep it without a decision from the partner/MVS side.

## Problem

The Emirates and Qatar Airways market sets overlap, and the two partners want different
header logos in the same markets:

| Partner | What the header should show |
|---|---|
| Qatar Airways | the local underwriter's logo — GIG Bahrain, LIVA, GIG, Sukoon, Qatar General Insurance |
| Emirates | **no logo at all** |

Emirates' market list includes `BH`, `AE`, `QA`, `KW`, `OM`, `LB` — exactly the markets the
Qatar Airways build delivered. ROW keeps **one template per market/language**, not one per
partner, so a hardcoded `<img>` can only satisfy one of them.

> The source partner list wrote those as `BA`/`UE`/`QT`/`KT`, none of which are the ISO
> codes for Bahrain/UAE/Qatar/Kuwait. Corrected in `row/CLAUDE.md` → Partner Reference,
> along with `HG`→`HU` and `SZ`→`CH`; `UK` is deliberately kept as `UK` in prose there while
> everything technical uses `GB`.

## Approach

Replace the header logo `<img>` with the list-A MVS field `{{Image_AIGGlobalLogoHeader}}`
and let the MVS supply the whole tag per partner — the underwriter `<img>` for Qatar
Airways, an empty value for Emirates.

```html
<td style="…padding-bottom: 30px; padding-top: 30px;">
  {{Image_AIGGlobalLogoHeader}}
</td>
```

## Done

- `row/bh/en/policy-confirmation.html`
- `row/bh/ar/policy-confirmation.html`

## Not done — on purpose

| Market | Langs | Logo still hardcoded |
|---|---|---|
| ae | en, ar | `LIVA_UAE_Logo.png` (140px) |
| kw | en, ar | `giga-logo-kt.png` (200px) |
| lb | en | `gig-logo-lb.png` (200px) |
| om | en, ar | `sukoon-logo.png` (200px) |
| qa | en, ar | `qa-gen-logo.png` (200px) |

Also unconverted, and probably should stay that way: `_template/row-reference.html` and
`_template/row-reference-rtl.html` keep the Travel Guard + Zurich `<img>` as the skeleton
default, since new non-MEA markets have no partner split to solve.

## Before converting the rest

1. **MVS has to carry the full `<img>` tag** — width, `alt`, inline styles — not just a URL.
   The hosted URLs in `row/CLAUDE.md` → Logo become the reference for what MVS must supply.
   A converted market whose MVS entry is empty ships with **no logo and no error**.
2. Convert **en and ar together** for a market; the header markup is identical apart from
   the font stack.
3. The `<td>`'s `padding-top: 30px; padding-bottom: 30px` stays when the token is empty, so
   the no-logo build gets a ~60px `#F1F6FB` band above the split header. Same colour as the
   body background, so it reads as whitespace — but confirm that's acceptable rather than
   removing the row.
4. `Image_AIGGlobalLogoHeader` is an approved list-A field. The "AIG" is a token identifier,
   never customer-visible, and the QA scripts strip `{{…}}` before the AIG-branding check —
   don't rename it.
