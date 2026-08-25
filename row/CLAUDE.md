# CLAUDE.md — ROW

ROW = Zurich Travel Guard "Rest of World." This directory holds policy-confirmation templates organized by country and language.

For shared technical patterns (DOCTYPE, meta tags, MSO conditional, Google Fonts loading, dark mode CSS, layout, preheader, font stack, brand colors, gotchas), see the **root `/CLAUDE.md`**. This file covers only ROW-specific content.

## Directory Structure

```
row/
├── _template/
│   ├── row-reference.html          # Canonical structural skeleton (LTR)
│   └── row-reference-rtl.html      # RTL/Arabic variant of the skeleton
└── {country}/
    └── {language}/
        └── policy-confirmation.html
```

**Markets:** ae (UAE), at (Austria), be (Belgium), bh (Bahrain), ca (Canada), ch (Switzerland), cy (Cyprus), cz (Czech Republic), de (Germany), dk (Denmark), es (Spain), fr (France), gb (United Kingdom), gr (Greece), hu (Hungary), ie (Ireland), it (Italy), kw (Kuwait), lb (Lebanon), mt (Malta), nl (Netherlands), no (Norway), nz (New Zealand), om (Oman), pl (Poland), pt (Portugal), qa (Qatar), se (Sweden), sg (Singapore), us (United States), za (South Africa)

**Multi-language countries:** Austria (de/en), Bahrain (en/ar), Belgium (en/fr/nl), Canada (en/fr), Switzerland (de/en/fr), Cyprus (en/el), Denmark (en/da), Greece (en/el), Hungary (en/hu), UAE (en/ar), Kuwait (en/ar), Norway (en/nb), Oman (en/ar), Poland (en/pl), Qatar (en/ar), Sweden (en/sv)

**RTL (Arabic) markets:** ae, bh, kw, om, qa each have an `ar/` template built on `_template/row-reference-rtl.html` — see [RTL templates](#rtl-arabic-templates) below.

## Handlebars Variables

Handlebars tokens in ROW templates come from **two sources**, and the distinction matters when auditing:

**A. MVS content fields** — the authoritative list of tokens the multi-variate sheets (MVS) can populate. **A template may only use a token from this list** (plus the service-provided values in group B). If a token isn't here and isn't a `policyDetail-*` service value, it will render literally / blank — it is a bug. Approved MVS vocabulary (verified against the live MVS, July 2026):

```
# Office / entity
OfficeOfficialEntityNameLabel   Image_OfficeOfficialStamp
Image_AuthorisedSignaturesImage Image_AuthorisedSignaturesImage2
AuthorisedSignaturesNames       AuthorisedSignaturesNames2
OfficeWebsite                   OfficeAddressLine1..5
OfficeAddressPostcode           PostalAddressLine1
OfficeTelephone1  OfficeTelephone2  OfficeFax
DirectorsName  CompanySecretary  CompanyNumber
# Customer services
CustomerServicesContactNumber   CustomerServicesFaxNumber
CustomerServicesEmailAddress    CustomerServicesURL
CustomerServiceOperatingHours   technicalSupportContactNumber
# Claims
ClaimsContactNumber  ClaimsFaxNumber  ClaimsEmailAddress
ClaimsOperatingHours  ClaimsURL  OfflineClaimsFormLink
# Assistance
AssistanceServicesContactNumber AssistanceServicesFaxNumber
AssistanceServicesEmailAddress  AssistanceOperatingHours
# Other contacts
OtherContactNumber2..4  OtherClientEmailAddress
EmailSubjectLine  EmailFromAddress
# Copy blocks
ImportantNotes  ImportantNotes1  ImportantNotes2
ImportantNotes1SecondLanguage  ImportantNotes2SecondLanguage  ImportantNotes3SecondLanguage
AdditionalInformation  AdditionalInformation1  AdditionalInformation2
AdditionalInformation1LocalLanguage  AdditionalInformation2LocalLanguage
Header1  Footer1  Footer1LocalLanguage
FinancialServicesText  Brexit1  Brexit2  GDPR1  GDPR2  CountryExclusions
# Product / geography
ProductNamePlaceHolder  GeographicalTerritoryLabel  GeographicalTerritoryValue
PlaceHolderField1..4
# View-policy block
ViewPolicyURL  AltViewPolicyLinks  ViewPolicyContactDetails
ViewPolicyNavigationLinks  ViewPolicySocialMediaList  ViewPolicySecurityIconList
ViewPolicyCopyright  ViewPolicyDisclaimer
# Links & images
TermsOfUseLink  PrivacyPolicyLink  AboutUsLink
Image_AIGGlobalLogoHeader  Image_AIGGlobalLogoFooter
```

**B. Service-provided values** — injected by back-end services, NOT in the MVS. Currently in use:

```
{{policyDetail-policyNumber}}              # Policy number
{{policyDetail-primaryInsured}}            # Full name (first + last combined)
{{policyDetail-primaryInsured-firstName}}  # Customer first name
{{policyDetail-primaryInsured-lastName}}   # Customer last name
{{policyDetail-address-country}}           # Residency country
{{policyDetail-productName}}               # Product name
{{policyDetail-planDescription}}           # Plan description (it/it only)
```

> **Auditing rule — check every new country/template against list A before shipping.** When adding a new country or template, confirm each `{{token}}` is either in list A (MVS) or a known `policyDetail-*` service value from list B. Any token that is neither is almost certainly a typo or an invented field the MVS can't populate — flag it, don't ship it. Quick scan: `grep -rhoE '\{\{[^}]+\}\}' row --include=*.html | sort -u` then diff against list A + B.

Legacy `{Variable}` (single-brace) placeholders should be converted to the modern `{{...}}` Handlebars form (`pl` was the last holdout, cleared August 2026 — see Template Modernization Status. `mt` briefly held that title until the unregistered `pl` drop was found).

## Logo

- **Travel Guard + Zurich logo:** `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/CM_Travel_Guard_v_RGB.png` (200px width) — default for ROW templates, hardcoded as an `<img>` in `_template/row-reference.html`.
- Several Qatar Airways markets use the **underwriter's own logo** instead — see the table below.

### Tokenized header logo — `{{Image_AIGGlobalLogoHeader}}`

**Status (August 2026): `bh`, `ae` and `kw` — all three contested markets are converted.
Every other market keeps its hardcoded `<img>`, and should.**

Those six files (`en` and `ar` for each of the three) no longer carry a logo `<img>` at all —
the header cell is just the list-A token:

```html
<td style="…padding-bottom: 30px; padding-top: 30px;">
  {{Image_AIGGlobalLogoHeader}}
</td>
```

**Why:** the MEA markets are shared between partners, and the partners disagree about the
logo. The Qatar Airways build wants the local underwriter's logo (GIG, LIVA, Sukoon, …);
**Emirates wants no logo at all** in the same markets. Compare the Partner Reference table
below — Emirates covers `BH`/`AE`/`KW` — bh, ae, kw — three of the nine markets
Qatar Airways delivered. One template per market can't serve both with the logo baked in, so
the whole `<img>` tag moves into the MVS: Qatar Airways' MVS supplies the underwriter
`<img>`, Emirates' supplies an empty value and the header renders bare.

**August 2026 — `SA`, `QA`, `OM` and `LB` were descoped from Emirates.** `qa`, `om` and `lb`
now have Qatar Airways as their only partner, so their hardcoded underwriter logos are
correct as they stand and need no tokenization. That confined the conflict to `bh`, `ae` and
`kw` — all three since converted.

**Consequences when converting a market:**

- The **MVS must now carry the full `<img>` tag**, not just a URL — width, `alt`, and inline
  styles included. The table below becomes the reference for what MVS has to supply; the
  template no longer documents it. A market converted without its MVS entry populated ships
  with **no logo at all**, silently.
- The header `<td>` keeps its `padding-top: 30px; padding-bottom: 30px` when the token is
  empty, so the no-logo variant has a ~60px band of `#F1F6FB` above the split header. That
  reads as extra whitespace rather than a visible break (the body background is the same
  colour), but it is not the same as deleting the row.
- `Image_AIGGlobalLogoHeader` is an approved list-A MVS field (see Handlebars Variables) and
  the AIG in the name is a token identifier, not visible branding — the QA scripts strip
  `{{…}}` before the AIG-branding check, so don't "fix" it.
- **Precedent:** `expedia/us/en/policy-confirmation.html` moved its co-brand header logo into
  the same `{{Image_AIGGlobalLogoHeader}}` token (commit `748ac02`) — different brand, same
  reasoning, and the same requirement that the ESP supply the whole tag including `alt`.

**Nothing further should be converted.** `lb`, `om` and `qa` were descoped from Emirates, so
Qatar Airways is their only partner and the hardcoded underwriter logo **is** the correct
header — tokenizing them would lose a logo nobody asked to lose. The Travel Guard default in
`_template/row-reference.html` / `row-reference-rtl.html` stays hardcoded too: a new non-MEA
market has no partner split to solve. Tracked in
[`_work-items/mea-logo-tokenization.md`](../_work-items/mea-logo-tokenization.md).

> **Qatar Airways' MVS entries for `ae` and `kw` were populated in August 2026** — that
> dependency is closed. The standing rule still holds for any converted market: the MVS
> supplies the whole `<img>`, and one whose entry is empty renders with no logo and no
> error. The URLs in the table below are the reference for what MVS has to carry.

| Market | Underwriter (provisional) | Hosted logo URL | In template today |
|--------|---------------------------|-----------------|-------------------|
| ae | LIVA | `https://policy.travelguard.com/content/dam/site-images-docs/ae/LIVA_UAE_Logo.png` (140px) | **`{{Image_AIGGlobalLogoHeader}}`** |
| bh | GIG Bahrain | `https://www.travelguard.com/content/dam/tg-documents/qatar/gig-logo-bh.png` (180px) | **`{{Image_AIGGlobalLogoHeader}}`** |
| kw | GIG | `https://www.travelguard.com/content/dam/tg-documents/qatar/giga-logo-kt.png` (200px) | **`{{Image_AIGGlobalLogoHeader}}`** |
| lb | GIG | `https://www.travelguard.com/content/dam/tg-documents/qatar/gig-logo-lb.png` (200px) | hardcoded `<img>` |
| om | Sukoon | `https://www.travelguard.com/content/dam/tg-documents/qatar/sukoon-logo.png` (200px) | hardcoded `<img>` |
| qa | Qatar General Insurance | `https://www.travelguard.com/content/dam/tg-documents/qatar/qa-gen-logo.png` (200px) | hardcoded `<img>` |

> The BH/KW/LB/OM/QA logos live in the CDN folder `/content/dam/tg-documents/qatar/`. The local PNG copies under `row/{country}/` are source assets only — templates reference the hosted URLs, not the local files. The underwriter names (and therefore `alt` text) are provisional and need confirmation.

## Rebranding Rules (AIG Travel → Travel Guard)

When converting legacy templates to the modern format:

1. **Logo** → Replace any AIG logo with the Travel Guard + Zurich logo above
2. **Opening thank you line** → Remove "from AIG Travel" entirely
   - Before: `Thank you for choosing a Travel Guard® Insurance Policy from AIG Travel!`
   - After: `Thank you for choosing a Travel Guard® Insurance Policy!`
3. **Emergency contact section** → Change "AIG Travel" to "Travel Guard"
   - Before: `Call AIG Travel any time on {AssistanceServicesContactNumber}`
   - After: `Call Travel Guard any time on {{AssistanceServicesContactNumber}}`
4. **Signature/sign-off** → "AIG Travel" → "Travel Guard"
5. **Email domains** → `@aig.com` → `@zurich.com`

## Template Modernization Status

All ROW policy confirmation templates have been updated to the modern responsive format with Travel Guard branding.

**Modernized in January 2026:**

| Country | Languages | Notes |
|---------|-----------|-------|
| at (Austria) | de, en | |
| be (Belgium) | en, fr, nl | be/nl was created from scratch (file was empty) |
| ch (Switzerland) | de, en, fr | ch/de and ch/fr include cancellation policy section |
| cz (Czech Republic) | cz, en | cz/cz had modern format, only needed rebrand |
| de (Germany) | de, en | |
| es (Spain) | en, es | es/es includes Spain residency disclaimer |
| fr (France) | en, fr | fr/fr includes France residency disclaimer |
| nl (Netherlands) | en, nl | |
| pt (Portugal) | en, pt | Fixed typo "fposso" → "posso" in pt/pt |
| us (United States) | en | US-specific content (World Service Center, claims online link, self-service page). Shared by United + LHGROUP; also holds `post-trip.html` and `pre-trip.html` |

**United-under-ROW consolidation (completed August 2026):** `us/en/policy-confirmation.html` is now shared by **both United and LHGROUP**, the same multi-partner arrangement used across the EMEA markets — MVS substitutes the partner-specific content, so there is no per-partner template. It began as a composite merging United US fulfillment copy (World Service Center, online claims, self-service, cancellation notice) into the ROW structure, per `_work-items/united-under-row.md`; the claims link, self-service link and United footnotes became `{{ClaimsURL}}`, `{{CustomerServicesURL}}` and `{{Footer1}}`, leaving the template partner-neutral. It then replaced the old LHGROUP-only `policy-confirmation.html`.

The `united/us/` directory was retired in the same change: its legacy unstyled `policy-confirmation.html` was deleted, and `post-trip.html` / `pre-trip.html` moved to `row/us/en/`. Only `united/ca/en/` remains outside ROW. Because the `{{#if}}`-flagged hybrid model in the spec proved unnecessary — MVS handles the partner split — the open questions in that doc are moot.

**Already modern (not modified):** ca (en, fr) — note ca/en is a deliberate plain-HTML stub; it (en, it), nz (en), sg (en)

**Modernized subsequently:** ie (en) — expanded CSS formatting, dark mode, full responsive layout; gb (en) — renamed from uk/ (ISO 3166-1 alpha-2)

**Modernized June 2026 (Qatar Airways partner onboarding):**

| Country | Languages | Notes |
|---------|-----------|-------|
| ae (UAE) | en, ar | **LIVA** underwriter logo (not Travel Guard); ar is RTL. **August 2026:** header logo tokenized to `{{Image_AIGGlobalLogoHeader}}` in both languages — see [Logo](#logo) |
| kw (Kuwait) | en, ar | **GIG** underwriter logo (not Travel Guard); ar is RTL. **August 2026:** header logo tokenized to `{{Image_AIGGlobalLogoHeader}}` in both languages — see [Logo](#logo) |
| lb (Lebanon) | en | English only; customer-service + claims are email-only (no phone) |
| no (Norway) | en, nb | 3-bullet Website/Email/Telephone contact block + `{{ClaimsURL}}` claims line |
| om (Oman) | en, ar | ar is RTL |
| qa (Qatar) | en, ar | ar is RTL |
| se (Sweden) | en, sv | 3-bullet contact block; sv retains a market-specific "Viktig information" liability notice |

**Added July 2026 (Qatar Airways, later market):**

| Country | Languages | Notes |
|---------|-----------|-------|
| bh (Bahrain) | en, ar | **GIG Bahrain** underwriter logo (not Travel Guard); ar is RTL and uses the `ترافل جارد` brand rendering (same as ae). **August 2026:** the header logo `<img>` was replaced by `{{Image_AIGGlobalLogoHeader}}` in both languages so the Emirates build of the same market can render logo-free — bh was the first market converted, with `ae` and `kw` following; see [Logo](#logo). |

All Qatar Airways templates have the `{{AltViewPolicyLinks}}` section **removed** (per partner requirement). The same removal was applied to the existing **ch (Switzerland)** templates (de, en, fr) for this partner.

**Added August 2026 (new markets):**

| Country | Languages | Notes |
|---------|-----------|-------|
| cy (Cyprus) | en, el | **Greek is a new ROW language** (`lang="el"`) — no other `el` template exists to diff against, so the Greek copy is carried verbatim from the legacy AEM source and is **pending native-speaker / QA-team review**. Both templates were legacy AIG AEM exports (`aem-Grid` fragments, single-brace variables). The split-header banner originally carried the source's own top heading; it was realigned to the standard ROW thank-you line in the same sweep that added `dk`, so no ROW market deviates any more. Anchor colours were normalised off the skeleton's stale `#1352DE` to the repo-standard `#0076be` when `gr` shipped — the last three holdouts (`_template/row-reference.html` and `us/en/pre-trip.html`/`post-trip.html`) were cleaned up in the same follow-up, so `#1352DE` no longer appears anywhere in `row/`. Partner: **Emirates**. |
| dk (Denmark) | en, da | **Danish is a new ROW language** (`lang="da"`). Both files were legacy AIG AEM exports; copy comes from the DK team's tracked-change Word redlines kept alongside them (`en/denmark-en.docx`, `da/denmark-dk.docx`). Built on the `no`/`se` shape: bulleted Website/Email/Telephone/Opening-hours contact block plus a `{{ClaimsURL}}` "Report your claim via:" claims line. Emergency line follows the redline's "Call **us** any time on" rather than the sibling "Call Travel Guard". Danish cross-checked against `expedia/dk/da` but **pending native-speaker / QA-team review** — the source typo "undtagelserr" is knowingly retained. Partner: **Emirates**. |
| gr (Greece) | en, el | Second `el` market. Both files were legacy AIG AEM exports and arrived with **no** redline, so all copy is carried verbatim from source. The Greek is word-for-word identical to `cy/el` in every section and was lifted from it — the only content difference between the two markets is that **GR assistance is phone-only** (no `{{AssistanceServicesEmailAddress}}`), in both languages. Plain contact pattern: `Please call …` sentence rather than the `no`/`se` bullet block, and no `{{ClaimsURL}}` line. Greek is **pending native-speaker / QA-team review**, same as `cy`. Partner: **Emirates**. |
| hu (Hungary) | en, hu | Underwriter **Colonnade Insurance**; listed as `HG` in the source Emirates partner list (corrected to `HU` in Partner Reference). Both files were legacy AIG AEM exports; copy comes from Colonnade's tracked-change Word redlines kept alongside the templates (`en/hungary-en.docx`, `hu/hungary-hu.docx`). Built on the `no`/`dk` bulleted Website/Email/Telephone/Opening-hours customer-service shape. Both redlines leave the claims section untouched (still the legacy literal `+36 1 801 0801` / `karrendezes@colonnade.hu`), unlike the customer-service section — the 46/52 ROW precedent is `{{ClaimsContactNumber}}`/`{{ClaimsOperatingHours}}`/`{{ClaimsEmailAddress}}` tokens, so claims was converted to match rather than left literal (only `ca/en` and `ca/fr` keep genuinely literal, region-specific claims numbers, and that's documented as a deliberate stub, not the case here). Eligibility reminders are **asymmetric between languages**, matching the existing `cz` precedent: `hu/en` is residency-based, `hu/hu` is purchase-date-based — this split exists in the legacy source itself, not something introduced here. `hu/en`'s emergency line was tokenized to `{{AssistanceServicesContactNumber}}` to match `hu/hu`'s redline, even though `hu/en`'s own redline left the old number hardcoded (untouched by any tracked change) — treated as a reviewer oversight rather than a market-specific choice, since every other ROW market tokenizes this field. Bold text on *Certificate of Insurance (COI)* / *Policy Wording* uses `#003D6E` TG navy, matching `cy`/`gr` — confirmed as a deliberate choice even though plain bold (matching the skeleton) is actually the more common pattern across the 27 markets. Partner: **Emirates**. |
| pl (Poland) | en, pl | **Polish is a new ROW language** (`lang="pl"`). Both files were bare unstyled AIG AEM fragments with single-brace `{Variable}` placeholders — the genuine last holdouts (see the `AltViewPolicyLinks` note below; `mt` was wrongly recorded as last because `pl` was an unregistered, never-committed drop). Copy comes from `poland.doc` — note this is a **legacy OLE2 binary `.doc`, not a `.docx` zip**; extract it with `antiword -m UTF-8.txt row/pl/poland.doc` (`unzip` fails, and the Store-stub `python` on PATH won't run). Unlike the dk/hu/mt redlines it carries **no tracked changes** — it is a clean bilingual spec covering **only the customer-service contact block**, so every other section's copy is carried verbatim from the legacy source per the `gr` precedent, with the rebrand applied. The doc's English column uses descriptive pseudo-tokens (`{{Customer services Website}}`, and Polish `{{Godziny pracy Działu Obsługi Klienta}}`) that would render literally — all mapped onto the real list-A names. The doc also **deletes** the "and quote your policy number" clause in both languages, and rewrites the Polish "by post" sentence into second-person register (`należy` → `chcesz`/`możesz`). Emergency line follows rebranding rule 3 (`Call Travel Guard` / `zadzwonić do Travel Guard`) rather than dk/mt's redline-specific "Call us", since the doc is silent there. No `{{ClaimsURL}}` line (mt precedent). Eligibility reminders are **asymmetric between languages**, matching `cz`/`hu`: `pl/en` is residency-based, `pl/pl` is purchase-date-based — the split is in the legacy source. COI/Policy Wording bold is plain, not navy (mt precedent). Polish is **pending native-speaker / QA-team review**; the source typo `obowiązują pewnie wyjątki` (should be `pewne`) is knowingly retained, same as dk's "undtagelserr". Partner: **Emirates**. |
| mt (Malta) | en | English only. Was a bare unstyled AIG AEM fragment (no `&lt;!DOCTYPE&gt;`/`&lt;head&gt;`/`&lt;body&gt;`, single-brace `{Variable}` placeholders) — the last market on this list still in that state. Copy comes from a tracked-change Word redline kept alongside the template (`en/malta.docx`). Structurally a hybrid: `dk`-style bulleted Website/Email/Telephone/Opening-hours customer-service block **and** `dk`'s "Call us any time on..." emergency-line wording, but `hu`-style claims section (redline leaves `+356 21 238 500` / `info@montaldoinsurance.com` literal, converted to `{{ClaimsContactNumber}}`/`{{ClaimsOperatingHours}}`/`{{ClaimsEmailAddress}}` per the same precedent as `hu`, and unlike `dk` there is no redlined "Report your claim via: `{{ClaimsURL}}`" line so that addition was not carried over). Bold text on *Certificate of Insurance (COI)* / *Policy Wording* is plain (skeleton default), not navy — unlike `hu`/`cy`/`gr`. Partner: **Emirates**. |
| za (South Africa) | en | English only. Was a bare unstyled AIG AEM fragment (single-brace `{Variable}` placeholders, no `&lt;!DOCTYPE&gt;`/`&lt;head&gt;`/`&lt;body&gt;`) and arrived with **no** redline, so all copy is carried verbatim from source with only the rebrand applied — the `gr` precedent. Keeps the source's plain `Please call …` contact sentence rather than the bulleted block (see [Contact-block convention](#contact-block-convention-opening-hours-sit-outside-the-bullet-list)), and its trailing "and quote your policy number" clause, which `pl` dropped only because its doc said to. Bold text on *Certificate of Insurance (COI)* / *Policy Wording* is `#003D6E` TG navy, matching `cy`/`gr`/`hu` — the source colours both terms, so the colour is preserved rather than flattened to `mt`/`pl`'s plain bold. Eligibility reads `residents of {{policyDetail-address-country}}` with **no** definite article, as the source has it (the skeleton's "the" would give "residents of the South Africa"). Assistance email stays inline in the emergency sentence rather than the skeleton's separate "You can also email" line. Retains the source's **"IMPORTANT Contact Information"** heading as a group label above the three contact sections — rendered in the borderless navy variant `it/it` uses, so it reads a level above them rather than as a fourth sibling heading; no other ROW market has this heading. Dropped from the source: its 24px "Travel Insurance" top heading (the split-header banner carries the thank-you, per the `cy` precedent), the single-brace `AltViewPolicyLinks`, and the AEM artifacts — a junk `&lt;title&gt;`, a 9000px off-screen div, and a hidden `{ErrorMsg}` input, which is in neither the MVS list nor the service values and would have rendered literally. Partner: **Emirates**; no Qatar Airways overlap, so the header keeps the standard hardcoded Travel Guard logo and the MEA logo tokenization does not apply. |

**LHGROUP claims/contact update (July 2026):** `at (de, en)`, `fr (en, fr)`, `gb (en)`, and `nl (en, nl)` had `{{AltViewPolicyLinks}}` removed and a `{{ClaimsURL}}` (and, for gb, `{{CustomerServicesURL}}`) line added to the claims/customer-service contact copy, matching the pattern already applied to Expedia AT/DE and BE/NL. `it (it)` and `se (en, sv)` received the equivalent `{{ClaimsURL}}`/`{{CustomerServicesURL}}` copy addition without an existing `{{AltViewPolicyLinks}}` block to remove.

**`AltViewPolicyLinks` fully retired (August 2026):** the last 9 templates carrying the section — `be (en, fr)`, `cz (cs, en)`, `es (en, es)`, `ie (en)`, `pt (en, pt)` — had it removed. Two stragglers survived undetected, though — the then-unregistered **`gr` (Greece)** templates, which still carried the legacy single-brace `{AltViewPolicyLinks}` and so never matched a `{{...}}` search. They were cleared when `gr` was modernized later that month. **The same trap then caught `pl`** — the unregistered Poland drop carried single-brace `{AltViewPolicyLinks}` in both `pl/en` and `pl/pl` and likewise never matched a `{{...}}` search, so the "used by no ROW template" claim was false a second time until `pl` was modernized. If a market is not yet in the Markets list above, a `{{...}}` grep will not see it — search for the single-brace form too before declaring a token retired. The `cy` and `dk` markets added the same month never carried it. Both `_template/` skeletons record it as RETIRED; do not reintroduce it when building a new market. The removal takes out the whole wrapping `<table>`, not just the token, so no empty cell or stray 25px padding is left behind. `ie/en` and the two skeletons keep a `SECTION 10 … RETIRED` comment (with the handlebars braces stripped — Handlebars substitutes inside HTML comments) so the 9 → 11 section numbering stays readable.

> Known gap: `be/nl` has neither the retired section nor the `{{ClaimsURL}}` claims line that the other LHGROUP markets received in July 2026.

### RTL (Arabic) templates

Arabic templates (`ae/ar`, `bh/ar`, `kw/ar`, `om/ar`, `qa/ar`) are built on `_template/row-reference-rtl.html`. RTL-specific conventions:

- `<html lang="ar" dir="rtl">` + `dir="rtl"` / `direction: rtl` on the body and content containers; body text cells use `text-align: right`.
- Font: **Noto Sans Arabic** loaded first, Latin Noto Sans as fallback — stack `'Noto Sans Arabic', 'Noto Sans', 'Source Sans Pro', Arial, sans-serif`.
- **Split header is mirrored** — navy thank-you banner on the right, photo on the left (banner `<td>` ordered first under `dir=rtl`).
- Bullet lists use `padding-right` (not `padding-left`).
- **Bidi isolation:** wrap LTR data (phone numbers, emails, policy numbers, URLs) in `<span dir="ltr">` so digits/punctuation don't reorder inside Arabic text.
- Brand name uses each market's **base-content Arabic rendering** (not Latinised): `حراس السفر` for kw/om/qa, `ترافل جارد` for ae and bh. The legacy AIG company reference (`أيه آي جي`) in the assistance line was de-branded to that market's brand term. **Arabic copy is pending native-speaker / QA-team review.**

## Contact-block convention: opening hours sit OUTSIDE the bullet list

Markets using the bulleted customer-service block put **Website / Email / Telephone** in the `<ul>`, then close the list and render opening hours as its own line:

```html
  <li>Telephone: {{CustomerServicesContactNumber}}</li>
</ul>
Opening hours: {{CustomerServiceOperatingHours}}<br>
<br>
If you would like to receive your policy documentation by post, …
```

This is the shape in **36 of 36** bulleted templates (at, be, ch, cy, de, dk, es, fr, gb, gr, hu, ie, it, mt, nl, no, pl, pt, se — both languages each, except the en-only gb, ie, mt and the three-language ch; `es/es` reads `Abierto {{…}}` with no colon). The label localizes (`Öffnungszeiten:`, `Åbningstider:`, `Nyitvatartás:`, `Godziny otwarcia:`, `Heures d'ouverture:`, `Ώρες λειτουργίας:`, …); the structure does not.

`dk (en, da)`, `hu (en, hu)` and `mt (en)` briefly deviated by making opening hours a 4th `<li>` — those five were normalized in August 2026 when `pl` arrived and its source doc confirmed the outside-the-list form. **Do not reintroduce the 4th-bullet variant.** Markets using the plain `Please call …` sentence instead of a bullet block (nz, cz, ae/bh/kw/om/qa, be/nl, sg, za) are a separate pattern and are unaffected. `gr (en, el)` and `cy (en, el)` moved off that plain sentence onto this bulleted block in August 2026.

> `za` joined the plain-sentence group in August 2026 because that is what its legacy source
> carries and it shipped with no redline to direct otherwise. Worth a second look if new
> Emirates markets are meant to standardise on the bulleted block — `gr` and `cy` were moved
> onto it the same month, so the plain-sentence group is no longer purely legacy.

## Content variations by language

- **Belgian French (be/fr)** uses different terminology than France French (fr/fr): "Attestation d'Assurance" vs "Certificat d'assurance", "Termes de Votre Police" vs "Conditions Générales"
- **Swiss French (ch/fr)** and **Swiss German (ch/de)** include an additional "policy cancellation" section not in other templates
- **Czech (cz/cz)** eligibility section focuses on purchase date requirements rather than residency
- **Singapore (sg/en)** is light-mode-only — `color-scheme: light` instead of `light dark`, no dark-mode classes; greeting uses "Dear {firstName}," (no lastName); includes MFA eRegister notice and legal/regulatory footer

## Partner Reference

Markets covered per partner:

| Partner | Markets |
|---------|---------|
| LHGROUP | AT, BE, CH, DE, ES, FR, IT, NL, PT, UK, **US** |
| United | BE, CH, DE, ES, FR, IE, IT, PT, **US** |
| Emirates | AE, AT, BE, BH, CA, CH, CY, CZ, DE, DK, ES, FR, GR, HU, IE, IT, KW, MT, NL, NO, NZ, PL, PT, SE, SG, UK, ZA |
| Qatar (planning set) | AE, AT, BE, CZ, DE, ES, FR, IT, KW, LB, NL, NO, OM, QA, SE, UK |
| **Qatar Airways** (delivered, Jun–Jul 2026) | ae, bh, ch, kw, lb, no, om, qa, se |

> **August 2026 — `SA`, `QA`, `OM` and `LB` are descoped from Emirates**, and have been
> removed from the Emirates row above (31 markets → 27). `QA`, `OM` and `LB` stay in scope
> for Qatar Airways, which is now the only partner in those three markets — which is why
> they drop out of the header-logo conflict below. `SA` (Saudi Arabia) is out of scope
> entirely; there was never a ROW folder for it.

> **Codes in the Emirates/Qatar rows above have been corrected to ISO 3166-1 alpha-2.** The
> source partner lists used codes that are not valid ISO for the country meant. Corrected
> here — if you are diffing against the partner's original list, expect these six to differ:
>
> | Source code | Country | Corrected to | Why the source code is wrong |
> |---|---|---|---|
> | `UE` | UAE | **`AE`** | transposed |
> | `QT` | Qatar | **`QA`** | not ISO |
> | `KT` | Kuwait | **`KW`** | not ISO |
> | `BA` | Bahrain | **`BH`** | `BA` is ISO for Bosnia & Herzegovina |
> | `HG` | Hungary | **`HU`** | not ISO |
> | `SZ` | Switzerland | **`CH`** | `SZ` is ISO for Eswatini |
>
> **`UK` is left as `UK` on purpose** — it stays readable to people, and this table is a
> human reference, not a machine input. Everything technical uses **`GB`**: the folder is
> `row/gb/` (renamed from `uk/` for that reason), as are template paths, `cmpid` values and
> any backend identifier. Don't "fix" `UK` here, and don't let it leak into a path.
>
> `SA` used to sit in the Emirates row and was carried as-is rather than "corrected" to
> `ZA` — `ZA` (South Africa) appeared separately in the same list, so `SA` read as genuinely
> Saudi Arabia. It was descoped in August 2026 and no longer appears above.
>
> CDN asset filenames were minted under the old codes and keep them — Kuwait's logo is still
> `giga-logo-kt.png`; Bahrain (added July 2026) uses `gig-logo-bh.png`. Don't rename the
> assets to match.

> **The Emirates and Qatar Airways market sets overlap, and they disagree about the header logo.** After the August 2026 descope, Emirates covers `BH`/`AE`/`KW` — bh, ae, kw — three of the nine markets Qatar Airways was delivered for, but Emirates wants **no logo** where Qatar Airways wants the underwriter's. There is one template per market, so the logo was moved into `{{Image_AIGGlobalLogoHeader}}` for MVS to fill per partner. **All three are now converted** — see [Logo](#logo) before touching a header in any MEA market. `qa`, `om` and `lb` are no longer contested and keep their hardcoded underwriter logos.

Live deployed template URLs (per language):

| Lang | URL |
|------|-----|
| EN | https://documents.travelguard.com/content/templates/row/gb/en/policy-confirmation.html |
| IT | https://documents.travelguard.com/content/templates/row/it/it/policy-confirmation.html |
| FR | https://documents.travelguard.com/content/templates/row/fr/fr/policy-confirmation.html |
| PT | https://documents.travelguard.com/content/templates/row/pt/pt/policy-confirmation.html |
| DE | https://documents.travelguard.com/content/templates/row/de/de/policy-confirmation.html |
| NL | https://documents.travelguard.com/content/templates/row/nl/nl/policy-confirmation.html |
| CS | https://documents.travelguard.com/content/templates/row/cz/cs/policy-confirmation.html |
