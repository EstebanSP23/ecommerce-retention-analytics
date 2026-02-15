# Customer Retention & Revenue Sustainability Analysis  
### Production-Style SQL Analytics Pipeline (PostgreSQL + Power BI)

---

## 1. Business Problem

E-commerce companies must balance **customer acquisition and retention** to achieve sustainable revenue growth.

This project focuses on:

- Measuring customer retention and repeat purchase behavior
- Analyzing revenue contribution from new vs existing customers
- Evaluating discount and marketing impact on revenue
- Understanding customer lifetime value (descriptive)
- Performing cohort analysis to measure monthly retention

The objective is to build a **production-style analytics system**, not just a dashboard.

---

## 2. Architecture Overview

The project follows a layered data architecture:

### Raw Layer (`raw` schema)
- Exact copy of source CSV files
- No transformations applied
- Preserves full traceability to source data

### Staging Layer (`staging` schema)
- Data type normalization
- Date parsing (MM/DD/YYYY → DATE)
- Text cleaning & standardization
- Numeric conversions (GST %, discount %)
- Month normalization for discount joins

### Mart Layer (`mart` schema)
- Dimensional star schema modeling
- Physical fact and dimension tables
- Deterministic invoice value computation
- Explicit grain enforcement and key constraints

**Dimensions**
- `dim_date`
- `dim_customer`
- `dim_product`

**Facts**
- `fact_sales_line` (line-item level)
- `fact_orders` (order-level aggregation)

### KPI Layer (SQL Views – In Progress)
- Monthly revenue analysis
- Retention calculations
- New vs existing customer revenue
- Cohort analysis
- Marketing efficiency metrics

---

## 3. Dataset Description

Source: Kaggle –  
[Marketing Insights for E-Commerce Company](https://www.kaggle.com/datasets/rishikumarrajvansh/marketing-insights-for-e-commerce-company/data)

Transaction period:  
**2019-01-01 to 2019-12-31**

Total sales rows:  
**52,924 line items**

Distinct customers:  
**1,468**

Distinct transactions:  
**25,061**

---

## 4. Data Grain

The primary fact table is modeled at the **transaction line level**:

> 1 row = 1 product SKU within a specific transaction

This ensures:
- No revenue double-counting
- Correct aggregation logic
- Product-level flexibility
- Clean order-level rollups

A secondary fact table (`fact_orders`) aggregates to:

> 1 row = 1 transaction_id

---

## 5. Invoice Value Logic

Invoice Value is computed at line level inside the mart layer:

Invoice Value = ((Quantity × Avg_Price) × (1 - Discount_pct) × (1 + GST)) + Delivery_Charges

Business rules enforced:

- Discounts apply only when coupon_status indicates usage.
- GST is applied at the product category level.
- Null handling ensures deterministic revenue calculation.

This logic is centralized in SQL to prevent duplication in the BI layer.

---

## 6. Data Quality Handling

During modeling, it was identified that some `transaction_id` values mapped to multiple `customer_id`s in the source dataset.

To preserve the intended order-level grain:

- A deterministic customer assignment rule was applied (`MIN(customer_id)`).
- A flag (`is_customer_id_conflicted`) was added to identify affected transactions.
- Revenue totals were reconciled to ensure integrity.

This approach maintains model consistency while preserving auditability.

---

## 7. Key Business Metrics

- Revenue (Invoice Value)
- Repeat Purchase Rate
- Monthly Retention
- Cohort Retention Matrix
- New vs Existing Revenue Split
- Average Order Value (AOV)
- Marketing Spend as % of Revenue
- Revenue by Category
- Discount Impact Analysis

---

## 8. Design Principles

This project emphasizes:

- Clear separation of data layers
- Controlled transformation logic
- Explicit grain declaration
- Dimensional modeling best practices
- Deterministic business logic in the data layer
- Avoiding over-computation in BI tools
- Reproducible SQL pipeline

The objective is to simulate how analytics systems are designed in real-world production environments.

---

## 9. Tools Used

- PostgreSQL (Data modeling & SQL transformations)
- pgAdmin 4
- Power BI (Visualization layer)
- GitHub (Documentation & version control)

---

## 10. Project Status

✅ Raw ingestion completed  
✅ Staging layer completed  
✅ Mart star schema implemented  
🔄 KPI views under development  
🔄 Dashboard development upcoming  

---

## 11. Future Enhancements

- Predictive CLV modeling
- Churn probability modeling
- Marketing attribution analysis
- Performance indexing simulation
- Automated data validation layer

---

*Project by [EstebanSP23](https://github.com/EstebanSP23) – Building a job-ready data analytics portfolio*
