# MEA header logo → `{{Image_AIGGlobalLogoHeader}}`

**Status: COMPLETE (August 2026).** All three contested markets — `bh`, then `ae` and `kw` —
are converted, six files in total. The rest of MEA is **deliberately not converted** and
should stay that way; see "No longer in scope" below.

**August 2026 descope: `SA`, `QA`, `OM` and `LB` left Emirates' scope.** That took `qa`, `om`
and `lb` out of this work item entirely — Qatar Airways is now their only partner, so their
hardcoded underwriter logos are correct as they stand, which left `ae` and `kw` as the only
markets still needing conversion.

> **Closed, August 2026:** the templates are done and Qatar Airways' MVS entries for `ae` and
> `kw` have been populated, so the `<img>` the templates no longer carry is supplied from the
> MVS side. Nothing outstanding on this work item.

## Problem

The Emirates and Qatar Airways market sets overlap, and the two partners want different
header logos in the same markets:

| Partner | What the header should show |
|---|---|
| Qatar Airways | the local underwriter's logo — GIG Bahrain, LIVA, GIG, Sukoon, Qatar General Insurance |
| Emirates | **no logo at all** |

Emirates' market list includes `BH`, `AE` and `KW` — three of the nine markets the Qatar
Airways build delivered. (It also covered `QA`, `OM` and `LB` until the August 2026 descope.)
ROW keeps **one template per market/language**, not one per partner, so a hardcoded `<img>`
can only satisfy one of them.

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
- `row/ae/en/policy-confirmation.html`
- `row/ae/ar/policy-confirmation.html`
- `row/kw/en/policy-confirmation.html`
- `row/kw/ar/policy-confirmation.html`

The `<img>` each one replaced, for whoever populates the MVS:

| Market | Langs | Logo the MVS must now supply |
|---|---|---|
| ae | en, ar | `LIVA_UAE_Logo.png` (140px), `alt="LIVA"` |
| bh | en, ar | `gig-logo-bh.png` (180px), `alt="GIG Bahrain"` |
| kw | en, ar | `giga-logo-kt.png` (200px), `alt="GIG"` |

## No longer in scope — descoped from Emirates, August 2026

Qatar Airways is the only partner in these three markets now, so there is nothing to
reconcile: the hardcoded underwriter logo **is** the correct header. Do not tokenize them.

| Market | Langs | Logo (correct as-is) |
|---|---|---|
| lb | en | `gig-logo-lb.png` (200px) |
| om | en, ar | `sukoon-logo.png` (200px) |
| qa | en, ar | `qa-gen-logo.png` (200px) |

Also unconverted, and probably should stay that way: `_template/row-reference.html` and
`_template/row-reference-rtl.html` keep the Travel Guard + Zurich `<img>` as the skeleton
default, since new non-MEA markets have no partner split to solve.

## Standing facts about the converted markets

These stay true for `bh`/`ae`/`kw` now that they are tokenized, and are the rules to follow
if a further market ever is (nothing is queued — see "No longer in scope").

1. **MVS has to carry the full `<img>` tag** — width, `alt`, inline styles — not just a URL.
   The hosted URLs in `row/CLAUDE.md` → Logo are the reference for what MVS must supply.
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
