# 🏘️ Real Estate Data Analysis Using SQL  

> **Discover the Secrets Hidden in Real Estate Data** 🔍  
> Behind every sale lies a story — and this project uncovers it.  
> Using advanced SQL techniques, the analysis explores **who buys, what sells, and when the market peaks**.  
> From identifying high-performing agents and agencies to revealing profitable regions and client behaviors,  
> this project turns raw property transactions into **data-driven insights that power real estate decisions**.

---

## 📊 Project Overview
This project focuses on performing **data analysis on real estate sales data using SQL** to extract meaningful business insights.  
The analysis explores **property sales, agent performance, customer activity,** and **revenue trends** across different regions and time periods.

The goal is to transform raw transactional data into actionable insights that can guide decision-making in the real estate industry.

---

## 🎯 Objectives
- Analyze property sales and pricing trends across different cities and states  
- Identify top-performing agents and offices  
- Segment clients based on purchase behavior and sales contribution  
- Discover high-value properties and profitable market regions  
- Track sales performance by month and quarter  

---

## 🧩 Dataset Description
The project uses multiple datasets representing different business entities:

| Table | Description |
|--------|--------------|
| **fact_sales** | Contains details of each property sale (price, date, agent, client, etc.) |
| **dim_properties** | Information about properties such as city, state, and type |
| **dim_clients** | Contains client contact and demographic details |
| **dim_agents** | Includes agent details and the agencies they represent |

---

## 🧮 SQL Concepts Applied
- **Joins (INNER, LEFT)** – To combine data from multiple related tables  
- **Aggregations** – SUM, COUNT, AVG for analyzing totals and averages  
- **Window Functions** – RANK(), ROW_NUMBER(), DENSE_RANK() for ranking and comparison  
- **CTEs (Common Table Expressions)** – To organize and simplify complex queries  
- **Date Functions** – For monthly and yearly trend analysis  
- **CASE Statements** – For client segmentation and business categorization  

---

## 🔍 Key Analytical Questions (Advanced Analytics)
1. Which **states or cities** generate the most total sales revenue and property transactions?  
2. Which **months or quarters** record the highest total property sales and revenue?  
3. Which **property types** achieve the highest average sale prices and volumes?  
4. Who are the **top-performing agents or agencies** based on total sales value and transaction count?  
5. Which **clients** demonstrate the highest lifetime value and consistent engagement patterns?  
6. What is the **year-over-year growth rate** in total sales value across cities?  
7. How can clients be segmented into **VIP, Regular, and New** categories using purchase behavior metrics?  

---

## 🗂️ Final Analytical Views
The final SQL scripts generate key analytical reports and summary tables including:

| View Name | Description |
|------------|--------------|
| **`gold.report_property_sales`** | Tracks property sales performance by city, property type, and state |
| **`gold.report_agents`** | Evaluates and ranks agents by total revenue and transaction count |
| **`gold.report_clients`** | Segments clients by lifetime value, recency, and purchasing behavior |

---

## ⚙️ Tools & Technologies
- **Language:** SQL  
- **Database:** MySQL  
- **Tools Used:** MySQL Workbench / DBeaver  
- **Core Focus:** Business Intelligence and Analytical SQL  

---

## 📈 Insights Generated
- Identified **top-performing regions** driving the highest revenue and sales volume  
- Highlighted **high-value agents** and agency networks with the strongest market performance  
- Revealed **client lifetime value** and segmentation for strategic engagement  
- Exposed **seasonal and monthly trends** to assist in market timing and forecasting  
- Provided a foundation for **advanced data-driven real estate analysis**

---
   ```bash
   git clone https://github.com/<your-username>/real-estate-sql-analysis.git
