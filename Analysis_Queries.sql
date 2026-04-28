-- ============================================
-- FULLERS360 FERRY PASSENGER ANALYSIS
-- Analytical Queries
-- Author: Mark Thomas Bundang
-- Created: March 2026
-- Description: A series of analytical SQL queries designed to extract business insights from the Fullers360 ferry passenger operation database.
-- Covers data validation, performance analysis, seasonal trends, and operational efficiency.

-- ============================================
-- Query 1: Record Count Per Table
-- Purpose: Data validation check to confirm all three tables were populated correctly after data load. Good first step before any analysis to ensure data integrity.
-- Technique: UNION ALL across multiple tables
-- ============================================

SELECT 'vessels' AS table_name, COUNT(*) AS record_count FROM vessels
UNION ALL
SELECT 'routes', COUNT(*) FROM routes
UNION ALL
SELECT 'passenger_records', COUNT(*) FROM passenger_records;

-- ============================================
-- Query 2: Total Passengers by Route
-- Purpose: Identify which ferry routes carry the most passengers across the full year. Useful for capacity planning, resource allocation, and identifying high-demand routes.
-- Technique: JOIN, GROUP BY, aggregate functions (SUM, COUNT, AVG)
-- ============================================

SELECT
    r.route_name,
    COUNT(pr.record_id)               AS trip_records,
    SUM(pr.passenger_count)           AS total_passengers,
    ROUND(AVG(pr.passenger_count), 0) AS avg_daily_passengers
FROM passenger_records pr
JOIN routes r ON pr.route_id = r.route_id
GROUP BY r.route_name
ORDER BY total_passengers DESC;

-- ============================================
-- Query 3: Passengers by Season
-- Purpose: Understand how passenger demand shifts across Peak, Shoulder, and Off-Peak seasons. Supports scheduling decisions and seasonal staffing/resource planning.
-- Technique: GROUP BY with aggregate functions on a categorical column
-- ============================================

SELECT
    season,
    COUNT(*)                          AS records,
    SUM(passenger_count)              AS total_passengers,
    ROUND(AVG(passenger_count), 0)    AS avg_per_record
FROM passenger_records
GROUP BY season
ORDER BY total_passengers DESC;

-- ============================================
-- Query 4: Busiest Vessel Ranking
-- Purpose: Determine which vessels carry the highest passenger volumes across the network. Helps inform maintenance scheduling, fleet deployment decisions, and vessel retirement
-- planning.
-- Technique: JOIN between passenger_records and vessels, GROUP BY with SUM and COUNT
-- ============================================

SELECT
    v.vessel_name,
    v.vessel_type,
    v.capacity,
    COUNT(pr.record_id)               AS trips_recorded,
    SUM(pr.passenger_count)           AS total_passengers
FROM passenger_records pr
JOIN vessels v ON pr.vessel_id = v.vessel_id
GROUP BY v.vessel_name, v.vessel_type, v.capacity
ORDER BY total_passengers DESC;

-- ============================================
-- Query 5: Weekend vs Weekday Comparison
-- Purpose: Analyse whether passenger behaviour differs between weekdays and weekends. Useful for targeted pricing strategies, promotional campaigns, and staffing level adjustments.
-- Technique: CASE WHEN to transform a boolean flag into a readable label, GROUP BY
-- ============================================

SELECT
    CASE WHEN is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(*)                          AS records,
    SUM(passenger_count)              AS total_passengers,
    ROUND(AVG(passenger_count), 0)    AS avg_passengers
FROM passenger_records
GROUP BY is_weekend;

-- ============================================
-- Query 6: Monthly Passenger Trend
-- Purpose: Track passenger volume month by month across the full calendar year to identify seasonal peaks, winter troughs, and recovery patterns. Supports annual forecasting and budget planning.
-- Technique: MONTHNAME() and MONTH() date functions, GROUP BY multiple columns, RDER BY month number for chronological display
-- ============================================

SELECT
    MONTHNAME(travel_date)            AS month_name,
    MONTH(travel_date)                AS month_num,
    season,
    SUM(passenger_count)              AS total_passengers
FROM passenger_records
GROUP BY MONTHNAME(travel_date), MONTH(travel_date), season
ORDER BY month_num;

-- ============================================
-- Query 7: Full Route and Vessel Detail with  Occupancy Rate
-- Purpose: Provide a granular daily view of network operations — combining route, vessel, and passenger data in a single output. The occupancy percentage shows how efficiently
-- each vessel's capacity is being utilised per trip, which is a key operational efficiency metric.
-- Technique: Three-table JOIN across passenger_records, routes, and vessels. CASE WHEN for day type label. ROUND with calculated occupancy formula.
-- Note: Occupancy = passengers / (capacity x daily trips) expressed as a percentage
-- ============================================

SELECT
    pr.travel_date,
    r.route_name,
    r.origin,
    r.destination,
    v.vessel_name,
    v.vessel_type,
    v.capacity,
    pr.passenger_count,
    pr.season,
    CASE WHEN pr.is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    ROUND((pr.passenger_count / v.capacity / pr.daily_trips) * 100, 1) AS avg_occupancy_pct
FROM passenger_records pr
JOIN routes r  ON pr.route_id  = r.route_id
JOIN vessels v ON pr.vessel_id = v.vessel_id
ORDER BY pr.travel_date, r.route_name;
