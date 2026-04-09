# Expedia EMEA — Followup Items

First pass complete. All 12 templates built. The items below were kept verbatim per docx or represent intentional deviations that need client confirmation before changing.

## Formatting Notes

**Underlined text → italics:** Underlined text from the Word documents is rendered as italic (`<i>`) in the HTML emails rather than underlined (`<u>`). This is standard email practice: underlined text in an email is universally interpreted as a hyperlink. Using underline on non-link text confuses recipients and can erode trust (it looks like a broken or misleading link). Italics preserve the intended emphasis without that risk.

| # | Template | Item | Notes |
|---|----------|------|-------|
| 1 | NL/nl | Email `expedia@covermoreeurope.com` | Missing `cs.` subdomain — all others use `expedia@cs.covermoreeurope.com` |
| 2 | CH/it | "CHGF 200,000" | Likely typo for "CHF 200,000" |
| 3 | DK/da | Claims URL `https://claims.covermoreeurope.com/expedia` | Docx uses covermoreeurope.com; stub uses `https://claims.travelguard.com/myclaim/dk` |
| 4 | DK/da | "Der er visse undtagelse" | Likely "undtagelser" (plural) |
| 5 | DK/da | Empty bullet in eligibility list | Docx has a blank `- ` list item between age criteria and COVID bullet — omitted from HTML |
| 6 | NO/no | "bosatt i Norge Vennligst les hele forsikringsvilkåret" | Missing period after "Norge" — two sentences appear merged into one bullet |
| 7 | SE/sv | "Ring ossnär som helst" | Missing space — should be "oss når som helst" |
| 8 | SE/sv | "informera ss om eventuella riskförändringar" | Likely "oss" — missing leading "o" |
| 9 | DE/de | "Der Reiseschutzbietet eine Deckung" | Missing space — should be "Der Reiseschutz bietet" |
| 10 | CH/de | «Plus»-Autoschutzplan list — item 1 rendered as bullet | Docx has "1." numbered list for first item, then bullets for items 2–3. Converted all three to `<ul>` bullets since a single-item numbered list makes no sense. Flagged for review. |
| 11 | CH/de | "Versand Ihrer Versicherungsunterlagen per Post" italicized | Docx underlines this phrase — rendered as italic per the underline → italic convention (see Formatting Notes above). |
| 12 | CH/fr | Email `expedia@cs.covermoreeurope.com` — `.com` added | Docx has `expedia@cs.covermoreeurope` (missing `.com`) in Q1 and Q4 contact answers. Fixed to match all other templates. |
| 13 | CH/it | Claims paragraph line break removed | Docx has a paragraph break between the claims URL and "oppure di contattarci…" — merged into one sentence for readability. |
