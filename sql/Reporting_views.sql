/*
===============================================================================
Project: End-to-End Transaction Analytics & Risk Monitoring Solution
File: 04_reporting_views.sql

View: vw_kpi_summary

Description:
Provides executive-level KPIs for the dashboard.

===============================================================================
*/

DROP VIEW IF exists vw_kpi_summary;
CREATE VIEW vw_kpi_summary AS

SELECT

-- ============================================================================
-- Operational KPIs
-- ============================================================================

    COUNT(*) AS total_transactions,

    COUNT(DISTINCT nameOrig) AS unique_customers,

    COUNT(DISTINCT nameDest) AS unique_recipients,

-- ============================================================================
-- Financial KPIs
-- ============================================================================

    ROUND(SUM(amount),2) AS total_transaction_value,

    ROUND(AVG(amount),2) AS average_transaction_value,

-- ============================================================================
-- Risk KPIs
-- ============================================================================

    SUM(isFraud) AS fraud_cases,

    SUM(isFlaggedFraud) AS flagged_transactions,

    ROUND(
        100 * SUM(isFraud) / COUNT(*),
        4
    ) AS fraud_rate_percentage

FROM vw_transactions_prepared;

-- ============================================================================
-- Validation
-- ============================================================================

SELECT *
FROM vw_kpi_summary;
/*
===============================================================================
View: vw_transaction_summary

Description:
Summarizes transaction activity by transaction type.

Used For:
• Transaction Volume Chart
• Transaction Value Chart
• Executive Dashboard
===============================================================================
*/

CREATE VIEW vw_transaction_summary AS

SELECT

    type,

    COUNT(*) AS transaction_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS transaction_percentage,

    ROUND(SUM(amount),2) AS total_transaction_value,

    ROUND(AVG(amount),2) AS average_transaction_value,

    ROUND(
        SUM(amount) * 100.0 /
        SUM(SUM(amount)) OVER (),
        2
    ) AS value_percentage,

    SUM(isFraud) AS fraud_cases

FROM vw_transactions_prepared

GROUP BY type;

-- Validation

SELECT *
FROM vw_transaction_summary;

/*
===============================================================================
View: vw_time_summary

Description:
Summarizes transaction activity by day, hour and time bucket.

===============================================================================
*/
DROP VIEW IF exists vw_time_summary ;
CREATE  VIEW vw_time_summary AS

SELECT

    transaction_day,

    hour_of_day,

    time_bucket,

    COUNT(*) AS transaction_count,

    ROUND(SUM(amount),2) AS total_transaction_value,

    SUM(isFraud) AS fraud_cases

FROM vw_transactions_prepared

GROUP BY

    transaction_day,

    hour_of_day,

    time_bucket;

-- Validation

SELECT *
FROM vw_time_summary
LIMIT 20;
/*
===============================================================================
View: vw_customer_summary
===============================================================================
*/
DROP VIEW IF exists vw_customer_summary;
CREATE VIEW vw_customer_summary AS

SELECT

    nameOrig,

    COUNT(*) AS transaction_count,

    ROUND(SUM(amount),2) AS total_transaction_value,

    ROUND(AVG(amount),2) AS average_transaction_value,

    MAX(amount) AS largest_transaction,

    SUM(isFraud) AS fraud_cases

FROM vw_transactions_prepared

GROUP BY nameOrig;

-- Validation

SELECT *
FROM vw_customer_summary
LIMIT 20;
/*
===============================================================================
View: vw_risk_summary
===============================================================================
*/
DROP VIEW IF exists vw_risk_summary;
CREATE  VIEW vw_risk_summary AS

SELECT

    type,

    COUNT(*) AS total_transactions,

    SUM(isFraud) AS fraud_cases,

    SUM(isFlaggedFraud) AS flagged_transactions,

    ROUND(
        100 * SUM(isFraud)/COUNT(*),
        4
    ) AS fraud_rate_percentage

FROM vw_transactions_prepared

GROUP BY type;

-- Validation

SELECT *
FROM vw_risk_summary;
/*
===============================================================================
View: vw_balance_validation
===============================================================================
*/
CREATE VIEW vw_balance_validation AS

SELECT

    type,

    AVG(origin_balance_change) AS avg_origin_change,

    AVG(destination_balance_change) AS avg_destination_change,

    AVG(amount) AS avg_transaction_amount

FROM vw_transactions_prepared

GROUP BY type;
SELECT *
FROM vw_balance_validation;