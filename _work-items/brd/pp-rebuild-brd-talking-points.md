# PP Rebuild BRD — Talking Points

Prep for meeting with Peter (June 11, 2026). Source: call with Jake, June 10.

## TL;DR

The BRD exists to get the US purchase path rebuild **formally on the dev docket** and to secure **QA resources** for relaunching our biggest market. It is still necessary even though dev capacity has improved — it holds the requirements QA will test against. Meanwhile, we're making real progress in lower environments: the TravelX authoring enhancements are being integrated into the Travel Guard US build so we relaunch on the most up-to-date code, not legacy Singapore code.

## 1. Why the BRD exists in the first place

- **Origin (~April):** POC was completed based on the Singapore version of the purchase path. When real content went in, gaps surfaced immediately — e.g., the trip cost calculator (step 2) doesn't translate to the new code. This was never a simple "recreate with new colors" job; it required workshops with Rafael to work through.
- **Competing priorities ate the timeline:** Qantas, Expedia, and Jetstar launches were all happening simultaneously, plus the AEM environment migration from the AIG platform to the Zurich platform. Environments were down for days (sometimes a week); bypass workarounds had permission issues; workshops kept getting pushed.
- **No visibility:** The PP rebuild was effectively a side project. On dev calls, anything other than the active launches (Qantas etc.) was shut down — there was no awareness that this work was happening at all.
- **The BRD was the team's own recommendation:** In one of the Tuesday meetings, Peter (or Ping) said to write the BRD and put it in the fast track so it lands on the devs' plate and time gets allocated. We did exactly what was asked.

## 2. The BRD is necessary for QA — non-negotiable

- We are **relaunching the biggest market on new technology**. That cannot be QA'd by a handful of us punching in random states — that's not proper testing.
- The BRD holds the **requirements (as actual PBIs)** that QA tests against: data coming through correctly, edge cases and gotchas covered — not just the happy path.
- Without the BRD there is no mechanism to **allocate QA resources** to this project. So even with dev capacity improving, the BRD is not null and void — it's how we avoid going live broken.

## 3. Progress in lower environments — integrating the latest authoring

- Jake and Rafael have been building the TravelX purchase path with newer authoring capabilities, and those enhancements are being brought into the Travel Guard US build — e.g., the **newer PCT (trip cost) grid**, an enhancement over what the current PP offers, working toward the **dynamic trip cost** that was an identified gap.
- **Recommendation going forward:** build on this newer TravelX-based code rather than the older Singapore-based code. Going live on old code means shipping technical debt and redoing the work anyway — might as well do it right the first time.
- **Framing (important for Peter):** this is *not* two teams duplicating work. The majority of the rebuild is already built; we're now incorporating the TravelX enhancements (recent work, not a months-long parallel effort). Going forward, Stuart + Jake + Rafael work together — knowledge share on the newer practices, then build out the remainder as one effort on the future-proof code.

## 4. The light touch buys us the room to do this right

- To stay aligned with **Rhonda's Zurich rebrand timelines**, we're doing a light touch on the *current* purchase path — in progress now, vast majority done by **EOD June 11**, with only a few image files left to regenerate.
- This means we **meet the branding deadline** while giving ourselves the breathing room to rebuild and properly test the PP on the new code — without regressing wins already shipped (like dynamic trip cost).

## Anticipated pushback & answers

| Likely question | Answer |
|---|---|
| "Who even came up with this BRD?" | It came out of the Tuesday meeting — the direction was to write it and fast-track it so devs allocate time. |
| "Why are two people building the same thing separately?" | We're not — one build. The Singapore-based version was the first pass; the TravelX enhancements are recent and are being folded in. From here it's one combined effort (Stuart, Jake, Rafael). |
| "Why do you still need a BRD if you have dev help now?" | The BRD's second purpose is QA: it carries the launch requirements as PBIs so QA resources can be allocated and test against them. Biggest market — proper QA isn't optional. |
| "Why the light touch on the old PP?" | Meets Rhonda's rebrand timeline now, and buys time to rebuild on the new code correctly instead of rushing it. |

## Recap (one breath)

1. BRD was created because simultaneous launches + the environment migration left the rebuild with no dev time and no visibility — we needed it in writing to get on the docket.
2. BRD is still required to secure QA resources and carry launch requirements for our biggest market.
3. Dev resource now exists post-TravelX; we're using that technology to enhance the rebuild before go-live.
4. Light touch on the current PP meets Rhonda's branding timeline in the meantime.
