-- Nykaa Marketing Campaign Performance Dashboard
-- SQL Queries Used for Data Validation, Cleaning, KPI Engineering and Analysis

CREATE DATABASE nykaa_marketing_db;

USE nykaa_marketing_db;

-- 1. Create staging table
CREATE TABLE nykaa_campaign_staging (
    Campaign_ID VARCHAR(50),
    Campaign_Type VARCHAR(100),
    Target_Audience VARCHAR(100),
    Duration INT,
    Channel_Used VARCHAR(255),
    Impressions INT,
    Clicks INT,
    Leads INT,
    Conversions INT,
    Revenue DECIMAL(15,2),
    Acquisition_Cost DECIMAL(15,2),
    ROI DECIMAL(10,4),
    Language VARCHAR(50),
    Engagement_Score DECIMAL(10,2),
    Customer_Segment VARCHAR(100),
    Date VARCHAR(20)
);

-- 2. Check total imported rows
SELECT COUNT(*) AS total_rows
FROM nykaa_campaign_staging;

-- 3. Preview first 20 rows
SELECT *
FROM nykaa_campaign_staging
LIMIT 20;

-- 4. Check table structure
DESCRIBE nykaa_campaign_staging;

-- 5. Check missing values
SELECT COUNT(*) AS rows_with_missing_values
FROM nykaa_campaign_staging
WHERE Campaign_ID IS NULL OR Campaign_ID = ''
   OR Campaign_Type IS NULL OR Campaign_Type = ''
   OR Target_Audience IS NULL OR Target_Audience = ''
   OR Duration IS NULL
   OR Channel_Used IS NULL OR Channel_Used = ''
   OR Impressions IS NULL
   OR Clicks IS NULL
   OR Leads IS NULL
   OR Conversions IS NULL
   OR Revenue IS NULL
   OR Acquisition_Cost IS NULL
   OR ROI IS NULL
   OR Language IS NULL OR Language = ''
   OR Engagement_Score IS NULL
   OR Customer_Segment IS NULL OR Customer_Segment = ''
   OR Date IS NULL OR Date = '';

-- 6. Check duplicate Campaign IDs
SELECT
    Campaign_ID,
    COUNT(*) AS duplicate_count
FROM nykaa_campaign_staging
GROUP BY Campaign_ID
HAVING COUNT(*) > 1;

-- 7. Check date range
SELECT
    MIN(STR_TO_DATE(Date, '%d-%m-%Y')) AS earliest_campaign_date,
    MAX(STR_TO_DATE(Date, '%d-%m-%Y')) AS latest_campaign_date
FROM nykaa_campaign_staging;

-- 8. Check impossible negative values
SELECT *
FROM nykaa_campaign_staging
WHERE Impressions < 0
   OR Clicks < 0
   OR Leads < 0
   OR Conversions < 0
   OR Revenue < 0
   OR Acquisition_Cost < 0
   OR Duration < 0
   OR Engagement_Score < 0;

-- 9. Check marketing funnel logic
SELECT *
FROM nykaa_campaign_staging
WHERE Clicks > Impressions
   OR Leads > Clicks
   OR Conversions > Leads;

-- 10. Create clean analysis table
DROP TABLE IF EXISTS nykaa_campaign_clean;

CREATE TABLE nykaa_campaign_clean AS
SELECT
    Campaign_ID AS campaign_id,
    Campaign_Type AS campaign_type,
    Target_Audience AS target_audience,
    Duration AS duration_days,
    Channel_Used AS channel_used,
    Impressions AS impressions,
    Clicks AS clicks,
    Leads AS leads,
    Conversions AS conversions,
    Revenue AS revenue,
    Acquisition_Cost AS acquisition_cost,
    ROI AS source_roi,
    Language AS campaign_language,
    Engagement_Score AS engagement_score,
    Customer_Segment AS customer_segment,
    STR_TO_DATE(Date, '%d-%m-%Y') AS campaign_date,

    ROUND(Acquisition_Cost * Conversions, 2) AS estimated_spend,

    ROUND(
        Revenue - (Acquisition_Cost * Conversions),
        2
    ) AS profit,

    ROUND(
        (Revenue - (Acquisition_Cost * Conversions))
        / NULLIF(Acquisition_Cost * Conversions, 0),
        2
    ) AS calculated_roi,

    ROUND(
        Revenue / NULLIF(Acquisition_Cost * Conversions, 0),
        2
    ) AS roas,

    ROUND(
        Clicks / NULLIF(Impressions, 0) * 100,
        2
    ) AS click_through_rate_pct,

    ROUND(
        Leads / NULLIF(Clicks, 0) * 100,
        2
    ) AS click_to_lead_rate_pct,

    ROUND(
        Conversions / NULLIF(Leads, 0) * 100,
        2
    ) AS lead_to_conversion_rate_pct,

    ROUND(
        Conversions / NULLIF(Clicks, 0) * 100,
        2
    ) AS click_to_conversion_rate_pct,

    ROUND(
        (Acquisition_Cost * Conversions) / NULLIF(Clicks, 0),
        2
    ) AS cost_per_click,

    ROUND(
        (Acquisition_Cost * Conversions) / NULLIF(Leads, 0),
        2
    ) AS cost_per_lead

FROM nykaa_campaign_staging;

-- 11. Check clean table row count
SELECT COUNT(*) AS clean_table_rows
FROM nykaa_campaign_clean;

-- 12. Validate ROI mismatch
SELECT
    COUNT(*) AS roi_mismatch_rows
FROM nykaa_campaign_clean
WHERE ABS(source_roi - calculated_roi) > 0.05;

-- 13. Performance benchmark query
SELECT
    ROUND(AVG(calculated_roi), 2) AS average_roi,
    ROUND(AVG(revenue), 2) AS average_revenue,
    ROUND(AVG(profit), 2) AS average_profit
FROM nykaa_campaign_clean;

-- 14. Create final campaign classification table
DROP TABLE IF EXISTS nykaa_campaign_final;

CREATE TABLE nykaa_campaign_final AS
SELECT
    *,

    CASE
        WHEN calculated_roi >= 2.71
             AND revenue >= 515819.72
        THEN 'High Performer'

        WHEN calculated_roi >= 2.71
             AND revenue < 515819.72
        THEN 'Efficient but Low Revenue'

        WHEN calculated_roi < 2.71
             AND revenue >= 515819.72
        THEN 'High Revenue but Low ROI'

        ELSE 'Underperformer'
    END AS performance_category,

    CASE
        WHEN calculated_roi >= 2.71
             AND revenue >= 515819.72
        THEN 'Scale Campaign'

        WHEN calculated_roi >= 2.71
             AND revenue < 515819.72
        THEN 'Increase Budget Carefully'

        WHEN calculated_roi < 2.71
             AND revenue >= 515819.72
        THEN 'Optimize Cost'

        ELSE 'Reduce Spend'
    END AS recommended_action

FROM nykaa_campaign_clean;

-- 15. Overall KPI summary
SELECT
    COUNT(DISTINCT campaign_id) AS total_campaigns,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(estimated_spend), 2) AS total_estimated_spend,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(estimated_spend), 0),
        2
    ) AS overall_roi,
    SUM(conversions) AS total_conversions
FROM nykaa_campaign_final;

-- 16. Campaign type performance
SELECT
    campaign_type,
    COUNT(DISTINCT campaign_id) AS total_campaigns,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(estimated_spend), 2) AS total_estimated_spend,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(estimated_spend), 0),
        2
    ) AS overall_roi,
    SUM(conversions) AS total_conversions
FROM nykaa_campaign_final
GROUP BY campaign_type
ORDER BY total_profit DESC;

-- 17. Customer segment performance
SELECT
    customer_segment,
    COUNT(DISTINCT campaign_id) AS total_campaigns,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(estimated_spend), 2) AS total_estimated_spend,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(estimated_spend), 0),
        2
    ) AS overall_roi,
    SUM(conversions) AS total_conversions
FROM nykaa_campaign_final
GROUP BY customer_segment
ORDER BY total_profit DESC;

-- 18. Marketing channel performance
SELECT
    channel_used,
    COUNT(DISTINCT campaign_id) AS total_campaigns,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(estimated_spend), 2) AS total_estimated_spend,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(estimated_spend), 0),
        2
    ) AS overall_roi,
    SUM(conversions) AS total_conversions
FROM nykaa_campaign_final
GROUP BY channel_used
ORDER BY total_profit DESC;

-- 19. Monthly revenue and profit trend
SELECT
    DATE_FORMAT(campaign_date, '%Y-%m') AS campaign_month,
    COUNT(DISTINCT campaign_id) AS total_campaigns,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(estimated_spend), 2) AS total_estimated_spend,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(estimated_spend), 0),
        2
    ) AS overall_roi,
    SUM(conversions) AS total_conversions
FROM nykaa_campaign_final
GROUP BY DATE_FORMAT(campaign_date, '%Y-%m')
ORDER BY campaign_month;
