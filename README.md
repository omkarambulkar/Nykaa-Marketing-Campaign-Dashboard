# Nykaa Marketing Campaign Performance Dashboard

## Project Overview

This project analyzes marketing campaign performance using a public Nykaa e-commerce campaign dataset. The goal of the project was to build an end-to-end marketing analytics dashboard that helps stakeholders understand campaign profitability, customer segment performance, marketing channel effectiveness, and monthly revenue/profit trends.

The project was built using **MySQL** for data validation, cleaning, KPI engineering, and campaign classification, and **Tableau Public** for interactive dashboard visualization.

---

## Business Problem

Marketing teams run multiple campaigns across different campaign types, customer segments, and marketing channels. However, not every campaign performs equally. Some campaigns generate high revenue but low ROI, while others are cost-efficient but operate at a smaller scale.

The business requirement was to build a dashboard that can answer:

- How is the overall campaign portfolio performing?
- Which campaign type generates the highest profit?
- Which customer segment is most profitable?
- Which marketing channel contributes the most profit?
- How do revenue and profit trend month by month?
- Which campaigns should be scaled, optimized, or reviewed?

---

## Tools and Technologies Used

- **MySQL** – Data import, validation, cleaning, KPI calculations, and campaign classification
- **Tableau Public** – Dashboard creation and interactive visualization
- **Excel / CSV** – Dataset storage and Tableau data source
- **GitHub** – Project documentation and portfolio hosting

---

## Dataset

The project uses a public marketing campaign dataset containing 55,555 campaign records.

Key fields include:

- Campaign ID
- Campaign Type
- Target Audience
- Campaign Duration
- Channel Used
- Impressions
- Clicks
- Leads
- Conversions
- Revenue
- Acquisition Cost
- ROI
- Engagement Score
- Customer Segment
- Campaign Date

---

## Project Workflow

1. Downloaded and reviewed the campaign dataset.
2. Created a MySQL database and staging table.
3. Imported raw campaign data into MySQL.
4. Performed data validation checks for:
   - Row count
   - Missing values
   - Duplicate campaign IDs
   - Date format
   - Negative or impossible values
   - Funnel logic
5. Created a clean analysis table with calculated KPIs.
6. Calculated estimated spend using:

   `Estimated Spend = Acquisition Cost × Conversions`

7. Calculated business KPIs such as:
   - Profit
   - ROI
   - ROAS
   - Click-through rate
   - Cost per click
   - Cost per lead
8. Created campaign performance categories and recommended actions.
9. Exported the final MySQL table to CSV for Tableau Public.
10. Built an interactive Tableau dashboard with KPI cards, charts, and filters.

---

## SQL Analysis Performed

The SQL analysis focused on validating the dataset and creating business-ready metrics.

Major SQL steps included:

- Creating database and staging table
- Importing raw CSV data
- Checking row count and table structure
- Checking missing values
- Checking duplicate campaign IDs
- Validating date conversion
- Checking campaign funnel logic
- Creating calculated fields:
  - Estimated spend
  - Profit
  - Calculated ROI
  - ROAS
  - CTR
  - CPC
  - CPL
- Creating campaign classification logic
- Aggregating performance by:
  - Campaign type
  - Customer segment
  - Marketing channel
  - Month

---

## Tableau Dashboard

The Tableau dashboard was designed to be crisp and business-focused. It includes KPI cards and four main charts.

### KPI Cards

- Total Campaigns
- Total Conversions
- Total Revenue
- Estimated Spend
- Total Profit
- Overall ROI

### Charts Used

1. **Campaign Type Performance by Profit**  
   Shows which campaign type generated the highest total profit.

2. **Customer Segment Performance by Profit**  
   Identifies the most profitable customer segments.

3. **Top 5 Marketing Channels by Profit**  
   Highlights the highest-profit marketing channels.

4. **Monthly Revenue and Profit Trend**  
   Shows monthly movement of revenue and profit across the reporting period.

### Interactive Filters

The dashboard includes filters for:

- Campaign Type
- Customer Segment
- Performance Category

---

## Key Insights

- The campaign portfolio generated **₹28,656.36M revenue** and **₹18,957.24M profit**.
- Overall ROI was **1.95x**, meaning every ₹1 of estimated spend generated ₹1.95 in profit.
- **Social Media** was the strongest campaign type by total profit.
- **Working Women** was the highest-profit customer segment.
- **Instagram** led the top marketing channels by profit.
- Monthly revenue and profit remained broadly stable across the reporting period.
- June 2025 was a partial month and should not be directly compared with full months.

---

## Business Recommendations

- Scale high-performing Social Media campaigns.
- Prioritize campaigns targeting Working Women due to strong profitability.
- Continue investing in Instagram as a high-profit marketing channel.
- Review weaker segments and campaign types to improve targeting, content, and cost efficiency.
- Monitor months with lower ROI to identify cost inefficiencies.

---

## Live Dashboard

View the Tableau Public dashboard here:
https://public.tableau.com/app/profile/omkar.ambulkar/viz/Nykadashboard-compeletefile/NykaaCampaignDashboard

---

## Project Walkthrough Video

Watch the dashboard walkthrough here:
https://youtu.be/oln90wOCoM8

---

## Project Documentation

- [One-page project overview](docs/Nykaa_Marketing_Campaign_Project_One_Page_Overview.docx)


---

## Repository Structure

```text
Nykaa-Marketing-Campaign-Dashboard
│
├── README.md
├── sql/
│   └── nykaa_campaign_sql_queries.sql
├── docs/
│   ├── Nykaa_Marketing_Campaign_Project_One_Page_Overview.docx
│   └── Nykaa_Marketing_Campaign_Detailed_Interview_Prep.docx
├── images/
│   └── dashboard_screenshot.png
├── videos/
│   └── nykaa_dashboard_walkthrough.mp4
└── data/
    └── sample_dataset_or_final_table.csv
