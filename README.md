# Used Car Auction KPI Reporting Pipeline

This project uses **MySQL, Python, Power BI, and CSV/Excel files** to turn used-car auction transaction data into a cleaned, reporting-ready dataset and business-facing dashboard.

## At a Glance

| Area | Detail |
|---|---|
| Dataset | Public used-car auction transaction data |
| Main tools | MySQL, Power BI, Python, Excel/CSV |
| Core workflow | Raw CSV → SQL staging → validation → cleaned dataset → reporting views → dashboard |
| Business focus | Sales performance, seller comparison, vehicle mix, state trends, mileage/condition bands, price vs. MMR |
| Best-fit roles | Data Analyst, BI Analyst, Reporting Analyst, Operations Analyst |

## Recruiter Scan

This project demonstrates a practical analyst workflow:

- cleaned messy transaction data with SQL
- validated dates, prices, odometer values, VINs, and missing fields
- created derived business metrics such as vehicle age, price vs. MMR, mileage band, condition band, and price band
- built SQL reporting views for dashboard consumption
- developed a Power BI dashboard for sales, seller, state, vehicle mix, and pricing analysis
- documented a repeatable raw-data-to-dashboard process

## Business Question

How can used-car auction transaction data be cleaned, modeled, and summarized so business users can compare sales performance by time period, seller, state, vehicle type, mileage, condition, and price relative to MMR?

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
```

## Repository Structure

```text
data/       cleaned sample exports and supporting CSV/XLSX files
docs/       supporting documentation
powerbi/    Power BI dashboard file and dashboard documentation
python/     Python analysis or helper scripts
sql/        MySQL cleaning, validation, and reporting queries
```

## Power BI Dashboard

Dashboard file:

```text
powerbi/Project2_PowerBI_Dashboard.pbix
```

The dashboard supports analysis of sales performance, seller performance, state-level auction patterns, vehicle mix, price compared with MMR, mileage bands, and condition bands.

See `powerbi/README.md` for dashboard artifact notes.

## Tools Used

- **MySQL 8.0+** — data cleaning, validation, deduplication, indexing, and reporting views
- **Power BI** — dashboard design and KPI reporting
- **Python** — analysis support and reproducibility
- **Excel / CSV** — source-data handling and sample exports
- **GitHub** — project documentation and version control

## Analyst Value

This project is framed as business analytics work: take messy operational data, clean it, validate assumptions, create useful reporting fields, and make the results understandable for decision-makers.

The strongest portfolio signal is the end-to-end workflow from raw auction records to SQL-cleaned data and Power BI reporting.
