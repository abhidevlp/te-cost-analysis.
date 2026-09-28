# Travel & Expense (T&E) Cost-Driver Analysis

End-to-end data analytics project: **Python -> PostgreSQL -> Power BI**. I investigate why
the average cost per business trip rose, find the real drivers, and size the savings.

---

## Dashboard

![T&E cost analysis dashboard](docs/dashboard.png)

## The question

Leadership believed the average cost per trip had jumped ~18% while trip volume fell.
Is that true, and if so, why - and what can be done about it?

## The answer (headline)

- Cost per trip rose **~11%, not 18%** - and **volume was flat, not down**. (I corrected
  the assumption with evidence.)
- **90% of spend is flights + hotels.**
- Three behaviors raise the cost of the same trip: **non-preferred vendors (+$182)**,
  **policy exceptions (+$139)**, **last-minute booking (+$109)**.
- Worst compliance is in **LATAM/APAC**; most total spend is in **EMEA**.
- **~$130K/window (~$86K annual)** is realistically capturable - a compliance fix, not a
  travel cut.

---

## Tech stack

| Stage | Tool | What I did |
|-------|------|-----------|
| Clean & prepare | Python (pandas, Jupyter) | profiling, cleaning, feature engineering |
| Store & analyze | PostgreSQL (SQL) | relational schema + 9 analytical queries |
| Visualize | Power BI | single-page executive dashboard (KPIs, trend, drivers) |

## Data

5 related tables: `employees`, `trips`, `expense_line_items`, `offices`, `vendors`.
Trip cost is **derived** by summing approved expense lines per trip (there is no single
cost column). Final analysis grain = **one completed trip** (4,060 trips, ~$3.8M spend).

---

## Repo structure

```
te-cost-analysis/
  python/     data profiling, cleaning, and feature engineering (Jupyter)
  sql/        PostgreSQL schema and the analysis queries
  powerbi/    the dashboard (.pbix)
  docs/       the written analysis
  data/        raw and processed CSVs (kept private, not committed)
```

The raw datasets are company data, so they are not published here. Everything else - the
notebooks, SQL, dashboard, and analysis - is included so the work can be followed end to end.

## Running it yourself

With the five source tables in `data/raw/`, the pipeline runs in order: the Python
notebooks clean the data and build the trip-level table, `06_load_postgres.ipynb` loads it
into a PostgreSQL database (`te_analysis`), and `sql/02_analysis.sql` produces the analysis.
The Power BI file reads the processed trip table for the dashboard.

---

## Read the analysis (in order)

| Doc | What it covers |
|-----|----------------|
| `docs/01_project_brief.md` | business problem, objective, KPIs, scope |
| `docs/02_data_understanding.md` | tables, keys, relationships, grain |
| `python/05_build_features.ipynb` | how trip cost + features were built |
| `sql/02_analysis.sql` | the SQL analysis |
| `docs/07_root_cause.md` | why cost rose (the drivers) |
| `docs/08_financial_impact.md` | how much is realistically addressable |
| `docs/11_recommendations.md` | Problem -> Evidence -> Impact -> Action |
| `docs/12_executive_story.md` | the executive summary |

## Key skills shown

Data cleaning & validation, feature engineering, SQL (joins, window functions,
aggregation), relational modeling, BI dashboarding, and - most importantly - turning data
into a clear business recommendation while correcting a wrong assumption with evidence.
