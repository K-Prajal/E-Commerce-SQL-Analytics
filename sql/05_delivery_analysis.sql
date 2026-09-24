-- =====================================================================
-- E-COMMERCE SQL ANALYTICS PROJECT
-- File: 05_delivery_analysis.sql
-- Tables: orders, customers
-- Purpose: Measure on-time delivery performance, average delivery time,
--          and how delivery speed varies by customer state.
-- =====================================================================


-- Query 1: On-time vs late deliveries
-- (compares actual delivery date to the estimated delivery date)
SELECT 
    CASE 
        WHEN STR_TO_DATE(order_delivered_customer_date, '%m/%d/%Y %H:%i') 
             <= STR_TO_DATE(order_estimated_delivery_date, '%m/%d/%Y %H:%i') 
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;
-- Result: On Time = 88,649 (89.15%) | Late = 10,792 (10.85%)


-- Query 2: Average delivery time, in days (purchase date to delivery date)
SELECT 
    ROUND(AVG(DATEDIFF(
        STR_TO_DATE(order_delivered_customer_date, '%m/%d/%Y %H:%i'),
        STR_TO_DATE(order_purchase_timestamp, '%m/%d/%Y %H:%i')
    )), 1) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
-- Result: 12.5 days average


-- Query 3: Average delivery time by state (JOIN + DATEDIFF)
SELECT 
    c.customer_state,
    ROUND(AVG(DATEDIFF(
        STR_TO_DATE(o.order_delivered_customer_date, '%m/%d/%Y %H:%i'),
        STR_TO_DATE(o.order_purchase_timestamp, '%m/%d/%Y %H:%i')
    )), 1) AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC
LIMIT 10;
-- Result: Remote northern states are slowest - RR (29.3 days),
-- AP (27.2 days), AM (26.4 days) - roughly double the national
-- average, reflecting Brazil's logistics network being concentrated
-- in the southeast.
