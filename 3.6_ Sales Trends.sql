 -- A. Monthly Sales & Profit Trends
 
WITH monthly AS (
  SELECT
    DATE_TRUNC('month', order_date)::date  AS period_start,
    SUM(total_sales)                       AS sales,
    SUM(gross_profit)                      AS profit,
    SUM(units)                             AS units_sold
  FROM sales
  GROUP BY DATE_TRUNC('month', order_date)
  ORDER BY period_start
)
SELECT
  period_start,
  sales,
  profit,
  units_sold
FROM monthly
WHERE period_start >= DATE_TRUNC('month', NOW())::date - INTERVAL '24 months';


-- B. Quarterly Sales & Profit Trends
-- Quarterly Sales & Profit Trends (last 8 quarters = last 24 months)
WITH quarterly AS (
  SELECT
    DATE_TRUNC('quarter', order_date)::date AS period_start,
    SUM(total_sales)                       AS sales,
    SUM(gross_profit)                      AS profit,
    SUM(units)                             AS units_sold
  FROM sales
  GROUP BY DATE_TRUNC('quarter', order_date)
  ORDER BY period_start
)
SELECT
  period_start,
  sales,
  profit,
  units_sold
FROM quarterly
WHERE period_start >= DATE_TRUNC('quarter', NOW())::date
                        - INTERVAL '24 months';

