-- =====================================================================
-- E-COMMERCE SQL ANALYTICS PROJECT
-- File: 06_business_analysis.sql
-- Tables: orders, customers, order_items
-- Purpose: Cross-table JOIN analysis connecting order outcomes and
--          revenue back to customer geography, surfacing insights
--          that are impossible to see from any single table alone.
-- =====================================================================


-- Query 1: First JOIN - combine order status with customer location
SELECT 
    o.order_id,
    o.order_status,
    c.customer_city,
    c.customer_state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 10;


-- Query 2: Canceled orders by state (raw count)
SELECT 
    c.customer_state,
    COUNT(*) AS canceled_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'canceled'
GROUP BY c.customer_state
ORDER BY canceled_orders DESC
LIMIT 10;
-- Result: SP leads with 327 canceled orders (52.3% of all cancellations),
-- disproportionately higher than its 42% share of the customer base


-- Query 3: Cancellation RATE by state (fairer comparison than raw count,
-- since it accounts for how many total orders each state actually has)
SELECT 
    c.customer_state,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS canceled_orders,
    ROUND(SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY cancellation_rate DESC
LIMIT 10;
-- Result: ranking flips once measured by rate - RR tops the list at
-- 2.17% (though on a small base of 46 orders), and SP actually drops
-- to 4th place (0.78%). Raw counts and rates can tell very different
-- stories.


-- Query 4: Revenue by state (3-table JOIN: order_items -> orders -> customers)
SELECT 
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;
-- Result: SP leads with R$5,202,955.05 (38.3% of total revenue) -
-- slightly below its 42% customer share


-- Query 5: Average revenue per order by state
-- (uses COUNT(DISTINCT order_id) since the JOIN multiplies rows for
-- orders with multiple items)
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_revenue_per_order
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_revenue_per_order DESC
LIMIT 10;
-- Result: smaller/remote states (PB, AP, AC) have the HIGHEST average
-- revenue per order (R$195-217), while SP - despite dominating in
-- volume - ranks well outside the top 10 at just R$125.75 per order.
-- Suggests customers in remote states may purchase higher-value items
-- per order, possibly due to fewer local retail alternatives.
