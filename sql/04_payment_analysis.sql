-- =====================================================================
-- E-COMMERCE SQL ANALYTICS PROJECT
-- File: 04_payment_analysis.sql
-- Table: order_payments (103,886 rows)
-- Purpose: Examine payment method usage and installment behavior,
--          a distinctly common pattern in Brazilian e-commerce.
-- =====================================================================


-- Query 1: Table structure
DESCRIBE order_payments;


-- Query 2: Payment method breakdown
SELECT 
    payment_type,
    COUNT(*) AS total_payments,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_payments), 2) AS percentage
FROM order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;
-- Result: credit_card = 73.92% | boleto = 19.04% | voucher = 5.56% |
-- debit_card = 1.47% | not_defined = 0.00%


-- Query 3: Installment behavior for credit card payments
-- (does average payment value rise with more installments?)
SELECT 
    payment_installments,
    COUNT(*) AS total_payments,
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM order_payments
WHERE payment_type = 'credit_card'
GROUP BY payment_installments
ORDER BY payment_installments;
-- Result: avg payment value rises from R$95.87 (1 installment) to
-- R$415.09 (10 installments), confirming customers finance larger
-- purchases over more installments


-- Query 4: Average and maximum payment value by payment type
SELECT 
    payment_type,
    ROUND(AVG(payment_value), 2) AS avg_payment_value,
    ROUND(MAX(payment_value), 2) AS max_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY avg_payment_value DESC;
-- Result: credit_card has both the highest average (R$163.32) and
-- highest single payment (R$13,664.08)
