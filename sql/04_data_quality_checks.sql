-- ============================================================
-- Data Quality Checks for Used Car Auction Sales Analysis
-- Project: Car-Auctions
-- Database: MySQL 8.0+
--
-- Purpose:
--   Run this after CarAuctions.sql to document data validation,
--   reconciliation, and dashboard-readiness checks.
--
-- Expected objects from CarAuctions.sql:
--   car_sales_raw
--   car_sales_clean
--   car_sales_clean_deduped
--   vw_monthly_sales
--   vw_sales_by_make
--   vw_sales_by_state
--   vw_seller_performance
-- ============================================================

-- ------------------------------------------------------------
-- 01. Pipeline row-count reconciliation
-- ------------------------------------------------------------

SELECT
    'row_count_reconciliation' AS check_name,
    (SELECT COUNT(*) FROM car_sales_raw) AS raw_rows,
    (SELECT COUNT(*) FROM car_sales_clean) AS clean_rows,
    (SELECT COUNT(*) FROM car_sales_clean_deduped) AS deduped_rows,
    (SELECT COUNT(*) FROM car_sales_clean) -
        (SELECT COUNT(*) FROM car_sales_clean_deduped) AS duplicate_rows_removed;

-- ------------------------------------------------------------
-- 02. Required-field completeness after cleaning
-- Expected result: all issue counts should be 0.
-- ------------------------------------------------------------

SELECT
    'required_field_completeness' AS check_name,
    SUM(vin IS NULL OR vin = '') AS missing_vin,
    SUM(make IS NULL OR make = '') AS missing_make,
    SUM(model IS NULL OR model = '') AS missing_model,
    SUM(seller IS NULL OR seller = '') AS missing_seller,
    SUM(state IS NULL OR state = '') AS missing_state,
    SUM(sale_date IS NULL) AS missing_sale_date,
    SUM(sellingprice IS NULL) AS missing_selling_price,
    SUM(mmr IS NULL) AS missing_mmr,
    SUM(odometer IS NULL) AS missing_odometer,
    SUM(`condition` IS NULL) AS missing_condition
FROM car_sales_clean_deduped;

-- ------------------------------------------------------------
-- 03. Numeric validity checks
-- Expected result: all issue counts should be 0.
-- ------------------------------------------------------------

SELECT
    'numeric_validity' AS check_name,
    SUM(year < 1980 OR year > YEAR(CURDATE()) + 1) AS invalid_year,
    SUM(sellingprice <= 0) AS invalid_selling_price,
    SUM(mmr < 0) AS invalid_mmr,
    SUM(odometer < 0 OR odometer > 1000000) AS invalid_odometer,
    SUM(`condition` < 0 OR `condition` > 50) AS invalid_condition
FROM car_sales_clean_deduped;

-- ------------------------------------------------------------
-- 04. Duplicate transaction check after deduplication
-- Expected result: duplicate_transaction_groups should be 0.
-- ------------------------------------------------------------

SELECT
    'dedupe_check' AS check_name,
    COUNT(*) AS duplicate_transaction_groups
FROM (
    SELECT vin, sale_timestamp, sellingprice, COUNT(*) AS row_count
    FROM car_sales_clean_deduped
    GROUP BY vin, sale_timestamp, sellingprice
    HAVING COUNT(*) > 1
) duplicate_groups;

-- ------------------------------------------------------------
-- 05. State-code validation
-- Expected result: invalid_state_codes should be 0.
-- ------------------------------------------------------------

SELECT
    'state_code_validation' AS check_name,
    COUNT(*) AS invalid_state_codes
FROM car_sales_clean_deduped
WHERE state NOT REGEXP '^[A-Z]{2}$';

-- ------------------------------------------------------------
-- 06. Revenue reconciliation: base table vs monthly view
-- Expected result: revenue_difference should be 0.00.
-- ------------------------------------------------------------

SELECT
    'revenue_reconciliation' AS check_name,
    ROUND((SELECT SUM(sellingprice) FROM car_sales_clean_deduped), 2) AS base_table_revenue,
    ROUND((SELECT SUM(total_sales) FROM vw_monthly_sales), 2) AS monthly_view_revenue,
    ROUND(
        (SELECT SUM(sellingprice) FROM car_sales_clean_deduped) -
        (SELECT SUM(total_sales) FROM vw_monthly_sales),
        2
    ) AS revenue_difference;

-- ------------------------------------------------------------
-- 07. Dashboard KPI snapshot
-- Use this as a quick check against Power BI cards.
-- ------------------------------------------------------------

SELECT
    'dashboard_kpi_snapshot' AS check_name,
    COUNT(*) AS vehicles_sold,
    ROUND(SUM(sellingprice), 2) AS total_sales,
    ROUND(AVG(sellingprice), 2) AS avg_selling_price,
    ROUND(AVG(mmr), 2) AS avg_mmr,
    ROUND(AVG(price_vs_mmr), 2) AS avg_price_vs_mmr,
    COUNT(DISTINCT seller) AS distinct_sellers,
    COUNT(DISTINCT state) AS distinct_states,
    MIN(sale_date) AS first_sale_date,
    MAX(sale_date) AS last_sale_date
FROM car_sales_clean_deduped;

-- ------------------------------------------------------------
-- 08. Price vs. MMR distribution
-- This supports benchmark-pricing analysis.
-- ------------------------------------------------------------

SELECT
    'price_vs_mmr_distribution' AS check_name,
    ROUND(MIN(price_vs_mmr), 2) AS min_price_vs_mmr,
    ROUND(AVG(price_vs_mmr), 2) AS avg_price_vs_mmr,
    ROUND(MAX(price_vs_mmr), 2) AS max_price_vs_mmr,
    SUM(price_vs_mmr > 0) AS vehicles_above_mmr,
    SUM(price_vs_mmr = 0) AS vehicles_at_mmr,
    SUM(price_vs_mmr < 0) AS vehicles_below_mmr
FROM car_sales_clean_deduped;

-- ------------------------------------------------------------
-- 09. Top business slices for review
-- These checks help verify dashboard rankings.
-- ------------------------------------------------------------

SELECT
    make,
    COUNT(*) AS vehicles_sold,
    ROUND(SUM(sellingprice), 2) AS total_sales,
    ROUND(AVG(sellingprice), 2) AS avg_selling_price,
    ROUND(AVG(price_vs_mmr), 2) AS avg_price_vs_mmr
FROM car_sales_clean_deduped
GROUP BY make
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    state,
    COUNT(*) AS vehicles_sold,
    ROUND(SUM(sellingprice), 2) AS total_sales,
    ROUND(AVG(sellingprice), 2) AS avg_selling_price,
    ROUND(AVG(price_vs_mmr), 2) AS avg_price_vs_mmr
FROM car_sales_clean_deduped
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    seller,
    COUNT(*) AS vehicles_sold,
    ROUND(SUM(sellingprice), 2) AS total_sales,
    ROUND(AVG(sellingprice), 2) AS avg_selling_price,
    ROUND(AVG(price_vs_mmr), 2) AS avg_price_vs_mmr
FROM car_sales_clean_deduped
GROUP BY seller
ORDER BY total_sales DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 10. Outlier review queue
-- These are not automatically wrong; they are rows worth checking.
-- ------------------------------------------------------------

SELECT
    vin,
    make,
    model,
    year,
    state,
    odometer,
    `condition`,
    mmr,
    sellingprice,
    price_vs_mmr,
    sale_date,
    seller
FROM car_sales_clean_deduped
WHERE
    sellingprice >= 75000
    OR odometer >= 250000
    OR ABS(price_vs_mmr) >= 10000
ORDER BY ABS(price_vs_mmr) DESC, sellingprice DESC
LIMIT 50;
