--- Factories_Table_Cleaning---

-- 1. Text‐Column Cleaning factory_name
 
 SELECT
  SUM(CASE WHEN factory_name IS NULL OR factory_name = '' THEN 1 ELSE 0 END) AS factory_name_missing
FROM factories;


-- Verify Distinct Values
SELECT DISTINCT factory_name
FROM factories
ORDER BY factory_name;

--- 2. Numeric‐Column Cleaning & Validation factories.latitude and factories.longitude
 
 SELECT
  SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END)  AS lat_nulls,
  SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) AS lng_nulls
FROM factories;


SELECT
  MIN(latitude)   AS min_lat,
  MAX(latitude)   AS max_lat,
  MIN(longitude)  AS min_lng,
  MAX(longitude)  AS max_lng
FROM factories;

-- Uniqueness & Final Checks
SELECT
  COUNT(*)          AS total_rows,
  COUNT(DISTINCT factory_id) AS unique_ids
FROM factories;



--- Division_Table_Cleaning---

-- 1. Text‐Column Cleaning 

SELECT
  SUM(CASE WHEN division IS NULL OR division = '' THEN 1 ELSE 0 END) AS division_missing,
  SUM(CASE WHEN the_target IS NULL THEN 1 ELSE 0 END) AS the_target_missing
FROM targets;


UPDATE targets
SET
  division = INITCAP(LOWER(TRIM(division)));


SELECT DISTINCT division
FROM targets
ORDER BY division;


-- 2. Number‐Column Cleaning 


SELECT
  SUM(CASE WHEN the_target IS NULL THEN 1 ELSE 0 END) AS target_nulls,
  SUM(CASE WHEN the_target < 0    THEN 1 ELSE 0 END) AS target_negative
FROM targets;

-- Check the range of the_target
SELECT
  MIN(the_target) AS min_target,
  MAX(the_target) AS max_target
FROM targets;



--- Products_Table_Cleaning---
 
 -- Text Columns Columns: division, product_name, factory_name, Product_ID
-- 1. Check for NULL or Empty Values

SELECT
  SUM(CASE WHEN division      IS NULL OR division      = '' THEN 1 ELSE 0 END) AS division_missing,
  SUM(CASE WHEN product_name  IS NULL OR product_name  = '' THEN 1 ELSE 0 END) AS product_name_missing,
  SUM(CASE WHEN factory_name  IS NULL OR factory_name  = '' THEN 1 ELSE 0 END) AS factory_name_missing,
  SUM(CASE WHEN product_id  IS NULL OR product_id  = '' THEN 1 ELSE 0 END) AS product_id_missing
FROM products;


-- Trim Leading/Trailing Whitespace

UPDATE products
SET
  division     = TRIM(division),
  product_name = TRIM(product_name),
  factory_name = TRIM(factory_name),
  product_id   = TRIM(product_id);

-- Case Normalization

UPDATE products
SET
  division     = INITCAP(LOWER(division)),
  product_name = INITCAP(LOWER(product_name)),
  product_id   = UPPER((product_id));
 
-- Verify Distinct Values
 SELECT DISTINCT division     FROM products ORDER BY division;
SELECT DISTINCT factory_name FROM products ORDER BY factory_name;
SELECT DISTINCT product_name FROM products ORDER BY product_name;
SELECT DISTINCT product_id   FROM products ORDER BY product_id;


-- 2. Integer Columns: unit_price, unit_cost

-- Null / Missing & Negative Checks

ALTER TABLE products ADD COLUMN price_cost_flag BOOLEAN DEFAULT FALSE;

UPDATE products
SET price_cost_flag = TRUE
WHERE
  unit_price IS NULL OR unit_price < 0
  OR unit_cost  IS NULL OR unit_cost  < 0;


-- Range Validation: Min/Max Values
SELECT
  MIN(unit_price) AS min_price,
  MAX(unit_price) AS max_price,
  MIN(unit_cost)  AS min_cost,
  MAX(unit_cost)  AS max_cost
FROM products;


--  Foreign-Key Integrity

-- products.division → targets(division)
--Find orphan divisions in products
 
SELECT
  s.row_id,
  s.product_id AS bad_product_id,
  s.division   AS bad_sales_div,
  s.postal_code,
  p.product_id AS prod_ok,
  p.division   AS prod_div,
  p.factory_name AS prod_factory,
  t.division   AS target_div,
  f.factory_name AS factory_ok
FROM sales s
LEFT JOIN products p
  ON s.product_id = p.product_id
LEFT JOIN targets t
  ON p.division = t.division
LEFT JOIN factories f
  ON p.factory_name = f.factory_name
WHERE
  p.product_id IS NULL      -- sales→products
  OR t.division IS NULL     -- products→targets
  OR f.factory_name IS NULL -- products→factories
;

-- Re‐Enable Foreign‐Key Constraints to ensure that any insert or update 
-- that would break referential integrity will be rejected by PostgreSQL.

ALTER TABLE products
  ADD CONSTRAINT fk_products_division
    FOREIGN KEY (division)
    REFERENCES targets(division)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE products
  ADD CONSTRAINT fk_products_factory
    FOREIGN KEY (factory_name)
    REFERENCES factories(factory_name)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE sales
  ADD CONSTRAINT fk_sales_product
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

 
-- Total products vs. products with valid division
SELECT
  COUNT(*)                               AS total_products,
  COUNT(*) FILTER (
    WHERE division IN (SELECT division FROM targets)
  ) AS products_with_valid_div
FROM products;


-- Uniqueness & Final Checks
SELECT
  COUNT(*)          AS total_rows,
  COUNT(DISTINCT product_id) AS unique_ids
FROM products;

-- 1) Index on division to speed up JOINs and WHERE-clauses
CREATE INDEX idx_products_division
  ON products(division);

-- 2) Index on factory_name to speed up JOINs and WHERE-clauses
CREATE INDEX idx_products_factory_name
  ON products(factory_name);


-- Spot-check a few rows
SELECT * FROM products
WHERE price_cost_flag = TRUE OR division IS NULL OR factory_name IS NULL
LIMIT 20;



--- Us_Zip_Table_Cleaning---

-- 1. Text Columns  
--Columns:  `state_id`, `state_name`, `county_fips`, `county_name`, `timezone`,country

--1.1 Check for NULL or Empty
 
SELECT
  SUM(CASE WHEN state_id     IS NULL OR state_id = ''     THEN 1 ELSE 0 END) AS state_id_missing,
  SUM(CASE WHEN state_name   IS NULL OR state_name = ''   THEN 1 ELSE 0 END) AS state_name_missing,
  SUM(CASE WHEN county_fips  IS NULL OR county_fips = ''  THEN 1 ELSE 0 END) AS county_fips_missing,
  SUM(CASE WHEN county_name  IS NULL OR county_name = ''  THEN 1 ELSE 0 END) AS county_name_missing,
  SUM(CASE WHEN timezone     IS NULL OR timezone = ''     THEN 1 ELSE 0 END) AS timezone_missing,
  SUM(CASE WHEN country      IS NULL OR country = ''      THEN 1 ELSE 0 END) AS country_missing

FROM us_zips;


-- Trim Whitespace & Normalize Case

UPDATE us_zips
SET
   
  state_id     = UPPER(TRIM(state_id)),  
  state_name   = INITCAP(LOWER(TRIM(state_name))),
  county_fips  = TRIM(county_fips),
  county_name  = INITCAP(LOWER(TRIM(county_name))),
  timezone     = INITCAP(LOWER(TRIM(timezone))),
  country     = INITCAP(LOWER(TRIM(country)));


 --  2. Integer Columns Zip & populationn

 SELECT
  SUM(CASE WHEN populationn IS NULL        THEN 1 ELSE 0 END) AS pop_null,
  SUM(CASE WHEN populationn < 0            THEN 1 ELSE 0 END) AS pop_negative,
  SUM(CASE WHEN zip IS NULL        THEN 1 ELSE 0 END) AS zip_null,
  SUM(CASE WHEN zip < 0            THEN 1 ELSE 0 END) AS zip_negative
FROM us_zips;



 -- B1) Count total rows vs. distinct ZIPs for uniqueness
SELECT
  COUNT(*)             AS total_rows,
  COUNT(DISTINCT zip)  AS unique_zips
FROM us_zips;


--🧹 3. Cleaning `density` & `zcta`
  
-- Check for NULL or Negative Values
SELECT
  SUM(CASE WHEN density IS NULL THEN 1 ELSE 0 END)   AS density_nulls,
  SUM(CASE WHEN density < 0    THEN 1 ELSE 0 END)   AS density_zeros,
  MIN(density)                                    AS min_density,
  MAX(density)                                    AS max_density
FROM us_zips;

-- zcta (BOOLEAN)  Check for NULL Values
 
SELECT
  SUM(CASE WHEN zcta IS NULL THEN 1 ELSE 0 END) AS zcta_null
FROM us_zips;

SELECT
  COUNT(*) FILTER (WHERE zcta = TRUE)  AS num_zcta_true,
  COUNT(*) AS total_zcta
FROM us_zips;

 --  Foreign-Key Integrity

-- Uniqueness

 SELECT
  COUNT(*)          AS total_rows,
  COUNT(DISTINCT Zip) AS unique_ids
FROM us_zips;

-- 1) Speed up lookups by state_id (e.g. "WHERE state_id = 'NY'")
CREATE INDEX idx_us_zips_state_id
  ON us_zips (state_id);

-- 2) Speed up lookups by county_name
CREATE INDEX idx_us_zips_county_name
  ON us_zips (county_name);

-- 3) Speed up queries that find all ZIPs under a given parent_zcta
CREATE INDEX idx_us_zips_parent_zcta
  ON us_zips (zcta);

-- 4) (Optional) If you do range filters on populationn
CREATE INDEX idx_us_zips_populationn
  ON us_zips (populationn);

-- 5) (Optional) If you do range or grouping on density
CREATE INDEX idx_us_zips_density
  ON us_zips (density);


 --- Sales_Table_Cleaning---
 
-- 1) Add a delivery_days column 

ALTER TABLE sales
  ADD COLUMN IF NOT EXISTS delivery_days INT;

-- 2) Compute delivery_days = ship_date – order_date

UPDATE sales
SET delivery_days = (ship_date - order_date)::INT;

-- 3) Add a delivery_category column for easy tracking

ALTER TABLE sales
  ADD COLUMN IF NOT EXISTS delivery_category TEXT;

-- 4) Verify my work with Basic stats: min, 25th, median, 75th, max

SELECT
  MIN(delivery_days)      AS min_days,
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY delivery_days) AS p25,
  PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY delivery_days) AS median,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY delivery_days) AS p75,
  MAX(delivery_days)      AS max_days
FROM sales;

-- 5) Update delivery_category using those cut-points

UPDATE sales
SET delivery_category = CASE
  WHEN delivery_days <= 2003 THEN 'Q1 (Top 25%)'
  WHEN delivery_days <= 2004 THEN 'Q2 (25–50%)'
  WHEN delivery_days <= 2005 THEN 'Q3 (50–75%)'
  ELSE                            'Q4 (Bottom 25%)'
END;

-- 6) last_Check

SELECT
*
FROM 
    sales

-- 🧹 Phase 2.A: Cleaning Text Columns
-- 1. Identify Null or Blank Values
 SELECT
  SUM(CASE WHEN ship_mode    IS NULL OR ship_mode    = '' THEN 1 ELSE 0 END) AS ship_mode_missing,
  SUM(CASE WHEN country      IS NULL OR country      = '' THEN 1 ELSE 0 END) AS country_missing,
  SUM(CASE WHEN city         IS NULL OR city         = '' THEN 1 ELSE 0 END) AS city_missing,
  SUM(CASE WHEN statee       IS NULL OR statee       = '' THEN 1 ELSE 0 END) AS state_missing,
  SUM(CASE WHEN division     IS NULL OR division     = '' THEN 1 ELSE 0 END) AS division_missing,
  SUM(CASE WHEN region       IS NULL OR region       = '' THEN 1 ELSE 0 END) AS region_missing,
  SUM(CASE WHEN order_id     IS NULL OR order_id     = '' THEN 1 ELSE 0 END) AS order_id_missing,
  SUM(CASE WHEN product_id   IS NULL OR product_id   = '' THEN 1 ELSE 0 END) AS product_id_missing,
  SUM(CASE WHEN product_name IS NULL OR product_name = '' THEN 1 ELSE 0 END) AS product_name_missing,
  SUM(CASE WHEN delivery_category IS NULL OR delivery_category = '' THEN 1 ELSE 0 END) AS delivery_category_missing

FROM sales;

 -- 2. Trim_Spaces

UPDATE sales
SET
  ship_mode    = TRIM(ship_mode),
  country      = TRIM(country),
  city         = TRIM(city),
  statee       = TRIM(statee),
  division     = TRIM(division),
  region       = TRIM(region),
  order_id     = TRIM(order_id),
  product_id   = TRIM(product_id),
  product_name = TRIM(product_name),
  delivery_category = TRIM(delivery_category);
  
  -- 3: Case Normalization

  UPDATE sales
SET
  ship_mode    = INITCAP(lower(ship_mode)),                     
  country      = INITCAP(lower(country)),                          
  statee       = INITCAP(lower(statee)),                           
  division     = INITCAP(LOWER(division)),                
  region       = INITCAP(LOWER(region)),                   
  city         = INITCAP(LOWER(city)),                     
  product_name = INITCAP(LOWER(product_name));     

---- see the final set of values and catch any errors

SELECT DISTINCT ship_mode FROM sales;
SELECT DISTINCT country   FROM sales;
SELECT DISTINCT statee     FROM sales;
SELECT DISTINCT division  FROM sales;
SELECT DISTINCT region    FROM sales;
SELECT DISTINCT city      FROM sales;
SELECT DISTINCT product_name FROM sales;


DELETE FROM sales
WHERE ship_mode = 'Same Day';


--🧹 Phase 2.B: Integer `row_id`, `customer_id`, `postal_code`, `delivery_days` 

-- 1.1 Extended Check for NULL and Invalid Integer Values

 
SELECT
  -- 1) NULL checks
  SUM(CASE WHEN row_id        IS NULL THEN 1 ELSE 0 END) AS row_id_null,
  SUM(CASE WHEN customer_id   IS NULL THEN 1 ELSE 0 END) AS customer_id_null,
  SUM(CASE WHEN postal_code   IS NULL THEN 1 ELSE 0 END) AS postal_code_null,
  SUM(CASE WHEN delivery_days IS NULL THEN 1 ELSE 0 END) AS delivery_days_null,

  -- 2) Basic validity checks
  SUM(CASE WHEN row_id        <= 0    THEN 1 ELSE 0 END) AS row_id_invalid,
  SUM(CASE WHEN customer_id   <= 0    THEN 1 ELSE 0 END) AS customer_id_invalid,
  SUM(CASE WHEN postal_code   <= 0 THEN 1 ELSE 0 END) AS postal_code_invalid,
  SUM(CASE WHEN delivery_days <=  0    THEN 1 ELSE 0 END) AS delivery_days_negative,
  SUM(CASE WHEN delivery_days > 3650  THEN 1 ELSE 0 END) AS delivery_days_too_large
FROM sales;


--🧹 Phase 2.C  Financial Cleaning  `units`, `total_sales`, `gross_profit`, `cost`


/* Check for NULL or Missing Values**  
   Check for Invalid Ranges** (e.g. negatives)  
   Flag or Fix any problematic rows  */


-- 1. NULL / Missing Check & Invalid Range Check
 

ALTER TABLE sales
  ADD COLUMN finance_flag BOOLEAN DEFAULT FALSE;

UPDATE sales
SET finance_flag = TRUE
WHERE
  units        IS NULL
  OR units        < 0

  OR total_sales  IS NULL
  OR total_sales  < 0

  OR gross_profit IS NULL
  OR gross_profit < 0

  OR cost         IS NULL
  OR cost         < 0;

SELECT*
FROM sales
WHERE    finance_flag = TRUE;



 -- 🧹 Phase 2.C: Date Column Cleaning Techniques

 SELECT
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS order_date_null,
  SUM(CASE WHEN ship_date  IS NULL THEN 1 ELSE 0 END) AS ship_date_null
FROM sales;

-- Range Validation

   SELECT
  MIN(order_date) AS mn_order, MAX(order_date) AS mx_order,
  MIN(ship_date) AS mn_ship,  MAX(ship_date) AS mx_ship
FROM sales;

-- check_rows where shipping precedes ordering.

SELECT COUNT(*) AS inverted
FROM sales
WHERE ship_date < order_date;

--  Foreign-Key Integrity: Combined Multi‐FK JOIN Check
SELECT
  s.row_id,                       -- 1) sales PK
  s.postal_code    AS zip_fk,     -- 2) child’s postal_code
  z.zip            AS zip_ok,     -- 3) parent’s zip (NULL if no match)
  s.division       AS div_fk,     -- 4) child’s division
  t.division       AS div_ok,     -- 5) parent’s division (NULL if no match)
  s.product_id     AS prod_fk,    -- 6) child’s product_id
  p.product_id     AS prod_ok     -- 7) parent’s product_id (NULL if no match)
FROM
  sales s                          -- 8) alias sales as ‘s’
LEFT JOIN
  us_zips z                        -- 9) left join to us_zips
  ON s.postal_code = z.zip         -- 10) join condition
LEFT JOIN
  products p                       -- 11) left join to products
  ON s.product_id = p.product_id   -- 12) join condition
LEFT JOIN
  targets t                        -- 13) left join to targets
  ON s.division = t.division       -- 14) join condition
WHERE
  z.zip IS NULL                    -- 15) orphan in sales→us_zips
  OR t.division IS NULL            -- 16) orphan in sales→division
  OR p.product_id IS NULL          -- 17) orphan in sales→products
;

-- Re-Enforcing the Constraints
ALTER TABLE sales
  ADD CONSTRAINT fk_sales_zip
    FOREIGN KEY (postal_code)
    REFERENCES us_zips(zip)
    ON UPDATE CASCADE       
    ON DELETE RESTRICT;    

ALTER TABLE sales
  ADD CONSTRAINT fk_sales_division
    FOREIGN KEY (division)
    REFERENCES targets(division)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE sales
  ADD CONSTRAINT fk_sales_product
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

-- Creating Indexes on sales After Cleaning
-- to speed up joins/filters on postal_code

CREATE INDEX idx_sales_postal_code
  ON sales(postal_code);

-- Index to speed up joins/filters on division
CREATE INDEX idx_sales_division
  ON sales(division);

-- Index to speed up joins/filters on product_id
CREATE INDEX idx_sales_product_id
  ON sales(product_id);

-- Index for filter by ship_date or order_date:
CREATE INDEX idx_sales_order_date
  ON sales(order_date);

CREATE INDEX idx_sales_ship_date
  ON sales(ship_date);


--Compare total rows vs. distinct row_ids_for_ uniqueness
SELECT
  COUNT(*)         AS total_rows,
  COUNT(DISTINCT row_id) AS unique_row_ids
FROM sales;