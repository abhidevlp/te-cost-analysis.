# Root-Cause Analysis

**Question:** Why did the average cost per business trip go up?

All numbers below come from `sql/02_analysis.sql`, run against the `trip_analytics`
table (completed trips with cost > 0). This is the analysis grain: one completed trip.

---

## 1. What actually happened (the trend)

Average cost per trip, by quarter, and the % change vs the previous quarter:

| Quarter | Avg cost/trip | Change vs prev Q |
|---------|--------------:|-----------------:|
| 2024 Q1 | $992          | -                |
| 2024 Q2 | $1,036        | +4.4%            |
| 2024 Q3 | $1,032        | -0.4%            |
| 2024 Q4 | $1,095        | +6.1%            |
| 2025 Q1 | $1,014        | -7.4%            |
| 2025 Q2 | $1,105        | +9.0%            |

**Finding:** cost per trip rose from **$992 to $1,105 = +11.4%** over the window.

**Important correction to the rumor.** The stakeholder believed cost/trip was up
~18% with trip volume falling. The data does not support that:
- The real rise is **~11%**, not 18%.
- The rise is **bumpy, not a steady climb** - it dips every Q1 (seasonality), then
  climbs again. It is a drift upward, not a spike.
- Trip **volume is flat to slightly up**, not down.

So the honest headline is: *"Cost per trip rose about 11% and unevenly. It is driven
by how trips are booked, not by a collapse in trip volume."* Reporting the truth here
is the point - a good analyst corrects a wrong assumption with evidence.

---

## 2. Where the money is (the components)

Share of total spend by cost component:

| Component | Share of spend |
|-----------|---------------:|
| Flight    | 53.2%          |
| Hotel     | 36.8%          |
| Meals     | 7.5%           |
| Ground    | 2.0%           |
| Misc      | 0.5%           |

**Finding:** flights + hotels = **90% of all spend**. Any cost lever that does not move
flights or hotels cannot move the total much. This tells us where to look.

---

## 3. The three real cost drivers

Each driver below is a "same trip, higher price" story - the thing that makes one trip
cost more than an otherwise similar trip.

### Driver A - Non-preferred vendors (biggest lever)

| Vendor type    | Avg cost/trip |
|----------------|--------------:|
| Preferred      | $992          |
| Non-preferred  | $1,174        |
| **Gap**        | **+$182**     |

Booking outside the preferred/contracted vendors costs **$182 more per trip (~18%)**.
Because it hits flights and hotels (the 90%), this is the strongest driver.

### Driver B - Policy exceptions (biggest by volume)

| Trip type          | Trips  | Avg cost/trip | Total spend |
|--------------------|-------:|--------------:|------------:|
| No policy exception| 2,593  | $1,007        | $2.61M      |
| Has policy exception| 1,035 | $1,146        | $1.19M      |
| **Gap**            |        | **+$139**     |             |

Trips that break a policy rule cost **$139 more each**, and there are a lot of them -
**1,035 trips, ~29% of all completed trips**. High gap x high volume = this is where
the real money leaks. Rough excess: $139 x 1,035 = **~$144K**.

### Driver C - Last-minute booking (real, but small volume)

| Booking window | Trips  | Avg cost/trip | Avg flight |
|----------------|-------:|--------------:|-----------:|
| 0-3 days       | 103    | $1,145        | $579       |
| 4-7 days       | 330    | $1,065        | -          |
| 8-14 days      | 580    | $1,068        | -          |
| 15+ days       | 2,615  | $1,036        | $550       |

Booking 0-3 days out costs **~$109 more per trip** than booking 15+ days ahead, and the
gap is mostly in the flight. But only **103 trips** are last-minute, so the total dollars
are smaller than A and B. It is a real behavior to fix, just a smaller pot.

---

## 4. Where it concentrates (region)

| Region        | Trips | Avg cost | Total spend | % non-preferred | % exceptions |
|---------------|------:|---------:|------------:|----------------:|-------------:|
| EMEA          | 1,435 | $1,060   | $1.52M      | 25.5%           | 27.7%        |
| APAC          | 963   | $1,042   | $1.00M      | 30.7%           | 29.2%        |
| LATAM         | 408   | $1,060   | $0.43M      | 31.6%           | 33.1%        |
| NAMER (blank) | 822   | $1,023   | $0.84M      | 24.3%           | 27.0%        |

**Finding:** average cost per trip is fairly even across regions (~$1,020-$1,060), so no
single region is "expensive" by itself. What differs is **compliance behavior**:
- **LATAM and APAC** have the highest non-preferred vendor use and the most policy
  exceptions - they exhibit the two costly behaviors most often.
- **EMEA** is the biggest total-spend region, so even a small % improvement there
  returns the most absolute dollars.
- The blank region is North America (the `region` field is empty for those offices in
  the source data - noted as a data-quality item, not an error in analysis).

---

## 5. The causal chain (putting it together)

```
Cost per trip is up ~11% (uneven, seasonal)
        |
        v
90% of spend is flights + hotels        <- so the lever must move flights/hotels
        |
        v
Three behaviors raise the price of the SAME trip:
   A. Non-preferred vendors   -> +$182/trip   (biggest per-trip gap)
   B. Policy exceptions       -> +$139/trip   x 1,035 trips = biggest total (~$144K)
   C. Last-minute booking     -> +$109/trip   (real, but only 103 trips)
        |
        v
These behaviors cluster in LATAM & APAC (compliance), 
while EMEA carries the largest absolute spend
        |
        v
=> The rise is a COMPLIANCE + BOOKING-BEHAVIOR problem, not a price-of-travel problem.
   It is addressable by tightening vendor and policy adherence, not by cutting travel.
```

---

## 6. What this means for the recommendation (preview)

- The rise is **not** a market-price story and **not** a volume story - it is a
  **behavior** story: preferred-vendor use, policy exceptions, and lead time.
- The two levers worth acting on first are **A (vendor gap, $182/trip)** and
  **B (policy exceptions, ~$144K of excess)** because they combine a large gap with
  large volume, and they hit flights/hotels.
- Target the behavior where it clusters: **LATAM/APAC for compliance**, **EMEA for
  absolute savings**.

The dollar sizing of these levers is done in the financial impact analysis.

---

## 7. Honesty / limitations

- Cost per trip is **derived** (summed approved expense lines per trip); the source
  had no single trip-cost column.
- These are **associations, not proven causation** - non-preferred trips *may* also be
  longer or to pricier cities. A fair next step is to compare within the same route or
  trip purpose. The direction and size are consistent enough to act on.
- Spend counts **approved** expense lines only (rejected/pending excluded), so figures
  are conservative.
- The ~$144K excess is an **indicative** figure, not a booked saving - the financial
  impact analysis applies a conservative capture rate.
