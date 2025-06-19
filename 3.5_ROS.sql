-- Return‑on‑Sales by Region
SELECT
  s.region                            ,
   ROUND(
    SUM(s.gross_profit)::numeric
    / NULLIF(SUM(s.total_sales), 0)::numeric
  , 4)                                  AS ros,
  SUM(s.total_sales)                   AS total_sales,
  SUM(s.gross_profit)                  AS total_profit,
  SUM(s.units)                         AS total_units_sold
FROM sales s
GROUP BY s.region
HAVING SUM(s.total_sales) > 0          -- avoid division by zero
  AND SUM(s.units) >= 100              -- optional: filter low‑volume states
ORDER BY ros DESC
LIMIT 10;

 