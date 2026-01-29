# saas-growth-engine
# SaaS Growth Engine (dbt Demo)


## Project Overview
This project demonstrates a  SaaS subscription business. 

It tackles complex real-world data challenges such as **Slowly Changing Dimensions (SCD Type 2)**, **Late Arriving Data**, and **Cohort Retention Analysis**.

## Key Features & Architecture

### 1. Handling History & Latency
* **SCD Type 2 Snapshots**: Uses `snapshots/sns_subscriptions.sql` to track every status change (Trial -> Active -> Cancelled).
* **Lookback Window**: The incremental model `int_subscription_daily_status` includes a **3-day lookback window** to self-heal and capture late-arriving data updates from upstream sources.

### 2. Date Spining for MRR
* Calculates **Daily MRR** (Monthly Recurring Revenue) by fanning out subscription start/end dates into a daily grain using `dbt_utils.date_spine`.

### 3.Advanced Metrics
* **Cohort Retention**: Calculates user retention rates by cohort month (`fct_cohort_retention`).
* **User Segmentation**: Segments users into Power/Casual users based on 30-day event frequency (`int_user_activity_segmentation`).

## How to Run (Zero Config)

This project is designed to be self-contained. 
While it requires a Snowflake connection for computation, it uses dbt seeds to load raw mock data directly into the warehouse. 
This eliminates the need for external ETL tools (like Fivetran) or third-party data sources to run this demo.

Since this project runs on **Snowflake**, you will need a Snowflake account to execute the models.

### 1. Configure Credentials
You can configure the connection in your `~/.dbt/profiles.yml` or use environment variables. 
*(Note: I follow security best practices by not committing credentials to git.)*

**Required Environment Variables:**
```bash
export SNOWFLAKE_ACCOUNT='your_account_id'  # e.g., xy12345.us-east-1
export SNOWFLAKE_USER='your_username'
export SNOWFLAKE_PASSWORD='your_password'
export SNOWFLAKE_ROLE='ACCOUNTADMIN'        # or your transformer role
export SNOWFLAKE_WAREHOUSE='COMPUTE_WH'
export SNOWFLAKE_DATABASE='ANALYTICS_DEV'
export SNOWFLAKE_SCHEMA='dbt_jennifer'

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
6.  **Generate docs and Index**
     ```bash
    dbt docs generate
    dbt docs serve
    ```

## 📂 Project Structure
* `snapshots/`: Captures historical changes in subscription status.
* `models/intermediate/`: Contains the heavy lifting (Date Spine, Segmentation Logic).
* `models/marts/`: Business-ready tables (Retention, Growth, MRR).

---
*Created by [Ashley] *
