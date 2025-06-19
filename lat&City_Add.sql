CREATE  TABLE us_zips_import (
  
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
  county_names_all  TEXT,                        
  county_fips_all   TEXT,                       
  imprecise         BOOLEAN,                     
  military          BOOLEAN,                     
  timezone          TEXT        
);

COPY us_zips_import(
  zip, lat, lng, city, state_id, state_name, zcta, parent_zcta,
  populationn, density, county_fips, county_name, county_weights,
  county_names_all, county_fips_all, imprecise, military, timezone
)
  FROM 'D:/SQL/US_Candy/CSV/us_zips.csv.csv'
  WITH (FORMAT csv, HEADER);
 
UPDATE us_zips z
SET
  lat  = ui.lat,
  lng  = ui.lng,
  city = ui.city
FROM us_zips_import ui
WHERE z.zip = ui.zip::integer;



SELECT
lat,
lng,
city
FROM
us_zips_import


SELECT
* 
FROM
us_zips



DROP TABLE us_zips_import;