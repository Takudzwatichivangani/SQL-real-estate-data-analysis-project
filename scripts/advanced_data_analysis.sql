/*
============================================================
REAL ESTATE ANALYTICS PROJECT — ADVANCED DATA ANALYTICS
============================================================

PROJECT OVERVIEW
------------------------------------------------------------
This SQL script focuses on advanced analytical techniques applied 
to the Real Estate Data Warehouse (Gold Layer). The purpose is to 
derive deeper insights into sales performance, market behavior, 
and property trends across time, geography, and categories.

------------------------------------------------------------
OBJECTIVES
------------------------------------------------------------
1. Analyze year-over-year and month-over-month sales trends.  
2. Compute cumulative and running totals for sales revenue and averages.  
3. Evaluate property type performance relative to historical and average benchmarks.  
4. Perform part-to-whole analysis to measure contribution by property category.  
5. Segment property sales based on pricing ranges for better market understanding.

------------------------------------------------------------
DATA SOURCE
------------------------------------------------------------
- gold.fact_sales  
- gold.dim_properties  

------------------------------------------------------------
NOTES
------------------------------------------------------------
This analysis expands on descriptive analytics by introducing 
trend, comparative, and segmentation insights. It leverages 
advanced SQL functions such as CTEs, window functions, 
and conditional logic for dynamic performance analysis.

============================================================
*/


-- Advanced Data Analytics

-- 1) Change-Over-Time Trends
-- Analyze the sales performance over time
SELECT
DATE_FORMAT(sale_date, '%Y') AS yearly_sales,
FORMAT(SUM(sale_price), 0) AS total_sales_revenue,
COUNT(DISTINCT sales_id) AS total_number_of_sales,
COUNT(DISTINCT client_id) AS total_clients
FROM gold.fact_sales
GROUP BY yearly_sales
ORDER BY yearly_sales;

-- 2) Cumulative Analysis
-- Calculate the total sales per month and the running total of sales over time
SELECT 
monthly_sales,
total_sales_revenue,
total_sales_average,
SUM(total_sales_revenue) OVER(ORDER BY monthly_sales) AS running_total_sales,
AVG(total_sales_average) OVER(ORDER BY monthly_sales) AS running_average_sales
FROM 
(
SELECT 
DATE_FORMAT(sale_date, '%m') monthly_sales,
SUM(sale_price) AS total_sales_revenue,
AVG(sale_price) AS total_sales_average
FROM gold.fact_sales
GROUP BY monthly_sales
) t;

-- 3)Perfomance Analysis
-- Analyze the yearly perfomance of property types by comparing each property type to both its average sales perfomance and the previous years sales
WITH yearly_property_sales AS (
SELECT 
DATE_FORMAT(f.sale_date, '%Y') year,
p.property_type,
SUM(f.sale_price) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY DATE_FORMAT(f.sale_date, '%Y'), p.property_type
)
SELECT year,
property_type,
current_sales,
AVG(current_sales) OVER(PARTITION BY property_type) AS average_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY property_type) AS diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY property_type) > 0 THEN 'Above Average'
	 WHEN current_sales - AVG(current_sales) OVER(PARTITION BY property_type) < 0 THEN 'Below Average'
     ELSE  'Average'
END AS average_change,
LAG(current_sales) OVER(PARTITION BY property_type ORDER BY year) AS previous_sales,
current_sales - LAG(current_sales) OVER(PARTITION BY property_type ORDER BY year) AS previous_sales,
CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY property_type ORDER BY year) > 0 THEN 'Increase'
     WHEN current_sales - LAG(current_sales) OVER(PARTITION BY property_type ORDER BY year) < 0 THEN 'Decrease'
     ELSE 'No Change'
END AS diff_py
FROM yearly_property_sales
ORDER BY year, property_type;

-- 4)Part-to-Whole Analysis
-- Which property type contribute to the most overall sales
WITH property_sales AS (
SELECT
p.property_type,
SUM(f.sale_price) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p 
ON f.property_id = p.property_id
GROUP BY p.property_type)

SELECT 
property_type,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND(total_sales/SUM(total_sales) OVER() * 100, 2), '%') AS percentage_of_total
FROM property_sales;

-- 5)Data Segmentation
-- Property types sales price ranges
WITH property_segments AS (
SELECT 
f.property_id,
p.property_type,
F.sale_price,
CASE WHEN sale_price < 500000 THEN 'Below 500K'
     WHEN sale_price BETWEEN 500000 AND 1000000 THEN '500K-1M'
     ELSE 'Above 1M'
END AS cost_ranges
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id)

SELECT 
cost_ranges,
COUNT(cost_ranges) AS total_properties
FROM property_segments
GROUP BY cost_ranges;
