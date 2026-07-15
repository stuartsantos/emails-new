# Bringing US United under the shared ROW template

**Status:** Proposal — for review by the US United team. No template HTML is changed by this
document; the actual ROW edit is a follow-up once United signs off.

**Files compared:**
- `united/us/en/policy-confirmation.html` — legacy, unstyled plain HTML (United today)
- `row/us/en/policy-confirmation.html` — modern, responsive, dark-mode template (built for LHGROUP)

## Why

The two emails already share ~90% of their copy. The ROW US template is the modern
Travel Guard / Zurich build: responsive (620px wrapper, mobile breakpoint), dark-mode aware
(`prefers-color-scheme` + Gmail `[data-ogsc]`), Outlook-safe (VML/MSO), accessible
(`role="presentation"`, `alt` text), and covered by the repo's `batch-qa` tooling. United's file
is none of these — it is bare `<p>` tags with no styling, no responsive layout, and no dark mode.

Rather than maintain a separate United template, we propose United adopt the ROW template as its
base. The overlapping content is shared verbatim; the **three United-only paragraphs** and the
partner-specific tracking/contact details are injected with **Handlebars** — so nothing United
needs today is lost, and United automatically inherits every future fix made across the 24-market
ROW family.

## Section-by-section diff

### Shared content — ROW is already the source of truth

These sections exist in both emails. The ROW wording is equivalent (or cleaner) and needs no
change. Where United hardcodes a value, ROW already externalizes it into a variable, so the
partner-specific value flows through the variable at send time.

| Section | ROW US (shared template) | United today | Integration |
|---|---|---|---|
| Greeting | `Hello {{policyDetail-primaryInsured-firstName}} {{policyDetail-primaryInsured-lastName}},` | `{{policyDetail-primaryInsured}},` (combined field, no "Hello") | Use ROW greeting — no change |
| Thank-you line | "Thank you for purchasing a travel insurance plan from Travel Guard." | "Thank you for purchasing a Travel Guard® travel insurance plan." | Use ROW wording — equivalent |
| Policy number | `Your Policy Number is {{policyDetail-policyNumber}}.` | `Your policy number is: {{policyDetail-policyNumber}}` | Shared — identical variable |
| View Policy of Insurance link | `{{ViewPolicyURL}}` (variable) | hardcoded `policy.travelguard.com/aig-travel/us/en/?cmpid=emc-united-us-en-fulfillment-policyconfirmation` | Variable already handles it — United's URL (with cmpid) is injected into `{{ViewPolicyURL}}` |
| Claims online link | hardcoded `https://claims.travelguard.com` | `https://claims.travelguard.com/?cmpid=emc-united-us-en-fulfillment-policyconfirmation` | Convert ROW to `{{ClaimsURL}}` (or append `?cmpid=emc-{{partnerCode}}-…`) so tracking is partner-driven |
| Sign-off | "Enjoy your travel and thank you for choosing Travel Guard for your upcoming trip!" | "Enjoy your travel and thank you for choosing Travel Guard travel insurance for your upcoming trip!" | Use ROW wording — equivalent |
| 24-hr World Service Center | `contact our 24-hour World Service Center at: {{CustomerServicesContactNumber}}` | hardcoded `1-877-934-8308` | Variable already handles it — United number injected into `{{CustomerServicesContactNumber}}` |
| Footnote¹ | "Policy information is only accessible via the above link for one year past your travel return date." | identical | Shared — identical |

### United-only content — inject via Handlebars

Not present in the ROW template today. Each becomes an opt-in `{{#if}}` block so United (and any
future partner) can switch it on without affecting LHGROUP or the other 23 markets.

| # | Block | United copy (verbatim intent) | Proposed gate |
|---|---|---|---|
| A | **Refund policy** | "All travel insurance refund requests must be submitted in writing within 15 days of the effective date of the policy, provided it is not past the original departure date and no claim has been initiated. Requests may be emailed to united@travelguard.com or faxed to 715-345-2915." | `{{#if partner.refundPolicy}}` |
| B | **Policy changes** | "All policy changes such as: change in travel dates, change in trip cost, name corrections, mailing address updates, etc., can be made online by clicking here or emailing us at united@travelguard.com. Please do not send credit card information via email, only policy number(s) and requested changes." | `{{#if partner.policyChanges}}` |
| C | **IMPORTANT reservation notice** | "**IMPORTANT:** If you cancel your United Airlines reservation or make any changes to your reservation, you will need to update your travel insurance policy via the self service options above or by contacting Travel Guard directly." | `{{#if partner.reservationNotice}}` |

### ROW-only content

| Block | ROW copy | Proposed gate |
|---|---|---|
| Self-Service / Help Center | "Click here to access our Self-Service page which allows you to view your claim online, modify your policy, view FAQs and more." (`https://www.travelguard.com/help-center`) | `{{#if partner.selfService}}` — United has no equivalent; gate it off for United (block B covers United's self-service needs) |

## Hybrid Handlebars integration model

**Principle:** ROW stays the single source of truth. Shared copy is unconditional. Partner
differences are handled two ways:

1. **`{{#if}}` blocks** for the optional whole paragraphs (A, B, C, and the ROW-only Self-Service).
2. **Variables** for partner-specific data that varies but always renders (URLs, phone, email, fax,
   tracking code).

Per-section boolean flags (rather than one `isUnited`) mean a future airline partner can reuse
block A without inheriting blocks B and C.

### New / reused Handlebars variables

| Variable | New? | Purpose | United value |
|---|---|---|---|
| `partner.refundPolicy` | new (flag) | show refund block A | `true` |
| `partner.policyChanges` | new (flag) | show policy-changes block B | `true` |
| `partner.reservationNotice` | new (flag) | show reservation notice C | `true` |
| `partner.selfService` | new (flag) | show ROW Self-Service block | `false` for United |
| `{{partnerCode}}` | new | cmpid tracking segment | `united` |
| `{{RefundFaxNumber}}` | new | refund fax in block A | `715-345-2915` |
| `{{CustomerServicesEmailAddress}}` | existing ROW var | partner contact email (blocks A, B) | `united@travelguard.com` |
| `{{ClaimsURL}}` | new (replaces hardcode) | partner-tracked claims link | `https://claims.travelguard.com/?cmpid=emc-united-us-en-fulfillment-policyconfirmation` |
| `{{ViewPolicyURL}}` | existing ROW var | partner-tracked portal link | United portal URL + cmpid |
| `{{CustomerServicesContactNumber}}` | existing ROW var | World Service Center phone | `1-877-934-8308` |

cmpid convention (root CLAUDE.md): `emc-{partner}-{market}-{lang}-{category}-{emailname}` →
`emc-{{partnerCode}}-us-en-fulfillment-policyconfirmation`.

### Annotated insertion points in `row/us/en/policy-confirmation.html`

The United-only blocks slot into the existing content column (between the sign-off and the
footnote), each wrapped in the **same `.text` table markup** the ROW template already uses for
every paragraph — so they inherit spacing, dark mode, and responsive behavior automatically.

```handlebars
{{! === existing shared blocks: greeting, World Service Center, sign-off === }}

{{#if partner.refundPolicy}}
<!-- BLOCK A — REFUND POLICY (copy the existing .text <table> wrapper) -->
  All travel insurance refund requests must be submitted in writing within 15 days
  of the effective date of the policy, provided it is not past the original departure
  date and no claim has been initiated. Requests may be emailed to
  <a style="color: #0076be;" href="mailto:{{CustomerServicesEmailAddress}}">{{CustomerServicesEmailAddress}}</a>
  or faxed to {{RefundFaxNumber}}.
{{/if}}

{{#if partner.policyChanges}}
<!-- BLOCK B — POLICY CHANGES -->
  All policy changes such as: change in travel dates, change in trip cost, name
  corrections, mailing address updates, etc., can be made online by
  <a style="color: #0076be;" href="{{ViewPolicyURL}}">clicking here</a> or emailing us at
  <a style="color: #0076be;" href="mailto:{{CustomerServicesEmailAddress}}">{{CustomerServicesEmailAddress}}</a>.
  Please do not send credit card information via email, only policy number(s) and requested changes.
{{/if}}

{{#if partner.reservationNotice}}
<!-- BLOCK C — IMPORTANT RESERVATION NOTICE -->
  <b><i>IMPORTANT:</i></b> <i>If you cancel your United Airlines reservation or make any
  changes to your reservation, you will need to update your travel insurance policy via the
  self service options above or by contacting Travel Guard directly.</i>
{{/if}}

{{#if partner.selfService}}
<!-- ROW-only SELF-SERVICE — gated off for United -->
  <a style="color: #0076be;" href="https://www.travelguard.com/help-center">Click here</a> to
  access our Self-Service page which allows you to view your claim online, modify your policy,
  view FAQs and more.
{{/if}}

{{! === existing shared footnote === }}
```

Anchor colors are pinned to `#0076be` per the root CLAUDE.md **Anchor color pinning** rule (United
today uses `#1352DE`; adopting ROW brings its anchors onto the Travel Guard brand blue).

## What United gains

- One responsive, dark-mode-tested, Outlook-safe template instead of bare `<p>` tags.
- Accessibility (screen-reader tables, `alt` text) and the repo's automated `batch-qa` coverage.
- Brand-consistent Travel Guard / Zurich styling, in lockstep with 24 other ROW markets.
- Every future fix to the shared template lands for United automatically — no divergent maintenance.
- Nothing United-specific is lost: refund policy, policy-changes, and the United Airlines
  reservation notice are all preserved, gated behind partner flags.

## Open questions for United / the delivery team

1. **`{{ViewPolicyURL}}`** — confirm the injected value carries United's cmpid
   (`emc-united-us-en-fulfillment-policyconfirmation`) and the `/aig-travel/us/en/` portal path.
2. **Claims link** — OK to convert the hardcoded `claims.travelguard.com` to `{{ClaimsURL}}`
   (or append `?cmpid=emc-{{partnerCode}}-…`) so United's tracking is preserved?
3. **Fax** — keep `715-345-2915` as `{{RefundFaxNumber}}`, or is fax being retired?
4. **Flag naming** — confirm `partner.refundPolicy` / `partner.policyChanges` /
   `partner.reservationNotice` / `partner.selfService` fit the sending platform's data model
   (vs. a single `partnerCode`-driven switch).
5. **Self-Service block** — confirm United wants it gated **off** (block B covers changes), or
   whether United also wants the help-center link.
