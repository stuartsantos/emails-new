# Holiday Email Series 2026 — Handoff

## Status

- [x] `national-tourism-day-2026.html` — National Tourism Day (May 7)
- [x] `national-road-trip-day-2026.html` — National Road Trip Day (May 22)
- [x] `cheap-flight-day-2026.html` — Cheap Flight Day (Aug 23)
- [x] `labor-day-2026.html` — Labor Day
- [x] `thanksgiving-2026.html` — Thanksgiving
- [x] `travel-tuesday-2026.html` — Travel Tuesday (Dec 1)
- [x] `holiday-2026.html` — Holiday/Christmas
- [x] `new-years-2027.html` — New Year's 2027

## Base Template

Copy `national-park-week.html` (in this folder) for each new email. It's the cleanest holiday template.

## What to Change Per Email

1. `<title>` tag
2. Preheader hidden `<div>` text
3. H1 heading
4. Hero `<img>` src and alt (use `../img/hero-{name}.jpg` placeholder — images TBD from design)
5. Body copy paragraphs (verbatim from content doc)
6. **All 5 cmpid links** — preheader "Get My Quote", body travelguard.com, CTA button, assistance services button, compare plans button

Everything else stays the same (header, CTA box text, assistance services list, social icons, footer, legal).

## Content Docs

Source docs are in `../docs/`. Use `pandoc "filename.docx" -t markdown` to extract content.

---

## Email Specs

### 2. `national-road-trip-day-2026.html`
- **Subject:** Get ready to hit the road!
- **Preheader:** Celebrate National Road Trip Day.
- **Title tag:** National Road Trip Day - Travel Guard
- **H1:** National Road Trip Day
- **cmpid:** `emc-tgdirect-us-en-holiday-roadtripdaymay26`
- **Body (3 paragraphs):**
  1. This year, National Road Trip Day is on May 22, which takes place annually on the Friday before Memorial Day. It's the perfect reason to [plan the road trip](https://www.travelguard.com/travel-news/planning-the-perfect-road-trip) you've always wanted to take. From weekend getaways to cross-country adventures, there are travel opportunities at every turn.
  2. To help you prepare for your road trip, check out our article on [essential road safety tips](https://www.travelguard.com/travel-resources/travel-tips/rental-car-essential-road-safety-tips) or [road trip games](https://www.travelguard.com/travel-resources/travel-tips/road-trip-games) to keep everyone entertained. Additionally, you can use our [packing checklist](https://www.travelguard.com/travel-resources/travel-tips/packing-checklist) to help you pack for your trip.
  3. If you're planning to [rent a vehicle](https://www.travelguard.com/travel-insurance/trip-types/rental-car-insurance) or simply want coverage for your trip, be sure to pack a Travel Guard travel insurance plan.
- **Note:** Body has 5 hyperlinks — keep them as `<a>` tags with underline, color `#1c252e`

### 3. `cheap-flight-day-2026.html`
- **Subject:** Cheap Flight Day is 08/23
- **Preheader:** Don't miss out!
- **Title tag:** Cheap Flight Day - Travel Guard
- **H1:** Take Advantage of National Cheap Flight Day
- **cmpid:** `emc-tgdirect-us-en-holiday-cheapflightdayaug26`
- **Body (2 paragraphs):**
  1. August 23 is National Cheap Flight Day, which is a time when airlines historically drop their prices following the end of the peak summer travel season. In other words, this day is the perfect opportunity to score flight details and check some destinations off your travel bucket list like [Thailand](https://www.travelguard.com/travel-resources/destinations/asia-and-middle-east/thailand), [Japan](https://www.travelguard.com/travel-resources/destinations/asia-and-middle-east/japan), [Australia](https://www.travelguard.com/travel-resources/destinations/australia/australia) or [Vietnam](https://www.travelguard.com/travel-resources/destinations/asia-and-middle-east/vietnam).
  2. After you book great deals on flights, [don't forget a travel insurance plan](https://www.travelguard.com/travel-insurance/plans). Travel Guard can help protect your trip investment and provide valuable assistance, navigating anything from [trip delays](https://www.travelguard.com/travel-insurance/benefits/trip-delay-missed-connection) and [cancellations](https://www.travelguard.com/travel-insurance/benefits/trip-cancellation-insurance), to [lost bags](https://www.travelguard.com/travel-insurance/benefits/baggage-insurance) and [medical emergencies](https://www.travelguard.com/travel-insurance/benefits/travel-health-insurance).
- **Note:** No closing "visit travelguard.com" paragraph in the doc — the CTA box handles it

### 4. `labor-day-2026.html`
- **Subject:** One last summer trip?
- **Preheader:** Add a travel insurance plan before you go
- **Title tag:** Take a Break This Labor Day - Travel Guard
- **H1:** Take a Break This Labor Day
- **cmpid:** `emc-tgdirect-us-en-holiday-labordaysep26`
- **Body (3 paragraphs):**
  1. As Labor Day approaches and you get ready to spend quality time with the people you love, it may be the perfect opportunity to plan one more getaway before fall officially begins.
  2. Whether your travel plans are already booked for the holiday or you are planning a trip later in the year, it's not too late to add a [Travel Guard travel insurance plan](https://www.travelguard.com/travel-insurance/plans) to help protect your trip investment from unexpected delays, interruptions and cancellations. A Travel Guard plan can also give you access to our [emergency assistance team](https://www.travelguard.com/info/assistance-services), available 24/7 to help with travel issues such as rebooking hotels, arranging new flights after a missed connection and more that may arise during your trip.
  3. Ready to purchase your travel insurance plan for your trip? Visit [travelguard.com](cmpid link), call us at [877.920.3105](tel:18779203105) or speak with your travel advisor.

### 5. `thanksgiving-2026.html`
- **Subject:** Thank you for traveling with us
- **Preheader:** We're grateful for you
- **Title tag:** Happy Thanksgiving - Travel Guard
- **H1:** Happy Thanksgiving from Travel Guard
- **cmpid:** `emc-tgdirect-us-en-holiday-thanksgiving26`
- **Body (3 paragraphs):**
  1. As 2026 comes to a close, we want to thank you for trusting Travel Guard to help protect your travels throughout the year. It has been our privilege to support you wherever your journeys have taken you. We hope your year was filled with unforgettable experiences, new destinations and meaningful time with the people who matter most.
  2. If you are planning to travel this holiday season, we wish you safe and happy travels. Whether your bags are already packed or you are still deciding where to go next, it is always a good time to think about protecting your trip from the unexpected.
  3. It's not too late to get coverage for your upcoming travel plans. Visit [travelguard.com](cmpid link), call us at [877.920.3105](tel:18779203105) or speak with your travel advisor.
- **Note:** Source doc had old cmpid `emc-001-TGUS-RN-Thanksgiving-2019` — use the updated one above

### 6. `travel-tuesday-2026.html`
- **Subject:** Don't miss Travel Tuesday deals
- **Preheader:** December 1, 2026
- **Title tag:** Travel Tuesday - Travel Guard
- **H1:** Travel Tuesday
- **cmpid:** `emc-tgdirect-us-en-holiday-traveltuesdaydec26`
- **Body (4 paragraphs):**
  1. You've heard of Black Friday and Cyber Monday deals, but if you've got a case of wanderlust, then you'll want to keep an eye out on Travel Tuesday on December 1.
  2. Celebrated the Tuesday after Thanksgiving, Travel Tuesday is when airlines and travel suppliers often offer discounted flights and vacation packages. It can be the perfect time to find a great deal and cross a destination off your bucket list.
  3. If you happen to score a Travel Tuesday deal this year, remember to protect your trip investment with a travel insurance plan. Even the best travel deals can benefit from coverage if the unexpected happens. A travel insurance plan from Travel Guard may include important benefits such as baggage coverage, emergency medical coverage and 24/7 travel assistance.
  4. Don't forget Travel Guard this Travel Tuesday and happy deal hunting.
- **CTA override:** Change the "Get My Quote" button link to `https://www.travelguard.com/purchase/start-your-quote?cmpid=...` (doc specifically says "Get a Quote" with that URL)

### 7. `holiday-2026.html`
- **Subject:** Holiday travel plans?
- **Preheader:** Travel smarter this season.
- **Title tag:** Happy Holidays - Travel Guard
- **H1:** Happy Holidays from Travel Guard
- **cmpid:** `emc-tgdirect-us-en-holiday-holiday26`
- **Body (4 paragraphs):**
  1. As this year comes to an end, we wish you a safe and happy holiday season. If you're celebrating with your loved ones, we hope your travel plans go as smoothly as possible.
  2. Before you take off to spend quality time with friends and family, consider a Travel Guard travel insurance plan to help protect your trip investment if the unexpected happens.
  3. Travel Guard travel insurance plans include 24/7 access to our emergency assistance team, so you have the support when you need it most.
  4. It's not too late to get coverage for your upcoming travel plans. Visit [travelguard.com](cmpid link), call us at [1.877.920.3105](tel:18779203105) or speak with your travel advisor.

### 8. `new-years-2027.html`
- **Subject:** Where will 2027 take you?
- **Preheader:** A new year of travel starts here.
- **Title tag:** Happy New Year - Travel Guard
- **H1:** Happy New Year from Travel Guard
- **cmpid:** `emc-tgdirect-us-en-holiday-newyears27`
- **Body (4 paragraphs):**
  1. As we prepare to welcome 2027 and reflect on the memories from this past year, we want to thank you for being a Travel Guard customer. Whether this was your first year traveling with us or one of many, we're grateful to be part of your journeys.
  2. We wish you good health, happiness, success and many new adventures in the year ahead.
  3. If you have already booked travel plans for the new year or are starting to plan your next trip, Travel Guard is here to help with travel coverage that can support you in unforeseen circumstances, such as flight cancellations or delays.
  4. When you're ready, visit [travelguard.com](cmpid link), call us at [1.877.920.3105](tel:18779203105) or speak with your travel advisor when making your reservations.

---

## Hero Images

All 8 hero images are TBD from the design team. Use `../img/hero-{name}.jpg` as the placeholder path. The VML Outlook fallback block stays in place — update dimensions when images are available.

## Diagnostics Note

CSS warnings for `mso-table-lspace`, `mso-table-rspace`, `supported-color-schemes`, `mso-hide` are expected — these are Outlook/email-client-specific properties that VS Code doesn't recognize. Ignore them.
