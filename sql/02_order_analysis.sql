-- =====================================================================
-- E-COMMERCE SQL ANALYTICS PROJECT
-- File: 02_order_analysis.sql
-- Table: orders (99,441 rows)
-- Purpose: Examine order status/fulfillment health, and analyze order
--          timing trends (year/month growth, day-of-week, hour-of-day).
-- =====================================================================


-- Query 1: Table structure
DESCRIBE orders;


-- Query 2: Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;
-- Result: 99,441


-- Query 3: Orders by status, sorted by frequency
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;
-- Result: delivered = 96,478 | shipped = 1,107 | canceled = 625 |
--         unavailable = 609 | invoiced = 314 | processing = 301 |
--         created = 5 | approved = 2


-- Query 4: Orders by status, as a percentage of total orders
SELECT 
    order_status, 
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;
-- Result: 97.02% of all orders were successfully delivered


-- Query 5: Raw list of canceled orders
SELECT order_id, customer_id, order_status, order_purchase_timestamp
FROM orders
WHERE order_status = 'canceled';
-- Result: 625 rows


-- Query 6: Count of canceled orders
SELECT COUNT(*) AS total_canceled_orders
FROM orders
WHERE order_status = 'canceled';
-- Result: 625


-- Query 7: "Problem" orders combined (canceled + unavailable)
SELECT COUNT(*) AS problem_orders
FROM orders
WHERE order_status IN ('canceled', 'unavailable');
-- Result: 1,234 (1.24% of all orders)


-- Query 8: Successful/in-progress orders (everything except problem statuses)
SELECT COUNT(*) AS successful_orders
FROM orders
WHERE order_status NOT IN ('canceled', 'unavailable');
-- Result: 98,207 (98.76% of all orders)


-- Query 9: Test converting the text-based purchase timestamp into a real DATE
-- (all date columns were imported as TEXT, e.g. "7/24/2018 14:29")
SELECT 
    order_purchase_timestamp,
    STR_TO_DATE(order_purchase_timestamp, '%m/%d/%Y %H:%i') AS converted_date
FROM orders
LIMIT 5;


-- Query 10: Order volume by year and month (business growth trend)
SELECT 
    YEAR(STR_TO_DATE(order_purchase_timestamp, '%m/%d/%Y %H:%i')) AS order_year,
    MONTH(STR_TO_DATE(order_purchase_timestamp, '%m/%d/%Y %H:%i')) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;
-- Result: strong growth from late 2016 through 2017, peaking Nov 2017
-- (7,544 orders, likely Black Friday), plateauing through 2018.
-- Sep/Oct 2018 show a sharp drop-off - this reflects the dataset's
-- known collection cutoff, not an actual business collapse.


-- Query 11: Order volume by day of week
SELECT 
    DAYNAME(STR_TO_DATE(order_purchase_timestamp, '%m/%d/%Y %H:%i')) AS day_of_week,
    COUNT(*) AS total_orders
FROM orders
GROUP BY day_of_week
ORDER BY total_orders DESC;
-- Result: Monday busiest (16,196), Saturday quietest (10,887) -
-- weekday shopping clearly outpaces weekends


-- Query 12: Order volume by hour of day
SELECT 
    HOUR(STR_TO_DATE(order_purchase_timestamp, '%m/%d/%Y %H:%i')) AS order_hour,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;
-- Result: quietest overnight (3-5 AM), consistently high from
-- 10 AM to 10 PM, peaking around 4 PM (6,675 orders)
