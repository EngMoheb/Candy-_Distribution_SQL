-- factories
CREATE TABLE factories (
  factory_id   SERIAL PRIMARY KEY,
  factory_name TEXT UNIQUE NOT NULL,
  latitude     DOUBLE PRECISION,
  longitude    DOUBLE PRECISION
);


-- targets
CREATE TABLE targets (
  division TEXT PRIMARY KEY,
 the_target   NUMERIC
);


-- products
CREATE TABLE products (
  division   TEXT NOT NULL
                    REFERENCES targets(division),
 product_name TEXT NOT NULL,
  
  factory_name TEXT NOT NULL
                    REFERENCES factories(factory_name),
 
  product_id   TEXT PRIMARY KEY,
               
  unit_price   NUMERIC,
  unit_cost    NUMERIC
 
   
);



CREATE TABLE us_zips (
  zip               TEXT       PRIMARY KEY,       
  lat               DOUBLE PRECISION,           
  lng               DOUBLE PRECISION,            
  city              TEXT,                       
  state_id          TEXT,                        
  state_name        TEXT,                       
  zcta              BOOLEAN,                    
  parent_zcta       TEXT,                       
  populationn        INTEGER,                    
  density           DOUBLE PRECISION,            
  county_fips       TEXT,                       
  county_name       TEXT,                        
  county_weights    JSONB,                       
  county_names_all  TEXT,                        
  county_fips_all   TEXT,                       
  imprecise         BOOLEAN,                     
  military          BOOLEAN,                     
  timezone          TEXT                         
);






-- sales
CREATE TABLE sales (
  row_id       BIGINT     PRIMARY KEY,
  order_id     TEXT,
  order_date   DATE,
  ship_date    DATE,
  ship_mode    TEXT,
  customer_id  TEXT,
  country      TEXT,
  city         TEXT,
  statee       TEXT,
  postal_code  TEXT       REFERENCES us_zips(zip),
  division     TEXT       REFERENCES targets(division),
  region       TEXT,
  product_id   TEXT       REFERENCES products(product_id),
  product_name TEXT,
  total_sales  NUMERIC,
  units        INTEGER,
  gross_profit NUMERIC,
  cost         NUMERIC
);