# Executive Insights

## Business Question

Which vehicle segments, sellers, and states drive the strongest used-car auction sales performance, and where should management focus follow-up analysis?

## Audience

This summary is written for a hiring manager, business stakeholder, or operations manager who wants the answer before the technical detail.

## What This Project Shows

This project simulates a common entry-level analyst workflow:

1. Start with messy transaction-level data.
2. Clean and validate it in SQL.
3. Create reporting-ready views.
4. Build a Power BI dashboard.
5. Translate the dashboard into business recommendations.

## Core KPIs

The dashboard is designed around these measures:

| KPI | Business Meaning |
|---|---|
| Total Sales | Overall auction revenue represented in the dataset |
| Vehicles Sold | Transaction volume |
| Average Selling Price | Typical sales value per vehicle |
| Average MMR | Benchmark market value |
| Average Price vs. MMR | Whether vehicles sell above or below benchmark |
| Distinct Sellers | Breadth of seller participation |

## Analysis Themes

### 1. Sales Performance

The executive page focuses on total sales, vehicles sold, average selling price, and price performance against MMR. These measures answer whether auction performance is driven by volume, pricing, or both.

### 2. Vehicle Mix

The dashboard compares sales by make, model, body type, mileage band, condition band, and price band. This helps identify which inventory categories contribute most to revenue and which segments may be underperforming against market benchmarks.

### 3. Regional Performance

Sales by state help identify geographic concentration. This is useful for prioritizing operational review, regional inventory strategy, or seller outreach.

### 4. Seller Performance

Seller-level reporting shows which sellers contribute the most volume and revenue, and whether their vehicles tend to sell above or below MMR.

### 5. Pricing Against Benchmark

Price vs. MMR is the most important analytical feature in the project. It converts raw selling price into a benchmark-adjusted performance metric.

## Recommended Business Actions

1. **Prioritize high-volume, above-benchmark seller relationships.**
   Sellers with strong volume and positive average price vs. MMR should be reviewed as potential high-value partners.

2. **Investigate high-volume sellers with below-benchmark pricing.**
   A seller can contribute substantial revenue while still underperforming relative to MMR. Those sellers are candidates for deeper vehicle-condition, mileage, or channel analysis.

3. **Use mileage and condition bands to explain pricing differences.**
   Odometer and condition bands help explain whether low selling prices reflect poor vehicle quality or a possible pricing/process issue.

4. **Review state-level concentration risk.**
   If a small number of states account for a large share of sales, operational performance in those states should be monitored more closely.

5. **Use price vs. MMR as the primary performance diagnostic.**
   Total sales alone can reward volume without identifying whether vehicles are priced efficiently.

## Limitations

- The dataset is historical and public, not live operational data.
- The dashboard is descriptive, not causal.
- The included sample CSV is intended for portfolio demonstration; conclusions should be validated on the full dataset before business use.
- Power BI forecasting is directional because the dataset has a limited time horizon.

## Recruiter Relevance

This project directly demonstrates recurring entry-level data analyst requirements:

| Job Requirement | Where It Appears in This Project |
|---|---|
| SQL cleaning | `CarAuctions.sql` |
| Data validation | `sql/04_data_quality_checks.sql` |
| Dashboarding | Power BI `.pbix` file |
| KPI design | README, dashboard, SQL views |
| Business communication | This executive summary |
| Reproducibility | README reproduction steps |
