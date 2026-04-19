# Used Car Auction Sales Dashboard

## Overview
This project analyzes real-world used car auction sales data using MySQL and Power BI. The goal was to clean and transform raw transaction data, calculate business-facing sales metrics, and build an interactive dashboard for trend analysis, regional comparisons, seller performance, and pricing behavior.

## Problem Statement
The raw dataset was not immediately suitable for reporting. It contained inconsistent text values, mixed date formats, and fields that required validation and standardization before meaningful analysis could be performed. The project objective was to create an analysis-ready dataset in SQL and then build a Power BI dashboard that clearly presents sales performance and product trends.

## Tools Used
- MySQL
- Power BI
- GitHub
- Microsoft Word

## Dataset
The dataset contains vehicle auction transaction records with fields such as:
- sale date
- make
- model
- trim
- body type
- state
- seller
- odometer
- condition
- MMR
- selling price

## Methodology

### 1. Data Cleaning and Transformation
The raw CSV was imported into MySQL and cleaned through a structured SQL pipeline. The cleaning process included:
- trimming and standardizing text fields
- normalizing transmission values
- standardizing state values
- parsing mixed-format sale dates
- removing invalid or incomplete records
- creating derived analytical columns such as vehicle age, price vs MMR, odometer band, condition band, and price band

### 2. Calculations and Aggregations
SQL was used to calculate the main reporting metrics, including:
- total sales
- vehicles sold
- average selling price
- average MMR
- average price vs MMR

Aggregations were created across:
- time
- make
- model
- body type
- state
- seller

### 3. Dashboard Development
Power BI was used to create a two-page dashboard:
- **Page 1:** Executive Overview
- **Page 2:** Seller and Vehicle Analysis

Interactive slicers and drill-down features were added to improve usability.

## Dashboard Features

### Executive Overview
- Total Sales
- Vehicles Sold
- Average Selling Price
- Average Price vs MMR
- Distinct Sellers
- Monthly Sales Trend
- Top Makes by Total Sales
- Sales by State
- Vehicles Sold by Body Type

### Seller and Vehicle Analysis
- Seller Performance table
- Vehicle Mix Drilldown
- Odometer vs Selling Price scatter plot
- Transaction Detail table

## Key Insights
- The dashboard reveals how total vehicle sales change over time.
- It identifies which makes generate the highest total sales.
- It shows which body types account for the most units sold.
- It highlights which states contribute the strongest sales performance.
- It shows seller-level differences in sales volume and pricing outcomes.
- It demonstrates the relationship between odometer readings and selling price.
- It compares actual selling prices against MMR benchmarks.

## Challenges and Solutions
One major challenge was cleaning mixed-format raw data. This was addressed using a SQL cleaning pipeline that standardized fields, parsed dates, removed invalid rows, and created derived columns for analysis.

Another challenge was adapting the assignment requirements to the structure of the dataset. Because the dataset was transaction-based rather than customer-based, the customer acquisition rate was not an appropriate metric. Seller performance and transaction volume were used instead as valid substitutes.

A final challenge was improving dashboard readability. Early layouts were too dense, so chart selection, spacing, titles, and KPI formatting were refined to make the final dashboard more professional and easier to interpret.

## Optional Extension
A light trend forecasting component was explored using Power BI’s built-in forecasting on the monthly sales trend. Because the dataset covers a limited time horizon, the forecast is treated as directional rather than a long-range predictive model.

## Files in This Repository
- `sql/Project2_SQL_Code.sql` — full SQL workflow
- `powerbi/Project2_PowerBI_Dashboard.pbix` — Power BI dashboard
- `screenshots/` — dashboard images
- `docs/` — supporting Word documents

## How to Reproduce
1. Import the CSV into MySQL.
2. Run the SQL script to create the cleaned and reporting-ready tables/views.
3. Open the Power BI file.
4. Refresh the Power BI data connection.
5. Review the dashboard pages and filters.

## Portfolio Value
This project demonstrates:
- SQL data cleaning and transformation
- aggregation and metric design
- dashboard development in Power BI
- business-oriented analysis
- project documentation and presentation
