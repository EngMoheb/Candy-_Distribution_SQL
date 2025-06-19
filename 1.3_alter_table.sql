-- drop_unused_us_zips_columns
DROP TABLE us_zips CASCADE;
ALTER TABLE us_zips
  DROP COLUMN lat,
  DROP COLUMN lng,
  DROP COLUMN city,
  DROP COLUMN parent_zcta,
  DROP COLUMN county_weights,
  DROP COLUMN county_names_all,
  DROP COLUMN county_fips_all,
  DROP COLUMN imprecise,
  DROP COLUMN military;


-- 1. Alter the table to add lat, lng, and city columns
ALTER TABLE us_zips
  ADD COLUMN lat     NUMERIC(9,6),
  ADD COLUMN lng     NUMERIC(9,6),
  ADD COLUMN city    VARCHAR(100);

-- 2. Verify that the columns were added
\d us_zips
