# saas-growth-engine
# 🚀 SaaS Growth Engine (dbt Demo)


## 📖 Project Overview
This project demonstrates a  SaaS subscription business. 

It tackles complex real-world data challenges such as **Slowly Changing Dimensions (SCD Type 2)**, **Late Arriving Data**, and **Cohort Retention Analysis**.

## 🏗 Key Features & Architecture

### 1. 🛡 Handling History & Latency
* **SCD Type 2 Snapshots**: Uses `snapshots/sns_subscriptions.sql` to track every status change (Trial -> Active -> Cancelled).
* **Lookback Window**: The incremental model `int_subscription_daily_status` includes a **3-day lookback window** to self-heal and capture late-arriving data updates from upstream sources.

### 2. 📅 Date Spining for MRR
* Calculates **Daily MRR** (Monthly Recurring Revenue) by fanning out subscription start/end dates into a daily grain using `dbt_utils.date_spine`.

### 3. 📊 Advanced Metrics
* **Cohort Retention**: Calculates user retention rates by cohort month (`fct_cohort_retention`).
* **User Segmentation**: Segments users into Power/Casual users based on 30-day event frequency (`int_user_activity_segmentation`).

## 🛠 How to Run (Zero Config)

This project uses **dbt seeds** to simulate raw data, so you don't need a warehouse connection to check the logic.

1.  **Install Dependencies**
    ```bash
    dbt deps
    ```

2.  **Load Mock Data**
    ```bash
    dbt seed
    ```

3.  **Snapshot History (Initialize SCD2)**
    ```bash
    dbt snapshot
    ```

4.  **Run Models**
    ```bash
    dbt run
    ```

5.  **Test Data Quality**
    ```bash
    dbt test
    ```

## 📂 Project Structure
* `snapshots/`: Captures historical changes in subscription status.
* `models/intermediate/`: Contains the heavy lifting (Date Spine, Segmentation Logic).
* `models/marts/`: Business-ready tables (Retention, Growth, MRR).

---
*Created by [Ashley] *
