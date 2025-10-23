/*
============================================================
REAL ESTATE ANALYTICS PROJECT — FINAL CLIENT REPORT
============================================================

PROJECT OVERVIEW
------------------------------------------------------------
This script generates the final consolidated client report view 
(`gold.report_clients`) that profiles client performance, 
engagement, and value within the Real Estate Data Warehouse.  
It integrates key metrics from transactional and dimensional data 
to support strategic decision-making, client segmentation, 
and business intelligence reporting.

------------------------------------------------------------
OBJECTIVES
------------------------------------------------------------
1. Aggregate client-level sales and engagement data.  
2. Derive key customer metrics including total sales, properties sold,  
   lifespan, and recency.  
3. Segment clients into categories (VIP, Regular, New) based on  
   performance thresholds.  
4. Compute customer monthly averages and active duration for retention analysis.  
5. Provide a unified, query-ready reporting view for business insights.

------------------------------------------------------------
DATA SOURCE
------------------------------------------------------------
- gold.fact_sales  
- gold.dim_clients  

------------------------------------------------------------
NOTES
------------------------------------------------------------
This final deliverable represents the culmination of the 
data analysis workflow. It transforms analytical results into 
an operational business report suitable for dashboards and 
client relationship management (CRM) insights.  

============================================================
*/

-- Final Client/Customer Report

CREATE OR REPLACE VIEW gold.report_clients AS
WITH base_query AS (
SELECT 
f.sales_id,
f.property_id,
f.client_id,
f.agency,
f.sale_date,
f.sale_price,
c.client_name,
c.client_phone_number, 
c.client_email
FROM gold.fact_sales f
LEFT JOIN gold.dim_clients c
ON f.client_id = c.client_id),

client_aggregation AS (
SELECT
client_id,
client_name,
client_email,
SUM(sale_price) AS total_sales,
COUNT(DISTINCT property_id) AS total_properties_sold,
TIMESTAMPDIFF(month, MIN(sale_date), MAX(sale_date)) AS lifespan,
TIMESTAMPDIFF(month, MAX(sale_date), CURDATE()) AS recency,
MAX(sale_date) AS last_order_date
FROM base_query
GROUP BY client_id, client_name, client_email)

SELECT 
client_id,
client_name,
client_email,
CASE WHEN lifespan >= 12 AND total_sales > 2000000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_sales BETWEEN 1000000 AND 2000000 THEN 'Regular'
     ELSE 'New'
END AS customer_segment,
last_order_date,
total_sales,
total_properties_sold,
lifespan,
recency,
CASE WHEN lifespan = 0 THEN total_sales
     ELSE ROUND(total_sales/lifespan, 2)
END AS monthly_average
FROM client_aggregation;

-- View
SELECT * FROM gold.report_clients;
