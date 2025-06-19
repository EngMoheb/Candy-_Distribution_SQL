WITH
  -- 1. Map product → factory coords
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

  -- 2. Map ZIP → customer coords
  customer_loc AS (
    SELECT
      zip               AS customer_zip,
      lat               AS cust_lat,
      lng               AS cust_lng,
      city              AS customer_city,
      state_name        AS customer_state
    FROM us_zips
  ),

  -- 3. Build the geo‑coded sales stream
  sales_geo AS (
    SELECT
      s.row_id,
      fl.factory_name,
      cl.customer_zip,
      cl.customer_city,
      cl.customer_state,
      s.gross_profit,
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

SELECT
  factory_name,
  customer_zip,
   ROUND(
    AVG(distance_miles)::numeric
    / NULLIF(AVG(gross_profit),0)::numeric
  , 3)      AS miles_per_dollar_profit,
  ROUND(AVG(distance_miles)::numeric, 1)    AS avg_distance_miles,
  ROUND(AVG(gross_profit)::numeric, 2)       AS avg_profit_per_order,                                 
  customer_city,
  customer_state,
  COUNT(*)                                   AS num_orders
FROM sales_geo
GROUP BY
  factory_name,
  customer_zip,
  customer_city,
  customer_state
HAVING COUNT(*) >= 5
ORDER BY
  miles_per_dollar_profit DESC
LIMIT 10;
