# Used Car Auction KPI Reporting Pipeline

## Recruiter Scan

This project demonstrates a practical junior data analyst workflow:

- cleaned messy transaction data with SQL
- validated dates, prices, odometer values, VINs, and missing fields
- created derived business metrics such as vehicle age, price vs. MMR, mileage band, condition band, and price band
- built SQL reporting views for dashboard consumption
- developed a Power BI dashboard for sales, seller, state, vehicle mix, and pricing analysis
- documented a repeatable raw-data-to-dashboard process

**Best match roles:** Data Analyst, BI Analyst, Reporting Analyst, Operations Analyst, Financial Data Analyst.

## Executive Summary

This project uses MySQL and Power BI to convert used-car auction transaction data into a reporting-ready dataset and business-facing dashboard.

The source data contains auction transactions with vehicle details, seller information, odometer readings, condition scores, market benchmark values, and selling prices. The analysis cleans and standardizes those records, creates derived KPI fields, builds reporting views, and presents the results in a Power BI dashboard.

The emphasis is not on advanced modeling. The emphasis is on the work analysts are commonly expected to perform in business settings: clean messy data, validate assumptions, build useful metrics, and communicate results clearly.

## Business Question

How can used-car auction transaction data be cleaned, modeled, and summarized so that business users can compare sales performance by time period, seller, state, vehicle type, mileage, condition, and price relative to MMR?

## Tools Used

- **MySQL 8.0+** — data cleaning, validation, deduplication, indexing, and reporting views
- **Power BI** — dashboard design and KPI reporting
- **Excel / CSV** — source-data handling and sample exports
- **GitHub** — project documentation and version control

## Dataset

The project uses a public used-car auction prices dataset from Kaggle.

Key fields include:

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

## Data Pipeline

```text
Raw CSV
  ↓
car_sales_raw
  ↓
profiling checks
  ↓
car_sales_cleaned
  ↓
deduplicated analytical table
  ↓
reporting views
  ↓
Power BI dashboard
