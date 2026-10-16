-- ============================================================
-- TELECOM CUSTOMER CHURN ANALYSIS
-- ============================================================
use talecom_churn;
-- ============================================================
-- BUSINESS PROBLEM
-- ============================================================

-- The telecom company wants to understand customer churn,
-- identify high-risk customer segments,
-- and estimate the monthly revenue associated with churned customers.


-- ============================================================
-- DATABASE SETUP
-- ============================================================

-- CREATE DATABASE telecom_churn;

-- ============================================================
-- 01. DATA VALIDATION
-- ============================================================

-- Preview data

SELECT *
FROM customers
LIMIT 10;

 table;

-- Total customers

SELECT
    COUNT(*) AS total_customers
FROM customers;


-- Unique customers

SELECT
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customers;


-- Check duplicate customer IDs

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 02. NULL CHECK
-- ============================================================

SELECT
    SUM(customer_id IS NULL) AS customer_id_null,
    SUM(gender IS NULL) AS gender_null,
    SUM(senior_citizen IS NULL) AS senior_citizen_null,
    SUM(tenure_months IS NULL) AS tenure_null,
    SUM(monthly_charges IS NULL) AS monthly_charges_null,
    SUM(total_charges IS NULL) AS total_charges_null,
    SUM(contract_type IS NULL) AS contract_null,
    SUM(internet_service IS NULL) AS internet_service_null,
    SUM(payment_method IS NULL) AS payment_method_null,
    SUM(churn IS NULL) AS churn_null
FROM customers;


-- ============================================================
-- 03. OVERALL CHURN ANALYSIS
-- ============================================================

SELECT
    COUNT(*) AS total_customers,

    SUM(churn = 'Yes') AS churned_customers,

    ROUND(
        100.0 * SUM(churn = 'Yes') / COUNT(*),
        2
    ) AS churn_rate

FROM customers;


-- ============================================================
-- 04. CHURN BY CONTRACT TYPE
-- ============================================================

SELECT
    contract_type,

    COUNT(*) AS total_customers,

    SUM(churn = 'Yes') AS churned_customers,

    ROUND(
        100.0 * SUM(churn = 'Yes') / COUNT(*),
        2
    ) AS churn_rate

FROM customers

GROUP BY contract_type

ORDER BY churn_rate DESC;


-- ============================================================
-- 05. CHURN BY TENURE
-- ============================================================

SELECT

    CASE
        WHEN tenure_months <= 6 THEN '0-6 months'
        WHEN tenure_months <= 12 THEN '7-12 months'
        WHEN tenure_months <= 24 THEN '13-24 months'
        ELSE '25+ months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    SUM(churn = 'Yes') AS churned_customers,

    ROUND(
        100.0 * SUM(churn = 'Yes') / COUNT(*),
        2
    ) AS churn_rate

FROM customers

GROUP BY
    CASE
        WHEN tenure_months <= 6 THEN '0-6 months'
        WHEN tenure_months <= 12 THEN '7-12 months'
        WHEN tenure_months <= 24 THEN '13-24 months'
        ELSE '25+ months'
    END

ORDER BY churn_rate DESC;


-- ============================================================
-- 06. CHURN BY MONTHLY CHARGES
-- ============================================================

SELECT

    CASE
        WHEN monthly_charges < 40 THEN 'Low'
        WHEN monthly_charges < 70 THEN 'Medium'
        ELSE 'High'
    END AS charge_group,

    COUNT(*) AS total_customers,

    SUM(churn = 'Yes') AS churned_customers,

    ROUND(
        100.0 * SUM(churn = 'Yes') / COUNT(*),
        2
    ) AS churn_rate

FROM customers

GROUP BY
    CASE
        WHEN monthly_charges < 40 THEN 'Low'
        WHEN monthly_charges < 70 THEN 'Medium'
        ELSE 'High'
    END

ORDER BY churn_rate DESC;


-- ============================================================
-- 07. CHURN BY PAYMENT METHOD
-- ============================================================

SELECT

    payment_method,

    COUNT(*) AS total_customers,

    SUM(churn = 'Yes') AS churned_customers,

    ROUND(
        100.0 * SUM(churn = 'Yes') / COUNT(*),
        2
    ) AS churn_rate

FROM customers

GROUP BY payment_method

ORDER BY churn_rate DESC;


-- ============================================================
-- 08. CHURN BY INTERNET SERVICE
-- ============================================================

SELECT

    internet_service,

    COUNT(*) AS total_customers,

    SUM(churn = 'Yes') AS churned_customers,

    ROUND(
        100.0 * SUM(churn = 'Yes') / COUNT(*),
        2
    ) AS churn_rate

FROM customers

GROUP BY internet_service

ORDER BY churn_rate DESC;


-- ============================================================
-- 09. HIGH-RISK CUSTOMER SEGMENTS
-- ============================================================

SELECT

    contract_type,

    CASE
        WHEN tenure_months <= 6 THEN '0-6 months'
        WHEN tenure_months <= 12 THEN '7-12 months'
        WHEN tenure_months <= 24 THEN '13-24 months'
        ELSE '25+ months'
    END AS tenure_group,

    CASE
        WHEN monthly_charges < 40 THEN 'Low'
        WHEN monthly_charges < 70 THEN 'Medium'
        ELSE 'High'
    END AS charge_group,

    COUNT(*) AS total_customers,

    SUM(churn = 'Yes') AS churned_customers,

    ROUND(
        100.0 * SUM(churn = 'Yes') / COUNT(*),
        2
    ) AS churn_rate

FROM customers

GROUP BY
    contract_type,

    CASE
        WHEN tenure_months <= 6 THEN '0-6 months'
        WHEN tenure_months <= 12 THEN '7-12 months'
        WHEN tenure_months <= 24 THEN '13-24 months'
        ELSE '25+ months'
    END,

    CASE
        WHEN monthly_charges < 40 THEN 'Low'
        WHEN monthly_charges < 70 THEN 'Medium'
        ELSE 'High'
    END

HAVING COUNT(*) >= 20

ORDER BY churn_rate DESC;


-- ============================================================
-- 10. REVENUE AT RISK
-- ============================================================

-- Total monthly revenue

SELECT

    ROUND(
        SUM(monthly_charges),
        2
    ) AS total_monthly_revenue

FROM customers;


-- Monthly revenue associated with churned customers

SELECT

    COUNT(*) AS churned_customers,

    ROUND(
        SUM(monthly_charges),
        2
    ) AS monthly_revenue_at_risk

FROM customers

WHERE churn = 'Yes';


-- Percentage of monthly charges associated with churned customers

SELECT

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN churn = 'Yes'
                THEN monthly_charges
                ELSE 0
            END
        )
        / SUM(monthly_charges),
        2
    ) AS revenue_at_risk_percentage

FROM customers;


-- ============================================================
-- END OF ANALYSIS
-- ============================================================