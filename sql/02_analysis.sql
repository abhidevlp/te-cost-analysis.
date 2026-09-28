-- =====================================================================
-- Business analysis queries
-- Run against the trip_analytics table (one row per trip).
-- Cost analysis uses completed trips with cost > 0.

-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. OVERALL TREND: trips, total spend, avg & median cost per trip, by quarter
-- ---------------------------------------------------------------------
SELECT
    quarter,
    COUNT(*)                                    AS trips,
    ROUND(SUM(total_cost)::numeric, 0)          AS total_spend,
    ROUND(AVG(total_cost)::numeric, 0)          AS avg_cost_per_trip,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_cost)::numeric, 0) AS median_cost_per_trip
FROM trip_analytics
WHERE trip_status = 'completed' AND total_cost > 0
GROUP BY quarter
ORDER BY quarter;


-- 1b. Percentage change in avg cost per trip vs the previous quarter
SELECT
    quarter,
    avg_cost_per_trip,
    ROUND( (avg_cost_per_trip - LAG(avg_cost_per_trip) OVER (ORDER BY quarter))
           / LAG(avg_cost_per_trip) OVER (ORDER BY quarter) * 100, 1) AS pct_change_vs_prev_q
FROM (
    SELECT quarter, ROUND(AVG(total_cost)::numeric, 0) AS avg_cost_per_trip
    FROM trip_analytics
    WHERE trip_status = 'completed' AND total_cost > 0
    GROUP BY quarter
) q
ORDER BY quarter;

-- ---------------------------------------------------------------------
-- 2. COST COMPONENTS: which component is largest, and how each moves by quarter
-- ---------------------------------------------------------------------
SELECT
    quarter,
    ROUND(SUM(flight_cost)::numeric, 0)           AS flight,
    ROUND(SUM(hotel_cost)::numeric, 0)            AS hotel,
    ROUND(SUM(meals_cost)::numeric, 0)            AS meals,
    ROUND(SUM(ground_transport_cost)::numeric, 0) AS ground,
    ROUND(SUM(misc_cost)::numeric, 0)             AS misc,
    ROUND(AVG(flight_cost)::numeric, 0)           AS avg_flight_per_trip,
    ROUND(AVG(hotel_cost)::numeric, 0)            AS avg_hotel_per_trip
FROM trip_analytics
WHERE trip_status = 'completed' AND total_cost > 0
GROUP BY quarter
ORDER BY quarter;

-- ---------------------------------------------------------------------
-- 3. VENDOR ANALYSIS: preferred vs non-preferred vs unknown
-- ---------------------------------------------------------------------
SELECT
    preferred_vendor_flag,
    COUNT(*)                                            AS trips,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)  AS pct_of_trips,
    ROUND(AVG(total_cost)::numeric, 0)                  AS avg_cost_per_trip,
    ROUND(SUM(total_cost)::numeric, 0)                  AS total_spend
FROM trip_analytics
WHERE trip_status = 'completed' AND total_cost > 0
GROUP BY preferred_vendor_flag
ORDER BY avg_cost_per_trip DESC;

-- 3b. Cost difference: non-preferred vs preferred (single number)
SELECT
    ROUND(AVG(CASE WHEN preferred_vendor_flag = 'non_preferred' THEN total_cost END)::numeric, 0) AS avg_non_preferred,
    ROUND(AVG(CASE WHEN preferred_vendor_flag = 'preferred'     THEN total_cost END)::numeric, 0) AS avg_preferred,
    ROUND((AVG(CASE WHEN preferred_vendor_flag = 'non_preferred' THEN total_cost END)
        -  AVG(CASE WHEN preferred_vendor_flag = 'preferred'     THEN total_cost END))::numeric, 0) AS cost_gap
FROM trip_analytics
WHERE trip_status = 'completed' AND total_cost > 0;

-- ---------------------------------------------------------------------
-- 4. BOOKING BEHAVIOUR: does late booking cost more?
-- ---------------------------------------------------------------------
SELECT
    booking_window,
    COUNT(*)                            AS trips,
    ROUND(AVG(total_cost)::numeric, 0)  AS avg_cost_per_trip,
    ROUND(AVG(flight_cost)::numeric, 0) AS avg_flight_cost
FROM trip_analytics
WHERE trip_status = 'completed' AND total_cost > 0
GROUP BY booking_window
ORDER BY avg_cost_per_trip DESC;

-- ---------------------------------------------------------------------
-- 5. POLICY EXCEPTIONS: trips with vs without an exception
-- ---------------------------------------------------------------------
SELECT
    has_policy_exception,
    COUNT(*)                            AS trips,
    ROUND(AVG(total_cost)::numeric, 0)  AS avg_cost_per_trip,
    ROUND(SUM(total_cost)::numeric, 0)  AS total_spend
FROM trip_analytics
WHERE trip_status = 'completed' AND total_cost > 0
GROUP BY has_policy_exception
ORDER BY has_policy_exception;

-- ---------------------------------------------------------------------
-- 6. OFFICE / REGION: where is cost highest and where is non-preferred usage high
-- ---------------------------------------------------------------------
SELECT
    region,
    COUNT(*)                            AS trips,
    ROUND(AVG(total_cost)::numeric, 0)  AS avg_cost_per_trip,
    ROUND(SUM(total_cost)::numeric, 0)  AS total_spend,
    ROUND(100.0 * SUM(CASE WHEN preferred_vendor_flag = 'non_preferred' THEN 1 ELSE 0 END)
          / COUNT(*), 1)                AS pct_non_preferred,
    ROUND(100.0 * SUM(CASE WHEN has_policy_exception THEN 1 ELSE 0 END)
          / COUNT(*), 1)                AS pct_policy_exception
FROM trip_analytics
WHERE trip_status = 'completed' AND total_cost > 0
GROUP BY region
ORDER BY avg_cost_per_trip DESC;

-- ---------------------------------------------------------------------
-- 7. TRIP PURPOSE: which purposes cost the most
-- ---------------------------------------------------------------------
SELECT
    trip_purpose,
    COUNT(*)                            AS trips,
    ROUND(AVG(total_cost)::numeric, 0)  AS avg_cost_per_trip,
    ROUND(SUM(total_cost)::numeric, 0)  AS total_spend
FROM trip_analytics
WHERE trip_status = 'completed' AND total_cost > 0
GROUP BY trip_purpose
ORDER BY avg_cost_per_trip DESC;

-- ---------------------------------------------------------------------
-- 8. EMPLOYEE CONCENTRATION: is spend concentrated in a few travellers?
--    (top 10% of employees by spend = what share of total spend)
-- ---------------------------------------------------------------------
WITH emp_spend AS (
    SELECT employee_id, SUM(total_cost) AS emp_total
    FROM trip_analytics
    WHERE trip_status = 'completed' AND total_cost > 0
    GROUP BY employee_id
),
ranked AS (
    SELECT employee_id, emp_total,
           NTILE(10) OVER (ORDER BY emp_total DESC) AS decile
    FROM emp_spend
)
SELECT
    CASE WHEN decile = 1 THEN 'Top 10% of employees' ELSE 'Other 90%' END AS group_name,
    COUNT(*)                                                              AS employees,
    ROUND(SUM(emp_total)::numeric, 0)                                     AS total_spend,
    ROUND((100.0 * SUM(emp_total) / SUM(SUM(emp_total)) OVER ())::numeric, 1) AS pct_of_total_spend
FROM ranked
GROUP BY CASE WHEN decile = 1 THEN 'Top 10% of employees' ELSE 'Other 90%' END
ORDER BY total_spend DESC;

-- ---------------------------------------------------------------------
-- 9. HIGH-COST TRIPS: how many, and what share of spend do they carry
-- ---------------------------------------------------------------------
SELECT
    is_high_cost,
    COUNT(*)                            AS trips,
    ROUND(AVG(total_cost)::numeric, 0)  AS avg_cost_per_trip,
    ROUND(SUM(total_cost)::numeric, 0)  AS total_spend,
    ROUND((100.0 * SUM(total_cost) / SUM(SUM(total_cost)) OVER ())::numeric, 1) AS pct_of_total_spend
FROM trip_analytics
WHERE trip_status = 'completed' AND total_cost > 0
GROUP BY is_high_cost
ORDER BY is_high_cost;
