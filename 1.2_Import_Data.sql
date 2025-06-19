-- 1) Load factories
COPY factories(factory_name, latitude, longitude)
  FROM 'D:/SQL/US_Candy/CSV/Factories.csv.csv'
  WITH (FORMAT csv, HEADER);

-- 2) Load  targets
COPY targets(division, the_target )
  FROM 'D:/SQL/US_Candy/CSV/Targetts.csv.csv'
  WITH (FORMAT csv, HEADER);

 


-- 3) Load products  
COPY products( division, product_name, factory_name,product_id,  unit_price, unit_cost)
  FROM 'D:/SQL/US_Candy/CSV/Products.csv.csv'
  WITH (FORMAT csv, HEADER);

-- 4) Load Us_ZIP  
COPY us_zips(
  zip, lat, lng, city, state_id, state_name, zcta, parent_zcta,
  populationn, density, county_fips, county_name, county_weights,
  county_names_all, county_fips_all, imprecise, military, timezone
)
  FROM 'D:/SQL/US_Candy/CSV/us_zips.csv.csv'
  WITH (FORMAT csv, HEADER);



 

-- 5) Load sales

-- 1. Switch DateStyle to Day-Month-Year
SET datestyle = 'ISO, DMY';

COPY sales(
  row_id, order_id, order_date, ship_date, ship_mode,
  customer_id, country, city, statee, postal_code,
  division, region, product_id, product_name,
  total_sales, units, gross_profit, cost
)
FROM 'D:/SQL/US_Candy/CSV/Sales.csv.csv'
WITH (FORMAT csv, HEADER);



