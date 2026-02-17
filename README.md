# Customer Retention & Revenue Sustainability Analysis  
### Production-Style SQL Analytics Pipeline (PostgreSQL + Power BI)


## 1. Business Problem

E-commerce companies must balance **customer acquisition and retention** to achieve sustainable revenue growth.

While acquisition drives short-term revenue spikes, long-term profitability depends on:

- Customer retention
- Repeat purchase behavior
- Sustainable lifetime value
- Efficient marketing spend

This project analyzes customer behavior using a production-style SQL architecture to answer:

- How much revenue comes from new vs existing customers?
- How strong is month-over-month retention?
- How do cohorts behave over time?
- Are discounts contributing to sustainable revenue?
- Is marketing spend proportionate to revenue?

The objective is to simulate how analytics systems are built in real production environments — not just create dashboards.


## 2. Architecture Overview

The project follows a layered data architecture using PostgreSQL.

### Raw Layer (`raw` schema)
- Exact copy of source CSV/Excel files
- No transformations applied
- Full traceability to source data

### Staging Layer (`staging` schema)
- Data type normalization
- Date parsing (MM/DD/YYYY → DATE)
- Text cleaning and trimming
- GST percentage normalization
- Discount percentage normalization
- Month number standardization for joins

### Mart Layer (`mart` schema)

Dimensional star schema designed for analytical consumption.

#### Dimensions
- `dim_date`
- `dim_customer`
- `dim_product`

#### Fact Tables
- `fact_sales_line`
  - Grain: 1 row = 1 SKU within a transaction
  - Invoice value computed at line level
  - Explicit numeric precision (`numeric(18,2)`)

- `fact_orders`
  - Grain: 1 row = 1 transaction_id
  - Aggregated from line-level fact
  - Deterministic revenue rollups

### KPI Layer (SQL Views)

Business-facing views built on top of mart tables:

- `vw_monthly_revenue_new_vs_existing`
- `vw_cohort_retention`
- `vw_cohort_retention_rates` (0–6 month window)

All KPI logic is centralized in SQL to avoid duplication in Power BI.


## 3. Dataset Description

Source: Kaggle  
[Marketing Insights for E-Commerce Company](https://www.kaggle.com/datasets/rishikumarrajvansh/marketing-insights-for-e-commerce-company/data)

Transaction period:  
**2019-01-01 to 2019-12-31**

Dataset scale:

- 52,924 line items
- 25,061 distinct transactions
- 1,468 distinct customers
- 20 product categories
- 365 marketing spend records


## 4. Data Grain & Modeling Decisions

Primary fact table:

> 1 row = 1 product SKU within a transaction

Secondary aggregation:

> 1 row = 1 transaction_id

This ensures:

- No revenue double counting
- Product-level flexibility
- Correct order-level rollups
- Scalable dimensional modeling


## 5. Invoice Value Logic (Centralized in SQL)

Invoice value is calculated at the line-item level:


Invoice Value = ((Quantity × Avg_Price) × (1 - Discount_pct) × (1 + GST)) + Delivery_Charges


Business rules enforced:

- Discounts apply only when coupon status indicates usage.
- GST is applied at product category level.
- Numeric precision explicitly controlled (`numeric(18,2)`).
- Null-safe calculations ensure deterministic revenue.

Revenue totals reconciled after mart rebuild:

**Total Revenue: 4,877,837.47**


## 6. Data Quality Handling

During modeling, it was discovered that some `transaction_id` values mapped to multiple `customer_id`s in the raw data.

To preserve order-level grain:

- A deterministic rule was applied: `MIN(customer_id)`
- A flag `is_customer_id_conflicted` identifies affected transactions
- All KPI views exclude conflicted transactions where necessary
- Revenue totals were reconciled post-adjustment

This mirrors real-world production issue handling.


## 7. Implemented KPI Views

### 1. Monthly Revenue (New vs Existing)

- Customer classification based on first purchase month
- Revenue split by acquisition vs retention
- Order count and AOV included

### 2. Cohort Retention Matrix

- Cohort defined by first purchase month
- Retention measured as % of active customers
- Window capped at 6 months for comparability
- Long-format output optimized for BI pivot visuals


## 8. Power BI Integration

Power BI connects directly to PostgreSQL (Import mode).

- No business logic reimplemented in DAX
- SQL views used for KPI consumption
- Star schema relationships maintained
- Numeric precision issues resolved at database layer

This separation ensures:

- Maintainability
- Performance
- Architectural clarity
- Minimal BI-layer computation


## 9. Design Principles

This project emphasizes:

- Clear separation of layers
- Explicit grain declaration
- Deterministic revenue logic
- Centralized business rules in SQL
- Minimal BI over-computation
- Reproducibility
- Production-aware modeling

The goal is to demonstrate systems thinking, not just query writing.


## 10. Tools Used

- PostgreSQL 18
- pgAdmin 4
- Power BI Desktop (Live DB connection)
- GitHub


## 11. Project Status

✅ Raw ingestion completed  
✅ Staging layer implemented  
✅ Mart star schema implemented  
✅ KPI views implemented  
✅ Power BI connected live to PostgreSQL  
🔄 Dashboard design in progress  


## 12. Future Enhancements

- Predictive CLV modeling
- Churn probability modeling
- Marketing attribution modeling
- Indexing & performance simulation
- Automated data validation checks

---

*Project by [EstebanSP23](https://github.com/EstebanSP23) – Building a production-ready data analytics portfolio*
