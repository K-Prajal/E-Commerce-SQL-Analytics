# E-Commerce SQL Analytics: Brazilian Olist Marketplace

A SQL-based analysis of ~100,000 real e-commerce orders, exploring customer geography, order fulfillment, revenue, payment behavior, and delivery performance — with a focus on finding insights that only emerge once separate tables are joined together.

**Tech stack:** MySQL 8.0, MySQL Workbench
**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)

---

## Project Overview

This project analyzes ~2 years (2016-2018) of order data from Olist, a Brazilian e-commerce marketplace, to answer practical business questions a real analytics team would ask: Where are our customers? Are orders being fulfilled successfully? What drives revenue? How do customers pay? Is delivery reliable?

The analysis progresses from single-table exploration through multi-table JOINs to cross-cutting business insights — mirroring how a real analyst builds understanding of a new dataset from the ground up.

## Repository Structure

```
E-Commerce-SQL-Analytics/
│
├── README.md
│
├── sql/
│   ├── 01_customer_analysis.sql      -- Geography, customer distribution
│   ├── 02_order_analysis.sql         -- Order status, timing trends
│   ├── 03_sales_analysis.sql         -- Revenue, top products/categories
│   ├── 04_payment_analysis.sql       -- Payment methods, installments
│   ├── 05_delivery_analysis.sql      -- On-time rate, delivery speed
│   └── 06_business_analysis.sql      -- Cross-table JOIN insights
│
├── screenshots/
│   └── (query results, if included)
│
└── data/
    └── dataset_information.md        -- Dataset source and table notes
```

## Business Questions Answered

1. Where are Olist's customers geographically concentrated, and how does that compare to where revenue and cancellations actually come from?
2. How healthy is the order fulfillment pipeline — what share of orders are delivered successfully vs. canceled or unavailable?
3. How has order volume trended over time, and are there weekly/daily shopping patterns?
4. What is the true average order value, and which product categories drive the most revenue?
5. How do customers pay, and how common is installment-based payment?
6. How reliable is delivery, and does it vary by region?
7. Does a state's share of customers match its share of revenue, cancellations, and delivery speed — or do smaller markets behave differently?

## Key Insights

**Geographic concentration.** São Paulo (SP) accounts for **41.98% of all customers** and **38.3% of total revenue** — the single largest market by a wide margin, with Rio de Janeiro (RJ) and Minas Gerais (MG) a distant second and third.

**Order fulfillment is strong but not perfect.** **97.02%** of orders reach "delivered" status; combined cancellations and unavailable-item orders account for **1.24%** of all orders.

**Raw counts and rates tell different stories.** SP has the most canceled orders in absolute terms (327, or 52.3% of all cancellations) — disproportionate to its 42% customer share. But measured as a **rate**, SP's cancellation rate (0.78%) is actually below several smaller states; Roraima (RR) has the highest rate (2.17%), though on a small base of only 46 orders.

**Revenue value doesn't track customer volume.** Despite dominating in order volume, **SP has one of the lowest average revenue-per-order figures (R$125.75)** of any state. Smaller/remote states like Paraíba (R$216.67) and Amapá (R$198.15) show significantly higher per-order spend — possibly reflecting fewer local retail alternatives driving larger online purchases.

**True average order value requires care.** Naively averaging item price (R$120.65) understates the real average order value. Correctly aggregating to the order level first gives a true average order value of **R$160.58**.

**Category revenue isn't just about volume.** Watches & Gifts generates nearly as much revenue as Health & Beauty (the top category) despite selling ~38% fewer units — indicating a much higher average price point per item.

**Installment payments are the norm.** Credit card is the dominant payment method (**73.92%**), and average payment value scales clearly with installment count — from R$95.87 (1 installment) to R$415.09 (10 installments) — reflecting the common Brazilian practice of financing purchases interest-free over several months.

**Delivery performance is regionally uneven.** **89.15%** of orders arrive on or before the estimated delivery date, with an average delivery time of **12.5 days**. But remote northern states (Roraima, Amapá, Amazonas) see delivery times of **26-29 days — roughly double the national average** — likely due to Brazil's logistics infrastructure being concentrated in the southeast. This regional delivery gap plausibly connects to the elevated cancellation rates seen in the same states.

## SQL Skills Demonstrated

- **Fundamentals:** `SELECT`, `WHERE`, aliasing, filtering with `IN` / `NOT IN`
- **Aggregation:** `COUNT`, `SUM`, `AVG`, `MAX`, `GROUP BY`, `HAVING`
- **Sorting & limiting:** `ORDER BY`, `LIMIT`
- **Joins:** Two-table and three-table `JOIN`s connecting customers, orders, order items, products, and category translations
- **Subqueries:** Scalar subqueries (percentage-of-total calculations) and derived tables (aggregating to the correct grain before analysis)
- **Conditional logic:** `CASE WHEN` for conditional counting (e.g., cancellation rate calculations)
- **Date/time functions:** `STR_TO_DATE`, `YEAR`, `MONTH`, `DAYNAME`, `HOUR`, `DATEDIFF`
- **Data quality handling:** Identifying and working around malformed CSV imports, BOM-corrupted column names, and text-based date columns using `LOAD DATA INFILE` and `STR_TO_DATE`

## About This Project

This project was built as a hands-on learning exercise to develop practical SQL and data-analysis skills using a real, messy, business-relevant dataset — including troubleshooting real data-import issues rather than working from a pre-cleaned file. All results and insights above are taken directly from queries in the `sql/` folder.

---

**Resume-ready project description:**

> Analyzed ~100K orders from a real Brazilian e-commerce marketplace (Olist) using MySQL, writing 35+ SQL queries across customer, order, revenue, payment, and delivery data. Used multi-table JOINs, subqueries, and conditional aggregation to uncover insights not visible from single-table analysis — including a customer-revenue geographic mismatch and a 2x regional delivery-time gap — while resolving real-world data-import issues (malformed CSVs, encoding artifacts) using `LOAD DATA INFILE`.
