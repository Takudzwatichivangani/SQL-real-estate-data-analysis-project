/*
============================================================
REAL ESTATE ANALYTICS PROJECT — EXPLORATORY DATA ANALYSIS
============================================================

PROJECT OVERVIEW
------------------------------------------------------------
This SQL script performs comprehensive Exploratory Data Analysis (EDA)
on the Real Estate Data Warehouse (Gold Layer). The goal is to uncover 
key insights into property sales performance, agent activity, and 
regional revenue trends.

------------------------------------------------------------
OBJECTIVES
------------------------------------------------------------
1. Explore database structure and dimensions (states, cities, property types, agencies).  
2. Compute key business measures such as total revenue, average sale price, and sales volume.  
3. Perform magnitude analysis to compare performance across different dimensions.  
4. Apply ranking analysis to identify top-performing regions, property types, and agencies.  
5. Establish a foundation for advanced trend and predictive analytics.

------------------------------------------------------------
DATA SOURCE
------------------------------------------------------------
- gold.fact_sales  
- gold.dim_properties  
- gold.dim_clients  

------------------------------------------------------------
NOTES
------------------------------------------------------------
This script focuses on descriptive and diagnostic analytics.
All measures are formatted for readability, and results are grouped
by relevant dimensions to support reporting and visualization.

============================================================
*/


-- EXPLORATORAY DATA ANALYSIS (EDA)

-- Explore All Objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES;


-- Explore All Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_properties';

-- Dimension Exploration
-- Explore All states
SELECT DISTINCT state FROM gold.dim_properties;


-- Explore All cities
SELECT DISTINCT city FROM gold.dim_properties;


-- Explore All types of properties
SELECT DISTINCT property_type FROM gold.dim_properties;

-- Explore All agencies
SELECT DISTINCT agency FROM gold.dim_properties;


-- Date Exploration
SELECT 
MIN(sale_date) AS first_sale_date,
MAX(sale_date) AS last_sale_date,
TIMESTAMPDIFF(YEAR, MIN(sale_date), MAX(sale_date)) AS sales_range_years
FROM gold.fact_sales;

-- Measures Exploration

-- What is the total sales value (sum of sale_price)?
SELECT FORMAT(SUM(sale_price), 2) AS total_sales FROM gold.fact_sales;

-- What is the total number of sales?
SELECT FORMAT(COUNT(sales_id), 0) AS total_number_of_sales FROM gold.fact_sales;
SELECT FORMAT(COUNT(DISTINCT sales_id), 0) AS total_number_of_sales FROM gold.fact_sales;


-- What is the average sale price ?
SELECT FORMAT(AVG(sale_price), 2) AS average_sale_price FROM gold.fact_sales;


-- How many distinct properties were sold?
SELECT FORMAT(COUNT(DISTINCT property_id), 0) AS properties_sold FROM gold.dim_properties;

-- How many distinct clients made purchases?
SELECT FORMAT(COUNT(DISTINCT client_id), 0) AS properties_sold FROM gold.dim_clients;


-- Generate a report that shows all the key metrics of the business
SELECT 'Total Sales (Revenue)' AS measure_name, FORMAT(SUM(sale_price), 2) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Number of Sales' AS measure_name,  FORMAT(COUNT(sales_id), 0) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Sales' AS measure_name, FORMAT(AVG(sale_price), 2) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Number of Properties Sold' AS measure_name, FORMAT(COUNT(DISTINCT property_id), 0) AS measure_value FROM gold.dim_properties
UNION ALL
SELECT 'Total Number of Clients' AS measure_name, FORMAT(COUNT(DISTINCT client_id), 0) AS measure_value FROM gold.dim_clients;



-- Magnitude Analysis (Comparing measure values by categories)
-- Total sales revenue by city
SELECT p.city, FORMAT(SUM(f.sale_price), 0) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY p.city
ORDER BY SUM(f.sale_price) DESC;


-- Average sale prices vary across different states or cities?
SELECT p.city, FORMAT(AVG(f.sale_price), 0) average_price
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY p.city
ORDER BY SUM(f.sale_price) DESC;


-- Property types by total sales value?
SELECT p.property_type, FORMAT(SUM(f.sale_price),0) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY p.property_type 
ORDER BY SUM(f.sale_price) DESC;


-- City by properties sold
SELECT p.city, COUNT(f.sales_id) AS total_properties_sold
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY p.city
ORDER BY total_properties_sold DESC;


-- Which agents have the highest number of sales and revenue?
SELECT p.agency, FORMAT(COUNT(f.sales_id), 0) Total_number_of_sales, FORMAT(SUM(f.sale_price), 0) Total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY p.agency
ORDER BY COUNT(f.sales_id) DESC;

-- Ranking Analysis (Dimension By Measure)

-- Which property types consistently rank highest in terms of average sale price?
SELECT p.property_type, FORMAT(AVG(f.sale_price), 2) AS average_sale_price,
RANK() OVER (ORDER BY AVG(f.sale_price) DESC) AS ranking_for_average_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY p.property_type
ORDER BY AVG(f.sale_price) DESC;


-- Which states or regions generate the most total sales revenue and property transactions?
SELECT 
p.state,
FORMAT(SUM(f.sale_price), 0) AS sales_revenue,
FORMAT(COUNT(f.property_id), 0) AS property_transactions,
RANK() OVER (ORDER BY SUM(f.sale_price) DESC) AS state_revenue_rank,
RANK() OVER (ORDER BY COUNT(f.property_id) DESC) AS transaction_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY p.state
ORDER BY SUM(f.sale_price) DESC;


-- Which agencies achieve the highest average property value sold?
SELECT p.agency, FORMAT(AVG(f.sale_price), 0) average_price,
RANK() OVER(ORDER BY AVG(f.sale_price) DESC) AS agency_average_sales_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY p.agency
ORDER BY AVG(f.sale_price) DESC;

-- Which months or quarters record the highest total property sales and revenue?
SELECT DATE_FORMAT(f.sale_date, '%Y-%m') AS month, 
FORMAT(SUM(f.sale_price), 0) total_sales_revenue,
FORMAT(COUNT(f.sales_id), 0) total_properties_sold,
RANK() OVER(ORDER BY SUM(f.sale_price) DESC) AS revenue_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_properties p
ON f.property_id = p.property_id
GROUP BY DATE_FORMAT(f.sale_date, '%Y-%m')
ORDER BY SUM(f.sale_price) DESC;
