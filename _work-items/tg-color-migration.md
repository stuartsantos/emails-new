# TG color migration: `#0076be` → design-system tokens

**Status:** Awaiting decision — do not execute.

## Problem

The 2025 Travel Guard design system bundle (`_work-items/tg-design-system/`) introduces a refined Zurich Blue palette that conflicts with how `#0076be` is currently used across email templates.

Today, every TG/ROW/Expedia template uses `#0076be` for **everything blue**: anchor links, headings, accent text, CTA fills, accent borders. The April 2026 anchor-pinning sweep (commit `9773f12`) hard-coded this single hex into the inline `style="color: #0076be"` rule for every `<a href>`.

The new design system separates the role:

| Token | Hex | Role |
|---|---|---|
| `--zurich-blue` | **`#2167AE`** | Headings, primary CTA accent (NEW canonical) |
| `--zurich-blue-dark` | **`#0E4E88`** | Hover / secondary blue (replaces `#005b94`) |
| `--fg-link` | `#0076BE` | Anchors / link blue (preserved) |

So `#0076be` is no longer the single brand blue — it's been pushed to a narrower "link-only" role. Adopting the design-system palette means migrating every non-anchor use of `#0076be` to `#2167AE` (and every `#005b94` to `#0E4E88`).

## Scope of impact

Per `grep -rIl "#0076be" --include="*.html"`: **66 HTML files** across `tg/`, `row/`, `expedia/`, plus root `CLAUDE.md` and the rule set in `_work-items/tg-design-system/`.

## Audit checklist (before any sweep)

For every match, classify as one of:

1. **Stays `#0076be`** — usage IS an anchor link color (i.e., `<a href ... style="color: #0076be">` or equivalent). Maps to `--fg-link` post-migration.
2. **Moves to `#2167AE`** — usage is a heading color, eyebrow/label color, CTA fill, accent border, or non-anchor accent text. Maps to `--zurich-blue` post-migration.
3. **Ambiguous** — surfaces in dark-mode CSS (`[data-ogsc]` selectors), gradient stops, or VML fallbacks. Decide case-by-case.

For `#005b94`:

4. **Moves to `#0E4E88`** — every occurrence (currently used as the secondary blue / hover state in CTA blocks).

## Risk note

This is a **brand-visible color shift**. `#2167AE` is noticeably darker and more saturated than `#0076be`. Any sweep should be reviewed by stakeholders (marketing / design lead) before merge — ideally with a side-by-side preview render of one template per category (fulfillment, holiday, travel-tips, sponsor, ROW confirmation, Expedia confirmation).

## Proposed sequence (when approved)

1. Update root `CLAUDE.md` color table to show new tokens as authoritative.
2. Update the **Anchor color pinning** rule to keep `#0076be` for anchors only.
3. Sweep heading/CTA/accent uses → `#2167AE`. Use `batch-qa.sh` after each scope.
4. Sweep `#005b94` → `#0E4E88`.
5. QA: light + dark mode side-by-side per representative template.
6. Cross-check with sibling regional templates (ROW, Expedia markets) for visual consistency.

## Decision needed

- Adopt the new design-system palette? (yes / no / partial)
- If yes: who reviews the side-by-side preview before sweep merges?
- If partial: which categories migrate (e.g., new templates only, leave existing in place)?

Until this is answered, both tokens are noted in root `CLAUDE.md` and the existing `#0076be` behavior is canonical for templates.
