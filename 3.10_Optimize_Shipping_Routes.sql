-- 1. Attach each sale to its product’s division, factory, and customer coordinates
WITH sale_geo AS (
  SELECT
    p.division,                     -- product category/division
    f.factory_name,                 -- origin factory
    f.latitude  AS fac_lat,         -- factory latitude
    f.longitude AS fac_lng,         -- factory longitude
    u.lat       AS cust_lat,        -- customer ZIP latitude
    u.lng       AS cust_lng         -- customer ZIP longitude
  FROM sales s
  JOIN products p
    ON s.product_id = p.product_id  -- link sale to product
  JOIN factories f
    ON p.factory_name = f.factory_name  -- link product to factory
  JOIN us_zips u
    ON s.postal_code = u.zip       -- link sale to customer ZIP
),
-- 2. Compute average shipping distance (Haversine) per division & factory
div_fac_dist AS (
  SELECT
    division,
    factory_name,
    AVG(
      3959 * acos(                  -- Earth radius in miles × central angle
        cos(radians(fac_lat))
        * cos(radians(cust_lat))
        * cos(radians(cust_lng) - radians(fac_lng))
        + sin(radians(fac_lat))
        * sin(radians(cust_lat))
      )
    ) AS avg_distance_miles        -- average miles shipped per order
  FROM sale_geo
  GROUP BY division, factory_name  -- one row per division–factory
),
-- 3. Rank factories by proximity for each division
ranked AS (
  SELECT
    division,
    factory_name,
    avg_distance_miles,
    ROW_NUMBER() OVER (
      PARTITION BY division       -- restart rank for each division
      ORDER BY avg_distance_miles -- closest = rank 1
    ) AS rank_by_distance
  FROM div_fac_dist
)
-- 4. Compare each division’s current factory to the optimal (rank 1) factory
SELECT
  d1.division,
  d1.factory_name                        AS current_factory,
  ROUND(d1.avg_distance_miles::numeric, 1) AS current_avg_miles,
  d2.factory_name                        AS optimal_factory,
  ROUND(d2.avg_distance_miles::numeric, 1) AS optimal_avg_miles,
  ROUND(
    (d1.avg_distance_miles - d2.avg_distance_miles)::numeric
  ,1)                                     AS miles_saved
FROM ranked d1
JOIN ranked d2
  ON d1.division = d2.division
 AND d2.rank_by_distance = 1               -- pick the closest factory
WHERE d1.rank_by_distance > 1              -- exclude the optimal itself
ORDER BY miles_saved DESC;                 -- greatest potential savings first
