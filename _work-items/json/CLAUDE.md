# CLAUDE.md — Travel Guard JSON-LD Schema Project

Structured-data (JSON-LD) build-out for travelguard.com, aimed at LLM/AI-search citations first, traditional rich results second. Read this before touching anything in `jsonld/`.

## Key documents

| File | Purpose |
|---|---|
| `TravelGuard-Schema-Audit.md` | The audit: why each schema type, per-page recommendations, priority matrix, Otterly-informed P0 list |
| `TravelGuard-Schema-Audit.html` | Shareable rendered copy of the audit — keep in sync when editing the .md |
| `TravelGuard-KPI-Tracking.md` | Before/after measurement plan + dated checkpoints (§11 = first post-deploy checkpoint, Jun 9 2026) |
| `TravelGuard-KPI-Report.html` | Shareable rendered KPI scorecard (one chart per metric, self-contained) — update at each checkpoint by editing the `SERIES`/`MILESTONES` blocks in its `<script>`; keep in sync with `TravelGuard-KPI-Tracking.md` |
| `jsonld/` | The JSON-LD payloads, one file per page (see layout below) |

## Deployment state (as of 2026-06-11)

- **Live on every page:** the `_sitewide.json` Organization + WebSite bundle (verified byte-identical to repo).
- **Deployed 2026-06-11 (verified live, reflecting the current repo):**
  - **Homepage** (`index.json`) — WebPage + OfferCatalog + FAQPage + the Trustpilot `aggregateRating` (confirmed live).
  - **FAQ** (`help-center/faqs.json`) — full FAQPage now live (supersedes the old minimal block).
  - **Plans listing** (`plans/index.json`) — the 7-card ItemList (`numberOfItems` 7, summary-format, carousel fix live).
  - **All `/plans/*` product pages EXCEPT deluxe** — `preferred`, `essential`, `rental-vehicle-damage-plan`, `medevac`, `pack-n-go`, `annual`, all confirmed live as `FinancialProduct`.
- **NOT deployed — `plans/deluxe.json`** is held back (pending edits); the live `/plans/deluxe` page currently has only the `_sitewide.json` block, no plan schema. Deploy after the deluxe edits land.
- **Everything else in `jsonld/` is pre-deployment.** Repo is the source of truth for the next deploy; editing those files has no live-site risk. (The deployed pages above now DO carry live risk — coordinate a re-deploy when changing them.)

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
7. **`aggregateRating`:** org-level only, with real Trustpilot widget-data values, and **only on pages that visibly render a TrustBox** (currently homepage + reviews page — added 2026-06-11 as `aggregateRating` on a **typed** org reference: `"@type": "InsuranceAgency"` + `@id`. The repeated `@type` is required — without it the standalone file validates the node as `Thing` and validator.schema.org warns UNKNOWN_FIELD; repeating only the type is not a redefinition under rule #6). Never on Product nodes (the TrustScore is a site/company rating; no per-product reviews are collected). Never a `review` array — the on-page reviews rotate, so a static copy drifts (hard rule #2 problem). Canonical refresh source (same data the widgets render): `https://widget.trustpilot.com/trustbox-data/54197383fd9dceac42a68694?businessUnitId=5c6487f6dc82bd0001544423&locale=en-US&reviewLanguages=en` — re-pull at every KPI checkpoint and update both files if `trustScore`/`numberOfReviews` changed. Note: Google ignores self-serving org ratings for rich-result stars; this markup is an LLM trust signal (the project's primary goal), not a SERP-stars play.
8. **WebPage `name` = live `<title>`; `description` = live meta description** (exception: `legal/our-underwriter.json` uses the h1 because the live title still carries stale "AIG Travel Guard" branding — flagged for the web team).
9. Schema.org vocabulary correctness: `provider` is NOT valid on OfferCatalog; `isRelatedTo` is NOT valid on Article (use `mentions`). Both were validator findings.
10. **`ItemList` `ListItem`s use the summary-page format only:** `position` + `url` (+ optional `name`) pointing at the detail page. **Never** add a nested `item` alongside `url` — Google's carousel spec treats `url` (summary-page) and `item` (all-in-one-page) as mutually exclusive, so having both is a critical Rich Results error ("Two or more mutually-exclusive properties"), and a bare `item: { @id }` referencing a Product defined on another page also dangles to an empty `Thing`. The `url` already carries the cross-page link for both Google and LLMs. Fixed 2026-06-11 in `travel-insurance/plans/index.json` and `benefits/compare-travel-insurance.json`; all other landing `index.json` files were already summary-format.
11. **Plan pages use `FinancialProduct`, NOT `Product`:** the 6 `travel-insurance/plans/*.json` nodes are `@type: FinancialProduct` (schema.org's insurance type). `Product` + `offers` makes Google validate the page as a shoppable retail good and demand `offers.price`, `image`, `shippingDetails`, `hasMerchantReturnPolicy` — none of which exist for a quote-priced insurance plan (Product-snippet + Merchant-listing "invalid" errors, Jun 11 2026). `FinancialProduct` is not a Google e-commerce rich-result type, so it sidesteps that validation while keeping every property LLMs use (`offers`, `additionalProperty` coverage list, `audience`, `category`, `brand`, `isRelatedTo`) — all confirmed 0/0 at validator.schema.org. The `@id` fragment stays `#product` (it's an opaque identifier referenced from ~30 OfferCatalog/itemOffered nodes; changing it would dangle them — it does NOT have to match `@type`). Do not "fix" these back to `Product` or add a fabricated price to chase a Product rich result.

## Key entity facts

- Legal name: Travel Guard Group, Inc. · founded 1982 (Wikipedia-confirmed) · 3300 Business Park Drive, Stevens Point, WI 54482
- Primary phone: 800-826-5248 · Claims phone: 1-866-478-8222 (online claims tool supports USA-purchased policies only)
- Claims portal: claims.travelguard.com/claims · status: claims.travelguard.com/status (the /status URL 404s to curl but is linked from the live claims page — it's a JS app route, not a hallucination)
- Underwriters (from /legal/our-underwriter): American Zurich Insurance Company (NAIC 40142), Zurich American Insurance Company (NAIC 16535), National Union Fire Insurance Company of Pittsburgh, Pa. (NAIC 19445)
- parentOrganization: Zurich Insurance Group · memberships: UStiA, IGLTA · accreditation: BBB
- Email: inquire@travelguard.com

## Getting page inventory — the sitemap is stale

**Do not trust sitemap.xml for URL discovery.** It lists retired plans (`platinum`, capital-P `Preferred`) and is missing `/travel-insurance/plans/deluxe`, `/help-center/faqs`, `/travel-insurance/benefits/baggage-insurance`, and the pre-existing/student traveler-type pages. The **live nav** is authoritative — extract internal links from any downloaded page. The sitemap is still useful for one thing: real `lastmod` dates. **Correction (Jun 11 2026):** `/travel-insurance/plans/annual` was previously assumed retired — it is in fact a **live, self-canonical** plan (HTTP 200, sitemap `lastmod` 2026-04-23) and is shown as a card on the `/travel-insurance/plans` listing; `annual.json` built Jun 11. Don't re-flag it as retired.

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

Done: sitewide bundle, homepage, FAQ, claims, contact, about, reviews, plans listing (7-card ItemList) + **all 7 plan product pages (incl. MedEvac, Pack N’ Go + Annual built Jun 11)**, student travel safety, **all 13 trip-types**, **all 11 traveler-types**, **all 13 benefits pages + benefits landing**, **all 11 optional-coverage bundle/upgrade pages (CFAR + 10 built Jun 10)**, **all 9 info Education Center pages (what-is, assistance-services + 7 articles built Jun 10)**, our-underwriter, jet-lag article, **video library landing + all 8 video pages (Jun 11)**, 7 section landing index.json files.

**All in-scope batches are complete.** Remaining work is deployment (site team) and the excluded-from-scope sections below.

Benefits batch notes (Jun 10): canonical-check every /benefits/ URL first — several sitemap slugs 301 elsewhere (`travel-health-insurance` → `travel-medical-expense`, `medevac` → `/plans/medevac`, `cancel-for-any-reason`/`pre-existing-medical-waiver` → /optional-coverage/, `new-to-travel-insurance` → /info/, `coverages`/`quick-compare` → landing/compare). `adventure-sports-coverage` and `lodging-expense-benefit` are really the Adventure Sports and Quarantine **bundle** pages (canonical URLs under /benefits/). Many benefit pages have a "What is a policy of insurance?" sidebar teaser — exclude it as a question and truncate any answer at that string. **Pack N' Go Plan exists at `/travel-insurance/plans/pack-n-go` (linked from the Quarantine Bundle page) — not yet built, add to a future batch.**

Video-library batch notes (Jun 11): 9 files — `video-library/index.json` (CollectionPage + ItemList of the 8 videos, names = landing anchor text) + 8 video pages (WebPage + VideoObject + breadcrumb). 6 pages already embed a player-generated VideoObject block — its name/description/thumbnailUrl/uploadDate/duration/embedUrl are reused verbatim (on-page data; thumbnails all 200). `antarctica-testimonial` and `real-life-experience` have no player block → VideoObject built from h1 + iframe embedUrl only (no thumbnail/uploadDate/duration — can't invent). **All 8 pages have a visible Transcript accordion** (`cmp-accordion__title` → `cmp-text` div) — full transcripts included as `VideoObject.transcript`, the highest-value LLM-citation content on these pages. `real-life-experience` has no meta description → WebPage/VideoObject `description` omitted. Nepal page: live `<title>` and player block still say "AIG Travel" (stale brand, flagged for web team); WebPage `name` uses the h1 per the our-underwriter precedent, but the player VideoObject `name`/`description` are kept verbatim since they title the historical AIG-era video asset itself.

Info-articles batch notes (Jun 10): all 7 `/info/{slug}` articles are 200 self-canonical and **all 7 have real sitemap `lastmod`** → `dateModified` allowed on every one (5-tips 2026-03-30, how-does 2026-03-25, how-much-cost 2026-03-25, packing 2025-08-22, ti-checklist 2026-03-25, policy 2026-03-25, when-to-buy 2026-04-23). Pattern: Article + breadcrumb (Home → Education Center → page). Extras only where on-page content exists: `how-much-does-travel-insurance-cost` has a real FAQ section (4 h3 Q&As), `when-to-buy` has question-formatted h2s (3 Q&As), `what-is-a-policy-of-insurance` gets a DefinedTerm (description = verbatim on-page sentence), `5-essential-tips` gets an ItemList of its 5 h3 tips. The two checklists and how-does-it-work are plain Article — their h2s are list categories, not Q&As.

Bundles / Pack N’ Go batch notes (Jun 10): all 11 `/travel-insurance/optional-coverage/{slug}` URLs are 200 **and self-canonical** — including `quarantine-bundle`, even though `/travel-insurance/benefits/lodging-expense-benefit` carries near-identical Quarantine Bundle content under its own self-canonical URL (site-side duplicate — flagged for the web team; both pages get schema since both are canonical). Bundle pages use the trip-type question-h2 template; exclude `Reviews and Testimonials`, `More Common Questions`, `Example Scenario:` h2s and the `What is a policy of insurance?` sidebar. Plan tiles (h3 Deluxe Plan etc.) under "How can I learn more…" → `isRelatedTo` Product links. No on-page breadcrumb nav exists — breadcrumbs are constructed from the site hierarchy (Home → Travel Insurance Plans → Upgrades and Bundles → page), matching CFAR. Pack N’ Go (`plans/pack-n-go.json`) is a Product file like medevac; its page links no sibling plans, so no `isRelatedTo`.

Trip-type / traveler-type batch notes (Jun 10): these pages share one AEM template family — question-formatted h2s (or h3s nested under a "Ready to book…?" CTA heading, which must be excluded) with visible prose answers. Files are WebPage + Service + OfferCatalog (only the plans each page actually links) + FAQPage with verbatim on-page Q&As (79 + 78, all containment-verified). Trailing "Get a travel insurance plan the way you want it!" / "Get travel insurance the way you want it!" CTA headings must be trimmed from final answers. The pregnant-travelers page additionally has a real FAQ accordion (8 h3 Q&As) on top of its prose sections — both are marked up. Traveler-type `audience.audienceType` uses the site nav's own labels (Backpackers, Family Travelers, …).

Next batches: **none — the build-out is complete.** Future additions would come from new site pages or the excluded sections below.

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
| 2026-06-10 | Both Quarantine Bundle pages get schema (`benefits/lodging-expense-benefit` + `optional-coverage/quarantine-bundle`) | Both URLs are 200 and self-canonical with near-identical content; site-side duplicate flagged for web team, not ours to resolve |
| 2026-06-11 | Video pages reuse the on-page player VideoObject metadata verbatim; full visible transcripts included as `VideoObject.transcript` | Player block is on-page data (satisfies content fidelity, supplies uploadDate/duration/thumbnail we couldn't otherwise source); transcripts are verbatim page content and the strongest LLM-citation signal |
| 2026-06-11 | Nepal video: WebPage `name` = h1 (Travel Guard branding), but player VideoObject `name` kept verbatim ("AIG Travel's Crisis Response - Nepal Earthquake") | Live title is stale-brand (our-underwriter precedent), while the video asset itself is a historical AIG-era video — its on-page player title is the factual name. Stale title + player branding flagged for web team |
| 2026-06-11 | `_sitewide.json` keeps `InsuranceAgency` + `WebSite` only; do not add `LocalBusiness` or `FinancialProduct` | `InsuranceAgency` already subclasses `LocalBusiness` (redundant); `FinancialProduct` is per-page product markup that would violate hard rule #1 on the every-page bundle, and plan pages already use `Product` |
| 2026-06-11 | Trustpilot `aggregateRating` (4.1 / 1,600 reviews, snapshot 2026-06-11) added to reviews page + homepage org `@id` references; NOT sitewide; no `review` array | Both pages visibly render TrustBox widgets (Review Page widget + FlexTrustScore hero), satisfying audit §6.5; sitewide rejected (score not visible on most pages, staleness on every page, live-bundle churn); review array rejected (widget reviews rotate → guaranteed drift); values from the widget-data endpoint in hard rule #7, refreshed at KPI checkpoints. Self-serving caveat: no rich-result stars expected — LLM-signal play |
| 2026-06-11 | `ItemList` `ListItem`s drop the nested `item: { @id }`, keeping `url` (summary-page carousel format) | Google Rich Results Test flagged `plans/index.json` carousel invalid: `url` + `item` are mutually exclusive (critical error), and the `#product` `@id` referenced a Product on another page so it dangled to an empty `Thing` (4 "missing url" warnings). `url` preserves the cross-page link. Same fix applied to `benefits/compare-travel-insurance.json`; codified as hard rule #10 |
| 2026-06-11 | Built `plans/annual.json` (live page, not retired) and rebuilt `plans/index.json` ItemList to the 7 cards shown on the live listing | `/travel-insurance/plans/annual` 200s self-canonical and appears as a plan card — the old "annual = retired" note was wrong. annual = `FinancialProduct` (9 Standard + 6 Assistance coverages verbatim from page h3s; no `isRelatedTo` — page links no siblings; no `dateModified` for consistency with sibling plans). Listing ItemList was stale at 4; the live "Our Plans" section shows 7 cards (Deluxe, Preferred, Essential, Pack N’ Go, Annual, Medevac Per Trip, Rental Vehicle Damage Coverage) — rebuilt to match, in card order |
| 2026-06-11 | All 6 plan nodes retyped `Product` → `FinancialProduct` (`@id` kept as `#product`) | Google Rich Results flagged the plan `Product` invalid for Product snippets (missing `offers.price`) and Merchant listings (missing `price` + `image`) — insurance is quote-priced with no retail image/shipping/returns, and fabricating them violates hard rule #1. `FinancialProduct` is schema.org's insurance type and not a Google e-commerce rich-result type, so the errors clear while `offers`/`additionalProperty`/`audience`/`brand`/`isRelatedTo` all stay valid (0/0 at validator.schema.org). `@id` fragment left as `#product` to avoid dangling ~30 OfferCatalog references. Codified as hard rule #11; supersedes the "plan pages already use Product" note in the LocalBusiness/FinancialProduct row above |
