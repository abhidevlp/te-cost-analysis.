# Executive Summary

A one-page narrative for a non-technical executive. Structure: Situation, Complication,
Analysis, Finding, Impact, Action. This is what you would say in a 2-minute stand-up or
put on a summary slide.

---

## Situation
Business travel spend is a large, discretionary cost. Leadership believed the average
cost per trip had jumped ~18% while trip volume fell, and wanted to know why.

## Complication
There was no single "trip cost" figure in the data - cost lives in individual expense
lines. Before answering anything, cost per trip had to be reconstructed from ~11,700
expense line items and joined to trips, employees, offices, and vendors.

## Analysis
I built a clean trip-level dataset in Python, loaded it into PostgreSQL, and analyzed the
drivers with SQL, then visualized it in Power BI. Cost per trip was measured on completed
trips with real spend, so cancellations and zero-cost trips did not distort it.

## Finding
1. **The rise is real but smaller than believed: ~11%, not 18%** - and it is bumpy with
   a seasonal Q1 dip, not a steady spike. **Trip volume was flat, not down.**
2. **90% of spend is flights and hotels**, so that is where any saving must come from.
3. Three behaviors raise the cost of the *same* trip:
   - Non-preferred vendors: **+$182/trip**
   - Policy exceptions: **+$139/trip** (across ~29% of trips - the biggest total pot)
   - Last-minute booking: **+$109/trip** (small volume)
4. These behaviors cluster in **LATAM and APAC**; **EMEA** holds the most total spend.

**Bottom line: this is a compliance and booking-behavior problem, not a rising-price or
falling-volume problem. It can be fixed without cutting travel.**

## Impact
Tightening the top two behaviors (preferred vendors + policy exceptions) represents
**~$325K of potentially addressable spend**, of which a conservative **~$130K/window
(~$86K annual)** is realistically capturable at a 40% adherence improvement.

## Action
1. Make preferred vendors the booking default; require a reason to go off-list.
2. Fix the top policy-exception root causes with pre-trip approval.
3. Nudge travelers to book 14+ days ahead.
4. Pilot in LATAM/APAC (worst compliance), then scale to EMEA (largest spend).

---

### The 30-second version
> "Cost per trip rose about 11%, not the 18% we feared, and volume didn't fall. Ninety
> percent of spend is flights and hotels. The rise comes from three habits - using
> non-preferred vendors, policy exceptions, and last-minute booking - that make the same
> trip more expensive. Fixing the top two is worth roughly $130K, and it's a compliance
> fix, not a travel cut."
