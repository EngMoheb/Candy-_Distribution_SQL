# 🏭Candy-Distribution_SQL🍭
![ Cover](Assets/Profile.jpg)

## 📌 About the Project
This project explores a real-world dataset about the US candy industry. We uploaded the CSV files into VS Code, created a PostgreSQL database, and established a connection between them. Also we build a clean database foundation and prepare the data to answer key business questions about candy sales, factory efficiency, and regional trends.

---
## 🎯 Objectives
In this project, our main objectives are:

- ✅ Understand and structure the US Candy sales data.  
- ✅ Solve real business problems by identifying profitable products, comparing sales to targets, and providing advanced data analysis.
- ✅ Explore seasonality and regional trends in candy sales.  
- ✅ Compare product performance against division targets.  
- ✅ Build a maintainable, clean database schema with a clear ER diagram.
- ✅ Uncover data trends and hidden insights using advanced SQL techniques.
---

## 🗂️ Data Source & Context
**_Source👉_**: [**Maven Analytics “US Candy Distributor”**](https://www.mavenanalytics.io/data-playground?order=date_added%2Cdesc&search=candy%20distributor)



**Why This Candy Dataset?**
 
- **Balanced Size:** Ideal for both complex SQL queries and rapid iteration.
- **Geospatial & Time Series Data:** Includes latitude/longitude coordinates, order dates, and shipping information, ideal for joins, distance calculations, and time-based analyses.
- **Business Relevance:** SKU-level sales data, factory origins, customer locations, and division targets mirror real-world retail/distribution analytics scenarios.
- **Well-Organised CSV Files:** Multiple files represent distinct tables in a relational model.


_**Here is a short description for each CSV file & its columns**_:

1.**Sales.csv**  
   - **Columns**: `row_id`, `order_id`, `order_date`, `ship_date`, `customer_id`,  
     `division`, `product_id`, `units`, `gross_profit`, `cost`, etc.  
   - **Describes**: Individual sales transactions linking customers, products, and financials.

2.  **Factories.csv**  
   - **Columns**: `factory_name`, `latitude`, `longitude`  
   - **Describes**: Candy factory names and their geographic locations.

3. **Targets.csv**  
   - **Columns**: `division`, `Target_Count`  
   - **Describes**: Sales targets for each division (Chocolate, Sugar, Other).

4.  **Products.csv**  
   - **Columns**: `product_id`, `product_name`, `division`, `factory_name`, `unit_cost`, `unit_price`  
   - **Describes**:  type of candy and  its division, factory origin, and cost/price.

5. **us_zips.csv**  
   - **Columns**: `zip`, `lat`, `lng`, `city`, `state_id`, `state_name`,  
     `zcta`, `population`, `density`, `county_fips`, `county_name`, `timezone`  
   - **Describes**: ZIP-level geographic and demographic data for mapping customers.

6. **Dictionary.csv**
   
    _Lists descriptions for the tables & their columns._

---  dinner

> **_Now let's move into the deep work🕵️‍♂️_**

## 📑 Phase 1: Business & Data Understanding
- ✅ **Created** the PostgreSQL database and defined tables matching our CSV structures.  
- ✅ **Uploaded** CSV data into those tables using VS Code’s SQL editor.
- ✅ Verified row counts for each table matched CSV sources.  
- 🧹 Dropped unused columns from `us_zips` to keep only zip, zcta, state, county, population, density, timezone.   
- ✅ **Clarified** the business questions we’ll answer by analysing our dataset:

 **General Questions**

1. Which categories & products generate the highest profits?  
2. What are the top-selling categories & products by quantity?  
3. Which shipping routes are the most expensive?

**Geographic & Optimization**

1. Which customer–factory pairs are least efficient (long distance + low margin)?  
2. Are there specific states/regions with higher return on sales?

**Time-Based Trends**

1. How do monthly/quarterly sales trends look?  
2. Are there specific weekdays or weekends with higher volume or profit?

**Advanced Questions**

1. Who are the top 5 Customers Over Time?
2. How has profit changed over time for each category?
3. Which product lines should be moved to a different factory to optimize shipping routes?
   


### 🔗 ERD Diagram
    FACTORIES ||--o{ PRODUCTS       : factory_name
    TARGETS   ||--o{ PRODUCTS       : division
    TARGETS   ||--o{ SALES          : division
    PRODUCTS  ||--o{ SALES          : product_id
    US_ZIPS   ||--o{ SALES          : postal_code


### ERD Explained

- **FACTORIES → PRODUCTS** (`products.factory_name` → `factories.factory_name`)  
  One factory can produce many products.

- **TARGETS → PRODUCTS** (`products.division` → `targets.division`)  
  Each product belongs to a division that has a sales target.

- **TARGETS → SALES** (`sales.division` → `targets.division`)  
  Each sale is classified under a division with an associated target.

- **PRODUCTS → SALES** (`sales.product_id` → `products.product_id`)  
  A product can appear in many sales records.

- **US_ZIPS → SALES** (`sales.postal_code` → `us_zips.zip`)  
  Each sale’s customer ZIP links to geographic data.


---

## 🛠️ Tools Used

- **PostgreSQL** – Relational database for storing and querying data.  
- **VS Code** – IDE for writing SQL, managing CSVs, and connecting to the database.  
- **Git & GitHub** – Version control and documentation of the entire process.  
- **Sider AI** –  Explored multiple AI models for the data analysis journey. 
- **DeepSeek** – Automated code review & best-practice suggestions.  
- **Perplexity** – Contextual search for technical guidance & fact-checking.
- **GPT**–  Drafted and refined narrative content
- **Grammarly** – Writing assistant to polish documentation.  

---
 
# **Phase:** 2 of 3  🧹 Data Cleaning & Preparation 
 

## 🔍 Overview

During **Phase 2**, we cleaned and prepared 5 core tables:

- **`factories`**  
- **`targets`**  
- **`products`**  
- **`us_zips`**  
- **`sales`**

For each table, we:

1. **✅Validated Data Types & Removed Nulls / Invalid Values**  
2. **✂️Trimmed Whitespace & Normalized text casing**  
3. **📏 Checked ranges for numeric & date columns**  
4. **🔍 Ensured uniqueness & removed duplicates**  
5. **🔗 Enforced foreign key integrity relationships**  
6. **⚡ Created indexes to boost query performance**

---

## ✨ Data Spa Treatment  
### 📝 Text Columns  
- Identified and resolved missing values like hidden chocolate 🍫
- Removed extra spaces from all text fields ✂️ 
- Standardized capitalization — no more SHOUTING or whispering 🗣️

### 🔢 Numeric Columns  
- Eliminated negative values🚫
- ⚖️ erified geographic coordinates: Confirmed coordinates were Earth-bound 🌍 and prices validity ≥ $0
-🚩Flagged unusual values for review 

### 📅 Date Columns  
- Removed time-traveling shipments (1930s orders? Not happening!)
- Ensured logical date sequences (ship after order)   
- Flagged unrealistic dates (like candy deliveries from the year 3000 🚀) 

### ✔️ Boolean Columns  
- Replaced ambiguous entries with clear TRUE/FALSE values  
- Verified categorical consistency

---

## 🧩 Table-by-Table Transformation  

### 🏭 Factories Table  
- 🏷️ Standardized naming conventions  ("sweet FACTORY" → "Sweet Factory")
- 🌎 Validated geographic coordinates 
- 🔑 Ensured each factory had a unique ID 

### 🎯 Targets Table  
- 📊Cleaned division names 
- 🎯 Validated targets to ensure all values were ≥ $0
- 🚫Eliminated duplicate divisions  — one division, one target

### 🍬 Products Table  
- 🆔 **Standardized product IDs** ("choc-123" → "CHOC-123")
- 💰 **Flagged invalid pricing** (no negative costs!) 
- 🤝 **Fixed foreign keys** — every product matched to a valid factory and division

### 📮 US Zips Table  
-**🗺️ Standardized geographic names** ("nEw yOrk" → "New York")
- **🧮 Verified population densities** were realistic
- 👪 **Fixed parent-child** ZIP relationships where needed

### 💰 Sales Table  
- 🕰️ **Removed 1930 shipments** that broke the space-time continuum
- 📦 **Added delivery  time metrics** -  delivery days + delivery categories  (Q1, Q2, Q3, Q4)  
- 💸**Flagged financial inconsistencies** (negative profits? Free candy?)  
- 🚢 **Cleaned up shipping modes** — removed invalid entries like "Same Day"
  
  ## 🕰️ Special Case: 1930 Shipments  
**The Mystery:**Some orders claimed to ship _before_ they were placed!
**Findings:**  
- 📅  56 records dated to 1930  
- 🕰️ Ship dates < order dates  
**Resolution:**  
- 🗑️ Deleted all impossible records
- 🔍 Implemented delivery metrics to prevent similar issues in the future
**Why?** Like stale candy, bad data spoils everything!  

---

## 🔗 Relationship Counseling (Foreign Keys)  
We resolved the connectivity between related tables:
-  **🛟 Rescued 427 sales** linked to missing products
- **📬 Repaired ZIP code gaps**
-  **🏷️ Ensured all products matched to valid division**
- **Reconnected orphaned data entries to their parent tables**.
> *"Like matching candy to wrappers - every piece belongs somewhere!"*  
---

## ⚡ Performance Optimization 
**Added 15 critical indexes to improve query speed**  
- **⏱️ Dramatically improved query speed for future deep analysis** 
- **🐢→⚡Transformed slow operations**  

> *Without indexes, queries crawl like caramel spills... 🐌
---

## 🎉 Results
_After our data spa care, we_: 
- 🪥 Scrubbed 10,000+  fields  
- 🔗 Repaired 427 relationships 
- 🚀 Added 15 performance-boosting indexes
- 🗑️ 56 invalid records removed 

 **_Our data is now_**:
✅ Consistent
✅ Relational
✅ Analysis-Ready 

 
> *"Clean data is like premium chocolate — pure, smooth, and deeply  satisfying!"** 

---
➡️ Next Steps: Analysis Phase!
With our dataset cleaned and polished, we’re ready to:

- 🍫 Uncover regional sales trends
- 📈  Identify top-performing products
- 🚚 Optimize delivery operations
- 🎯 Evaluate sales target performance

  **Let the sweet insights flow!** 🍬✨

---

# **Phase:** 3 of 3  EDA & Advanced Analysis

## 🧠 SQL_Skills_Used

- **Joins** across multiple tables  
- **CASE** statements for conditional logic  
- **Common Table Expressions (CTEs)** for modular queries  
- **Window Functions** for running totals and rankings  
- **Data Cleaning:** null handling, formatting  
- **Pivoting** via CASE for cross-tabs  
- **Date/Time Functions** for extracting year/quarter/week  
- **Views** to encapsulate reusable queries  
- **Query Optimization** with indexes and EXPLAIN  

---

before we dive into the bussiness questions, we have made something called _Big_Picture_Analysis _that is about Simple Aggregate  Profit Distribution that show us how our dataset looklike before the deep analysis

```sql
--Simple Aggregate & basic summary statistics

SELECT
 count(*)  AS num_orders,
 Sum(total_sales) AS total_sales,
 sum(gross_profit) AS total_profit,
ROUND(AVG(total_sales), 2) AS avg_sales_per_Order,
ROUND(AVG(gross_profit), 2) AS avg_profit_per_Order
    FROM
        sales
``` 
 



here is the result:






```sql
--Bucketed Profit Distribution

WITH profit_buckets AS (
  SELECT
    gross_profit,
    CASE
      WHEN gross_profit < 50   THEN '$0–$50'
      WHEN gross_profit < 100  THEN '$50–$100'
      WHEN gross_profit < 200  THEN '$100–$200'
      ELSE '$200+' 
    END AS bucket_label
  FROM sales
)
SELECT
  bucket_label,
  COUNT(*)                AS num_orders,
  SUM(gross_profit)       AS bucket_total_profit,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_orders
FROM profit_buckets
GROUP BY bucket_label
ORDER BY
  CASE 
    WHEN bucket_label = '$0–$50'   THEN 1
    WHEN bucket_label = '$50–$100' THEN 2
    WHEN bucket_label = '$100–200' THEN 3

    ELSE 4
  END;
``` 
 



here is the result:



the insights we take from this analysis


 **General Questionss**

1. Which categories & products generate the highest profits?

```sql
-- (Category)- Level Profit Query

SELECT
  division,
  SUM(total_sales)   AS total_sales,
  SUM(gross_profit)  AS total_profit
FROM 
      sales 
GROUP BY 
      division
ORDER BY 
    total_profit DESC;
 
--Product‐Level Profit Query

SELECT
  p.product_id,
  p.product_name,
  SUM(s.total_sales)  AS total_sales,
  SUM(s.gross_profit) AS total_profit
 FROM 
      sales s
JOIN 
  products p
ON s.product_id = p.product_id
GROUP BY
   p.product_id, p.product_name
ORDER BY 
  total_profit DESC
LIMIT 10;
```

 


the output 



DDD" Data_Driven_Decision"

Checking the result : same categories = same products

   
2. What are the top-selling categories & products by quantity?
```sql
-- Top_Selling_Categories_by_Quantity
SELECT
  division,
  SUM(units) AS total_units_sold
FROM 
  sales 
GROUP BY
   division
ORDER BY
   total_units_sold DESC;


-- Top_Selling_Products_by_Quantity

SELECT
  p.product_id,
  p.product_name,
  SUM(s.units) AS total_units_sold
 FROM 
  sales s
JOIN products p 
ON s.product_id = p.product_id
GROUP BY 
    p.product_name, p.product_id
ORDER BY
     total_units_sold DESC
LIMIT 9;
```

 


the output 

Checking the result : same categories = same products

DDD" Data_Driven_Decision"


   
3. Which shipping routes are the most expensive?

question explained : what most expensive mean?

code:
   
```sql
 -- 1. Map every product_id to its factory
WITH
  factory_loc AS (
    SELECT
      p.product_id,
      f.factory_name
    FROM products p
    JOIN factories f
      ON p.factory_name = f.factory_name
  ),
 
  -- 2. Map every ZIP to its city/state & postal code
  customer_loc AS (
    SELECT
     u.zip               AS customer_zip,
     u.city              AS customer_city,
     u.state_name        AS customer_state,
     s.postal_code AS zip
    FROM
       us_zips u
    JOIN sales s
      ON u.zip = s.postal_code
  ),
 

  -- 3. Build a sales view with origin & destination 
  sales_routes AS (
    SELECT
      s.row_id,
      fl.factory_name          AS factory,
      cl.zip                 AS customer_zip,
      cl.city                 AS customer_city,
      cl.state_name             AS customer_state,
      s.cost                   AS shipping_cost
    FROM sales s
    JOIN products p
      ON s.product_id = p.product_id
    JOIN factories fl
      on p.factory_name = fl.factory_name
    JOIN us_zips cl
      ON s.postal_code = cl.zip
  )

SELECT
  factory,
  customer_zip,  
    SUM(shipping_cost)     AS total_shipping_cost,
  COUNT(*)          AS num_orders,
  ROUND(AVG(shipping_cost), 2) AS avg_cost_per_order,
   customer_state,
  customer_city
    
FROM sales_routes
GROUP BY
  factory,
  customer_zip,
  customer_city,
  customer_state
ORDER BY
  total_shipping_cost DESC
LIMIT 10;
```

 


the output 



DDD" Data_Driven_Decision"





**Geographic & Optimization**

1. Which customer–factory pairs are least efficient (long distance + low margin)?

   explain miles_per_dollar_profit
  
```sql
WITH
  -- 1. Associate each product with its factory’s coordinates
  factory_loc AS (
    SELECT
      p.product_id,
      f.factory_name,
      f.latitude  AS factory_lat,
      f.longitude AS factory_lng
    FROM products p
    JOIN factories f
      ON p.factory_name = f.factory_name
  ),

  -- 2. Associate each ZIP code with customer coordinates and location
  customer_loc AS (
    SELECT
      zip               AS customer_zip,
      lat               AS cust_lat,
      lng               AS cust_lng,
      city              AS customer_city,
      state_name        AS customer_state
    FROM us_zips
  ),

  -- 3. Build a geo-coded sales stream, computing distance from factory to customer
  sales_geo AS (
    SELECT
      s.row_id,
      fl.factory_name,
      cl.customer_zip,
      cl.customer_city,
      cl.customer_state,
      s.gross_profit,
      -- Haversine formula to compute miles between two lat/long points
      3959 * acos(
        cos(radians(fl.factory_lat))
        * cos(radians(cl.cust_lat))
        * cos(radians(cl.cust_lng) - radians(fl.factory_lng))
        + sin(radians(fl.factory_lat))
        * sin(radians(cl.cust_lat))
      ) AS distance_miles
    FROM sales s
    JOIN factory_loc fl
      ON s.product_id = fl.product_id
    JOIN customer_loc cl
      ON s.postal_code = cl.customer_zip
  )

-- Final aggregation: for each factory–ZIP pair with ≥5 orders
SELECT
  factory_name,
  customer_zip,
  -- Ratio of average distance to average profit (miles per $1 profit)
  ROUND(
    AVG(distance_miles)::numeric
    / NULLIF(AVG(gross_profit),0)::numeric
  , 3) AS miles_per_dollar_profit,   -- KPI Measure
  ROUND(AVG(gross_profit)::numeric, 2) AS avg_profit_per_order,
  ROUND(AVG(distance_miles)::numeric, 1)  AS avg_distance_miles,
  customer_city,
  customer_state,
  COUNT(*) AS num_orders
FROM sales_geo
GROUP BY
   factory_name,
  customer_zip,
  customer_city,
  customer_state
HAVING COUNT(*) >= 5
ORDER BY
  miles_per_dollar_profit DESC
LIMIT 22;
```

 


the output 



DDD" Data_Driven_Decision"
  
2. Are there specific regions with higher return on sales?

```sql
-- Return-on-Sales (ROS) by Region
SELECT
  region,
  
  -- 1. Compute ROS = total gross profit ÷ total sales, rounded to 4 decimals
  ROUND(
    SUM(gross_profit)::numeric
    / NULLIF(SUM(total_sales), 0)::numeric
  , 4) AS ros,
  
  -- 2. Include total sales, profit, and volume for context
  SUM(total_sales)  AS total_sales,
  SUM(gross_profit) AS total_profit,
  SUM(units)        AS total_units_sold

FROM sales 

-- 3. Group by region to aggregate metrics region-wide
GROUP BY region

-- 4. Filter out any region with zero sales or very low volume
HAVING
     SUM(total_sales) > 0
 AND SUM(units)       >= 100

-- 5. Order by highest ROS and limit to top 10 regions
ORDER BY ros DESC
LIMIT 10;
```
the output 



DDD" Data_Driven_Decision"

**Time-Based Trends**

1. How do monthly/quarterly sales trends look?

   Your sales table simply has no orders logged after July 2024
   accuracy check , top months = top quarter
```sql
 --- A. Monthly Sales & Profit Trends (last 24 months)
WITH monthly AS (
  SELECT
    -- A. Determine the first day of each month for grouping
    DATE_TRUNC('month', order_date)::date AS period_start,
    -- B. Sum up the key metrics for that month
    SUM(total_sales)   AS sales,
    SUM(gross_profit)  AS profit,
    SUM(units)         AS units_sold
  FROM sales
  GROUP BY DATE_TRUNC('month', order_date)
  ORDER BY period_start
)
SELECT
  period_start,
  sales,
  profit,
  units_sold
FROM monthly
-- 3. Filter to most recent 24 months
WHERE period_start >= (DATE_TRUNC('month', NOW())::date - INTERVAL '24 months');


-- B. Quarterly Sales & Profit Trends (last 8 quarters = last 2 years =last 24 months)
WITH quarterly AS (
  SELECT
    -- 1. Truncate order_date to first day of quarter
    DATE_TRUNC('quarter', order_date)::date AS period_start,
    -- 2. Aggregate core metrics
    SUM(total_sales)   AS sales,
    SUM(gross_profit)  AS profit,
    SUM(units)         AS units_sold
  FROM sales
  GROUP BY DATE_TRUNC('quarter', order_date)
  ORDER BY period_start
)
SELECT
  period_start,
  sales,
  profit,
  units_sold
FROM quarterly
-- 3. Filter to most recent 8 quarters
WHERE period_start >= (DATE_TRUNC('quarter', NOW())::date - INTERVAL '24 months');
```

the output 



DDD" Data_Driven_Decision"


   
2. Are there specific weekdays or weekends with higher volume or profit?

```sql
-- Day-of-Week & Weekend vs. Weekday Metrics
WITH day_metrics AS (
  SELECT
    -- 1. Name of the weekday (e.g. Monday, Tuesday)
    TO_CHAR(order_date, 'FMDay') AS day_name,

    -- 2. Classify as “Weekend” if Saturday '6'/Sunday'0', otherwise “Weekday”
    CASE
      WHEN EXTRACT(DOW FROM order_date) IN (0,6) THEN 'Weekend'
      ELSE 'Weekday'
    END AS day_type,

    -- 3. Aggregate counts and dollar metrics
    COUNT(*)           AS num_orders,
    SUM(total_sales)   AS total_sales,
    SUM(gross_profit)  AS total_profit

  FROM sales
  GROUP BY
    TO_CHAR(order_date, 'FMDay'),
    CASE
      WHEN EXTRACT(DOW FROM order_date) IN (0,6) THEN 'Weekend'
      ELSE 'Weekday'
    END
)

SELECT
  day_name,
  day_type,
  num_orders,
  total_sales,
  total_profit,

  -- 4. Percentage of total orders by day
  ROUND(100.0 * num_orders / SUM(num_orders)    OVER (), 1) AS pct_of_orders,

  -- 5. Percentage of total profit by day
  ROUND(100.0 * total_profit / SUM(total_profit) OVER (), 1) AS pct_of_profit

FROM day_metrics

-- 6. Order rows Monday → Sunday
ORDER BY
  CASE day_name
    WHEN 'Monday'    THEN 1
    WHEN 'Tuesday'   THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday'  THEN 4
    WHEN 'Friday'    THEN 5
    WHEN 'Saturday'  THEN 6
    WHEN 'Sunday'    THEN 7
  END;
```

code explanation:



the output 



DDD" Data_Driven_Decision"

**Advanced Questions**

1. Who are the Top Lifetime Customers?
```sql
-- 1. Aggregate per customer and shipping mode
WITH customer_totals AS (
  SELECT
    customer_id,
    ship_mode,
    COUNT(*)          AS num_orders,      -- total orders placed
    SUM(total_sales)   AS total_sales,    -- total revenue generated
    SUM(gross_profit)  AS total_profit,   -- total gross profit earned
    SUM(units)         AS total_units     -- total units purchased
  FROM sales
  GROUP BY
    customer_id,
    ship_mode
),

-- 2. Rank customers by lifetime spend
ranked_customers AS (
  SELECT
    customer_id,
    ship_mode,
    num_orders,
    total_sales,
    total_profit,
    total_units,
    ROW_NUMBER() OVER (
      ORDER BY total_sales DESC          -- Rank highest-spending first
    ) AS customer_rank
  FROM customer_totals
)

-- 3. Retrieve the top five
SELECT
  customer_id,
  customer_rank,
  total_sales,
  total_profit,
  num_orders,
  total_units,
  ship_mode
FROM 
    ranked_customers
ORDER BY 
  customer_rank
 LIMIT 10;
```

code explanation:



the output 



DDD" Data_Driven_Decision"

   
2. How has profit changed over time for each category?

 ```sql
-- 1. Aggregate gross profit by division and year
WITH division_yearly AS (
  SELECT
  division,
    EXTRACT(YEAR FROM order_date)::int    AS order_year,    -- calendar year                            -- product category
    SUM(gross_profit)            AS total_profit   -- total yearly profit
  FROM sales 
  
  GROUP BY
  division,
    EXTRACT(YEAR FROM order_date)
    
),

-- 2. Compute prior-year profit for each division
division_trends AS (
  SELECT
    division,
    order_year,
    total_profit,
    LAG(total_profit) OVER (
      PARTITION BY division                    -- reset lag per category
      ORDER BY order_year                      -- chronological order
    ) AS prev_year_profit
  FROM division_yearly
)

-- 3. Final: year-over-year change and percent change
SELECT
  division,
  order_year,
  total_profit,
  prev_year_profit,
  (total_profit - prev_year_profit)        AS change_in_profit,    -- absolute diff
  ROUND(
    (total_profit - prev_year_profit)::numeric
    / NULLIF(prev_year_profit, 0)::numeric
  , 4)                                      AS pct_change            -- relative diff
FROM division_trends
WHERE prev_year_profit IS NOT NULL         -- exclude the first year (no prior data)
ORDER BY
  division,
  order_year;
```


the output 



DDD" Data_Driven_Decision"



3. Which product lines should be moved to a different factory to optimize shipping routes?
```sql
-- 1. Geo-encode each sale with division, origin factory, and customer coordinates
WITH sale_geo AS (
  SELECT
    p.division,                     -- product division/category
    f.factory_name,                 -- factory fulfilling the order
    f.latitude  AS fac_lat,         -- factory latitude
    f.longitude AS fac_lng,         -- factory longitude
    u.lat       AS cust_lat,        -- customer ZIP latitude
    u.lng       AS cust_lng         -- customer ZIP longitude
  FROM sales s
  JOIN products p
    ON s.product_id = p.product_id
  JOIN factories f
    ON p.factory_name = f.factory_name
  JOIN us_zips u
    ON s.postal_code = u.zip
),

-- 2. Calculate average shipping distance per division and factory
div_fac_dist AS (
  SELECT
    division,
    factory_name,
    AVG(
      3959 * acos(                  -- Haversine formula: miles between two lat/longs
        cos(radians(fac_lat))
        * cos(radians(cust_lat))
        * cos(radians(cust_lng) - radians(fac_lng))
        + sin(radians(fac_lat))
        * sin(radians(cust_lat))
      )
    ) AS avg_distance_miles
  FROM sale_geo
  GROUP BY division, factory_name
),

-- 3. Rank factories by their average distance for each division
ranked AS (
  SELECT
    division,
    factory_name,
    avg_distance_miles,
    ROW_NUMBER() OVER (
      PARTITION BY division           -- reset ranking within each product division
      ORDER BY avg_distance_miles     -- closest factory = rank 1
    ) AS rank_by_distance
  FROM div_fac_dist
)

-- 4. Identify sub-optimal factories and their optimal alternative
SELECT
  d1.division,
  d1.factory_name                         AS current_factory,
  ROUND(d1.avg_distance_miles::numeric, 1) AS current_avg_miles,

  -- **Add this** to show the name of the closest factory
  d2.factory_name                         AS optimal_factory,
  ROUND(d2.avg_distance_miles::numeric, 1) AS optimal_avg_miles,

  ROUND(
    (d1.avg_distance_miles - d2.avg_distance_miles)::numeric
  , 1)                                     AS miles_saved

FROM ranked AS d1
JOIN ranked AS d2
  ON d1.division        = d2.division
 AND d2.rank_by_distance = 1               -- pick the closest factory
WHERE d1.rank_by_distance > 1              -- exclude the already-optimal
ORDER BY miles_saved DESC;````
```

 



the output 



DDD" Data_Driven_Decision"

