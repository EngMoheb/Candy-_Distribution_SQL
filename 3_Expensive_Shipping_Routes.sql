WITH
  -- 1. Pull in factory location for every sale
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

  -- 2. Pull in customer ZIP location for every sale
  customer_loc AS (
    SELECT
      u.zip                AS customer_zip,
      u.               AS customer_lat,
      u.lng                AS customer_lng,
      u.city               AS customer_city,
      u.state_name         AS customer_state
    FROM us_zips u
  ),

  -- 3. Combine sales with factory and customer coordinates
  sales_with_locs AS (
    SELECT
      s.row_id,
      s.product_id,
      fl.factory_name,
      cl.customer_zip,
      cl.customer_city,
      cl.customer_state,
      s.cost                     AS shipping_cost,
      s.total_sales,
      s.gross_profit
    FROM sales s
    JOIN factory_loc fl
      ON s.product_id = fl.product_id
    JOIN customer_loc cl
      ON s.postal_code = cl.customer_zip
  )

-- 4. Aggregate by Factory → ZIP (i.e. the “route”)
SELECT
  factory_name           AS origin_factory,
  customer_zip           AS destination_zip,
  customer_city          AS destination_city,
  customer_state         AS destination_state,
  COUNT(*)               AS num_orders_on_route,
  SUM(shipping_cost)     AS total_shipping_cost,
  ROUND(
    AVG(shipping_cost)::numeric,
    2
  )                       AS avg_shipping_cost_per_order
FROM sales_with_locs
GROUP BY
  factory_name,
  customer_zip,
  customer_city,
  customer_state
ORDER BY
  total_shipping_cost DESC
LIMIT 10;  -- top 10 most expensive lanes by total cost
