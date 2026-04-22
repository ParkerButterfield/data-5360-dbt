# Eco Essentials Data Warehouse Project

## Overview  
This project is a full end-to-end data pipeline built for **Eco Essentials**, an eco-friendly cookware company. The goal was to take raw data from multiple sources, turn it into a structured data warehouse, and use it to answer real business questions.

This project walks through the full data lifecycle: warehouse design, data ingestion, transformation, testing, automation, and visualization for decision-making.

---

## Business Context  

Eco Essentials wanted better visibility into two main areas:

- **Sales performance over time**
- **Marketing email effectiveness and whether those emails lead to purchases**

The goal was to build a data warehouse that makes these analyses easier and more useful for decision-making.

---

## What This Project Does  

- Combines **sales and marketing data** from multiple sources  
- Loads data into **Snowflake**  
- Transforms it into a **dimensional (star schema) model**  
- Automates refresh and transformation processes  
- Supports analysis through a **Tableau dashboard (live connection)**  

---

## Tech Stack  

- **Snowflake** – cloud data warehouse  
- **dbt** – data transformation and modeling  
- **Fivetran** – data ingestion  
- **AWS RDS PostgreSQL** – transactional data source  
- **AWS S3** – marketing data source  
- **Tableau** – data visualization  

---

## Data Sources  

### Transactional Data (AWS RDS - PostgreSQL)  
Contains core business data:
- Customers  
- Orders  
- Order line items  
- Products  

### Marketing Data (AWS S3)  
Contains Salesforce Marketing Cloud email event data:
- Sent  
- Opened  
- Clicked  
- Campaign interactions  

---

## Data Warehouse Design  

The data warehouse was designed using a dimensional modeling approach based on two core business processes:

### Sales  
Tracks customer purchases at the transaction level.  
- Grain: one row per order line  
- Used to analyze revenue, product performance, and sales trends  

### Marketing Email Engagement  
Tracks customer interaction with marketing emails.  
- Grain: one row per email event (sent, open, click)  
- Used to analyze campaign performance and engagement  

---

### Design Approach  

A **star schema** was used because it simplifies querying and makes the data easier to analyze in tools like Tableau.

- Fact tables store measurable events (sales and email activity)  
- Dimension tables store descriptive attributes (customer, product, campaign, date)  

---

### Key Design Decisions  

- **Conformed dimensions** (`DIM_CUSTOMER`, `DIM_DATE`, `DIM_CAMPAIGN`) are shared across fact tables  
  → This allows marketing activity to be directly linked to sales outcomes  

- **Event modeling using `DIM_EVENT_TYPE`**  
  → Instead of separate columns for open/click, events are stored as rows for flexibility  

- **Time tracking at multiple levels**  
  → `date_key` for aggregation  
  → `event_timestamp` for more detailed analysis  

---

This design allows analysis across the full customer journey, from marketing engagement to actual purchases.

---

## Data Pipeline Overview  

### Extract + Load  
Data is pulled from:
- PostgreSQL (RDS)  
- AWS S3  

Fivetran loads this data into raw Snowflake tables.

---

### Transform (dbt)  
dbt is used to:
- Clean and standardize data  
- Join transactional and marketing datasets  
- Build fact and dimension tables  
- Generate surrogate keys for consistency  

---

## Data Model  

The warehouse uses a **star schema design** centered around two business processes:

### Fact Tables  
- `FACT_SALES` → transaction-level sales data  
- `FACT_EMAIL_EVENTS` → email engagement activity  

### Dimension Tables  
- `DIM_CUSTOMER`  
- `DIM_PRODUCT`  
- `DIM_DATE`  
- `DIM_CAMPAIGN`  
- `DIM_EMAIL`  
- `DIM_EVENT_TYPE`  

These are **conformed dimensions**, allowing both fact tables to be analyzed together.

Both fact tables share dimensions like `DIM_CUSTOMER`, `DIM_DATE`, and `DIM_CAMPAIGN`, which allows marketing activity (email engagement) to be directly analyzed alongside sales performance.

---

## Automation & Scheduling  

The pipeline is fully automated:
- Fivetran syncs data every **24 hours**  
- dbt jobs rebuild models daily  
- No manual intervention is required  

---

## Data Quality  

Data quality is enforced using dbt tests:
- `not_null`  
- `unique`  
- `accepted_values`  
- `relationships`  

These help ensure the data warehouse stays reliable and consistent.

---

## Testing & Scheduling  

To make sure the data stays accurate and up to date:

- dbt tests were implemented across models  
- Fivetran connectors refresh data every **24 hours**  
- A dbt job rebuilds models daily  

This ensures the pipeline runs automatically and maintains data quality without manual work.

---

## Dashboard (Tableau – Live Connection)  

The final data warehouse is connected directly to Tableau using a **live connection**, allowing up-to-date data to be used for analysis without manual exports.

The dashboard is structured as a story that walks through key business questions and insights.

### Key Features:
- KPI card showing total revenue  
- Monthly sales trends  
- Weekly sales fluctuations  
- Campaign-level revenue comparison  
- Email engagement funnel (sent → open → click)  

---

## Business Questions  

The dashboard was designed to answer the following business questions:

1. **How much total revenue has Eco Essentials generated?**  
2. **How are sales trending over time?**  
3. **What short-term fluctuations exist in sales?**  
4. **Which marketing campaigns are driving the most revenue?**  
5. **How effectively are marketing emails engaging customers?**

---

## Key Insights  

- Total revenue is approximately **$10.6K**, providing a baseline view of performance  

- Sales increase steadily from **January through April**, peaking in April, before declining in May and June  

- Weekly sales show **noticeable volatility**, with spikes and dips indicating inconsistent short-term performance. High and low spikes pretty consistently alternate each week.

- The **“New Customer Welcome”** and **“Newsletter Subscriber Special”** campaigns generate the most revenue  

- Email engagement shows a clear drop-off:  
  - ~34 emails sent  
  - ~26 opened  
  - ~13 clicked  

---

## Future Improvements  

- Add deeper customer segmentation  
- Improve tracking from email engagement to purchases  
- Add more granular time-based analysis  
- Enhance dashboard interactivity  

---

## Final Thoughts  

This project walks through the full lifecycle of a modern data warehousing solution, from raw data ingestion to business-ready insights. It highlights the importance of clean data modeling, automation, and clear communication when supporting real business decisions.
