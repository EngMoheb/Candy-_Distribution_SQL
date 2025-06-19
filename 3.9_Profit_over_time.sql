WITH division_yearly AS (
  SELECT
    EXTRACT(YEAR FROM s.order_date)::int AS order_year,
    p.division,
    SUM(s.gross_profit)                  AS total_profit
  FROM sales s
  JOIN products p
    ON s.product_id = p.product_id
  GROUP BY
    EXTRACT(YEAR FROM s.order_date),
    p.division
),
division_trends AS (
  SELECT
    division,
    order_year,
    total_profit,
    LAG(total_profit) OVER (
      PARTITION BY division
      ORDER BY order_year
    ) AS prev_year_profit
  FROM division_yearly
)
SELECT
  division,
  order_year,
  total_profit,
  prev_year_profit,
  (total_profit - prev_year_profit)         AS change_in_profit,
  ROUND(
    (total_profit - prev_year_profit)::numeric
    / NULLIF(prev_year_profit, 0)::numeric
  , 4)                                       AS pct_change
FROM division_trends
WHERE prev_year_profit IS NOT NULL
ORDER BY
  division,
  order_year;
