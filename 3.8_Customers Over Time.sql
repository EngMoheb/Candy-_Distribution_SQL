WITH customer_totals AS (
  SELECT
    customer_id,
    COUNT(*)          AS num_orders,
    ship_mode,
    SUM(total_sales)   AS total_sales,
    SUM(gross_profit)  AS total_profit,
    SUM(units)         AS total_units
  FROM sales
  GROUP BY customer_id,
           ship_mode
),
ranked_customers AS (
  SELECT
    customer_id,
    ship_mode,
    num_orders,
    total_sales,
    total_profit,
    total_units,
    ROW_NUMBER() OVER (
      ORDER BY total_sales DESC
    ) AS customer_rank
  FROM customer_totals
)
SELECT
  customer_id,
  ship_mode,
  customer_rank,
  num_orders,
  total_sales,
  total_profit,
  total_units
FROM ranked_customers
ORDER BY customer_rank
limit 5;
 
