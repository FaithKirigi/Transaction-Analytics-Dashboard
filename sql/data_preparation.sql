CREATE OR REPLACE VIEW vw_transactions_prepared AS

SELECT
    step,
    FLOOR((step - 1) / 24) + 1 AS transaction_day,
    FLOOR((step - 1) / 168) + 1 AS transaction_week,
    MOD((step - 1), 24) AS hour_of_day,

    CASE
        WHEN MOD((step - 1), 24) BETWEEN 0 AND 5 THEN 'Night'
        WHEN MOD((step - 1), 24) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN MOD((step - 1), 24) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_bucket,

    type,
    amount,

    CASE
        WHEN amount < 1000 THEN 'Under 1K'
        WHEN amount BETWEEN 1000 AND 9999 THEN '1K - 10K'
        WHEN amount BETWEEN 10000 AND 99999 THEN '10K - 100K'
        WHEN amount BETWEEN 100000 AND 999999 THEN '100K - 1M'
        ELSE 'Above 1M'
    END AS amount_range,

    nameOrig,
    nameDest,
    oldbalanceOrg,
    newbalanceOrig,
    oldbalanceDest,
    newbalanceDest,

    oldbalanceOrg - newbalanceOrig AS original_balance_change,
    oldbalanceDest - newbalanceDest AS destination_balance_change,

    isFraud,

    CASE
        WHEN isFraud = 1 THEN 'Fraud'
        ELSE 'Legitimate'
    END AS fraud_status,

    isFlaggedFraud,

    CASE
        WHEN isFlaggedFraud = 1 THEN 'Flagged'
        ELSE 'Not Flagged'
    END AS flagged_status

FROM transaction_raw;
