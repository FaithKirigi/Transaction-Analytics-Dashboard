SELECT COUNT(*) as total_transactions
FROM transaction_raw ;
SELECT DISTINCT type 
FROM transaction_raw;
SELECT 
	type,
	COUNT (*) as transaction_count
FROM transaction_raw
GROUP BY type
ORDER BY transaction_count DESC;
SELECT 
	MIN(amount) as minimum_amount,
	MAX(amount) as maximum_amount,
	AVG(amount) as average_amount,
	SUM(amount) as total_transaction_value
FROM transaction_raw;
SELECT 
COUNT(DISTINCT nameOrig) as unique_customers
FROM transaction_raw;
SELECT 
COUNT (DISTINCT nameDest) as unique_destinations
FROM transaction_raw;
SELECT 
SUM(isFraud) as fraud_transactions,
COUNT(*)as total_transactions,
round(SUM(isFraud)*100.0/COUNT(*),4) as fraud_percentage
FROM transaction_raw;
SELECT 
type,
SUM(isFraud) as fraud_cases,
COUNT(*)as total_transactions,
round(SUM(isFraud)*100.0/COUNT(*),4) as fraud_rate
from transaction_raw
GROUP BY type
ORDER BY fraud_rate DESC;
select
sum(isFlaggedFraud) as flagged_transactions,
sum(isFraud) as actual_fraud
from transaction_raw;
select
CASE 
	when amount <1000 then 'Under 1K'
	when amount between 1000 and 9999 then '1K- 10K'
	when amount between 10000 and 99999 then '10K-100K'
	when amount between 100000 and 999999 then '100K-1M'
	else 'Above 1M'
END As amount_range,
count (*) as transactions
from transaction_raw
Group by amount_range 
order by transactions Desc;
select 
type,
sum(amount) as total_value,
avg(amount)as average_value,
max(amount) as highest_transaction
From transaction_raw
Group by type
order by total_value Desc;
SELECT step,
COUNT (*) as transactions,
sum(amount) as total_amount
from transaction_raw
Group by step
order by step ;
SELECT  nameOrig,
Count(*) as transaction_count,
sum(amount) as total_amount_sent
from transaction_raw
group by nameOrig 
order by transaction_count  DESC, total_amount_sent DESC 
limit 20;
select 
	ROUND(count(*)* 1.0/count(distinct nameOrig),2) as avg_transactions_per_customer
from transaction_raw;	
