# E-Commerce SQL Analytics: Brazilian Olist Marketplace

A SQL analysis of ~100,000 real e-commerce orders from Olist, a Brazilian online marketplace. I explored customer geography, order fulfillment, revenue, payments, and delivery performance, with a particular focus on insights that only show up once you join tables together rather than looking at any one table alone.

**Tech stack:** MySQL 8.0, MySQL Workbench
**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)

---

## Project Overview

This project works through ~2 years (2016-2018) of Olist order data to answer questions a business would actually care about: where are our customers, are orders getting fulfilled, what's driving revenue, how do people pay, and is delivery reliable?

I built this up gradually, starting with single-table exploration (counts, grouping, filtering) and working up to multi-table joins and cross-cutting questions once I was comfortable with the basics.

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

1. Where are Olist's customers concentrated, and does that match where the revenue and cancellations actually come from?
2. How healthy is the order pipeline — what share of orders are delivered vs. canceled or unavailable?
3. How has order volume trended over time, and are there weekly or daily shopping patterns?
4. What's the real average order value, and which product categories bring in the most revenue?
5. How do people pay, and how common are installment payments?
6. Is delivery reliable, and does that vary by region?
7. Does a state's share of customers actually match its share of revenue, cancellations, and delivery speed?

## Key Insights

São Paulo (SP) is the biggest market by far — **41.98% of all customers** and **38.3% of total revenue** — with Rio de Janeiro and Minas Gerais well behind in second and third.

Order fulfillment is solid: **97.02%** of orders reach "delivered," and cancellations plus unavailable-item orders only add up to **1.24%** of the total.

Raw counts and rates don't always agree. SP has the most canceled orders overall (327, over half of all cancellations), which sounds bad until you calculate it as a rate — SP's actual cancellation rate (0.78%) is lower than several smaller states. Roraima tops the list at 2.17%, though that's off a tiny base of 46 orders, so I wouldn't read too much into it.

Revenue doesn't scale the way I expected either. SP dominates on volume but has one of the lowest average revenue-per-order figures of any state (R$125.75). Smaller states like Paraíba (R$216.67) and Amapá (R$198.15) show much higher spend per order — maybe because customers there have fewer local shopping options and buy more per online order.

Average order value needed a second look too. Just averaging item price gives R$120.65, but that undercounts orders with multiple items. Aggregating to the order level first and then averaging gives the real number: **R$160.58**.

Watches & Gifts sells ~38% fewer units than the top category (Health & Beauty) but earns almost the same total revenue — a clear sign of a much higher price per item.

Credit card is the go-to payment method (**73.92%**), and installment payments are clearly a real thing here — average payment value climbs from R$95.87 for a single payment up to R$415.09 for 10 installments, which lines up with how common interest-free installment plans are in Brazilian retail.

Delivery is where the regional gap is most obvious. **89.15%** of orders arrive on time, averaging **12.5 days**. But the remote northern states (Roraima, Amapá, Amazonas) take **26-29 days** — roughly double the national average — which is probably tied to Brazil's delivery infrastructure being much stronger in the southeast. It's also a plausible reason those same states show higher cancellation rates.

## SQL Concepts I Practiced

- Filtering and aggregation: `WHERE`, `GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG`, `MAX`
- Sorting and limiting results with `ORDER BY` / `LIMIT`
- Two-table and three-table `JOIN`s across customers, orders, order items, products, and category translations
- Subqueries — both for percentage-of-total calculations and for building a derived table to get data to the right grain before aggregating
- `CASE WHEN` for conditional counting (e.g. cancellation rate)
- Date functions: `STR_TO_DATE`, `YEAR`, `MONTH`, `DAYNAME`, `HOUR`, `DATEDIFF`
- Dealing with real import issues — malformed CSVs, a BOM-corrupted column name, and text-based date columns — using `LOAD DATA INFILE` and `STR_TO_DATE`

## About This Project

I built this as a hands-on way to actually learn SQL, rather than just reading about it — using a real, slightly messy dataset instead of a pre-cleaned tutorial file. A good chunk of the learning came from debugging import errors (a stalled import wizard, a BOM character breaking a column name, a malformed CSV row) as much as from writing the queries themselves. All the numbers and insights above come directly from the queries in the `sql/` folder.
