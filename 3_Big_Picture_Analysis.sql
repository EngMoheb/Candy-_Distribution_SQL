--Simple Aggregate & basic summary statistics

SELECT
 count(*)  AS num_orders,
 Sum(total_sales) AS total_sales,
 sum(gross_profit) AS total_profit,
ROUND(AVG(total_sales), 2) AS avg_sales_per_Order,
ROUND(AVG(gross_profit), 2) AS avg_profit_per_Order
    FROM
        sales


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




