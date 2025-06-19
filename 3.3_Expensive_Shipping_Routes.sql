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
      zip               AS customer_zip,
      u.city              AS customer_city,
      state_name        AS customer_state,
      postal_code AS zip
    FROM us_zips u
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



   