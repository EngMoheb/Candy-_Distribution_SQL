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

 **General Analysis**

1. Which categories & products generate the highest profits?  
2. What are the top-selling categories & products by quantity?  
3. Which shipping routes are the most expensive?

**Geographic & Optimization**

1. Which customer–factory pairs are least efficient (long distance + low margin)?  
2. Are there specific states/regions with higher return on sales?

**Time-Based Trends**

1. How do monthly/quarterly sales trends look?  
2. Are there specific weekdays or weekends with higher volume or profit?

**Advanced Insights**

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

