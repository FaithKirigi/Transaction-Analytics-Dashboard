# Data Dictionary

## Overview

This document describes the transaction fields used in the **Transaction Analytics & Risk Monitoring Dashboard**.

The project uses the PaySim synthetic mobile-money dataset. The original dataset contains 11 fields, with additional analytical fields derived in SQL for reporting and dashboard analysis.

---

## Source Fields

| Field | Type | Description |
|---|---|---|
| `step` | Integer | Simulation time step. Each step represents one hour in the PaySim simulation. |
| `type` | Text | Transaction type: CASH_IN, CASH_OUT, DEBIT, PAYMENT, or TRANSFER. |
| `amount` | Decimal | Transaction amount. No currency unit is assumed in this project. |
| `nameOrig` | Text | Identifier of the account initiating the transaction. |
| `oldbalanceOrg` | Decimal | Origin account balance before the transaction. |
| `newbalanceOrig` | Decimal | Origin account balance after the transaction. |
| `nameDest` | Text | Identifier of the destination account. |
| `oldbalanceDest` | Decimal | Destination account balance before the transaction. |
| `newbalanceDest` | Decimal | Destination account balance after the transaction. |
| `isFraud` | Integer | Fraud label supplied by PaySim. `1` represents a fraud-labelled transaction and `0` represents a non-fraud-labelled transaction. |
| `isFlaggedFraud` | Integer | Flag indicator supplied by PaySim. `1` represents a transaction marked by the dataset's flagging rule and `0` represents an unflagged transaction. |

---

## Derived Fields

The following fields were created in `vw_transactions_prepared` to support analysis in Power BI.

| Field | Description |
|---|---|
| `transaction_day` | Simulation day derived from `step`. |
| `transaction_week` | Simulation week derived from `step`. |
| `hour_of_day` | Simulated hour of day ranging from 0 to 23. |
| `time_bucket` | Groups simulated transaction hours into broader time-of-day categories. |
| `amount_range` | Groups transactions into Low, Medium, High, and Very High Value segments. |
| `amount_range_sort` | Numeric sort key used to define the intended order of the value segments. |
| `origin_balance_change` | Change between the origin account's pre- and post-transaction balances. |
| `destination_balance_change` | Change between the destination account's pre- and post-transaction balances. |
| `fraud_status` | Business-friendly representation of the `isFraud` field. |
| `flagged_status` | Business-friendly representation of the `isFlaggedFraud` field. |
| `review_priority` | Derived review category used to support transaction-level analysis. It is an analytical prioritization field rather than a validated fraud-risk score. |

---

## Transaction Value Segmentation

Transaction amounts were grouped into four reporting segments.

| Segment | Transaction Amount |
|---|---:|
| Low Value | Below 10,000 |
| Medium Value | 10,000 – 99,999 |
| High Value | 100,000 – 999,999 |
| Very High Value | 1,000,000 and above |

These segments are analytical groupings created for this project and are not classifications provided by PaySim.

---

## Time Variables

PaySim provides a simulation `step` rather than a calendar timestamp.

The project derives time fields as follows:

```sql
FLOOR((step - 1) / 24) + 1
```

→ Simulation day

```sql
FLOOR((step - 1) / 168) + 1
```

→ Simulation week

```sql
MOD((step - 1), 24)
```

→ Hour of day

These fields should therefore be interpreted as **simulation time**, not real dates or observed customer activity at specific real-world times.

---

## Fraud Fields

Two fraud-related fields are provided by the source dataset:

### `isFraud`

Used as the primary fraud label throughout the analysis.

The dataset contains:

- **8,213 fraud-labelled transactions**
- **6,362,620 total transactions**
- **0.1291% overall fraud rate**

### `isFlaggedFraud`

A separate flag indicator provided by PaySim.

Only **16 transactions** have `isFlaggedFraud = 1`.

The project keeps this indicator separate from the primary fraud label and does not treat it as a complete measure of fraud-detection performance.

---

## Power BI Measures

The main dashboard measures include:

| Measure | Definition |
|---|---|
| Total Transactions | Number of transaction records |
| Total Transaction Value | Sum of transaction amounts |
| Average Transaction Value | Average transaction amount |
| Fraud Cases | Number of fraud-labelled transactions |
| Fraud Rate | Fraud Cases ÷ Total Transactions |
| Flagged Transactions | Number of transactions where `isFlaggedFraud = 1` |
| Fraud Transaction Value | Total value of transactions where `isFraud = 1` |
| Unique Origin Accounts | Distinct count of `nameOrig` |
| Unique Destination Accounts | Distinct count of `nameDest` |

All measures respond dynamically to the filter context applied within the Power BI report.

---

## Dataset Notes

- PaySim is a **synthetic financial transaction dataset**.
- Account identifiers represent simulated origin and destination accounts.
- Transaction amounts are presented without assigning a currency.
- Time-based analysis refers to PaySim simulation time.
- Fraud findings describe patterns within the synthetic dataset and should not be interpreted as production fraud rules or real customer behavior.
