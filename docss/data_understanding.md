# Data Understanding

Five tables were provided. Below, each is documented **from the actual columns present**


## 1. `employees`
- **Grain:** one row = one employee.
- **Columns:** `employee_id` (PK), `full_name`, `office_id` (FK → offices.office_id),
  `department`, `job_level` (Analyst / Consultant / Manager / Partner), `hire_date`,
  `employment_status` (active / terminated).
- **Role in analysis:** links a trip to an **office → region** and to
  department / job_level for segmentation.
- **Notes:** `full_name` is not unique (e.g. repeated names) — `employee_id` is the key.
  Some employees are `terminated`; they can still own historical trips.

## 2. `offices`
- **Grain:** one row = one office location.
- **Columns:** `office_id` (PK), `city`, `country`, `region` (NA / EMEA / APAC / LATAM),
  `cost_center_code`.
- **Role:** provides the **geographic dimension** (city / country / region) used for the
  office and regional analysis. Joined only through `employees.office_id`.
- **Notes:** small, clean dimension (15 rows). `region` is the roll-up level for the CFO view.

## 3. `vendors`
- **Grain:** one row = one travel vendor.
- **Columns:** `vendor_id` (PK), `vendor_name`, `vendor_type` (airline / hotel / car_rental),
  `is_preferred_vendor` (True/False), `contract_start_date`.
- **Role:** provides the **preferred-vendor flag**, the central lever for the vendor-compliance
  investigation. Joined through `trips.vendor_id`.
- **Notes:**
  - `contract_start_date` is blank exactly when `is_preferred_vendor = False` (non-preferred
    vendors have no contract) — this is consistent, not a data error.
  - `vendor_type` on a vendor does not always match the trip's dominant expense type; the trip
    references a single booking `vendor_id`, so we treat the vendor primarily via its
    **preferred flag**, not its type.

## 4. `trips`
- **Grain:** one row = one trip (a single business travel event by one employee).
- **Columns:** `trip_id` (PK), `employee_id` (FK → employees), `client_project_code`,
  `destination_city`, `trip_purpose` (client_site_visit / internal_meeting / conference /
  training), `booking_channel` (self_booked_online / corporate_travel_desk / offline_agent),
  `vendor_id` (FK → vendors, **nullable**), `booked_date`, `trip_start_date`, `trip_end_date`,
  `trip_status` (completed / cancelled / no_show).
- **Role:** the **spine of the analysis**. Every behavioural dimension (lead time, channel,
  vendor, purpose, destination, status) lives here, but **cost does not** — cost is joined
  from expenses.
- **Notes / data facts:**
  - **No cost column.** Trip cost must be derived from `expense_line_items`.
  - `vendor_id` is **missing on some trips** → treat as "unknown vendor".
  - A few `trip_end_date` values precede `trip_start_date` (a data quality issue flagged
    and fixed during cleaning, e.g. trips where end < start).
  - `booked_date` can be before or close to `trip_start_date`; lead time is derived from these.

## 5. `expense_line_items`
- **Grain:** **one row = one expense line on a trip** (the finest grain in the dataset).
- **Columns:** `line_item_id` (PK), `trip_id` (FK → trips), `category` (flight / hotel /
  meals / ground_transport / misc), `amount`, `currency` (USD), `submitted_date`,
  `approval_status` (approved / rejected / pending), `is_policy_exception` (True/False),
  `exception_reason`, `approved_by_level` (Team Lead / Manager / Director).
- **Role:** the **money table**. All spend, cost components, and policy-exception flags come
  from here. Aggregated up to `trip_id` to produce trip cost.
- **Notes / data facts:**
  - A trip has **many** expense lines (1-to-many from trips).
  - `exception_reason` is only populated when `is_policy_exception = True` (blank otherwise).
  - `approval_status` matters for financial figures: only **approved** lines are real spend.
  - Not every `trip_id` in trips necessarily has expense lines, and the reverse is checked
    during profiling (every expense `trip_id` should exist in trips).

---

## Relationships (logical model)
```
offices (1) ────< employees (1) ────< trips (1) ────< expense_line_items (many)
                                        │
                            vendors (1) ┘  (via trips.vendor_id, nullable)
```
- `offices.office_id` 1 —— * `employees.office_id`
- `employees.employee_id` 1 —— * `trips.employee_id`
- `trips.trip_id` 1 —— * `expense_line_items.trip_id`
- `vendors.vendor_id` 1 —— * `trips.vendor_id`  (optional / nullable)

## Grain of the final analytical table
> **One row = one completed trip**, enriched with: total trip cost, per-component costs
> (flight / hotel / meals / ground_transport / misc), booking lead time, trip duration,
> preferred-vendor flag, policy-exception flag/count, region/office/department, purpose,
> channel, and quarter. This is the table the SQL analysis and Power BI model are built on.

## Limitations identified up front
- **No native trip cost** → all cost is reconstructed; results depend on the approved-line rule.
- **Nullable vendor_id** → vendor-compliance rate is computed over trips with a known vendor,
  with "unknown" reported separately (not dropped).
- **Vendor type vs trip context mismatch** → we rely on the preferred flag, not vendor_type.
- **Some invalid trip dates** (end before start) → flagged and handled in cleaning, not silently kept.
