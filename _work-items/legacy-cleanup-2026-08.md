# Legacy template cleanup — August 2026

**Removal commits:**

| SHA | What it removed |
|---|---|
| `cd57d85` | 9 dead templates (Expedia dated duplicates, admin scratch files) + 22 stale QA exclude paths |
| `30350fc` | `row/us/en/lhgroup-old-policy-confirmation.html` |
| `9ad4c73` | `jetstar/sg/en/policy-confirmation.html` (the broken fragment), replaced by the promoted redesign |

Scope was everything outside `tg/`, limited to **dead files only**: dated backups, scratch
files, and orphans. Superseded-but-coherent templates, unmodernized live templates, and
prototypes were deliberately left in place.

## How to get a deleted file back

```bash
git show cd57d85 --stat                                    # what was removed
git show cd57d85^:expedia/us/en/policy-confirmation-old.html   # read one, without restoring
git checkout cd57d85^ -- expedia/us/en/policy-confirmation-old.html  # restore it to the tree
```

The `^` matters: the recorded SHA is the commit that *deleted* the file, so its last living
content is in that commit's parent. Use `30350fc^` for the LHGROUP template. To find a
deleted file when you don't know the path:

```bash
git log --diff-filter=D --name-only --oneline
```

## What was deleted (9 files)

### Expedia dated/backup duplicates

Frozen at `42455cc` (2026-02-15) while their canonical `policy-confirmation.html` siblings
were updated 2026-06-03 and are roughly 8KB larger. All carried legacy AIG-path logo assets.

| File | Size |
|---|---|
| `expedia/ca/en/expedia-ca-en.html` | 15,182 B |
| `expedia/ca/en/expedia-ca-en-august-2023.html` | ~15.5 KB |
| `expedia/ca/en/expedia-ca-en-june-2022.html` | ~15.5 KB |
| `expedia/ca/fr/expedia-ca-fr.html` | 15,160 B |
| `expedia/ca/fr/expedia-ca-fr-august-2023.html` | ~15.5 KB |
| `expedia/ca/fr/expedia-ca-fr-june-2022.html` | ~15.5 KB |
| `expedia/us/en/policy-confirmation-old.html` | — (used `aig-tg-logo-blue-expedia.png`) |

### Admin scratch files

No DOCTYPE, no `<head>` content, 555px fixed width, AIG-era logo assets (`aig_logo.gif`,
`AIGGlobalLogo_Small.png`). Near-identical to each other. Never individually developed —
their entire history is bulk folder-move and generic QA sweeps. A real 36KB
`admin/us/en/save-quote.html` sits beside them and is untouched.

| File | Size |
|---|---|
| `admin/us/en/xxx-admin-save-quote.html` | 7,222 B |
| `admin/us/en/xxx-admin-save-quote-new.html` | ~7,021 B |

### ROW US legacy LHGROUP template — removed in `30350fc`

`row/us/en/lhgroup-old-policy-confirmation.html` (1,681 B). AIG-branded, no dark mode, no
`role="presentation"` — one of the two remaining AIG-branding warnings in the `row` QA sweep.
Superseded by the current LHGROUP copy applied in the July 2026 claims/contact update.

The same commit dropped the "legacy files with `old` in the name are out of scope — skip
them" clause from the Handlebars auditing rule in `row/CLAUDE.md`, since this file was its
only example and no `-old` files remain under `row/`.

### Jetstar SG broken fragment — replaced in `9ad4c73`

`jetstar/sg/en/` held two files and neither was named correctly: the canonical name pointed
at an unusable file while a complete modern rebuild sat beside it under a `-redesign` suffix.
`policy-confirmation-redesign.html` was promoted to `policy-confirmation.html`, replacing:

- a bare fragment with no DOCTYPE, `<html>`, `<head>` or `<body>`
- literal rich-text-editor paste garbage on line 1 (`_rte_temp_br`)
- legacy single-brace `{FirstName}`/`{LastName}`/`{PolicyNumber}` placeholders — the last
  instances of that format anywhere in the repo
- a relative logo `src="/content/dam/…"` that cannot resolve in an email client
- a `policy.qa.travelguard.com` URL

To read the replaced file: `git show 9ad4c73^:jetstar/sg/en/policy-confirmation.html`.
The promoted file's own history is under its old name — use `git log --follow`.

**Left open deliberately:** the promoted template still carries AIG Asia Pacific underwriter
copy, `sgtravelclaims@aig.com` and `aig.sg` links. Whether Jetstar SG has transitioned to
Zurich is a separate question needing the correct legal copy. It also uses
`{{policyDetail-primaryInsured}}` where the rest of the repo uses
`{{policyDetail-primaryInsured-firstName}}` — likely a bug, unverified.

### Untracked

`bash.exe.stackdump` (repo root) — Git Bash crash artifact, gitignored. **Not recoverable
from git** (never tracked). Content was a bare Cygwin stack trace with no useful data.

## `.claude/qa-exclude.txt` — 22 phantom paths purged

The exclude list is the repo's strongest "this file is not live" signal, and it had drifted
badly enough to be misleading. Removed entries pointing at files that do not exist:

- The 9 files deleted above
- `tg/admin/…`, `tg/agents/…`, `tg/ca/…`, `tg/it/…`, `tg/my/…`, `tg/sg/…` — left behind when
  `admin/`, `agents/` and `digdrct/` moved to top level in `9ca3174`. **Consequence:** the
  admin `xxx-` files were listed under `tg/admin/…` and therefore were never actually being
  excluded from QA.
- `united/be/fr/policy-confirmation.html`, `united/be/nl/policy-confirmation.html` — deleted
  outright in `e6a5402` (Feb 2026)
- `united/old-policy-confirmation.html`, `united/new-policy-confirmation.html` — never
  existed at those paths
- `expedia/it/en/…`, `row/uk/en/…` — stale after market renames (`uk` → `gb`)

Every path in the file now resolves to a real file.

## Deliberately NOT deleted

Recorded so the next cleanup doesn't re-litigate these.

| File(s) | Why it stays |
|---|---|
| `digdrct/us/en/policy-confirmation.html`, `digdrct/sg/en/policy-confirmation.html` | **The naming is inverted.** `policy-confirmation-new.html` is the live one in both markets — the US one was forked at `47226f0`, developed across 5 commits to `2fd110a` "Modernize … for PROD" (2026-05-12), and is cited in root `CLAUDE.md` as the canonical two-column-header reference. The plainly-named files are frozen at a March 2026 generic sweep. That makes them *superseded*, not dead. Renaming `-new` into place would be the real fix. |
| Qantas non-`-revisions` originals (11 files) | Superseded by `au-revisions/` and `nz-revisions/`, not dead. |
| `.docx` / `.doc` / `.txt` sources | Deliberate. `qantas/CLAUDE.md` documents a "Source Document Workflow"; `row/*/email.docx` are copy/translation sources. |
| `digdrct/us/en/tiktok-white.png` | Referenced by the live `policy-confirmation-new.html`. |

## Open issues surfaced during the audit

Not cleanup items, but found while inventorying and worth tracking.

1. **UAT/QA hosts in policy links.** The 14 Expedia EU/international markets pointing at
   `policy.uat.travelguard.com` (`ch/{de,fr,it}`, `de/de`, `dk/da`, `es/es`, `fi/fi`,
   `fr/fr`, `hk/en` — also a UAT *claims* link — `ie/en`, `it/it`, `nl/nl`, `no/nb`, `se/sv`)
   are **expected**: those markets are still in QA/UAT and the links get swapped to
   production as each one launches. Not a defect; do not "fix" them in bulk.

   `row/ca/en/policy-confirmation.html` is a **separate case** — it uses
   `policy.uat.travelguard.ca` while its two near-identical sibling stubs,
   `agents/ca/en/policy-confirmation.html:17` and `united/ca/en/policy-confirmation.html:18`,
   both use production `policy.travelguard.ca`. Left as-is by decision (2026-08-04), but it
   is a genuine leftover rather than a staged link.
2. **Qantas AU status contradiction** — `qantas/CLAUDE.md` says the AU underwriter transition
   is "complete"; root `README.md` says "Planned". Open UAT bugs in `work-items.md` favour
   the README.
3. **`qantas/CLAUDE.md` claims some templates use XHTML 1.0 Transitional** — no longer true;
   all Qantas files now open with `<!DOCTYPE html>`.
4. **`row/se/sv/policy-confirmation.html`** retains a Swedish AIG liability clause despite
   being listed as modernized. **`row/cz/cs`** lacks dark mode with no documenting note
   (unlike `row/sg/en`, whose light-mode-only choice is documented).
5. **Five brands have no `CLAUDE.md`** — `jetstar/`, `united/`, `admin/`, `agents/`,
   `digdrct/`. That absence is why the ambiguous variants above needed git archaeology.
