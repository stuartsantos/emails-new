# Travel Guard Schema Markup Audit (LLM-First)

**Site reviewed:** https://www.travelguard.com
**Date:** May 2026
**Focus:** Structured data to improve discoverability and citation by AI search (ChatGPT, Perplexity, Google AI Overviews, Gemini, Copilot) — with traditional rich results as a secondary benefit.

---

## 1. Executive summary

Travel Guard's homepage and most key templates render the kinds of content that LLMs love to cite — product comparisons, FAQs, pricing rules of thumb, contact info, a clear brand identity, and an editorial library — but the page response I pulled showed no JSON-LD `<script>` blocks in the visible markup. That means LLM crawlers and Google's structured-data parsers are doing all the work themselves from the HTML, which leaves a lot of citation potential on the table.

The single highest-leverage move is a **site-wide JSON-LD bundle** (`Organization` + `WebSite` in one `@graph`) injected in `<head>` on every template, paired with a **per-page `BreadcrumbList`** embedded in each non-home page's own JSON-LD `@graph`. After that, the homepage, plan pages, FAQ, claims, articles, and reviews are the next priority because they're the pages LLMs are most likely to cite when answering "what is travel insurance," "does Travel Guard cover X," or "Travel Guard reviews."

This audit is also relevant to the AIG → Zurich rebrand: the homepage footer already names Zurich entities as underwriters. Codifying that relationship in `Organization.parentOrganization` and updating `alternateName`/`sameAs` is one of the cleanest ways to signal the brand transition to LLMs that have stale "AIG Travel Guard" associations in their training data.

---

## 2. Why structured data matters for LLM ranking

LLMs and AI search products don't behave exactly like Google's crawler, but they consistently benefit from the same signals:

- **Entity disambiguation.** `Organization` with `sameAs` links to Wikipedia, LinkedIn, Trustpilot, and the parent (Zurich) helps the model resolve "Travel Guard" to *your* company rather than a generic phrase. This is what makes the difference between being cited and being paraphrased away.
- **Fact extraction.** When a user asks "how much does Travel Guard cost?", a model that finds a `FAQPage` answer with a clean string ("typically 5-7% of trip cost") is much more likely to quote that verbatim with attribution than one that has to summarize prose.
- **Service/Product modeling.** Insurance is a relationship between *who*, *what coverage*, *for whom*, *where*. `Product` + `Offer` + `audience` + `areaServed` gives the model all four in one structured payload.
- **Citation hooks.** `mainEntityOfPage` and stable `@id` URIs give AI surfaces something specific to point to, which raises the probability of a linked citation versus an uncited paraphrase.
- **Recency and trust.** `dateModified`, `aggregateRating`, `hasCredential` (BBB), and `memberOf` (UStiA, IGLTA) are exactly the cues LLMs use to weigh authority when there are competing sources.

In practical terms: the goal isn't a Google rich snippet. It's making sure that when ChatGPT or Perplexity is composing an answer about travel insurance, your page is the one it pulls from and links to.

---

## 3. Site-wide schema (every page)

These should appear in the `<head>` of **every** rendered template. Put each `@type` in its own `<script type="application/ld+json">` block, or combine them in a single `@graph`.

### 3.1 Organization (highest priority)

The Organization entity is the spine that every other schema on the site should reference via `@id`. Key properties to lock down:

- `@type`: use `InsuranceAgency` (a subtype of `LocalBusiness` and `Organization`) — more specific is better for LLMs.
- `parentOrganization`: name Zurich Insurance Group. This is the cleanest way to communicate the AIG → Zurich underwriter relationship to AI systems.
- `alternateName`: include "AIG Travel Guard" so legacy queries still resolve to the current entity.
- `sameAs`: Facebook, LinkedIn, YouTube, Instagram, X/Twitter, Trustpilot, and Wikipedia if a page exists. The Trustpilot link in particular is high-value for LLM trust signals.
- `contactPoint`: separate entries for customer service, sanctioned-countries hotline, and Advisor Connect tech support — including `availableLanguage` and 24/7 `hoursAvailable` on the main line.
- `memberOf`: UStiA and IGLTA (both shown in your footer).
- `hasCredential`: BBB accreditation.
- `knowsAbout`: list of insurance topics — explicit topical authority signal.

→ See `jsonld/_sitewide.json` (the `@graph` bundle) for the full payload.

### 3.2 WebSite

Adds a sitelinks search box eligibility and explicitly ties pages back to the org. Include a `potentialAction` of type `SearchAction` if you have a `/search?q=` endpoint (or update the URL template to match).

→ See `jsonld/_sitewide.json` (bundled with the Organization node in one `@graph`).

### 3.3 BreadcrumbList

Every non-home page should carry a per-page `BreadcrumbList`. This is one of the schemas LLMs actually use to understand a page's place in the site hierarchy, which improves their ability to recommend related pages and properly attribute claims.

Unlike `Organization` and `WebSite`, a `BreadcrumbList` is **not** a single reusable payload and is **not** part of the sitewide bundle — each page has its own trail. It is therefore embedded directly in each page's `@graph` rather than kept as a separate file. The per-page JSON-LD files in `jsonld/` (e.g. `travel-insurance/plans/deluxe.json`, `help-center/faqs.json`, `help-center/claims.json`) each include their own `BreadcrumbList` node with an `@id` of `{page-url}#breadcrumb`. When adding a new template, copy the breadcrumb pattern from the closest existing page.

### 3.4 Speakable — removed (Jun 10, 2026)

Earlier drafts of this audit recommended `speakable` on editorial pages. It has since been **removed from all JSON-LD files**: the property is still "pending" at schema.org, Google's implementation is a beta limited to news content read by Google Assistant (travel-insurance pages are not eligible), and our selectors only pointed at generic `h1`/`h2` headings rather than genuinely quotable summaries. There is no evidence LLMs consume it, and it added validator noise plus a silent breakage risk if page markup changes. Don't re-add it unless Google expands the feature beyond news and the pages gain purpose-written speakable sections.

---

## 4. Per-page schema recommendations

Pages are ordered by LLM-citation value, highest first.

### 4.1 Homepage (`/`)

**Recommended types:** `WebPage` + `OfferCatalog` (for the four plans) + `FAQPage` (for the on-page FAQs) — wrapped in a single `@graph`.

**Why:** The homepage already exposes the four plan comparison, four canonical FAQs, trust signals (Trustpilot, BBB, UStiA), and contact info. Marking all of this up gives LLMs a self-contained "what is Travel Guard" payload they can cite without crawling further. The FAQ block in particular is high-value: ChatGPT and Perplexity routinely surface FAQPage answers verbatim.

**Avoid:** Don't list every FAQ on the site here — keep it to the 4 that are visibly on the page. Google penalizes mismatch between visible content and JSON-LD.

→ See `jsonld/index.json`.

### 4.2 Plan pages (`/travel-insurance/plans/{deluxe|preferred|essential|rental-vehicle-damage-plan}`)

**Recommended types:** `Product` + `Offer` + `additionalProperty` (for included coverages). `aggregateRating` and `FAQPage` are recommended future additions once verifiable Trustpilot data and plan-specific FAQs are in place.

**Why:** These are your money pages. `Product` + `Offer` is the schema LLMs map to "what plan covers X" questions. Use `additionalProperty` with `PropertyValue` items to enumerate the included coverages (Trip Cancellation, Emergency Medical, Baggage, etc.) — that's the structure LLMs need to answer "does the Deluxe Plan cover medical evacuation?" `additionalProperty` is preferred over `hasOfferCatalog` here because the coverages are *features* of the plan, not separately-purchasable products.

**LLM-specific tips:**
- `audience.audienceType` describes who the plan is for in plain English ("international travelers, senior travelers, high-end vacationers"). LLMs use this for "best travel insurance for seniors" type queries.
- `isRelatedTo` cross-links the other plans so an LLM can answer comparison questions.
- `areaServed` should be `Country: United States` — this prevents misattribution in Canada/UK queries.
- Only include `aggregateRating` with real, verifiable data. Inflating reviews is a structured-data policy violation and a reputational risk. The current `travel-insurance/plans/deluxe.json` intentionally omits `aggregateRating` until a Trustpilot integration is wired in.

→ See `jsonld/travel-insurance/plans/deluxe.json` (template for the other three).

### 4.3 Plans listing page (`/travel-insurance/plans`)

**Recommended type:** `ItemList` listing the four products in display order.

**Why:** Tells LLMs this page is a comparison/index — improves the chance they cite it for "Travel Guard plans" rather than picking one plan page arbitrarily.

→ See `jsonld/travel-insurance/plans/index.json`.

### 4.4 FAQ page (`/help-center/faqs`)

**Recommended type:** `FAQPage`.

**Why:** This is the single highest LLM-citation surface on any insurance site. AI assistants pull FAQ answers verbatim and almost always link back. Mark up **every** Q&A on the page, not just the top ones, but only ones whose answers are visible to the user.

**Tips:**
- Phrase questions the way real users ask them ("How much does Travel Guard cost?" not "Pricing structure").
- Keep answers under 300 words — LLMs are more likely to pull short, complete answers.
- Use one `FAQPage` with many `Question` children, not one FAQPage per question.

→ See `jsonld/help-center/faqs.json`.

### 4.5 Claims page (`/help-center/claims`)

**Recommended type:** `WebPage` + `Service` referencing the claims portal.

**Why:** "How do I file a Travel Guard claim" is one of the most common high-intent queries. The original recommendation here was a `HowTo`, but the live claims page presents no step-by-step workflow — just two portal CTAs (File a Claim → claims.travelguard.com/claims, Check Claim Status → claims.travelguard.com/status) and a short intro. Schema must match visible page content, so the JSON-LD models the page as a `WebPage` whose `mainEntity` is a `Service` with `availableChannel` entries for the two portal URLs and the claims phone line (1-866-478-8222, USA-purchased policies only per the on-page note). If the web team ever adds visible numbered filing steps to the page, revisit `HowTo`.

→ See `jsonld/help-center/claims.json`.

### 4.6 About Us (`/about-us`)

**Recommended type:** `AboutPage` whose `mainEntity` points to the `#organization` node.

**Why:** Strengthens the entity. LLMs use the About page to confirm corporate facts (founding, parent company, jurisdiction) when they evaluate whether to trust a source. This is the page to anchor the Zurich underwriter relationship in narrative form *and* in `parentOrganization` JSON-LD.

→ See `jsonld/about-us/index.json`.

### 4.7 Contact Us (`/help-center/contact-us`)

**Recommended type:** `ContactPage` referencing the org's `contactPoint` array.

**Why:** Standardizes phone, hours, and language availability for AI assistants answering "Travel Guard customer service number."

→ See `jsonld/help-center/contact-us.json`.

### 4.8 Trip-type and traveler-type pages (e.g. `/travel-insurance/trip-types/cruise-insurance`)

**Recommended type:** `WebPage` + `Service` (with `serviceType: "Cruise Travel Insurance"` etc.) + `OfferCatalog` listing the recommended plans for that trip type.

**Why:** These pages compete for high-intent queries like "best cruise travel insurance." `Service` with `audience` is what LLMs need to answer "what plan should I buy for a cruise?"

→ See `jsonld/travel-insurance/trip-types/cruise-insurance.json` (template for all trip and traveler types).

### 4.9 Education Center articles (`/info/*`, `/travel-resources/travel-tips/*`)

**Recommended type:** `Article` (or `NewsArticle` if dated/news-like). Add `DefinedTerm` for glossary-style content like "What is Travel Insurance?".

**Why:** LLMs love `Article` with clean `author`, `datePublished`, `dateModified`, `about`, and `mainEntityOfPage`. The `dateModified` field is particularly important — it's a primary recency signal AI search uses to choose between competing sources.

→ See `jsonld/_templates/article-template.json` and `jsonld/info/what-is-travel-insurance.json`.

### 4.10 Customer Reviews page (`/about-us/travel-insurance-reviews`)

**Recommended types:** `CollectionPage` whose `mainEntity` references the Organization. Layer in `aggregateRating` and a `review` array once verifiable Trustpilot data is available.

**Why:** Reviews mapped to schema can drive star ratings in traditional search and serve as a trust signal for LLMs. **Use only verifiable, first-party reviews** — never invent ratings.

**Current state:** `jsonld/about-us/travel-insurance-reviews.json` is intentionally minimal — it declares the `CollectionPage` and references the org by `@id`, but does not yet include `aggregateRating` or `review` entries. This is to prevent placeholder/fake data from shipping. When Trustpilot data is wired in, augment the `mainEntity` block with the real `aggregateRating` (ratingValue, reviewCount, bestRating, worstRating) and a `review` array of verbatim customer reviews with real author names and dates.

→ See `jsonld/about-us/travel-insurance-reviews.json`.

---

## 5. Page-by-page priority matrix

| Priority | Page / Template | Schema types | Effort | LLM impact |
|---|---|---|---|---|
| P0 | All pages (sitewide bundle) | Organization, WebSite | Low — one-time include | Very high — foundational entity |
| P0 | Every non-home page | BreadcrumbList (per-page, embedded in page `@graph`) | Low per page | Very high — site-hierarchy signal |
| P0 | Homepage | WebPage + OfferCatalog + FAQPage | Medium | Very high — first-touch citations |
| P0 | FAQ (`/help-center/faqs`) | FAQPage | Low | Very high — verbatim answer extraction |
| P0 | Plan pages (4) | Product + Offer + additionalProperty (+ aggregateRating, FAQPage as future additions) | Medium | Very high — product comparison queries |
| P1 | Plans listing | ItemList | Low | Medium |
| P1 | Claims | WebPage + Service (HowTo only if visible steps are added to the page) | Medium | High — high-intent workflow queries |
| P1 | About Us | AboutPage + Organization | Low | High — entity disambiguation, Zurich relationship |
| P1 | Contact Us | ContactPage | Low | Medium |
| P2 | Trip-type pages (13) | Service + OfferCatalog | Medium per page | High — long-tail "best X insurance" queries |
| P2 | Traveler-type pages (12) | Service + OfferCatalog + PeopleAudience | Medium per page | High — same |
| P2 | Education Center / Travel Tips | Article + DefinedTerm | Low per article | Medium-High — content authority |
| P2 | Reviews page | CollectionPage + Review + AggregateRating | Medium | Medium |
| P3 | Destinations pages | Place + TouristDestination + Article | Medium | Medium |
| P3 | Video Library | VideoObject per video | Medium | Medium |

---

## 6. Implementation notes for the dev team

### 6.1 Where to put the JSON-LD

Inject in `<head>` (or just before `</body>`) as `<script type="application/ld+json">`. AEM users typically add a global include for the site-wide schemas and a per-component include for page-specific schemas. Don't put JSON-LD inside `<noscript>` or behind JavaScript that runs after page load — many LLM crawlers don't execute JS.

### 6.2 `@id` discipline

Use stable, absolute-URL `@id`s for every node and *reference* them from other schemas with `{ "@id": "..." }`. This is what lets LLMs and crawlers stitch a knowledge graph across pages instead of treating each page as an isolated document. The pattern used throughout these JSON-LD files:

- Organization: `https://www.travelguard.com/#organization`
- WebSite: `https://www.travelguard.com/#website`
- Per-page entities: `{page-url}#{type}` — e.g. `https://www.travelguard.com/travel-insurance/plans/deluxe#product`

### 6.3 The Zurich rebrand opportunity

In addition to the schema work, three sitewide updates will help LLMs catch up to the rebrand:

1. **Organization.parentOrganization** in JSON-LD names Zurich Insurance Group — included in `_sitewide.json`.
2. **Add an underwriter disclosure page** (`/legal/our-underwriter` already exists per the footer) with its own JSON-LD `WebPage` and a clear text declaration. LLMs index legal pages disproportionately.
3. **Update Wikipedia/Wikidata** if you have a marketing team that can edit it. LLMs treat Wikidata as a high-trust ground truth — making sure the Travel Guard / Zurich relationship is reflected there will propagate through future model training.

### 6.4 Validation

Before pushing, validate each JSON-LD block at:

- https://validator.schema.org/ — confirms schema.org property correctness
- https://search.google.com/test/rich-results — confirms Google rich-result eligibility (FAQPage, Product, HowTo, Article are all eligible types)

### 6.5 Things to avoid

- Don't mark up content that isn't visible on the page — Google penalizes this and LLMs ignore the page.
- Don't fabricate `aggregateRating` values — link to Trustpilot via `sameAs` instead, and only add `aggregateRating` if you can render the matching rating widget on the page.
- Don't put price ranges on plan pages unless the price is actually shown — premiums depend on traveler age, trip cost, and state, so `priceSpecification.description` is the safer pattern (already in the Deluxe JSON-LD).
- Don't duplicate the same Organization JSON-LD with conflicting properties on different pages. Define it once site-wide and reference it via `@id` everywhere else.

---

## 7. Suggested rollout order

1. **Week 1:** Site-wide bundle (Organization + WebSite). Validate. Submit updated sitemap to Google Search Console. Per-page `BreadcrumbList` ships embedded in each page's own `@graph` as those pages are tackled in the weeks below.
2. **Week 2:** Homepage, FAQ page, all four plan pages.
3. **Week 3:** About Us, Contact Us, Claims (WebPage + Service), Plans listing (ItemList).
4. **Week 4-5:** Trip-type and traveler-type pages (Service schema).
5. **Week 6+:** Education Center and Travel Tips articles (template-driven, can be automated).

After 4-6 weeks of indexing, monitor LLM citations using a tool like Profound, Otterly, or simple manual probes ("what is Travel Guard," "compare travel insurance plans," "how do I file a claim with Travel Guard").

---

## 8. Otterly-informed priority update (May 2026)

After the initial audit was drafted, we pulled the Travel Guard brand report from Otterly.ai (Last 14 days, US, all engines, 20 prompts) to ground the schema work in observed LLM behavior rather than assumptions. Key findings, plus the priority changes they trigger:

### 8.1 The headline gap: mentions vs. citations

Travel Guard registers **452 brand mentions** in the period (rank #2 behind Seven Corners at 526), but the company's own domain only receives **185 citations** and **1% citation share**. Allianz, by comparison, has **541 own-domain citations** — their `allianztravelinsurance.com` is one of the top 5 most-cited domains across all travel-insurance prompts. The "mentioned but not cited" gap is the single biggest schema opportunity. LLMs know Travel Guard exists; they're just not pointing users at travelguard.com when they answer questions.

### 8.2 Pages already winning citations — escalate to P0

The Otterly report shows Travel Guard's three most-cited URLs in the period are:

| Rank | URL | Citations |
|---|---|---|
| 1 | /travel-resources/travel-safety/student-travel-safety | 26 |
| 2 | /traveler-types/pre-existing-medical-condition-travel-insurance-plans | 19 |
| 3 | /travel-insurance/optional-coverage/cancel-for-any-reason | 18 |

These pages are *already* getting cited — adding strong schema will compound the effect. All three move to **P0** and have dedicated JSON-LD files in this audit:

- `jsonld/travel-resources/travel-safety/student-travel-safety.json` — Article + EducationalAudience (HowTo was removed because the live page does not present its safety guidance as a discrete numbered step list — schema must match visible page content)
- `jsonld/traveler-types/pre-existing-medical-condition-travel-insurance-plans.json` — Service + FAQPage + PeopleAudience
- `jsonld/travel-insurance/optional-coverage/cancel-for-any-reason.json` — Service + FAQPage (using real FAQ content extracted from the live CFAR page)

### 8.3 Mention-to-citation gaps — biggest unlock opportunities

The Otterly "Top Prompts by Brand Mentions" vs. "Top Prompts by Website Citations" tables tell us where Travel Guard is mentioned in answers but the answer cites a competitor or aggregator. These are the prompts where structured data can swing citations our way.

| Prompt | Brand mentions | Own-domain citations | Schema lever |
|---|---|---|---|
| "What are the top travel insurance providers for lost baggage coverage?" | 62 | 12 | Plan `Product` + explicit Baggage Loss & Delay `Offer` line-items + dedicated baggage page if missing |
| "What are the top-rated travel insurance companies?" | 58 | not in top 10 | Homepage `aggregateRating` (real Trustpilot numbers) + `Review` markup on /about-us/travel-insurance-reviews |
| "Which travel insurance company has the best customer service" | 48 | not in top 10 | `ContactPage` + `Organization.contactPoint` with 24/7 `hoursAvailable` and `availableLanguage` |
| "Best travel insurance company for U.S. travelers" | 43 | not in top 10 | `Organization.areaServed: US` + `AboutPage` emphasizing U.S. focus + state-level `availableAtOrFrom` |
| "What are the best travel insurance options for emergency assistance?" | 34 | 3 | `Service` with serviceType "24/7 Emergency Travel Assistance" referenced from Org + plan pages |

### 8.4 Competitive benchmark: study Allianz

Allianz being in the **top 5 most-cited domains** overall (541 citations, 4% share) is the most actionable competitor signal in the report. Their site is succeeding at exactly what this audit is trying to achieve for Travel Guard. Before final implementation, a dev should view-source on `allianztravelinsurance.com`'s homepage and top product pages, catalog the JSON-LD types and properties they use, and copy whatever patterns make sense. Their content is no better than yours; their structured data discipline likely is.

### 8.5 Revised P0 list

The new P0 list, reflecting Otterly data:

1. **Site-wide bundle** — Organization + WebSite (per-page BreadcrumbList embedded in each page's `@graph`, not in the sitewide bundle)
2. **Homepage** — WebPage + OfferCatalog + FAQPage (+ aggregateRating once Trustpilot integration is verified)
3. **FAQ page** — full FAQPage
4. **Four plan pages** — Product + Offer + FAQPage with explicit Baggage Loss & Delay line-items
5. **CFAR page** ← new P0 (was unprioritized)
6. **Pre-existing conditions page** ← new P0 (was P2)
7. **Student travel safety article** ← new P0 (was P2)
8. **Contact Us** ← elevated from P1 (Otterly shows "best customer service" is a high-mention/low-citation gap)
9. **Reviews page** ← elevated from P2 (Otterly shows "top-rated" is a high-mention/low-citation gap)

### 8.6 The Allianz signal also tells us what NOT to do

We can't out-Squaremouth Squaremouth. The top 10 cited domains are dominated by comparison/aggregator sites (Squaremouth 7%, Nerdwallet 5%, Forbes 5%, US News 4%) and that's a PR/relationship game, not a schema game. Structured data is the right tool for direct-citation queries (CFAR, pre-existing conditions, claims, contact, specific coverages) — not for "best travel insurance overall" listicles. Set expectations accordingly: a realistic schema-driven goal is moving own-domain citations from 1% → 3-4% over 90 days, putting Travel Guard at parity with Allianz on direct citation share.

---

## 9. Files in this audit

The `jsonld/` folder mirrors the live site's URL structure: the folder root is the homepage (`index.json`), each URL path segment is a subfolder, and section landing pages are `index.json` inside their folder. Files prefixed with `_` are not pages (`_sitewide.json` is the every-page bundle; `_templates/` holds placeholder-marked templates that must never be deployed as-is).

```
TravelGuard-Schema-Audit.md              ← this document
TravelGuard-KPI-Tracking.md              ← before/after KPI tracking guide
CLAUDE.md                                ← project context + decision log for AI sessions
jsonld/
  _sitewide.json                         ← P0, every page (Organization + WebSite @graph bundle)
  _templates/
    article-template.json                ← P2 template, Travel Tips / blog ({{placeholders}}, do not deploy)
  index.json                             ← P0, homepage
  about-us/
    index.json                           ← P1, /about-us
    travel-insurance-reviews.json        ← P0 (escalated), reviews collection
  help-center/
    index.json                           ← P1, /help-center landing
    claims.json                          ← P1, /help-center/claims (WebPage + Service)
    contact-us.json                      ← P0 (escalated), /help-center/contact-us
    faqs.json                            ← P0, /help-center/faqs
  info/
    index.json                           ← P1, /info Education Center landing
    assistance-services.json             ← P0 (KPI 11.7), 7 assistance categories
    what-is-travel-insurance.json        ← P2, Education Center
  legal/
    our-underwriter.json                 ← P1, Zurich underwriter disclosure (audit 6.3)
  travel-insurance/
    benefits/
      baggage-insurance.json             ← P0 (KPI 11.7), Service + on-page FAQPage
    plans/
      index.json                         ← P1, /travel-insurance/plans
      deluxe.json                        ← P0, Deluxe plan
      preferred.json                     ← P0, Preferred plan
      essential.json                     ← P0, Essential plan
      rental-vehicle-damage-plan.json    ← P0, Rental Vehicle Damage Coverage
    optional-coverage/
      index.json                         ← P1, ItemList of the 11 upgrades/bundles
      cancel-for-any-reason.json         ← P0 (new), CFAR page
    trip-types/
      index.json                         ← P1, ItemList of the 13 trip types
      cruise-insurance.json              ← P2, trip-type template
  traveler-types/
    index.json                           ← P1, ItemList of the 11 traveler types
    pre-existing-medical-condition-travel-insurance-plans.json  ← P0 (new)
  travel-resources/
    travel-safety/
      student-travel-safety.json         ← P0 (new), student safety article
    travel-tips/
      how-to-beat-jet-lag-fast.json      ← P2, real Travel Tips article (worked example)
```

---

## 10. CLAUDE.md context (for your repo)

**This now exists:** see `_work-items/json/CLAUDE.md` for the maintained project context, hard rules, build workflow, and decision log. The snippet below is the original suggestion, kept for the dev team's site repo:

```markdown
# Travel Guard structured-data conventions

We use JSON-LD (not Microdata or RDFa) for all structured data. Every page must include:
- Site-wide Organization (`@id: https://www.travelguard.com/#organization`)
- Site-wide WebSite (`@id: https://www.travelguard.com/#website`)
- Per-page BreadcrumbList

Page-specific schema is added based on template type. See `/docs/schema/` for the
canonical JSON-LD payloads per template. When adding a new template, copy the
closest existing pattern and update `@id`s to the page URL with a `#type` suffix.

Key entity facts:
- Underwriter parent: Zurich Insurance Group (American Zurich Insurance Company,
  Zurich American Insurance Company, National Union Fire Insurance Company of
  Pittsburgh, Pa.)
- Legal name: Travel Guard Group, Inc.
- Primary phone: 800-826-5248
- Mailing address: 3300 Business Park Drive, Stevens Point, WI 54482
- Memberships to cite in Organization.memberOf: UStiA, IGLTA
- Accreditations to cite in Organization.hasCredential: BBB

Validate every new JSON-LD against https://validator.schema.org/ before merging.
```

---

---

*See `TravelGuard-KPI-Tracking.md` for the before/after measurement plan to validate the impact of these changes.*
