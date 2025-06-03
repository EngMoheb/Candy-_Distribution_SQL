-- Top_Selling_Categories_by_Quantity
SELECT
  p.division,
  SUM(s.units) AS total_units_sold,
  ROUND(SUM(s.units) * 100.0 / SUM(SUM(s.units)) OVER (), 1) AS percent_of_total
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.division
ORDER BY total_units_sold DESC;


-- Top_Selling_Products_by_Quantity

SELECT
  p.product_id,
  p.product_name,
  SUM(s.units) AS total_units_sold,
  ROUND(SUM(s.units) * 100.0 / SUM(SUM(s.units)) OVER (), 1) AS percent_of_total
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name, p.product_id
ORDER BY total_units_sold DESC
LIMIT 5;

