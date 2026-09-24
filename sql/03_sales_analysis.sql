-- =====================================================================
-- E-COMMERCE SQL ANALYTICS PROJECT
-- File: 03_sales_analysis.sql
-- Tables: order_items (112,650 rows), products (32,951 rows),
--         product_category_name_translation (71 rows)
-- Purpose: Calculate total revenue, average order value, and identify
--          top-selling products and product categories.
-- =====================================================================


-- Query 1: Table structure
DESCRIBE order_items;


-- Query 2: Row count (higher than orders/customers because a single
-- order can contain multiple items)
SELECT COUNT(*) AS total_order_items
FROM order_items;
-- Result: 112,650


-- Query 3: Total revenue - products vs freight/shipping
SELECT 
    ROUND(SUM(price), 2) AS total_product_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight_revenue,
    ROUND(SUM(price) + SUM(freight_value), 2) AS total_revenue,
    ROUND(SUM(freight_value) * 100.0 / (SUM(price) + SUM(freight_value)), 2) AS freight_percentage
FROM order_items;
-- Result: R$13,591,643.70 product revenue + R$2,251,909.54 freight
-- = R$15,843,553.24 total revenue (freight = 14.21% of total)


-- Query 4: Average item price and freight value
SELECT 
    ROUND(AVG(price), 2) AS avg_item_price,
    ROUND(AVG(freight_value), 2) AS avg_freight_value
FROM order_items;
-- Result: R$120.65 avg item price | R$19.99 avg freight


-- Query 5: True average ORDER value (not item value) - uses a subquery
-- to first collapse multi-item orders into one row per order, then
-- averages the order totals.
SELECT 
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT 
        order_id,
        SUM(price) + SUM(freight_value) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals;
-- Result: R$160.58 (higher than avg item price, confirming multi-item
-- orders pull the true average order value up)


-- Query 6: Top 10 products by revenue (raw product IDs)
SELECT 
    product_id,
    COUNT(*) AS times_ordered,
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;


-- Query 7: Top 10 product categories by revenue (readable English names,
-- via a 3-table JOIN: order_items -> products -> category translation)
SELECT 
    t.product_category_name_english,
    COUNT(*) AS times_ordered,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;
-- Result: health_beauty leads (R$1,258,681.34), closely followed by
-- watches_gifts (R$1,205,005.68) despite ~38% fewer units sold -
-- indicating a much higher average price point per item
