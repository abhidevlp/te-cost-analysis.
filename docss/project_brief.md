# Project Brief

## Business problem
Business travel is a large, discretionary cost. Leadership observed that the average cost
per trip appeared to be climbing and believed it had risen roughly 18% while the number of
trips fell. Before acting, they needed to know whether that was true and, if so, what was
driving it.

## Objective
Measure how the average cost per business trip changed over time, identify the factors
that drive cost up, quantify how much of the increase is realistically addressable, and
translate the findings into clear actions.

## Primary stakeholder
Finance leadership (CFO office). The output must be understandable by a non-technical
executive, not just an analyst.

## Key metrics (KPIs)
- **Average cost per trip** (primary) - total approved spend divided by completed trips.
- **Total spend** and **trip volume** - to test the "volume fell" assumption.
- **% non-preferred vendor** and **% policy exceptions** - the compliance levers.
- Cost split by **component** (flight, hotel, meals, ground, misc).

## Analytical questions
1. Did the average cost per trip actually rise, and by how much?
2. Did trip volume fall, as believed?
3. Which cost components dominate spend?
4. What behaviors make the same trip cost more (vendor, policy, booking timing)?
5. Where do those behaviors concentrate (region)?
6. How much of the increase can realistically be recovered?

## Key assumptions
- **Trip cost is derived.** The source has no single cost field, so trip cost is the sum of
  its expense lines.
- **Only approved lines count as spend.** Rejected and pending lines are excluded to keep
  figures conservative.
- **Analysis grain is one completed trip.** Cancelled and no-show trips, and zero-cost
  trips, are excluded from cost averages so they do not distort the result.
- All amounts are in USD (single currency in the data).

## Scope
- **In scope:** the five provided datasets (employees, trips, expense line items, offices,
  vendors) over the available window (2024 Q1 - 2025 Q2); cost-driver analysis and
  recommendations.
- **Out of scope:** external market airfare/hotel rate benchmarking, employee-level
  performance, and any data outside the provided tables.

## Deliverables
1. A clean, documented trip-level dataset (Python).
2. A relational database and SQL analysis (PostgreSQL).
3. A single-page executive dashboard (Power BI).
4. A root-cause analysis, financial impact estimate, and recommendation set.
