-- ============================================
-- MySQL 8.0+ cleaning script for car_prices.csv
-- Project: Used Car Auction Sales Analysis
-- ============================================

-- Recommended session settings
SET sql_safe_updates = 0;

-- ============================================
-- 01. RAW TABLE
-- ============================================

DROP TABLE IF EXISTS car_sales_raw;

CREATE TABLE car_sales_raw (
    year_val        INT,
    make            VARCHAR(100),
    model           VARCHAR(150),
    trim_name       VARCHAR(150),
    body            VARCHAR(100),
    transmission    VARCHAR(50),
    vin             VARCHAR(32),
    state           VARCHAR(10),
    `condition`     DECIMAL(10,2),
    odometer        DECIMAL(12,2),
    color           VARCHAR(50),
    interior        VARCHAR(50),
    seller          VARCHAR(255),
    mmr             DECIMAL(12,2),
    sellingprice    DECIMAL(12,2),
    saledate        VARCHAR(120)
);

-- Example load command.
-- Adjust the path to where the CSV lives on your MySQL server host.
-- You may need secure_file_priv configured, or use a GUI import.
--
-- LOAD DATA INFILE '/path/to/car_prices.csv'
-- INTO TABLE car_sales_raw
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- ESCAPED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (year_val, make, model, trim_name, body, transmission, vin, state,
--  @condition_in, @odometer_in, color, interior, seller, @mmr_in, @sellingprice_in, saledate)
-- SET
--   `condition`  = NULLIF(@condition_in, ''),
--   odometer     = NULLIF(@odometer_in, ''),
--   mmr          = NULLIF(@mmr_in, ''),
--   sellingprice = NULLIF(@sellingprice_in, '');

-- ============================================
-- 02. OPTIONAL PROFILING CHECKS
-- ============================================

SELECT COUNT(*) AS total_rows
FROM car_sales_raw;

SELECT
    COUNT(*) AS total_rows,
    SUM(make IS NULL OR TRIM(make) = '') AS make_missing,
    SUM(model IS NULL OR TRIM(model) = '') AS model_missing,
    SUM(vin IS NULL OR TRIM(vin) = '') AS vin_missing,
    SUM(sellingprice IS NULL) AS sellingprice_missing,
    SUM(saledate IS NULL OR TRIM(saledate) = '') AS saledate_missing
FROM car_sales_raw;

SELECT transmission, COUNT(*) AS row_count
FROM car_sales_raw
GROUP BY transmission
ORDER BY row_count DESC;

SELECT state, COUNT(*) AS row_count
FROM car_sales_raw
GROUP BY state
ORDER BY row_count DESC;

-- ============================================
-- 03. CLEAN TABLE
-- ============================================

DROP TABLE IF EXISTS car_sales_clean;

CREATE TABLE car_sales_clean AS
WITH standardized AS (
    SELECT
        year_val,

        NULLIF(TRIM(make), '') AS make_raw,
        NULLIF(TRIM(model), '') AS model_raw,
        NULLIF(TRIM(trim_name), '') AS trim_raw,
        NULLIF(TRIM(body), '') AS body_raw,
        NULLIF(TRIM(transmission), '') AS transmission_raw,
        NULLIF(TRIM(vin), '') AS vin_raw,
        NULLIF(TRIM(state), '') AS state_raw,
        `condition`,
        odometer,
        NULLIF(TRIM(color), '') AS color_raw,
        NULLIF(TRIM(interior), '') AS interior_raw,
        NULLIF(REGEXP_REPLACE(TRIM(seller), '\\s+', ' '), '') AS seller_raw,
        mmr,
        sellingprice,
        NULLIF(TRIM(saledate), '') AS saledate_raw
    FROM car_sales_raw
),
normalized AS (
    SELECT
        year_val AS year,

        CONCAT(
            UPPER(LEFT(LOWER(make_raw), 1)),
            SUBSTRING(LOWER(make_raw), 2)
        ) AS make,

        CONCAT(
            UPPER(LEFT(LOWER(model_raw), 1)),
            SUBSTRING(LOWER(model_raw), 2)
        ) AS model,

        trim_raw AS trim_name,

        CASE
            WHEN body_raw IS NULL THEN NULL
            ELSE CONCAT(UPPER(LEFT(LOWER(body_raw), 1)), SUBSTRING(LOWER(body_raw), 2))
        END AS body,

        CASE
            WHEN transmission_raw IS NULL THEN NULL
            WHEN LOWER(transmission_raw) IN ('automatic', 'auto', 'a/t') THEN 'Automatic'
            WHEN LOWER(transmission_raw) IN ('manual', 'man', 'm/t') THEN 'Manual'
            ELSE NULL
        END AS transmission,

        LOWER(vin_raw) AS vin,
        UPPER(state_raw) AS state,
        `condition`,
        odometer,

        CASE
            WHEN color_raw IS NULL THEN NULL
            WHEN LOWER(color_raw) IN ('—', '-', 'n/a', 'na', 'unknown', 'not available') THEN NULL
            ELSE CONCAT(UPPER(LEFT(LOWER(color_raw), 1)), SUBSTRING(LOWER(color_raw), 2))
        END AS color,

        CASE
            WHEN interior_raw IS NULL THEN NULL
            WHEN LOWER(interior_raw) IN ('—', '-', 'n/a', 'na', 'unknown', 'not available') THEN NULL
            ELSE CONCAT(UPPER(LEFT(LOWER(interior_raw), 1)), SUBSTRING(LOWER(interior_raw), 2))
        END AS interior,

        seller_raw AS seller,
        mmr,
        sellingprice,
        saledate_raw,

        -- Example incoming format:
        -- Tue Dec 16 2014 12:30:00 GMT-0800 (PST)
        STR_TO_DATE(
            TRIM(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(saledate_raw, ' GMT[+-][0-9]{4}', ''),
                    ' \\([A-Za-z]+\\)$',
                    ''
                )
            ),
            '%a %b %d %Y %H:%i:%s'
        ) AS sale_timestamp
    FROM standardized
),
validated AS (
    SELECT *
    FROM normalized
    WHERE
        vin IS NOT NULL
        AND CHAR_LENGTH(vin) = 17
        AND make IS NOT NULL
        AND model IS NOT NULL
        AND seller IS NOT NULL
        AND sale_timestamp IS NOT NULL

        AND year IS NOT NULL
        AND year BETWEEN 1980 AND YEAR(CURDATE()) + 1

        AND sellingprice IS NOT NULL
        AND sellingprice > 0

        AND mmr IS NOT NULL
        AND mmr >= 0

        AND odometer IS NOT NULL
        AND odometer >= 0
        AND odometer <= 1000000

        AND `condition` IS NOT NULL
        AND `condition` >= 0
        AND `condition` <= 50

        AND state REGEXP '^[A-Z]{2}$'
)
SELECT
    year,
    make,
    model,
    trim_name,
    body,
    transmission,
    vin,
    state,
    `condition`,
    odometer,
    color,
    interior,
    seller,
    mmr,
    sellingprice,
    saledate_raw,
    sale_timestamp,
    DATE(sale_timestamp) AS sale_date,
    YEAR(sale_timestamp) AS sale_year,
    MONTH(sale_timestamp) AS sale_month,
    DATE_FORMAT(sale_timestamp, '%Y-%m') AS sale_year_month,

    YEAR(sale_timestamp) - year AS vehicle_age,
    sellingprice - mmr AS price_vs_mmr,
    ROUND(sellingprice / NULLIF(mmr, 0), 4) AS price_ratio_to_mmr,

    CASE
        WHEN odometer < 25000 THEN 'Low Mileage'
        WHEN odometer < 75000 THEN 'Medium Mileage'
        ELSE 'High Mileage'
    END AS odometer_band,

    CASE
        WHEN `condition` < 10 THEN 'Low'
        WHEN `condition` < 30 THEN 'Medium'
        ELSE 'High'
    END AS condition_band,

    CASE
        WHEN sellingprice < 10000 THEN 'Budget'
        WHEN sellingprice < 25000 THEN 'Mid-Market'
        ELSE 'Premium'
    END AS price_band
FROM validated;

-- ============================================
-- 04. DEDUPLICATION
-- ============================================

DROP TABLE IF EXISTS car_sales_clean_deduped;

CREATE TABLE car_sales_clean_deduped AS
SELECT *
FROM (
    SELECT
        c.*,
        ROW_NUMBER() OVER (
            PARTITION BY vin, sale_timestamp, sellingprice
            ORDER BY odometer ASC, mmr DESC
        ) AS rn
    FROM car_sales_clean c
) ranked
WHERE rn = 1;

ALTER TABLE car_sales_clean_deduped
    DROP COLUMN rn;

-- ============================================
-- 05. INDEXES
-- ============================================

CREATE INDEX idx_car_sales_clean_sale_date
    ON car_sales_clean_deduped (sale_date);

CREATE INDEX idx_car_sales_clean_make
    ON car_sales_clean_deduped (make);

CREATE INDEX idx_car_sales_clean_state
    ON car_sales_clean_deduped (state);

CREATE INDEX idx_car_sales_clean_seller
    ON car_sales_clean_deduped (seller(100));

CREATE INDEX idx_car_sales_clean_vin
    ON car_sales_clean_deduped (vin);

-- ============================================
-- 06. ANALYTICS VIEWS
-- ============================================

DROP VIEW IF EXISTS vw_monthly_sales;
CREATE VIEW vw_monthly_sales AS
SELECT
    sale_year_month,
    MIN(sale_date) AS month_start,
    COUNT(*) AS vehicles_sold,
    SUM(sellingprice) AS total_sales,
    ROUND(AVG(sellingprice), 2) AS avg_selling_price,
    ROUND(AVG(mmr), 2) AS avg_mmr,
    ROUND(AVG(price_vs_mmr), 2) AS avg_price_vs_mmr
FROM car_sales_clean_deduped
GROUP BY sale_year_month;

DROP VIEW IF EXISTS vw_sales_by_make;
CREATE VIEW vw_sales_by_make AS
SELECT
    make,
    COUNT(*) AS vehicles_sold,
    SUM(sellingprice) AS total_sales,
    ROUND(AVG(sellingprice), 2) AS avg_selling_price,
    ROUND(AVG(price_vs_mmr), 2) AS avg_price_vs_mmr
FROM car_sales_clean_deduped
GROUP BY make;

DROP VIEW IF EXISTS vw_sales_by_state;
CREATE VIEW vw_sales_by_state AS
SELECT
    state,
    COUNT(*) AS vehicles_sold,
    SUM(sellingprice) AS total_sales,
    ROUND(AVG(sellingprice), 2) AS avg_selling_price
FROM car_sales_clean_deduped
GROUP BY state;

DROP VIEW IF EXISTS vw_seller_performance;
CREATE VIEW vw_seller_performance AS
SELECT
    seller,
    COUNT(*) AS vehicles_sold,
    SUM(sellingprice) AS total_sales,
    ROUND(AVG(sellingprice), 2) AS avg_selling_price,
    ROUND(AVG(price_vs_mmr), 2) AS avg_price_vs_mmr
FROM car_sales_clean_deduped
GROUP BY seller;

-- ============================================
-- 07. VALIDATION CHECKS
-- ============================================

SELECT COUNT(*) AS cleaned_rows
FROM car_sales_clean_deduped;

SELECT
    MIN(sale_date) AS min_sale_date,
    MAX(sale_date) AS max_sale_date,
    MIN(sellingprice) AS min_price,
    MAX(sellingprice) AS max_price,
    MIN(odometer) AS min_odometer,
    MAX(odometer) AS max_odometer
FROM car_sales_clean_deduped;

SELECT transmission, COUNT(*) AS row_count
FROM car_sales_clean_deduped
GROUP BY transmission
ORDER BY row_count DESC;

SELECT state, COUNT(*) AS row_count
FROM car_sales_clean_deduped
GROUP BY state
ORDER BY row_count DESC;
