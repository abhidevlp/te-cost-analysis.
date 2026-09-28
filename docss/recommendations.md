# Business Recommendations

Each recommendation follows: **Problem -> Evidence -> Impact -> Action**. All evidence is
from the SQL analysis and the financial impact sizing.

---

## Recommendation 1 - Tighten preferred-vendor use (highest per-trip saving)

- **Problem:** Trips booked with non-preferred vendors cost more for the same travel.
- **Evidence:** Non-preferred trips average **$1,174** vs **$992** for preferred - a
  **$182 per-trip gap**. 991 completed trips used non-preferred vendors.
- **Impact:** ~$180K full gap over the window; **~$72K/window realistically** at a 40%
  shift to preferred vendors.
- **Action:** Make preferred vendors the default in the booking tool; require a reason
  code to book off-list; review non-preferred bookings monthly, starting with LATAM/APAC.

---

## Recommendation 2 - Reduce policy exceptions (biggest total pot)

- **Problem:** Nearly a third of trips carry a policy exception, and they cost more.
- **Evidence:** Exception trips average **$1,146** vs **$1,007** without - a **$139
  per-trip gap** across **1,035 trips (~29% of completed)**.
- **Impact:** ~$144K full gap; **~$58K/window realistically** at 40% reduction.
- **Action:** Find the top 2-3 exception reasons (from `exception_reason`) and fix the
  root cause - tighten the rule, raise a limit that is too low, or add pre-trip approval
  so the exception is caught before spend, not after.

---

## Recommendation 3 - Encourage advance booking (quick win, small pot)

- **Problem:** Last-minute trips cost more, mostly on airfare.
- **Evidence:** 0-3 day bookings average **$1,145** vs **$1,036** for 15+ day bookings -
  a **$109 gap**, driven by flight cost ($579 vs $550). Only 103 last-minute trips.
- **Impact:** ~$11K over the window - small because volume is low.
- **Action:** Automated nudge to book 14+ days ahead; flag sub-3-day bookings to managers.
  Low effort, so worth doing even though the pot is small.

---

## Recommendation 4 - Focus effort by region

- **Problem:** Compliance behavior is uneven across regions.
- **Evidence:** LATAM (31.6% non-preferred, 33.1% exceptions) and APAC (30.7% / 29.2%)
  are worst; EMEA carries the most total spend ($1.52M).
- **Impact:** Targeting LATAM/APAC fixes the behavior where it is worst; targeting EMEA
  returns the most absolute dollars.
- **Action:** Pilot the vendor + exception changes in LATAM and APAC first, then roll the
  proven playbook to EMEA for the biggest dollar return.

---

## Priority summary

| Priority | Recommendation        | Realistic saving/window | Effort |
|----------|-----------------------|------------------------:|--------|
| 1        | Preferred vendors     | ~$72K                   | Medium |
| 2        | Policy exceptions     | ~$58K                   | Medium |
| 3        | Advance booking       | ~$11K                   | Low    |
| -        | Region focus (how)    | (enables 1 & 2)         | Low    |

**Combined realistic target: ~$130K/window (~$86K annual)** at 40% adherence improvement,
concentrated on flights and hotels where 90% of spend sits.
