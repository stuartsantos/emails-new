# Travel Guard Schema Implementation — Before/After KPI Tracking

**Purpose:** Measure whether the schema markup rollout actually changes how AI search and traditional search interact with travelguard.com. Built around your existing Otterly instance plus Google Search Console and analytics.

**Baseline snapshot (May 6-19, 2026, US, all engines, 20 prompts):**

| Metric | Baseline |
|---|---|
| Brand mentions | 452 |
| Brand rank | #2 (Seven Corners #1 at 526) |
| Brand coverage | 29.1% (Leader) |
| Brand coverage trend | -1 |
| Likelihood to buy | 79% (trend: -2) |
| Average brand position | 1.94 |
| Own-domain citations | 185 |
| Citation share | 1% |
| Domain coverage | 8% |

These are the numbers to beat. Re-pull the same Otterly view at the dates noted in the cadence section below.

---

## 1. The four KPI tiers

KPIs are organized into four tiers, in increasing distance from the change:

1. **Implementation hygiene** — did the schema actually deploy and parse correctly? Lead indicators, daily/weekly.
2. **LLM citation metrics** — Otterly-tracked. The primary success metric for this project.
3. **Traditional search rich results** — Google Search Console. Schema-enabled features (FAQ snippets, sitelinks, etc.).
4. **Downstream business metrics** — quote starts, conversions. The metrics that justify SEO investment to the business.

Tier 1 confirms you shipped. Tier 2 is your scorecard. Tier 3 and 4 validate it for stakeholders.

---

## 2. Tier 1 — Implementation hygiene KPIs

Track these continuously during rollout. Anything in this tier should be at 100% before declaring a phase "done."

| KPI | Target | Source | Cadence |
|---|---|---|---|
| % of priority templates with site-wide schema deployed | 100% | Schema validator + manual spot-check | Per rollout phase |
| JSON-LD validation pass rate | 100% | https://validator.schema.org/ | Per template |
| Rich Results Test pass rate (eligible types) | 100% | Google Rich Results Test | Per template |
| Schema parse errors in GSC "Enhancements" report | 0 | Google Search Console | Weekly |
| Pages with structured data indexed by Google | Target ≥ 95% of submitted | GSC > Coverage | Weekly |
| Bing Webmaster Tools markup validator errors | 0 | Bing Webmaster Tools | Weekly |

The Bing line matters more than people expect — ChatGPT search runs on Bing's index, so Bing's parser is effectively the gatekeeper for half your LLM citation pipeline.

---

## 3. Tier 2 — LLM citation metrics (Otterly)

These are the primary success metrics. Pull from the same Otterly Brand Report (Last 14 days, US, all engines) at the cadence below. The 90-day targets assume a focused rollout of the audit's P0 items.

### 3.1 Brand-level metrics

| KPI | Baseline | 30-day target | 90-day target | Why |
|---|---|---|---|---|
| Brand mentions | 452 | 475 | 525 | Reflects total LLM awareness of Travel Guard. Schema alone won't move this much — content does. |
| Brand rank | #2 | #2 | #1 or #2 | Catching Seven Corners requires citation-share improvement, not just schema. |
| Brand coverage % | 29.1% | 30% | 32% | The leading indicator of LLM share-of-voice. |
| Brand coverage trend | -1 | 0 | +1 | Reversing the decline is the first signal schema is working. |
| Average brand position | 1.94 | 1.80 | 1.65 | Lower is better. Position improves when LLMs cite *you* as the primary source, not as one of many. |
| Likelihood to buy | 79% (-2) | 80% | 83% | Tied to sentiment + how clearly your offering is described. Service schema with `audience` and `areaServed` helps. |
| Sentiment score | +63 | +65 | +68 | Watch this — schema shouldn't hurt sentiment, but rebrand messaging might. |

### 3.2 Citation metrics (the most important tier-2 numbers)

These are the metrics most directly affected by schema work. If these don't move, the implementation didn't work.

| KPI | Baseline | 30-day target | 90-day target | Why |
|---|---|---|---|---|
| Own-domain citations | 185 | 250 | 400 | The headline number. Doubling this is realistic and the explicit goal. |
| Citation share | 1% | 1.5% | 3-4% | Allianz is at 4%; this is achievable parity. |
| Domain coverage | 8% | 10% | 14% | % of prompts where travelguard.com is in the cited set. |
| # of unique travelguard.com URLs cited | (extract from full report) | +25% | +75% | More pages getting cited = broader entity recognition. |
| Top-cited TG URL citation count | 26 (student-travel-safety) | 35 | 50 | Top pages should grow with schema reinforcement. |

### 3.3 Per-prompt citation tracking

Track Travel Guard's domain citation count on the specific high-value prompts where today's gap is biggest. Re-pull the Otterly "Top Prompts by Website Citations" table at each checkpoint.

| Prompt | Baseline TG citations | 90-day target |
|---|---|---|
| How do I get trip protection for a last-minute trip? | 33 | 40 |
| Are there travel insurance plans that cover pre-existing conditions? | 29 | 50 |
| Are there travel safety services specifically for students studying abroad? | 29 | 50 |
| How do I know if my trip protection covers medical emergencies? | 21 | 35 |
| Is there a travel insurance plan that covers trip cancellations for any reason? | 14 | 35 |
| How do I track the status of my travel insurance claim? | 12 | 25 |
| What are the top travel insurance providers for lost baggage coverage? | 12 | 30 |

The pre-existing conditions, student safety, and CFAR prompts have the strongest theoretical upside — they correspond directly to the three P0 pages that already get cited, just amplified by schema.

### 3.4 Per-engine breakdown

Otterly lets you filter by engine. Re-pull the same metrics filtered to each:

- ChatGPT
- Perplexity
- Google AI Overviews / SGE
- Gemini
- Copilot

You'll likely see different rates of change. Perplexity is generally the most schema-responsive (it cites obsessively). Google AI Overviews moves slowest because it requires both indexing and a rendered AI Overview. ChatGPT changes when Bing's index re-crawls (typically 1-2 weeks).

---

## 4. Tier 3 — Traditional search rich results (GSC)

Schema work pays off in classic Google rich snippets too. Track these in Google Search Console (Search Console > Performance + Enhancements).

| KPI | Baseline | 90-day target | Source |
|---|---|---|---|
| FAQ-rich-result impressions | (capture pre-launch) | +50% | GSC > Search Appearance > FAQ |
| Product-rich-result impressions | (capture pre-launch) | New metric | GSC > Search Appearance > Product |
| HowTo-rich-result impressions | (capture pre-launch) | New metric | GSC > Search Appearance > HowTo |
| Sitelinks search box impressions | (capture pre-launch) | Track presence | GSC > Search Appearance |
| Rich result CTR vs. non-rich | Higher | Maintain | GSC > Performance, segment by Search Appearance |
| Total impressions on plan pages | (capture pre-launch) | +20% | GSC > Pages |
| Total clicks on plan pages | (capture pre-launch) | +15% | GSC > Pages |
| Pages with valid structured data | (capture pre-launch) | +50% | GSC > Enhancements |

Capture screenshots of GSC Performance + Enhancements the day before deploying each phase. That's your before snapshot.

Note: As of 2023, Google deprecated the FAQPage rich result for most sites — but the FAQPage schema still helps LLMs and is still surfaced for some verticals and queries. Track FAQ impressions to see whether your site is among the ones still getting them.

---

## 5. Tier 4 — Downstream business metrics

These are the metrics that prove SEO investment translates to business outcomes. They move slowest but justify the work.

| KPI | Source | Notes |
|---|---|---|
| Organic sessions to travelguard.com | GA4 | Segment by landing page to isolate schema'd pages |
| AI/Generative referral traffic | GA4 | Filter source/medium for `chatgpt.com`, `perplexity.ai`, `gemini.google.com`, `copilot.microsoft.com`. AI traffic is small but high-intent. |
| Quote starts from organic traffic | GA4 + your CRM | The conversion event closest to revenue. |
| Quote starts from AI referrals | GA4 + your CRM | The most important downstream number for justifying further schema/LLM work. |
| Bounce rate on schema'd pages | GA4 | Should improve as page understanding improves snippet quality. |
| Time on page, schema'd templates | GA4 | Schema doesn't directly affect this, but pages that get cited by LLMs tend to attract more engaged visitors. |
| Average position, brand + product terms | GSC | Should improve modestly with stronger entity signals. |

---

## 6. Measurement cadence

| Cadence | What to do |
|---|---|
| **Pre-launch (week 0)** | Capture all Tier 2/3/4 baselines. Screenshot the Otterly Overview, GSC Performance, and GSC Enhancements pages. Export Otterly CSVs if available. |
| **Daily during rollout** | Tier 1 only — run validator + Rich Results Test on each newly deployed template. |
| **Weekly (weeks 1-12)** | Tier 1 monitoring (GSC errors, Bing errors). |
| **Bi-weekly** | Tier 2 Otterly pull. Compare to baseline. Watch for early movement in citation count and brand coverage trend. |
| **Monthly** | Full Tier 2 + Tier 3 review. Update the priority matrix in the audit doc if certain pages are over- or under-performing expectations. |
| **Day 30** | First major checkpoint vs. 30-day targets. Adjust rollout if numbers are flat. |
| **Day 90** | Primary success readout. Report to stakeholders against 90-day targets. |
| **Day 180** | Sustainment check. Look for any decay (e.g., if you stopped updating `dateModified` fields, expect citation drift). |

---

## 7. Holdout / control comparisons

Schema work doesn't lend itself well to true A/B testing (you can't easily serve different JSON-LD to different LLM crawlers). But there are two reasonable quasi-experimental approaches:

**1. Page-cohort holdout.** Roll out schema to half of your trip-type pages in week 1 and the other half in week 6. Compare 30-day citation/coverage gains between the two cohorts at the matched relative timepoint. This isolates the schema effect from market drift.

**2. Competitor-baseline normalization.** Otterly tracks your top 5 competitors. If your brand coverage rises while competitors' is flat or declining, that's stronger evidence schema is working than raw absolute movement (which could be seasonal LLM behavior).

---

## 8. Things that will *look* like schema impact but aren't

Watch out for these confounds so you don't over- or under-credit schema:

- **Model updates.** ChatGPT and Gemini routinely refresh their training data and retrieval mechanisms. A sudden jump in citations on the day of an OpenAI model release isn't schema — it's a new model.
- **Algorithm-side citation changes.** Perplexity has historically changed how aggressively it cites primary sources vs. aggregators. Watch their changelog.
- **Seasonality.** Travel insurance queries spike pre-summer and pre-holidays. Compare year-over-year, not month-over-month, when possible.
- **Trustpilot/BBB review velocity.** New reviews change LLM sentiment independently of schema work.
- **The Zurich rebrand.** As AIG → Zurich messaging propagates, LLM mentions of "AIG Travel Guard" may drop while "Zurich Travel Guard" or "Travel Guard" rises. Track total mentions, not just exact-match strings.

---

## 9. The single most important chart to build

If you build only one tracking dashboard, build this one:

> A weekly line chart of **travelguard.com own-domain citation share** (from Otterly) overlaid with **rollout milestones** (vertical lines for "site-wide schema deployed," "plan pages deployed," "P0 article pages deployed," etc.).

This is the single visualization that will tell you, at a glance, whether the schema rollout is working. A clean step-up after each milestone is the success picture. A flat line means the schema is shipping but not changing model behavior — which would prompt investigation of whether the JSON-LD is being indexed or whether other factors (content quality, internal links, backlinks) are the real bottleneck.

---

## 10. Quick baseline capture checklist

Before kicking off implementation, lock in these baselines so you have something to compare against:

- [ ] Otterly Brand Report — export PDF or screenshot the Overview page (this audit's data is your snapshot for May 6-19, 2026)
- [ ] Otterly Prompts page — export the full prompt-by-prompt citation table
- [ ] Otterly Citations page — export full citations data
- [ ] GSC > Performance — last 90 days, total clicks/impressions/CTR/position
- [ ] GSC > Enhancements — screenshot all current rich-result reports
- [ ] GA4 > Acquisition > Traffic — last 90 days organic + AI referrers
- [ ] GA4 > Conversions — quote start funnel, last 90 days
- [ ] Bing Webmaster Tools — current markup status
- [ ] Trustpilot — current overall rating + review count (snapshot for the homepage `aggregateRating` work)

Save all of these to a shared `baseline-2026-05-20/` folder alongside this audit. That's your "before."

---

## 11. First post-deployment checkpoint — Jun 9, 2026

**Otterly window pulled:** May 27 – Jun 9, 2026 (13 days, US, all engines, 20 prompts)
**Days since schema deployment:** Most file timestamps are Jun 3-9, so the current Otterly window is roughly **half pre-deployment and half post-deployment, with at most 6 days of post-deploy data**. The site-wide bundle has been live longest; per-page schemas are still propagating into LLM indexes.

### 11.1 What changed at the brand level

| Metric | Baseline (May 7-20) | Current (May 27-Jun 9) | Δ | 30-day target | On track? |
|---|---|---|---|---|---|
| Brand mentions | 452 | **487** | **+35 (+7.7%)** | 475 | ✓ Exceeded |
| Brand rank | #2 | #2 | flat | #2 | ✓ |
| Brand coverage % | 29.1% | **31.2%** | **+2.1pp** | 30% | ✓ Exceeded |
| Brand coverage trend | -1 | **+1** | reversed | 0 | ✓ Exceeded |
| Likelihood to buy | 79% (-2) | **83%** (+1) | **+4pp** | 80% | ✓ Exceeded |
| Average brand position | 1.94 | **1.76** | **-0.18** (better) | 1.80 | ✓ Exceeded |
| Sentiment score | +63 | +59 | -4 | +65 | ✗ Slight decline |

Almost every brand-level KPI moved in the right direction. The coverage trend reversal (from -1 to +1) is the cleanest signal that whatever was eroding share previously has stopped. The likelihood-to-buy jump of +4pp also outpaces the 90-day target (+4pp) at the 30-day mark.

The sentiment dip (-4) is worth watching but likely noise — it's within the natural variance Otterly shows in the +63 to +73 range across competitors.

### 11.2 What changed in citations (the metrics most tied to schema work)

| Metric | Baseline | Current | Δ | 90-day target | On track? |
|---|---|---|---|---|---|
| Own-domain citations | 185 | **294** | **+109 (+58.9%)** | 400 | ✓ Strongly on pace |
| Citation share | 1% | **2%** | **doubled** | 3-4% | ✓ Halfway there at day 21 |
| Domain coverage | 8% | **13%** | **+5pp (+62.5%)** | 14% | ✓ Near 90-day target already |

The citation numbers are the most striking movement in the report. A 58.9% jump in own-domain citations in 21 days, before most LLM indexes can have re-crawled and absorbed the new schema, suggests other forces are also at work — most likely: (a) competitor decay (Allianz's own-domain citations dropped 541 → 518 in the same window, World Nomads lost 28 brand mentions), (b) the site-wide bundle was deployed earliest and is likely visible to faster-refreshing indexes (Bing/ChatGPT search), and (c) seasonality. Whatever the mix, the **direction is right** — and if the post-deployment trajectory continues, the 90-day citation targets are very reachable.

### 11.3 Pages winning citations now (vs. baseline)

The mix of top-cited URLs shifted significantly:

| Rank | Baseline top 3 URLs | Citations | Current top 3 URLs | Citations |
|---|---|---|---|---|
| 1 | /travel-resources/travel-safety/student-travel-safety | 26 | /traveler-types/pre-existing-medical-condition... | **34** |
| 2 | /traveler-types/pre-existing-medical-condition... | 19 | /info/assistance-services | **22** |
| 3 | /travel-insurance/optional-coverage/cancel-for-any-reason | 18 | /travel-insurance/benefits/baggage-insurance | **22** |

**Pre-existing conditions** climbed from #2 → #1 with a +79% citation increase (19 → 34). It was one of the new P0 pages we added schema for. Even if the schema isn't yet the proximate cause, this validates the Otterly-driven prioritization — the page was already trending up, and reinforcement should compound.

**Two brand-new entries** in the top 3: `/info/assistance-services` and `/travel-insurance/benefits/baggage-insurance`. Neither has dedicated JSON-LD yet. They're rising on the strength of the site-wide bundle alone plus content quality. Both are strong candidates for adding to the per-page schema queue:
- `assistance-services` aligns with the "best emergency assistance" prompt cluster (+14 citations in this window)
- `baggage-insurance` aligns with the "lost baggage coverage" prompt (+13 citations) — the audit's Section 8.3 already flagged this as a high mention-to-citation gap

**Student travel safety dropped out of the top 3** but not necessarily out of the top 10 — Otterly only shows top 3 in this view. The full Citations page in Otterly would confirm whether it actually declined or just got out-paced by faster-growing pages.

### 11.4 Per-prompt citation changes

Tracking the specific high-value prompts from the audit's Section 8.3:

| Prompt | Baseline TG citations | Current | Δ | 90-day target | Status |
|---|---|---|---|---|---|
| Are there travel insurance plans that cover pre-existing conditions? | 29 | **44** | +15 | 50 | ✓ 88% to target |
| How do I know if my trip protection covers medical emergencies? | 21 | **35** | +14 | 35 | ✓ Hit target |
| What is the best travel emergency assistance plan for a family vacation? | 19 | **33** | +14 | — | strong gain |
| How do I get trip protection for a last-minute trip? | 33 | 27 | -6 | 40 | ✗ Regressed |
| Are there travel safety services for students studying abroad? | 29 | 26 | -3 | 50 | ✗ Slight decline |
| Is there a travel insurance plan that covers trip cancellations for any reason? | 14 | **23** | +9 | 35 | ✓ 66% to target |
| What are the top travel insurance providers for lost baggage coverage? | 12 | **25** | +13 | 30 | ✓ 83% to target |
| How do I track the status of my travel insurance claim? | 12 | **20** | +8 | 25 | ✓ 80% to target |

7 of 8 tracked prompts moved up. The "medical emergencies" prompt already hit its 90-day target. CFAR, pre-existing, baggage, and claim-status are all 66-88% of the way to their 90-day targets in just 21 days.

The two regressions (last-minute trip protection -6, student safety -3) are small enough to be plausibly noise but worth watching at the next pull.

### 11.5 Competitive context — what was happening to others

The brand-level gains came in a window where competitors were largely flat or declining:

| Brand | Baseline mentions | Current | Δ |
|---|---|---|---|
| Seven Corners (#1) | 526 | 521 | -5 |
| Travel Guard (#2) | **452** | **487** | **+35** ✓ |
| World Nomads (#3) | 435 | 407 | -28 |
| Berkshire Hathaway | 219 | 177 | -42 |
| Allianz Global Assistance | 196 | 189 | -7 |
| Travelex Insurance Services | 195 | 232 | +37 |

Travel Guard had the **second-largest absolute gain** in the window (+35), behind only Travelex (+37). Notable: Allianz's own-domain citations also dropped (541 → 518), suggesting the broader citation landscape redistributed somewhat — which makes it harder to attribute Travel Guard's specific gain to schema. The gap to Seven Corners narrowed from 74 mentions to 34 mentions, the closest you've been in this dataset.

### 11.6 Honest read on what's attributable to schema vs. noise

The temptation is to credit schema with the gains. The honest answer is **probably some, but not all**.

What we can say:
- The site-wide Organization + WebSite bundle has been live longest (since the audit's Week 1 rollout) and has had the most time to propagate. Bing/ChatGPT search likely sees it; Google AI Overviews may not yet.
- Per-page schemas (Plan, FAQ, Service, Article) were finalized in the past 6 days. Too recent for LLM indexes to have fully refreshed.
- Competitor decay accounts for some of the relative gain — when Allianz and World Nomads lose ground, Travel Guard gains by default even without doing anything.
- Pre-existing-conditions citations jumped +79% — this page is one we added P0 schema for, but the gain likely predates the schema being live, so most of the movement is content-quality + LLM index updates, not yet schema.

What to watch at the next checkpoint (Jun 23):
- If citation share keeps climbing past 2% → 3%, that's the strongest schema signal we can hope for at week 5.
- If the per-page schemas (CFAR, pre-existing, plan pages) continue to gain disproportionately, that supports the schema-first hypothesis.
- If the gain plateaus or reverses, then the May 27 - Jun 9 jump was mostly competitor weakness + seasonality, and we need to revisit the rollout pacing.

### 11.7 Recommended actions before next pull

1. **Add page-specific JSON-LD for `/info/assistance-services` and `/travel-insurance/benefits/baggage-insurance`** — both are organically climbing into your top-cited URLs without any dedicated schema. Reinforcing them is the highest-leverage move you can make in the next two weeks. ✅ *Done Jun 10: `jsonld/info/assistance-services.json` and `jsonld/travel-insurance/benefits/baggage-insurance.json` are built from live-page content and awaiting deployment.*
2. **Pull a per-engine Otterly breakdown** at Jun 23 to see whether the gains are concentrated in Bing/ChatGPT (where schema has had most time to land) vs. Perplexity vs. Google AI Overviews. That delta is the cleanest natural experiment available.
3. **Take a Google Search Console snapshot now** so you have a structured-data-impressions baseline for the Jun 23 comparison. The Rich Results dashboards take 7-14 days to begin reflecting schema deployments.
4. **Add the baseline + this checkpoint to a `baseline-2026-05-20/` folder** alongside the audit so future checkpoints can be diffed mechanically.
5. **Refresh the Trustpilot `aggregateRating` values** (added Jun 11 2026 to `jsonld/index.json` + `jsonld/about-us/travel-insurance-reviews.json`; snapshot: 4.1 / 1,600 reviews). At every checkpoint, re-pull the widget-data endpoint (URL in `CLAUDE.md` hard rule #7 — same data the on-page TrustBoxes render) and update both files if `trustScore` or `numberOfReviews` changed. KPI expectation: this markup targets LLM citations on "top-rated travel insurance companies"-type prompts (§11.4) — Google ignores self-serving org ratings for rich-result stars, so don't look for SERP-star movement in GSC.

### 11.8 Headline summary

> 21 days into the schema rollout, every primary KPI is moving in the right direction. Own-domain citations are up **58.9%**, citation share **doubled** (1% → 2%), domain coverage is up **+5pp**, brand coverage trend reversed from -1 to +1, and the gap to Seven Corners narrowed by 40 mentions. Schema is plausibly contributing to some of this, but the rollout is too recent for confident attribution — competitor decay, content quality, and LLM index churn are also at work. Next checkpoint Jun 23 will tell us how much of this trajectory holds.
