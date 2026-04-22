# Eco Essentials Data Warehouse Project

## Overview  
This project is a full end-to-end data pipeline built for **Eco Essentials**, an eco-friendly cookware company. The goal was to take raw data from multiple sources, turn it into a structured data warehouse, and use it to answer real business questions.

This project walks through the full data lifecycle: warehouse design, data ingestion, transformation, testing, automation, and visualization for decision-making. It aligns with all four phases of the data warehousing process.

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

### Serve  
The final data warehouse is exposed for analytics and connected to Tableau through a **live connection**.

---

## Data Model  

The warehouse uses a **star schema design** centered around two business processes:

### Fact Tables  
- `fact_sales` → transaction-level sales data  
- `fact_email_events` → email engagement activity  

### Dimension Tables  
- `dim_customer`  
- `dim_product`  
- `dim_date`  
- `dim_campaign`  

These are **conformed dimensions**, allowing both fact tables to be analyzed together.

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

- dbt tests were implemented across models, including `not_null`, `unique`, `accepted_values`, and `relationships`  
- Fivetran connectors were scheduled to refresh data every **24 hours**  
- A dbt job was configured to rebuild models daily  

This ensures the pipeline runs automatically and maintains data quality without manual work.

---

## Dashboard (Tableau – Live Connection)  

A Tableau dashboard was built using a live connection to Snowflake to communicate insights to Eco Essentials leadership.

The dashboard is designed as a visual story that answers key business questions.

### Key Features:
- KPI card showing total revenue  
- Monthly sales trends  
- Weekly sales fluctuations  
- Campaign-level revenue comparison  
- Email engagement funnel (sent → open → click)  

---

## Dashboard Preview  

![Eco Essentials Dashboard](./dashboard.png)

---

## Business Questions  

The dashboard was designed to answer the following business questions:

1. **How much total revenue has Eco Essentials generated?**  
   Provides a high-level view of overall performance.

2. **How are sales trending over time?**  
   Helps identify growth patterns and slowdowns.

3. **What short-term fluctuations exist in sales, and are there any spikes or drops we should investigate?**  
   Highlights weekly variability and unusual patterns.

4. **Which marketing campaigns are driving the most revenue?**  
   Identifies the campaigns contributing the most value.

5. **How effectively are marketing emails engaging customers at each stage of the funnel?**  
   Looks at engagement through sent, open, and click events.

---

## Key Insights  

- Total revenue is approximately **$10.6K**, giving a baseline view of overall performance  

- Sales increase steadily from **January through April**, peaking in April, before declining in May and June  

- Weekly sales show **high volatility**, with noticeable spikes and dips, indicating inconsistent short-term performance  

- The **“New Customer Welcome”** and **“Newsletter Subscriber Special”** campaigns generate the most revenue, while several others contribute less  

- Email engagement shows a clear drop-off:  
  - ~34 emails sent  
  - ~26 opened  
  - ~13 clicked  
  This suggests people are opening emails, but fewer are actually clicking through  

---

## Example Use Cases  

- Analyze revenue trends over time  
- Identify top-performing marketing campaigns  
- Evaluate email marketing effectiveness  
- Track customer purchasing behavior  

---

## Challenges  

- Combining multiple data sources with different structures  
- Making sure joins between sales and marketing data were accurate  
- Debugging dbt model relationships and key mismatches  
- Designing a clean, easy-to-understand Tableau dashboard  

---

## Future Improvements  

- Add deeper customer segmentation (repeat customers, LTV)  
- Improve tracking from email → purchase  
- Add more detailed time-based analysis  
- Make the dashboard more interactive with filters and drilldowns  

---

## Final Thoughts  

This project walks through the full lifecycle of a modern data warehousing solution, from raw data ingestion to business-ready insights. It shows how important clean data modeling, automation, and clear communication are when supporting real business decisions.
