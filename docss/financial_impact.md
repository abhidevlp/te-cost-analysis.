# Financial Impact

**Question:** If we fix the cost drivers, how much money is realistically on the table?

All figures use the numbers from the SQL analysis and root-cause work. The base is **completed trips with
cost > 0 = 3,628 trips, $3,797,482 (~$3.8M) approved spend** over the ~6-quarter window.

**Read this the right way.** These are **potentially addressable spend** figures, not
guaranteed savings. You cannot move every trip to the cheaper behavior (some last-minute
trips are genuine emergencies; some exceptions are legitimate). So I size the *full gap*
first, then apply a **conservative capture rate** to get a realistic target.

---

## The counts behind the levers (real data)

| Group                         | Trips |
|-------------------------------|------:|
| Completed trips with cost     | 3,628 |
| - Preferred vendor            | 2,534 |
| - Non-preferred vendor        | **991** |
| - Unknown vendor (blank)      | 103   |
| Trips with a policy exception | **1,035** |
| Trips with no exception       | 2,593 |

---

## Lever A - Move non-preferred trips toward preferred pricing

- Per-trip gap: non-preferred $1,174 vs preferred $992 = **$182/trip**
- Non-preferred trips: **991**
- **Full gap = 991 x $182 = ~$180,000** over the window

You will never convert 100% of non-preferred trips (some routes have no preferred
option). Apply capture rates:

| Capture rate | Addressable saving (window) | Approx per year* |
|-------------:|----------------------------:|-----------------:|
| 25%          | ~$45,000                    | ~$30,000         |
| 40%          | ~$72,000                    | ~$48,000         |
| 60%          | ~$108,000                   | ~$72,000         |

\*Window is ~1.5 years (2024Q1-2025Q2), so annual ≈ window x 2/3.

---

## Lever B - Reduce policy exceptions (biggest pot)

- Per-trip gap: exception $1,146 vs no-exception $1,007 = **$139/trip**
- Exception trips: **1,035**
- **Full gap = 1,035 x $139 = ~$144,000** over the window

| Capture rate | Addressable saving (window) | Approx per year* |
|-------------:|----------------------------:|-----------------:|
| 25%          | ~$36,000                    | ~$24,000         |
| 40%          | ~$58,000                    | ~$38,000         |
| 60%          | ~$86,000                    | ~$58,000         |

---

## Lever C - Encourage advance booking (smaller pot)

- Per-trip gap: 0-3 day trips $1,145 vs 15+ day $1,036 = **$109/trip**
- Last-minute trips (0-3 days): **103**
- **Full gap = 103 x $109 = ~$11,000** over the window

Small because volume is low. Worth a nudge (booking reminders), not a big program.

---

## Headline number (conservative, defensible)

Levers A + B are the two that combine a real gap with real volume and hit flights/hotels
(90% of spend). Sizing them together:

| Scenario        | A + B full gap | At 40% capture |
|-----------------|---------------:|---------------:|
| Combined window | ~$324,000      | **~$130,000**  |
| Combined annual | ~$216,000      | **~$86,000**   |

**One-line version for the CFO / resume:**
> Identified ~$325K of potentially addressable T&E spend from two behaviors
> (non-preferred vendors and policy exceptions), with a conservative ~$130K
> realistically capturable at a 40% adherence-improvement rate.

Note the overlap caveat below - use the ~$130K figure, not the raw sum, to stay honest.

---

## Honesty / caveats

1. **Addressable, not booked.** These are targets, not savings already realized.
2. **Capture rate is an assumption.** I show 25/40/60% so the reader can pick their own;
   the headline uses the middle (40%).
3. **A and B overlap.** Some trips are BOTH non-preferred AND an exception, so the full
   gaps cannot simply be added - that double-counts. The headline uses the capture-rated
   figure and flags the overlap; a cleaner next step is to size the combined effect on
   the same set of trips (regression or a cross-tab), which is beyond this simple pass.
4. **Association, not proven causation** - non-preferred trips may differ in route/length.
   Direction and magnitude are strong enough to act on and monitor.
5. **Conservative base** - spend counts approved lines only.
