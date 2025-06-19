-- (Category)- Level Profit Query

SELECT
  p.division,
  SUM(s.total_sales)   AS total_sales,
  SUM(s.gross_profit)  AS total_profit,
  ROUND(
    SUM(s.gross_profit)::numeric
    / NULLIF(SUM(s.total_sales),0)::numeric
  , 4)                  AS margin_pct
FROM sales s
JOIN products p
  ON s.product_id = p.product_id
GROUP BY p.division
ORDER BY margin_pct DESC;







 
--Product‐Level Profit Query

SELECT
  p.product_id,
  p.product_name,
  SUM(s.total_sales)  AS total_sales,
  SUM(s.gross_profit) AS total_profit
 FROM sales s
JOIN products p
  ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_profit DESC
LIMIT 5;
