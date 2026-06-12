# CLAUDE.md — Adobe Customer Journey Analytics (CJA)

Shared guidance for using Claude with Adobe Customer Journey Analytics. Anyone on the team can use this to query and curate CJA data with consistent settings, so reports are comparable across people and sessions.

## Connector Setup

CJA is accessed via the **claude.ai Adobe Customer Journey Analytics** MCP connector (`mcp__claude_ai_Adobe_Customer_Journey_Analytics__*`).

- Authentication is per-user OAuth: run `/mcp` in Claude Code, select **claude.ai Adobe Customer Journey Analytics**, and complete the Adobe sign-in in the browser. Until authenticated, only auth stub tools are exposed.
- If a tool returns a missing-data-view error mid-session, re-run the bootstrap below rather than guessing IDs.

## Session Bootstrap (run in order, every session)

1. Call `describeCja` to load product context.
2. Set the default data view: `setDefaultSessionDataViewId` with the data view ID (see table below). The default persists ~8 hours.
3. Call `describeCja` with `guideType: DATAVIEW_CONTEXT_GUIDE` and the data view ID to load available dimensions/metrics/components.
4. For any relative date phrase ("last 30 days", "this month"), call `getServerDateTime` first and derive ISO 8601 `startDate`/`endDate` from the server clock — never assume today's date.

## Data Views

| Data view | ID | Notes |
|---|---|---|
| **TGUS Dataview (Prod)** | `dv_6887e717e9927cf644bbd0dc` | **Default for TG US work** |
| TGUS Dashboard Dataview (Prod) | `dv_69b834eb77ff6b489f5c9098` | |
| TGUS Direct Cross Platform Dataview (Prod) | `dv_69bab20dc8c295efb85d461d` | |
| AJ Sandbox - TGUS Dataview (Prod) | `dv_68cc2a0c7364da52e2fb6ff6` | AJ's sandbox — don't use for shared reporting |
| TGCA Dataview (Prod) | `dv_692e0603e60010703aaa4041` | |
| TGSG Combined Dataview (Prod) | `dv_692dfa80862fd4055abc22ea` | |
| TGSG Partners Dataview (Prod) | `dv_692f5490862fd4055abc22f1` | |
| TGSG Direct Dataview (Prod) | `dv_6977d7391e921e96a39e16f0` | |
| TG FNOL Global Dataview (Prod) | `dv_692f59126aaac06505a7c4ef` | |
| Qantas Dataview (Prod) | `dv_68a393f0b4b112dc909f0367` | |
| Qantas Cross Application Dataview (Prod) | `dv_696fd5e853bf8a045ebda0a8` | |
| Travel Dataview (Dev) | `dv_684c592511aa88d7fc108453` | Dev only |
| FNOL DEV - Dataview (Dev) | `dv_68daf9ccf2e7d89cd0d253fe` | Dev only |
| Travelex Dataview (Dev) | `dv_6a1df5a145f6d906ca7fa6ae` | Dev only |

### TGUS Dataview (Prod) calendar settings

- Timezone: **US/Central**
- Calendar: Gregorian, weeks start **Sunday**, year starts January

## MANDATORY: Bot / Internal Traffic Filtering

**Every report must filter out internal traffic and bots.** AJ Sosa maintains the standard segments for this and applies them to all team reports. Apply the appropriate segment as a global filter on every `runReport` unless the requester explicitly asks for unfiltered data.

### Primary segment — TGUS

**"TGUS - External US Users"** — `s593B407E5A93DFA90A495D11@AdobeOrg_68b087b96cd2840c3c32622c`

The most-used segment in the TGUS data view. It:

- Excludes known bot/internal domains: googlebot, google.com, observepoint, iijgio, thousandeyes, zenlayer, zscaler, **aig** (internal), amazonaws, praetorian
- Excludes test users (`_aigtravelinc.testUser` = "Digital Test User")
- Excludes bot-scored hits (`botDetection.score` = 1)
- Excludes suspicious Linux traffic (Linux + level3 domain, Linux with no domain, GNU/Linux from iij.net / JP geo)
- Excludes a known fake-traffic anomaly (cox.net domain + Omaha city + Italy destination)
- Includes only US visitors (`placeContext.geo.countryCode` = US)

### Sibling / per-brand filter segments

| Segment | ID | Use for |
|---|---|---|
| TGUS - Bot/Internal Filter | `s593B407E5A93DFA90A495D11@AdobeOrg_6903de5721120249ff7e6538` | Same bot/internal exclusions as above but **without** the US-only geo restriction — use when global traffic is needed |
| Global - Exclude Test Users and Policies | `s593B407E5A93DFA90A495D11@AdobeOrg_687e85a5256c96c3662e1eca` | Cross-brand / global reporting |
| TGSG - Exclude Test Users and Policies | `s593B407E5A93DFA90A495D11@AdobeOrg_68a72a48ce96057b73d5978e` | TGSG data views |
| TGCA - External Global Users | `s593B407E5A93DFA90A495D11@AdobeOrg_69383f1c2b34251b3986ee25` | TGCA data view |
| QFF - Exclude Test Users and Policies | `s593B407E5A93DFA90A495D11@AdobeOrg_68a775eba577847949776528` | Qantas data views |
| Qantas Site Traffic - D2C | `s593B407E5A93DFA90A495D11@AdobeOrg_687e80a8d18a86cb848671b8` | Qantas direct-to-consumer scope |

All segment IDs above are org-wide (IMS org `593B407E5A93DFA90A495D11@AdobeOrg`) and work across data views where the underlying schema fields exist.

## Commonly Used Components (TGUS)

Most-used dimensions and metrics in the TGUS data view — start here when building reports:

| Component | ID |
|---|---|
| Campaign ID (cmpid) | `variables/_aigtravelinc.tracking.cmpid_1` |
| Primary traveler age | `variables/_aigtravelinc.travelerInfo.agePrimaryTraveler` |
| State/province (geo) | `variables/placeContext.geo.stateProvince` |
| Page name | `variables/web.webPageDetails.name` |
| Day / Week / Month | `variables/daterangeday` / `daterangeweek` / `daterangemonth` |
| Sessions | `metrics/visits` |
| People | `metrics/visitors` |
| Events | `metrics/occurrences` |
| Purchase value | `metrics/commerce.purchases.value` |
| Product price total | `metrics/productListItems.priceTotal` |
| Optional coverages (purchase) | `metrics/_aigtravelinc.event.purchase.optionalCoverages_1` |

### Email campaign tracking

Email campaigns in this repo use the `cmpid` URL parameter (`emc-tgdirect-{market}-{lang}-{category}-{emailname}` — see root `CLAUDE.md`). In CJA, filter or break down `variables/_aigtravelinc.tracking.cmpid_1` by the `emc-` prefix to isolate email-driven traffic. There is also a prebuilt segment **"TG - Email Traffic"** (`s593B407E5A93DFA90A495D11@AdobeOrg_68ae1e1093a1cd69d359f0d3`).

## Known Issues (observed 2026-06-12, Claude Code CLI)

- `runReport` succeeds only for basic single-dimension / single-metric requests. Adding `segmentIds`, `adhocSegments`, `breakdowns`, or multiple metrics returns "An unexpected error occurred" — which blocks applying the mandatory bot/internal segment via the CLI connector. `findMetrics` errors as well.
- Workaround until fixed: run a ranked report on the target dimension (single metric per call) and read the row you need — but note the results are **unfiltered** (no bot/internal segment), so label them accordingly.
- For real reporting/visualization work, prefer the claude.ai web interface with the CJA connector (charts + working filters) or CJA Analysis Workspace directly. Use the CLI connector mainly for component discovery (`findSegments`, `findDimensions`, `searchDimensionItems`) and quick unfiltered sanity checks.

## Reporting Conventions

- Dates in `runReport` use ISO 8601: `yyyy-MM-dd'T'HH:mm` (e.g. `2026-06-01T00:00` to `2026-06-30T23:59`).
- In workspace projects, prefer rolling date formulas (e.g. `td-29d/td+1d`) over absolute dates.
- For breakdown reports, read the `BREAKDOWN_GUIDE` via `describeCja` first — breakdowns require a two-step item-ID workflow.
- Before creating new segments or calculated metrics, search existing ones (`findSegments` / `findCalculatedMetrics`) — AJ has already built most of the common ones.
