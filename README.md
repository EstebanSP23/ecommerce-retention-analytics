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

The goal is to build a **production-style analytics system**, not just a dashboard.

---

## 2. Architecture Overview

The project follows a layered data architecture:

### Raw Layer (`raw` schema)
- Exact copy of source CSV files
- No transformations applied
- Preserves traceability

### Staging Layer (`staging` schema)
- Data type normalization
- Date parsing (MM/DD/YYYY → DATE)
- Text cleaning & standardization
- Numeric conversions (GST %, discount %)

### Mart Layer (`mart` schema) *(coming next phase)*
- Fact tables
- Dimension tables
- Star schema modeling

### KPI Layer
- Revenue metrics
- Retention calculations
- Cohort analysis
- RFM segmentation
- Marketing efficiency metrics

---

## 3. Dataset Description

Source: Kaggle – [Marketing Insights for E-Commerce Company](https://www.kaggle.com/datasets/rishikumarrajvansh/marketing-insights-for-e-commerce-company/data)

Tables:

- `online_sales` – Transaction-level sales data (line-item level)
- `customer_data` – Customer demographic data
- `discount_coupon` – Monthly category-level coupon discounts
- `tax_amount` – GST by product category
- `marketing_spend` – Daily marketing spend (offline & online)

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

The primary grain of the dataset:

> 1 row = 1 product line within a transaction

A transaction may contain multiple line items.

This distinction is critical to prevent revenue double-counting.

---

## 5. Key Business Metrics (Planned)

- Revenue (Invoice Value)
- Repeat Purchase Rate
- Monthly Retention
- Cohort Retention Matrix
- New vs Existing Revenue Split
- Average Order Value (AOV)
- Marketing Spend as % of Revenue
- Revenue by Category
- Discount Impact Analysis
- RFM Segmentation (Descriptive)

---

## 6. Invoice Value Formula

Invoice Value is computed at line level as:

Invoice Value = ((Quantity × Avg_Price) × (1 - Discount_pct) × (1 + GST)) + Delivery_Charges

This logic is implemented in the transformation layer to ensure consistency.

---

## 7. Design Principles

This project emphasizes:

- Clear separation of data layers
- Controlled transformations
- Proper date handling
- Avoiding BI tool over-computation
- Dimensional modeling principles
- Reproducible SQL pipeline

The objective is to simulate how analytics systems are built in real companies.

---

## 8. Tools Used

- PostgreSQL (Data modeling & SQL transformations)
- pgAdmin 4
- Power BI (Visualization layer)
- GitHub (Documentation & version control)

---

## 9. Project Status

✅ Raw ingestion completed  
✅ Staging layer completed  
🔄 Mart schema modeling in progress  
🔄 KPI views under development  
🔄 Dashboard development upcoming  

---

## 10. Future Enhancements

- Predictive CLV modeling
- Churn probability modeling
- Marketing attribution analysis
- Indexing & performance optimization simulation

---

*Project by [EstebanSP23](https://github.com/EstebanSP23) – Building a job-ready data analytics portfolio*
