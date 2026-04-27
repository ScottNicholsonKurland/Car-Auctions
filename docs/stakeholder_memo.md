# Used Car Auction Sales — Stakeholder Memo

## Business Question
Which vehicle segments, sellers, states, and pricing patterns drive auction sales performance?

## Executive Summary
This analysis converts raw vehicle auction transactions into a reporting-ready dataset and Power BI dashboard. The dashboard helps compare sales by time, make, body type, seller, state, mileage, condition, and price relative to MMR.

## Recommended Actions
1. Monitor sellers with high volume but weak price-to-MMR performance.
2. Review mileage and condition bands where selling prices underperform benchmark values.
3. Use monthly trend views to identify seasonality or anomalous sales periods.
4. Prioritize dashboard refreshes around seller, state, and vehicle mix reporting.

## Data Quality Notes
The SQL pipeline standardizes text fields, parses sale dates, removes invalid records, validates VIN length, bounds numeric fields, and creates reporting views.

## Limitations
The dataset is historical and may not reflect current market prices. MMR is treated as a benchmark, not a causal pricing explanation.
