# Work Items

## Bugs

| ID | Title | Link |
|----|-------|------|
| 660998 | [Jetstar] [UAT] Feature 561171 JST NZ – Displaying PDS instead of COI [Zurich Policies] | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/660998) |

## Qantas Bugs (ITD 561169 / 561170)

| ID | Title | State | Link |
|----|-------|-------|------|
| 661912 | [Qantas] [UAT] ITD 561169 - Qantas AU: Medical Screening Email Content Not Updated | 1 - New | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/661912) |
| 661858 | [Qantas] [UAT] Qantas AU - ITD 561169: Quote Email Content Not Updated | 1 - New | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/661858) |
| 661863 | [Qantas] [UAT] Qantas - ITD 561169 - AU: Sales Confirmation Email Missing changes on "Help with your policy" (Footer note) | 1 - New | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/661863) |
| 661860 | [Qantas] [UAT] Qantas - ITD 561169 - AU: Sales Confirmation Email No changes on "Help with your policy" (Online wordings) | 1 - New | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/661860) |
| 661847 | [Qantas] [UAT] Qantas - ITD 561169 - AU: Sales Confirmation Email footer displayed "Zurich Australian Insurance Limited" Instead of "ZAIL" | 1 - New | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/661847) |
| 661837 | [Qantas] [UAT] Qantas - ITD 561170 - NZ: Confirmation Email - Alert Banner Not Updated | 1 - New | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/661837) |
| 661877 | [Qantas] [UAT] Qantas - ITD 561170 - NZ: Confirmation Email - Body/Content Not Updated | 1 - New | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/661877) |
| 661432 | [Qantas] [UAT] Qantas - ITD 561170 - NZ: Confirmation Email - Footer Section Not Updated | 6 - In DEV | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/661432) |

### Bug Details

---

**661912** — [Qantas] [UAT] ITD 561169 - Qantas AU: Medical Screening Email Content Not Updated
- **Description:** Incorrect details are shown in the content/body and footer of the Medical Screening Email. Red boxes indicate incorrect/incomplete text; green highlights show correct text.
- **Steps:** Navigate to UAT Standalone (qantas.uat.travelguard.com) → enter trip details → QFF login (1979970652/Loytest/1717) → select policy → proceed through Optionals → Review & Check Out → start Medical Assessment under "Existing Medical Conditions" → complete payment → check Medical Screening Email.
- **Latest comment (Neliza Mendoza):** CC: @Ballam Sai Deepthi Deepthi @Amnah Afzal @Angela He

---

**661858** — [Qantas] [UAT] Qantas AU - ITD 561169: Quote Email Content Not Updated
- **Description:** Incorrect details are shown in the content/body and footer of the Quote Email (MOR/PTS).
- **Steps:** Navigate to UAT Standalone → enter trip details → QFF login → select policy → select "Use Cash/Use Points" → click Email Quote → open received email.
- **Latest comment (Ballam Sai Deepthi Deepthi):** @Stuart Santos @Ping-Hao Lu Could you please help check this. Thanks..

---

**661863** — [Qantas] [UAT] Qantas - ITD 561169 - AU: Sales Confirmation Email Missing changes on "Help with your policy" (Footer note)
- **Description:** Confirmation Email missing footer note in "Help with your policy" section. Expected: "Note: If your travel dates change at all (including if your flight/s get rescheduled), please check that the Policy Start and End Dates above still match your travel plans. If they don't, please call or email us before your trip." Policy Number: 836086866.
- **Steps:** Open THS → purchase Integrated AU policy via lite.uat.travelguard.com/sml/amadeus → use attached purchase request (replace email) → click Send.
- **Latest comment (Ballam Sai Deepthi Deepthi):** @Stuart Santos Could you please help check this. Thanks..

---

**661860** — [Qantas] [UAT] Qantas - ITD 561169 - AU: Sales Confirmation Email No changes on "Help with your policy" (Online wordings)
- **Description:** AU Confirmation Email has no changes in "Help with your policy" section for Online Wordings. Expected: "Visit the Qantas Insurance website and log in to the policy Portal." Actual: "Log in to our policy portal". Policy Number: 836086866.
- **Steps:** Open THS → purchase Integrated AU policy via lite.uat.travelguard.com/sml/amadeus → use attached purchase request (replace email) → click Send.
- **Latest comment (Ballam Sai Deepthi Deepthi):** @Stuart Santos Could you please help check this. Thanks..

---

**661847** — [Qantas] [UAT] Qantas - ITD 561169 - AU: Sales Confirmation Email footer displayed "Zurich Australian Insurance Limited" Instead of "ZAIL"
- **Description:** Confirmation Email Footer is displaying the full "Zurich Australian Insurance Limited" instead of the abbreviation "ZAIL". Policy Number: 836086866.
- **Steps:** Open THS → purchase Integrated AU policy via lite.uat.travelguard.com/sml/amadeus → use attached purchase request (replace email) → click Send.
- **Latest comment (Ballam Sai Deepthi Deepthi):** @Stuart Santos Could you please help check this. Thanks..

---

**661837** — [Qantas] [UAT] Qantas - ITD 561170 - NZ: Confirmation Email - Alert Banner Not Updated
- **Description:** For NZ policies, the confirmation email's alert banner is not updated based on the BRD.
- **Steps:** Open THS → purchase Integrated NZ policy via lite.uat.travelguard.com/sml/amadeus → use attached quote request (sell 1 and 2; replace email) → click Send → open Sales Confirmation email.
- **Latest comment (Ping-Hao Lu):** Fulfilment emails were authored by @Stuart Santos, not by @Angela He - assigning to Stuart.

---

**661877** — [Qantas] [UAT] Qantas - ITD 561170 - NZ: Confirmation Email - Body/Content Not Updated
- **Description:** In NZ Confirmation emails, the contents are not updated as per the BR. Before the "Help While travelling" section (still within "Help with your policy"), there should be a Note.
- **Steps:** Open THS → purchase Integrated NZ policy via lite.uat.travelguard.com/sml/amadeus → use attached quote request (sell 1 and 2; replace email) → click Send → open Sales Confirmation email.
- **Latest comment (Ballam Sai Deepthi Deepthi):** @Stuart Santos @Ping-Hao Lu Could you please help check this. Thanks..

---

**661432** — [Qantas] [UAT] Qantas - ITD 561170 - NZ: Confirmation Email - Footer Section Not Updated
- **Description:** For NZ policies, the confirmation email Footer section is not updated based on the BRD.
- **Steps:** Open THS → purchase Integrated NZ policy via lite.uat.travelguard.com/sml/amadeus → use attached quote request (sell 1 and 2; replace email) → click Send → open Sales Confirmation email.
- **Latest comment (Allaizza Shane Arda):** Retest failed - we purchased new policies today after Bug 661417 was resolved. The second paragraph is already passing, however the first paragraph is now failing and not reflecting the expected updated content. CC: @Beena Ahuja @Ballam Sai Deepthi Deepthi @Amnah Afzal

## Sprint 116 PBIs

| ID | Title | Link |
|----|-------|------|
| 651167 | [RLL] Email Fulfillment Update | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/651167) |
| 657541 | [Placeholder] [RLL] United CA - Email Fulfillment | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/657541) |
| 649639 | AEM TSA Fronting - Emirates IE - Email Update | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/649639) |
| 649646 | AEM TSA Fronting - Emirates KT - Email Update | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/649646) |
| 649649 | AEM TSA Fronting - Emirates LB - Email Update | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/649649) |
| 649652 | AEM TSA Fronting - Emirates MT - Email Update | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/649652) |
| 657534 | AEM TSA Fronting - Lufthansa US - GCS Mapping | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/657534) |
| 657542 | [Placeholder] [RLL] United CA - GCS Mapping | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/657542) |
| 653473 | AEM TSA Fronting - United PT - Email Fulfillment | [View](https://devops.tg-tfs-prod.awsamer.com/tfs/DefaultCollection/Travel%20IT/_workitems/edit/653473) |
