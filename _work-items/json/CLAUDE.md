# CLAUDE.md — Travel Guard JSON-LD Schema Project

Structured-data (JSON-LD) build-out for travelguard.com, aimed at LLM/AI-search citations first, traditional rich results second. Read this before touching anything in `jsonld/`.

## Key documents

| File | Purpose |
|---|---|
| `TravelGuard-Schema-Audit.md` | The audit: why each schema type, per-page recommendations, priority matrix, Otterly-informed P0 list |
| `TravelGuard-Schema-Audit.html` | Shareable rendered copy of the audit — keep in sync when editing the .md |
| `TravelGuard-KPI-Tracking.md` | Before/after measurement plan + dated checkpoints (§11 = first post-deploy checkpoint, Jun 9 2026) |
| `jsonld/` | The JSON-LD payloads, one file per page (see layout below) |

## Deployment state (as of 2026-06-10)

- **Live on every page:** the `_sitewide.json` Organization + WebSite bundle (verified byte-identical to repo).
- **Live on /help-center/faqs only:** a minimal FAQPage block (same 14 Q&As as `help-center/faqs.json`; repo version adds page props + breadcrumb and has small verbatim-text corrections not yet deployed).
- **Everything else in `jsonld/` is pre-deployment.** Repo is the source of truth for the next deploy; editing these files has no live-site risk.

## Folder layout

`jsonld/` mirrors the live site URL structure:
- Folder root = homepage → `index.json`
- Each URL path segment = a subfolder; page file named after the final URL segment (`travel-insurance/plans/deluxe.json` ↔ `/travel-insurance/plans/deluxe`)
- Section landing pages = `index.json` inside their folder
- Underscore prefix = not a page: `_sitewide.json` (every-page bundle), `_templates/` (placeholder-marked `{{...}}` templates — **never deploy these**)

## Hard rules (violations = the hallucination bugs we already had to fix once)

1. **Only mark up content visible on the live page.** No invented FAQs, steps, dates, ratings, images, or coverage names. If the page doesn't show it, the schema doesn't say it.
2. **FAQ questions and answers verbatim** from the live page (curly apostrophes and all). Verify with the whitespace-normalized containment check (see Validation below).
3. **Coverage names verbatim from the page's own h3s**, grouped by its h2 sections. PropertyValue values used: `"Standard coverage"`, `"Extra coverage / optional upgrade"`, `"Assistance service"`.
4. **Dates:** never invent. `datePublished` is omitted everywhere (no source). `dateModified` only where the sitemap has a real `lastmod` for that exact URL (or a legacy URL that 301s to it).
5. **Images:** only if the URL appears in the live page source AND returns 200. Otherwise omit `image`.
6. **`@id` discipline:** `https://www.travelguard.com/#organization` and `/#website` are defined once in `_sitewide.json` and referenced everywhere else as `{ "@id": "..." }` — never redefined. Per-page entities use `{page-url}#{type}`; breadcrumbs use `{page-url}#breadcrumb`.
7. **No `aggregateRating` / `review` anywhere** until a verifiable Trustpilot integration exists (audit §6.5).
8. **WebPage `name` = live `<title>`; `description` = live meta description** (exception: `legal/our-underwriter.json` uses the h1 because the live title still carries stale "AIG Travel Guard" branding — flagged for the web team).
9. Schema.org vocabulary correctness: `provider` is NOT valid on OfferCatalog; `isRelatedTo` is NOT valid on Article (use `mentions`). Both were validator findings.

## Key entity facts

- Legal name: Travel Guard Group, Inc. · founded 1982 (Wikipedia-confirmed) · 3300 Business Park Drive, Stevens Point, WI 54482
- Primary phone: 800-826-5248 · Claims phone: 1-866-478-8222 (online claims tool supports USA-purchased policies only)
- Claims portal: claims.travelguard.com/claims · status: claims.travelguard.com/status (the /status URL 404s to curl but is linked from the live claims page — it's a JS app route, not a hallucination)
- Underwriters (from /legal/our-underwriter): American Zurich Insurance Company (NAIC 40142), Zurich American Insurance Company (NAIC 16535), National Union Fire Insurance Company of Pittsburgh, Pa. (NAIC 19445)
- parentOrganization: Zurich Insurance Group · memberships: UStiA, IGLTA · accreditation: BBB
- Email: inquire@travelguard.com

## Getting page inventory — the sitemap is stale

**Do not trust sitemap.xml for URL discovery.** It lists retired plans (`platinum`, `annual`, capital-P `Preferred`) and is missing `/travel-insurance/plans/deluxe`, `/help-center/faqs`, `/travel-insurance/benefits/baggage-insurance`, and the pre-existing/student traveler-type pages. The **live nav** is authoritative — extract internal links from any downloaded page. The sitemap is still useful for one thing: real `lastmod` dates.

Canonical-URL gotchas found so far:
- `/info/assistance-services` is canonical (the `/travel-insurance/benefits/assistance-services` path 301s to it)
- `/travel-insurance/trip-types/cruise-insurance` is canonical (sitemap's `/trip-types/cruise` is legacy)
- Always curl-check: every URL referenced in a JSON file must return 200 with no redirect

## Build workflow for a new page file

1. `curl -s -L -A "Mozilla/5.0..." {url}` → save HTML
2. Extract verbatim: `<title>`, meta description, h1/h2/h3 structure, FAQ accordion Q&As (beware: AEM wraps text across newlines — regex with `[\s\S]` and normalize whitespace)
3. Copy the closest existing pattern file (plans → `travel-insurance/plans/deluxe.json`; service+FAQ pages → `traveler-types/pre-existing...json`; articles → `_templates/article-template.json`; landings → `traveler-types/index.json`)
4. Validate (below), then update the audit doc §9 file tree

## Validation (every changed/new file)

1. `python3 -m json.tool` (or a glob loop) — parse check
2. Verbatim FAQ check: whitespace-normalized containment of every Q and A in the live page text (tolerate `-` list markers and spaces around tag-stripped link boundaries)
3. URL liveness: every `travelguard.com` URL in the file → 200, no redirect
4. validator.schema.org → 0 errors / 0 warnings. The POST endpoint `https://validator.schema.org/validate` (form field `html=` wrapping the JSON in a script tag) works for batching, **but Google rate-limits it after ~30 rapid requests** (reCAPTCHA wall, IP-based, also blocks the browser; the unblock from solving the captcha is a browser cookie, so post-captcha validation must run from the browser page context — e.g. `fetch()` via chrome-devtools `evaluate_script` — not curl). Space requests ≥1s apart and batch sparingly.

## Roadmap / deferred batches (in priority order, from the audit + Otterly data)

Done: sitewide bundle, homepage, FAQ, claims, contact, about, reviews, plans listing + **all 5 plan product pages (incl. MedEvac)**, CFAR, student travel safety, **all 13 trip-types**, **all 11 traveler-types**, **all 13 benefits pages + benefits landing**, what-is + assistance-services (info), our-underwriter, jet-lag article, 6 section landing index.json files.

Benefits batch notes (Jun 10): canonical-check every /benefits/ URL first — several sitemap slugs 301 elsewhere (`travel-health-insurance` → `travel-medical-expense`, `medevac` → `/plans/medevac`, `cancel-for-any-reason`/`pre-existing-medical-waiver` → /optional-coverage/, `new-to-travel-insurance` → /info/, `coverages`/`quick-compare` → landing/compare). `adventure-sports-coverage` and `lodging-expense-benefit` are really the Adventure Sports and Quarantine **bundle** pages (canonical URLs under /benefits/). Many benefit pages have a "What is a policy of insurance?" sidebar teaser — exclude it as a question and truncate any answer at that string. **Pack N' Go Plan exists at `/travel-insurance/plans/pack-n-go` (linked from the Quarantine Bundle page) — not yet built, add to a future batch.**

Trip-type / traveler-type batch notes (Jun 10): these pages share one AEM template family — question-formatted h2s (or h3s nested under a "Ready to book…?" CTA heading, which must be excluded) with visible prose answers. Files are WebPage + Service + OfferCatalog (only the plans each page actually links) + FAQPage with verbatim on-page Q&As (79 + 78, all containment-verified). Trailing "Get a travel insurance plan the way you want it!" / "Get travel insurance the way you want it!" CTA headings must be trimmed from final answers. The pregnant-travelers page additionally has a real FAQ accordion (8 h3 Q&As) on top of its prose sections — both are marked up. Traveler-type `audience.audienceType` uses the site nav's own labels (Backpackers, Family Travelers, …).

Next batches:
1. Pack N' Go plan page (`/travel-insurance/plans/pack-n-go`) — pattern: `plans/medevac.json`
2. Remaining optional-coverage bundle pages (see `optional-coverage/index.json`; note CFAR, Adventure Sports, and Quarantine bundles already covered — check each bundle URL's canonical before building)
3. 7 remaining info articles (`5-essential-travel-insurance-plan-tips`, `how-does-travel-insurance-work`, `how-much-does-travel-insurance-cost`, `packing-checklist`, `travel-insurance-checklist`, `what-is-a-policy-of-insurance`, `when-to-buy-travel-insurance`)
4. Video library (VideoObject — note the live student-safety page already carries 6 VideoObject blocks from the video player)

**Excluded from scope:** `/travel-news/*` and newsroom (per user, first pass), `/travel-resources/destinations/*` (P3).

## Decision log

Append a row whenever a non-obvious decision is made. Future sessions: read this before proposing changes.

| Date | Decision | Why |
|---|---|---|
| 2026-06-09 | No fabricated aggregateRating/reviews anywhere; reviews-page kept minimal | Structured-data policy violation risk; wait for Trustpilot integration |
| 2026-06-09 | Student-safety HowTo removed | Live page has no numbered step list; schema must match visible content |
| 2026-06-10 | Claims page = WebPage + Service, not HowTo | Live page has no steps, only portal CTAs; revisit HowTo only if the page adds visible steps |
| 2026-06-10 | Article dates: drop `datePublished`; `dateModified` only from sitemap `lastmod` | Pages display no dates; sitemap lastmod is the only verifiable source. Only jet-lag has one (2025-12-22, via legacy URL that 301s) |
| 2026-06-10 | Folder layout: path mirror, `index.json` landings, `_` prefix for non-pages | User decision; mirrors site structure for navigability |
| 2026-06-10 | Build scope: tiered P0/P1 first, then trip-types → traveler-types → benefits → bundles → info → video | User decision; news + destinations excluded this pass |
| 2026-06-10 | FAQ text matches the *visible page*, not the previously deployed JSON-LD (curly apostrophes, "non-family member") | Deployed block had drifted from page copy; visible content wins |
| 2026-06-10 | our-underwriter `name` uses h1, not `<title>` | Live title still says "AIG Travel Guard" (stale brand) — flagged for web team; h1 is on-page verbatim |
| 2026-06-10 | Deluxe/plan `image` dropped | Asset 200s but does not appear in the live page source; hero is CSS/JS-loaded |
| 2026-06-10 | `speakable` removed from all files; do not add to new ones | Pending vocabulary; Google's feature is news-only beta; selectors were generic h1/h2, not quotable summaries; no LLM evidence; caused validator noise (user decision) |
