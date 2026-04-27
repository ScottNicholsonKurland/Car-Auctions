# Used Car Auction Sales Dashboard

## Executive Summary

This project uses MySQL and Power BI to clean, model, and visualize used-car auction transaction data.

The project demonstrates an analyst workflow from messy raw transaction data to a reporting-ready dataset and interactive dashboard. The emphasis is on SQL cleaning, validation, metric design, and business-facing dashboard structure.

## Business Question

How can used-car auction data be cleaned and transformed into a dashboard that helps compare sales performance by time period, vehicle type, state, make/model, seller, mileage, and pricing against MMR?

## Tools Used

- MySQL 8.0+
- Power BI
- Excel / CSV
- GitHub

## Dataset

The project uses the public Kaggle used-car auction prices dataset.

Important fields include:

- sale date and sale time
- make, model, trim, and body type
- transmission
- VIN
- state
- vehicle condition
- odometer
- seller
- MMR
- selling price

## SQL Cleaning Pipeline

The SQL workflow in `CarAuctions.sql` creates:

- raw import table
- profiling checks
- cleaned analytical table
- deduplicated table
- indexes
- reporting views
- validation checks

The cleaning process includes:

- trimming and standardizing text fields
- normalizing transmission values
- standardizing state abbreviations
- parsing mixed-format sale dates
- removing invalid or incomplete rows
- validating VIN length
- bounding year, odometer, condition, selling price, and MMR values
- creating derived analytical columns

## Derived Columns

The cleaned table creates business-facing fields including:

- `vehicle_age`
- `price_vs_mmr`
- `price_ratio_to_mmr`
- `odometer_band`
- `condition_band`
- `price_band`
- `sale_year_month`

## Reporting Views

The SQL script builds reporting views for:

- monthly sales
- sales by make
- sales by state
- seller performance

## Dashboard Pages

The Power BI dashboard contains two main pages:

1. **Executive Overview**
   - total sales
   - vehicles sold
   - average selling price
   - average price vs MMR
   - monthly sales trend
   - top makes
   - sales by state
   - vehicles sold by body type

2. **Seller and Vehicle Analysis**
   - seller performance
   - vehicle mix drilldown
   - odometer vs selling price
   - transaction detail table

## Files in This Repository

- `CarAuctions.sql` — MySQL cleaning, validation, deduplication, indexing, and reporting-view script
- `Project2_PowerBI_Dashboard.pbix` — Power BI dashboard file
- `car_prices_cleaned_1000_rows.csv` — cleaned sample data
- `car_prices_cleaned_1000_rows.xlsx` — Excel version of cleaned sample data
- `README.md` — project documentation

## How to Reproduce

1. Import the auction CSV into MySQL as `car_sales_raw`.
2. Run `CarAuctions.sql`.
3. Confirm validation checks return plausible row counts, dates, prices, odometer values, and state counts.
4. Open `Project2_PowerBI_Dashboard.pbix`.
5. Refresh the Power BI data connection.
6. Review the dashboard pages and slicers.

## Portfolio Value

This project demonstrates:

- SQL data cleaning
- data validation
- derived business metrics
- SQL views for reporting
- dashboard design in Power BI
- communication of business insights from transactional data
