# Travel Tips Email Build — Handoff Notes

## Status
- **May** (`travel-tips-05-26.html`) — ✅ Complete
- **June** (`travel-tips-06-26.html`) — ✅ Complete
- **July** (`travel-tips-07-26.html`) — ✅ Complete
- **August** (`travel-tips-08-26.html`) — ✅ Complete
- **September** (`travel-tips-09-26.html`) — ✅ Complete
- **October** (`travel-tips-10-26.html`) — ✅ Complete
- **November** (`travel-tips-11-26.html`) — ✅ Complete
- **December** (`travel-tips-12-26.html`) — ✅ Complete

---

## Rules Established During May Build

1. **Use `travel-tips-04-26.html` (April) as the canonical reference template** for all new files.

2. **Content fidelity**: Only use content explicitly present in the Word doc. Do not invent article URLs, blurbs, or section copy.

3. **"More Travel Tips" section**: Use the April template's content verbatim (article title, URL, blurb) — only update the `cmpid`. The client will fix these links later.

4. **Hero images**: Use a descriptive placeholder CDN URL following the pattern:
   `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/{descriptive-name}.jpg`
   These need to be updated once the design team provides actual image assets.

5. **cmpid format**: `emc-tgdirect-us-en-traveltips-{mon}26` — applied to **every** link in the email (preheader, body, CTA, More Travel Tips, Education Center, Video Library).

6. **Doc extraction**: Use `pandoc` (now installed via Homebrew) to extract content from `.docx` files. It preserves bold, numbered lists, line breaks, and hyperlink URLs. Command:
   ```
   pandoc "/path/to/doc.docx" -t markdown
   ```

7. **Tip structure**: The docs use **bold tip titles followed by body text** — sometimes as a numbered list (`<ol>`), sometimes as bold headings with paragraph text below. Match whichever structure the doc uses.

8. **Closing paragraphs**: Any paragraphs after the list in the doc should be placed **outside the `<ol>`** as separate `<p>` tags, not inside the last `<li>`.

9. **Sub-sections within list items** (e.g. May's Scavenger Hunt / Road Trip Trivia): Use `<strong>Title</strong><br>` then description text on the next line, with `<br><br>` between sub-sections.

10. **Inline links in body copy**: Preserve all hyperlinks from the doc using the style `color: #1c252e; text-decoration: underline;` (matching existing template link style in body text).

11. **Video Library section**: Use the same video thumbnail and URL as March/April — `trusted-travel-girl-experience-playbtn.jpg` linking to `/video-library/real-life-experience`.

12. **Education Center section**: Identical across all months — same "How Does Travel Insurance Work?" content, only the cmpid changes.

13. **Testimonials section**: Identical across all months — same Todd B. quote.

---

## Remaining Files — Content Reference

All content extracted via pandoc from the Word docs in `docs/`.

---

### June — `travel-tips-06-26.html`
- **Title**: Tips to Help Avoid Pickpockets in Europe
- **Subject**: Tips to help avoid pickpockets in Europe
- **Preheader**: Travel safer with these tips.
- **cmpid**: `emc-tgdirect-us-en-traveltips-jun26`
- **Hero image placeholder**: `pickpockets-europe-hero.jpg`
- **Structure**: Bold headings (not numbered list), each followed by paragraph text

**Intro:**
Many tourists dream about visiting Europe, whether it's to get a taste of the delicious cuisine, learn about its rich history or create unforgettable memories. But as with any busy tourist area, petty crime, like pickpocketing, can be found in popular tourist spots. To help you stay safe from pickpockets in Europe, we've gathered some smart prevention tips:

**Be Wary of Friendly Strangers**
One of the best parts of travel is meeting friendly locals and other travelers, but it's in your best interest to keep your guard up. Whether it's an embrace, being too close for comfort or an accidental bump, pickpockets often use these kinds of tactics to get close to tourists to grab easy-to-take items. You may also be roped into a scam where you're presented with an item, like a bracelet, as if it's a gift and then intimidated into paying for the item.

**Blend in**
Since tourists are most often the victims of pickpockets, it's in your best interest to blend in as much as possible. This can apply to how you look and act, whether you have a backpack on with your camera out or are dressed to the nines, you can end up sticking out to locals. Instead, leave flashy jewelry and luxury items at home or locked in your hotel room and learn to dress like a local.

**Learn to Spot Fake Police**
Some pickpockets may use scare tactics to get what they want. In some cases, they may dress as a police officer or other official and ask to see your travel documents. Before handing over any information, assess the legitimacy of the situation. Real officials will accept copies of your documents and are willing to meet with you at the station, rather than doing business on the street.

**Closing:**
For more tips on how to avoid pickpockets in Europe, see our [travel tips article](https://www.travelguard.com/travel-resources/travel-tips/avoid-outsmart-pickpockets-in-europe).

If you have a Travel Guard travel insurance plan, you can contact [our assistance services team](https://www.travelguard.com/info/assistance-services) to inform them of your situation and see how they may be able to assist.

---

### July — `travel-tips-07-26.html`
- **Title**: Top Tips for Family Summer Travel
- **Subject**: Top tips for family summer travel
- **Preheader**: to create a memorable trip.
- **cmpid**: `emc-tgdirect-us-en-traveltips-jul26`
- **Hero image placeholder**: `family-summer-travel-hero.jpg`
- **Structure**: Bold headings, each followed by paragraph text (some multi-paragraph)

**Intro:**
When you consider packing, keeping kids entertained, managing different schedules and staying on top of safety, there's a lot to think about when it comes to planning a summer vacation. The good news? A little preparation goes a long way. To help you navigate your summer travel plans, we've gathered some helpful tips:

**Research summer trip ideas**
It may seem obvious, but tailor your trip to what you and your travel party enjoy. Ask yourself what your family enjoys doing together at home and see if you can expand from there. Are you into outdoor adventures, more cultural experiences or just want to relax by the beach all day? Whatever your preferences are, there are tons of family summer trip ideas that fit all budgets and age groups.

And don't just look at the big-name destinations, sometimes the smaller, less-crowded spots end up being the real highlights of your trip (plus, it may cost less!).

**Start early, book smart**
Summer is peak travel season, especially for families. Flights fill up fast, and popular resorts and parks can sell out months in advance. As soon as you know your travel dates, lock in accommodations and transportation (especially if you're [renting a car](https://www.travelguard.com/travel-insurance/trip-types/rental-car-insurance)). Look for [family-friendly travel insurance plans](https://www.travelguard.com/traveler-types/family-travel-insurance-plan) and consider traveling midweek for better rates and fewer crowds.

**Build a flexible itinerary**
You don't need to have every minute planned, but having a general game plan helps. Schedule must-do activities early in the day and always leave room for breaks or detours. Some of the best memories come from unexpected stops or spontaneous moments.

**Closing:**
And there we have it! A few simple steps can make a big difference when it comes to planning a summer vacation. Check out these [additional family summer travel tips](https://www.travelguard.com/travel-resources/travel-tips/family-summer-travel-tips) to help you prepare for your next memorable vacation.

---

### August — `travel-tips-08-26.html`
- **Title**: Tips if You Have a Medical Emergency Abroad
- **Subject**: Medical emergency abroad?
- **Preheader**: Travel tips to help you navigate.
- **cmpid**: `emc-tgdirect-us-en-traveltips-aug26`
- **Hero image placeholder**: `medical-emergency-abroad-hero.jpg`
- **Structure**: Bold headings, each followed by paragraph text

**Intro:**
Sometimes, preparing for the unexpected can make all the difference. If you're a traveler with a [pre-existing medical condition](https://www.travelguard.com/travel-insurance/optional-coverage/pre-existing-medical-condition-waiver) or want to know your options for coverage in case of a [medical emergency](https://www.travelguard.com/travel-insurance/benefits/travel-medical-expense), we can help you understand what you should do if you need medical attention while abroad:

**Find a healthcare facility**
You'll want to research in advance nearby hospitals or medical facilities where you'll be traveling and staying. This can be especially helpful if you have a pre-existing medical condition; in which case, you may want to add the [Pre-Existing Medical Condition Exclusion Waiver](https://www.travelguard.com/travel-insurance/optional-coverage/pre-existing-medical-condition-waiver)*. If you have a Travel Guard travel insurance plan for your trip, you can contact our [24/7 assistance service center](https://www.travelguard.com/info/assistance-services) with any questions, or you can contact the U.S. Embassy at your destination.

**Receive care**
After you arrive at the proper healthcare facility and receive treatment, you may have to pay for costs out of pocket. If you have a travel insurance plan, you'll be able to file a claim for reimbursement for covered expenses (be sure and save receipts, medical reports and any other paperwork you receive). If you can't afford the out-of-pocket expense, it's possible that you may be able to work with the local U.S. Embassy to get a loan to cover treatment costs until you're back home.

**File a claim**
Once you return, you'll be able to [file a claim](https://claims.travelguard.com/claims) for your covered medical expenses and unused costs of your trip if you have a travel insurance plan. Unused costs can include certain non-refundable costs and fees associated with planned activities you didn't get to enjoy.

**Closing:**
Finally, if you don't speak the language of your destination, it can be difficult to communicate the issues you're having, thus delaying your treatment. With [a Travel Guard travel insurance plan](https://www.travelguard.com/travel-insurance/plans), our assistance team can try to locate an English-speaking doctor or provide translation services if needed.

For extra coverage and higher benefit limits, check out our [Medical Bundle](https://www.travelguard.com/travel-insurance/optional-coverage/medical-bundle)*.

*Available with certain travel insurance plans.

---

### September — `travel-tips-09-26.html`
- **Title**: Tips to Help Stay Safe if a Natural Disaster Strikes During Your Trip
- **Subject**: Travel Tips for Natural Disasters
- **Preheader**: Prepare for Severe Weather
- **cmpid**: `emc-tgdirect-us-en-traveltips-sep26`
- **Hero image placeholder**: `natural-disaster-travel-hero.jpg`
- **Structure**: Bold headings with `<br>` after (inline line break before body text — note the doc uses `\` line breaks, meaning the heading and its body are in the same paragraph block)

**Intro:**
Severe weather can develop with little or no warning. Planning ahead can help you stay safer and feel more confident during your trip. Here are a few helpful tips to keep in mind if severe weather affects your vacation.

**Research weather risks for your destination**
Before your trip, check the forecast for your destination for the days you will be traveling. It is also helpful to learn about the warning signs of common natural disasters in the area you are visiting. If you live in a region prone to severe weather such as hurricanes, prepare your home before you leave and monitor any potential weather alerts that may affect your hometown while you are away.

**Share your travel plans with trusted contacts**
Provide a trusted family member or friend with a copy of your travel itinerary before you leave. Include your hotel contact information, flight numbers, travel insurance details and a general overview of your planned activities. You may also want to enroll in the [Smart Traveler Enrollment Program (STEP)](https://mytravel.state.gov/s/step), which helps the U.S. government contact you in case of an emergency and makes it easier for your trusted contacts to reach you if needed.

**Keep paper copies of important documents**
Travel apps are convenient, but it is still smart to carry paper copies of important documents in case your phone is lost, damaged or without power. Bring printed copies of your passport, flight information, hotel confirmations and a physical map. If possible, store these documents in a waterproof bag. Because these documents contain sensitive information, keep them secure and out of sight.

**Closing (bold heading + body, then links):**
**Looking for more ways to prepare?**
Learn additional tips to help you prepare for severe weather while traveling by reading the [full article](https://www.travelguard.com/travel-resources/travel-tips/natural-disaster-safety-tips). You can also [get a quote](https://www.travelguard.com/purchase/start-your-quote) to explore coverage options that may help protect your trip.

---

### October — `travel-tips-10-26.html`
- **Title**: Tips for Managing Medication on the Go
- **Subject**: Traveling with medication?
- **Preheader**: Tips for managing on the go.
- **cmpid**: `emc-tgdirect-us-en-traveltips-oct26`
- **Hero image placeholder**: `traveling-with-medication-hero.jpg`
- **Structure**: Bold headings, each followed by paragraph text

**Intro:**
Traveling with medication can look different for every traveler because guidelines may vary based on the laws of your destination and the type of prescription medication you carry. However, there are some rules you should follow no matter how you travel. Here are some of our best tips for traveling with medication:

**Packing your medication**
When packing medication, there are a few things to keep in mind. Be sure to pack enough medication for your entire trip plus a few extra days in case of travel delays. Always keep medication on your person or in a carry-on bag. Never check medication in case you need quick access to it. Finally, bring copies of your prescriptions and keep medication in their original containers.

**Preparing for TSA**
In addition to the basics of traveling with medication — packing enough, keeping it with you and carrying prescriptions in their labeled containers — air travel has a few additional considerations. Unlike regular liquids, the Transportation Security Administration (TSA) allows you to bring more than the standard 3.4 ounces (about 100.55 ml) of liquid or cream prescription medications through security. Make sure medication is clearly labeled and inform a TSA agent before screening your prescription medications or other necessary medical items.

**Traveling internationally with medication**
It's important to check the laws in the country you're visiting, even if you believe your medications are common or standard. If you confirm your prescriptions are not prohibited, double-check the amount you are allowed to bring. Many countries allow up to a 30-day supply of medication, which you may need to declare with a customs agent. Remember to bring a doctor's note, copies of your prescription and keep medication in its original container.

**Closing:**
A travel insurance plan from Travel Guard can give you access to our [assistance service team](https://www.travelguard.com/info/assistance-services), who can help you replace medication, find a physician and locate a pharmacy.* For more information on traveling with medication, see our [additional travel tips](https://www.travelguard.com/travel-resources/travel-tips/managing-medications-on-the-go).

*Expenses incurred from third-party vendors for assistance services not part of a filed insurance plan are the responsibility of the traveler.

---

### November — `travel-tips-11-26.html`
- **Title**: Tips to Help Get Through TSA Quickly
- **Subject**: Don't get stuck in the TSA line.
- **Preheader**: Tips to help get through quickly.
- **cmpid**: `emc-tgdirect-us-en-traveltips-nov26`
- **Hero image placeholder**: `tsa-tips-hero.jpg`
- **Structure**: Bold headings, each followed by paragraph text

**Intro:**
We've all faced the dreaded security line at the airport, wrapping around stanchions and often far past them. There's no way to make getting through TSA fun, but we can help you get through quickly with these tips:

**Arrive Early**
Don't set yourself up for a stressful wait. One of the best things you can do when traveling through airports is arrive early. Typically, travelers should arrive at the airport two hours before a domestic flight or three hours before an international flight. However, there are several factors that can affect your arrival time, including airport size, checking luggage or airport construction.

**Know the packing requirements**
Knowing what you can and cannot bring through security will make it easier for you when you get there. Bringing the right amount of liquids, packing electronics properly and knowing what is prohibited can help you get through TSA more quickly. When packing, remember items like mascara, toothpaste and certain deodorants count as liquids, so be conscious of your limitations.

**Apply for TSA PreCheck**
Have you ever reached the airport security line only to see a long wait ahead? We've all been there. With [TSA PreCheck](https://www.tsa.gov/precheck), you'll use dedicated screening lines, which can make all the difference on busy travel days. You can also keep your shoes, jacket and belt on and leave liquids and electronics in your bag. According to the TSA, 99% of PreCheck passengers wait less than 10 minutes to get through security.¹

**Closing (outside list):**
Even with planning, the unexpected can happen. Your flight could leave without you or get cancelled. Then what? Help protect your time and travel investment with a Travel Guard travel insurance plan.

Check out these [additional tips](https://www.travelguard.com/travel-resources/travel-tips/airport-travel-tips) on how to get through TSA quickly.

1. https://www.tsa.gov/precheck

---

### December — `travel-tips-12-26.html`
- **Title**: Safety Tips for Frequent Flyers
- **Subject**: Do you fly frequently?
- **Preheader**: Here are helpful safety tips.
- **cmpid**: `emc-tgdirect-us-en-traveltips-dec26`
- **Hero image placeholder**: `frequent-flyer-tips-hero.jpg`
- **Structure**: Bold headings, each followed by paragraph text

**Intro:**
You may be well versed at navigating airports and the obstacles they present, even when traveling through a new one. However, there may be safety tips and tricks you've missed. Here are a few updated frequent flyer hacks to make your journey even smoother:

**Prepare before your flight**
One of the most important frequent flyer tips is to stay ahead of surprises. Check travel advisories, monitor your airline's app for delays or gate changes and make sure your passport and visas are up to date before you leave. Creating a digital travel folder with copies of your passport, ID, boarding passes and travel insurance information can help keep everything organized. Store it in the cloud (Google Drive, Dropbox, etc.) and make sure it's accessible offline in case you lose service or your phone dies.

**Pack for security lines**
Efficient packing is one of the most valuable frequent flyer tips, especially when traveling through multiple airports. Consider bringing only a carry-on whenever possible. Not only does this save time at check-in and baggage claim, it also [reduces the risk of lost luggage](https://www.travelguard.com/travel-resources/travel-tips/airline-loses-your-luggage). Other helpful tips include rolling your clothes to save space, using packing cubes for organization and keeping a small bag of essentials easily accessible. If you do need to check a bag, use a TSA-approved lock and add a smart luggage tracker.

**Prioritize your health**
With recycled cabin air, jet lag and tight layovers, travel can take a toll on your body. Staying hydrated is one of the most effective frequent flyer hacks. If you struggle to drink enough water, consider adding electrolyte or hydration tablets to your bottle. This may also help [reduce the effects of jet lag](https://www.travelguard.com/travel-resources/travel-tips/how-to-beat-jet-lag-fast). On long-haul flights, sitting for extended periods can lead to stiffness or circulation issues. Try walking up and down the aisles every few hours, stretching in your seat or wearing compression socks.

**Closing:**
You're almost ready for takeoff with these [helpful safety tips](https://www.travelguard.com/travel-resources/travel-tips/safety-tips-for-frequent-flyers). Before you go, consider protecting your trip investment with a travel insurance plan from Travel Guard!

---

## Key Asset References

### CDN-hosted assets used across all travel tips emails
- **Logo**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/logo-travel-guard-white.png`
- **Green send icon**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-send-green.png` (14×14)
- **Navy send icon**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Send@2x.png` (20px)
- **Green quote icon**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/icon-quote-green.png` (48px)
- **Education icon**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/education@2x.png` (28px)
- **Play icon**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Play@2x.png` (12px)
- **Chat icon**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/Outlined-03-Communication-Chat@2x.png` (19px)
- **Video thumbnail**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/trusted-travel-girl-experience-playbtn.jpg`
- **FB**: `https://www.travelguard.com/content/dam/travelguard/us/images/email/shared/icon-fb.png` (30×30)
- **IG**: `https://www.travelguard.com/content/dam/travelguard/us/images/email/shared/icon-ig.png` (28×28)
- **YouTube**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/youtube_social_circle_red@2x.png` (28×28)
- **TikTok**: `https://www.travelguard.com/content/dam/tg-documents/travel-guard/us/en/tiktok@2x.png` (28×28)

### April "More Travel Tips" placeholder block (copy verbatim, update cmpid only)
```html
<p style="margin: 10px 0; font-family: 'Noto Sans', 'Source Sans Pro', Arial, sans-serif; font-size: 18px; font-weight: 600; line-height: 25px;">
  <a href="https://www.travelguard.com/travel-resources/travel-tips/tips-for-traveling-sustainably?cmpid=emc-tgdirect-us-en-traveltips-{MON}26" style="color: #005b94; text-decoration: none;">Tips for Traveling Sustainably</a>
</p>
<p style="margin: 0 0 10px 0; font-family: 'Noto Sans', 'Source Sans Pro', Arial, sans-serif; font-size: 16px; line-height: 24px; color: #1c252e;">
  Every little bit helps when it comes to protecting our planet. Check out our tips for making your next trip more sustainable.
</p>
```
