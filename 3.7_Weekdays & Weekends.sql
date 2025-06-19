
WITH day_metrics AS (
  SELECT
    TO_CHAR(order_date, 'FMDay')          AS day_name,
    CASE
      WHEN EXTRACT(DOW FROM order_date) IN (0,6) THEN 'Weekend'
      ELSE 'Weekday'
    END                                     AS day_type,
    COUNT(*)                               AS num_orders,
    SUM(total_sales)                       AS total_sales,
    SUM(gross_profit)                      AS total_profit
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
  ROUND(100.0 * num_orders / SUM(num_orders) OVER (), 1)    AS pct_of_orders,
  ROUND(100.0 * total_profit / SUM(total_profit) OVER (), 1) AS pct_of_profit
FROM day_metrics
ORDER BY
  -- Ensure Monday→Sunday order
  CASE day_name
    WHEN 'Monday'    THEN 1
    WHEN 'Tuesday'   THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday'  THEN 4
    WHEN 'Friday'    THEN 5
    WHEN 'Saturday'  THEN 6
    WHEN 'Sunday'    THEN 7
  END;

