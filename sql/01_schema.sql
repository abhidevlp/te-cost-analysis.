
DROP TABLE IF EXISTS expenses CASCADE;
DROP TABLE IF EXISTS trips CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS offices CASCADE;
DROP TABLE IF EXISTS vendors CASCADE;
DROP TABLE IF EXISTS trip_analytics CASCADE;

CREATE TABLE offices (
    office_id        INT PRIMARY KEY,
    city             TEXT,
    country          TEXT,
    region           TEXT,
    cost_center_code TEXT
);

CREATE TABLE vendors (
    vendor_id           INT PRIMARY KEY,
    vendor_name         TEXT,
    vendor_type         TEXT,
    is_preferred_vendor BOOLEAN,
    contract_start_date DATE
);

CREATE TABLE employees (
    employee_id       INT PRIMARY KEY,
    full_name         TEXT,
    office_id         INT REFERENCES offices(office_id),
    department        TEXT,
    job_level         TEXT,
    hire_date         DATE,
    employment_status TEXT
);

CREATE TABLE trips (
    trip_id             INT PRIMARY KEY,
    employee_id         INT REFERENCES employees(employee_id),
    client_project_code TEXT,
    destination_city    TEXT,
    trip_purpose        TEXT,
    booking_channel     TEXT,
    vendor_id           INT,               -- nullable: some trips have no vendor
    booked_date         DATE,
    trip_start_date     DATE,
    trip_end_date       DATE,
    trip_status         TEXT
);

CREATE TABLE expenses (
    line_item_id        INT PRIMARY KEY,
    trip_id             INT REFERENCES trips(trip_id),
    category            TEXT,
    amount              NUMERIC(12,2),
    currency            TEXT,
    submitted_date      DATE,
    approval_status     TEXT,
    is_policy_exception BOOLEAN,
    exception_reason    TEXT,
    approved_by_level   TEXT,
    is_approved         BOOLEAN
);


CREATE TABLE trip_analytics (
    trip_id                INT PRIMARY KEY,
    employee_id            INT,
    client_project_code    TEXT,
    destination_city       TEXT,
    trip_purpose           TEXT,
    booking_channel        TEXT,
    vendor_id              NUMERIC,
    booked_date            DATE,
    trip_start_date        DATE,
    trip_end_date          DATE,
    trip_status            TEXT,
    date_was_reversed      BOOLEAN,
    has_vendor             BOOLEAN,
    vendor_id_clean        NUMERIC,
    total_cost             NUMERIC(12,2),
    flight_cost            NUMERIC(12,2),
    hotel_cost             NUMERIC(12,2),
    meals_cost             NUMERIC(12,2),
    ground_transport_cost  NUMERIC(12,2),
    misc_cost              NUMERIC(12,2),
    policy_exception_count NUMERIC,
    department             TEXT,
    job_level              TEXT,
    office_id              NUMERIC,
    city                   TEXT,
    country                TEXT,
    region                 TEXT,
    vendor_name            TEXT,
    is_preferred_vendor    BOOLEAN,
    booking_lead_days      NUMERIC,
    trip_duration_days     NUMERIC,
    year                   NUMERIC,
    quarter                TEXT,
    month                  TEXT,
    preferred_vendor_flag  TEXT,
    booking_window         TEXT,
    has_policy_exception   BOOLEAN,
    is_high_cost           BOOLEAN
);
