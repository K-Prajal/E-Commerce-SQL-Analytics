-- =====================================================================
-- E-COMMERCE SQL ANALYTICS PROJECT
-- File: 01_customer_analysis.sql
-- Table: customers (99,441 rows)
-- Purpose: Explore customer distribution across Brazil (states/cities),
--          calculate market share, and identify a key data-quality
--          nuance in customer identifiers.
-- =====================================================================


-- Query 1: Table structure
DESCRIBE customers;


-- Query 2: Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;
-- Result: 99,441


-- Query 3: Customers by state (unsorted)
SELECT customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state;


-- Query 4: Customers by state, sorted from largest to smallest
SELECT customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;
-- Result: SP leads with 41,746 customers, followed by RJ (12,852) and MG (11,635)


-- Query 5: Top 5 states by customer count
SELECT customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 5;


-- Query 6: States with more than 5,000 customers (HAVING filters groups, not rows)
SELECT customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
HAVING COUNT(*) > 5000
ORDER BY total_customers DESC;


-- Query 7: Top 10 cities by customer count (grouping by city + state avoids
-- merging different cities that happen to share a name across states)
SELECT customer_city, customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city, customer_state
ORDER BY total_customers DESC
LIMIT 10;
-- Result: Sao Paulo (city) leads with 15,540 customers


-- Query 8: Customer share by state, as a percentage of the total customer base
SELECT 
    customer_state, 
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) AS percentage
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 10;
-- Result: Sao Paulo (SP) alone accounts for 41.98% of all customers


-- Query 9: Data-quality check - customer_id vs customer_unique_id
-- Olist generates a NEW customer_id every time a customer places an order,
-- while customer_unique_id stays the same for that person across all orders.
SELECT 
    COUNT(customer_id) AS total_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS total_unique_customers
FROM customers;
-- Result: 99,441 customer_ids vs 96,096 unique real customers
-- ~3,345 customers (3.5%) placed more than one order
