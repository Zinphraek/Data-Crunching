-- Inspecting and mofying data

CREATE TABLE meat_poultry_egg_establishments (
    establishment_number text CONSTRAINT est_number_key PRIMARY KEY,
    company text,
    street text,
    city text,
    st text,
    zip text,
    phone text,
    grant_date date,
    activities text,
    dbas text
);

COPY meat_poultry_egg_establishments
FROM '/tmp/MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER);

CREATE INDEX company_idx ON meat_poultry_egg_establishments (company);

SELECT count(*) FROM meat_poultry_egg_establishments;

----------------------------------------------------------------------------------------------------------
-- Interviewing the data
SELECT company,
	   street,
	   city,
	   st,
	   count(*) AS address_count
FROM meat_poultry_egg_establishments
GROUP BY company, street, city, st
HAVING count(*) > 1
ORDER BY company, street, st;

----------------------------------------------------------------------------------------------------------
-- Checking for missing values
SELECT st,
	   count(*) AS st_count
FROM meat_poultry_egg_establishments
GROUP BY st
ORDER BY st;

-------------------------------------
SELECT establishment_number,
	   company,
	   city,
	   st,
	   zip
FROM meat_poultry_egg_establishments
WHERE st IS NULL;

----------------------------------------------------------------------------------------------------------
-- Finding inconsistent data
SELECT company,
       count(*) AS company_count
FROM meat_poultry_egg_establishments
GROUP BY company
ORDER BY company ASC;

----------------------------------------------------------------------------------------------------------
-- Checking data integrity with 'length()' and 'count()'.
SELECT length(zip), count(*) AS length_count
FROM meat_poultry_egg_establishments
GROUP BY length(zip)
ORDER BY length(zip) ASC;

SELECT st, count(*) AS st_count
FROM meat_poultry_egg_establishments
WHERE length(zip) < 5
GROUP BY st
ORDER BY st ASC;

----------------------------------------------------------------------------------------------------------
-- Restoring missing column values
-- 1. Backing up the table
CREATE TABLE meat_poultry_egg_establishments_backup AS
SELECT * FROM meat_poultry_egg_establishments;

-- 2. Assessing the operation success.
SELECT
    (SELECT count(*) FROM meat_poultry_egg_establishments) AS original,
    (SELECT count(*) FROM meat_poultry_egg_establishments_backup) AS backup;

-- 3. Copying the target column (for precausion purposes)
ALTER TABLE meat_poultry_egg_establishments ADD COLUMN st_copy text;
UPDATE meat_poultry_egg_establishments
SET st_copy = st;

-- 4. Verifying operation success by checking differences.
SELECT st,
       st_copy
FROM meat_poultry_egg_establishments
WHERE st IS DISTINCT FROM st_copy
ORDER BY st;

-- 5. Updating the values. A quick online search give us the missing data.
-- Updating the 'st' column for three establishments
UPDATE meat_poultry_egg_establishments
SET st = 'MN'
WHERE establishment_number = 'V18677A';

UPDATE meat_poultry_egg_establishments
SET st = 'AL'
WHERE establishment_number = 'M45319+P45319';

UPDATE meat_poultry_egg_establishments
SET st = 'WI'
WHERE establishment_number = 'M263A+P263A+V263A'

-- Restoring original 'st' column
-- Source 1: Using the 'st_copy' column.
UPDATE meat_poultry_egg_establishments
SET st = st_copy;

-- Source 2: Using the backed up table.
UPDATE meat_poultry_egg_establishments original
SET st = backup.st
FROM meat_poultry_egg_establishments_backup backup
WHERE original.establishment_number = backup.establishment_number;
RETURNING establishment_number, company, city, st, zip;

-- Restoring inconsistent data
-- 1. Backing up the target column
ALTER TABLE meat_poultry_egg_establishments ADD COLUMN company_standard text;

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN zip_copy text;

UPDATE meat_poultry_egg_establishments
SET company_standard = company;

UPDATE meat_poultry_egg_establishments
SET zip_copy = zip;

-- 2. Fixing data inconsistency.
UPDATE meat_poultry_egg_establishments
SET company_standard = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%'
RETURNING company, company_standard;

UPDATE meat_poultry_egg_establishments
SET zip = '00' || zip
WHERE st IN('PR','VI') AND length(zip) = 3;

UPDATE meat_poultry_egg_establishments
SET zip = '0' || zip
WHERE st IN('CT','MA','ME','NH','NJ','RI','VT') AND length(zip) = 4;

-- Removing the copied data
-- Removing columns
ALTER TABLE meat_poultry_egg_establishments DROP COLUMN zip_copy;

-- Removing table
DROP TABLE meat_poultry_egg_establishments_backup;

----------------------------------------------------------------------------------------------------------
-- Backing up a table while adding and filling a new column
CREATE TABLE meat_poultry_egg_establishments_backup AS
SELECT *,
      '2024-02-14 00:00 EST'::timestamp with time zone AS reviewed_date
FROM meat_poultry_egg_establishments;

-- Swapping tables names
ALTER TABLE meat_poultry_egg_establishments
    RENAME TO meat_poultry_egg_establishments_temp;
ALTER TABLE meat_poultry_egg_establishments_backup
    RENAME TO meat_poultry_egg_establishments;
ALTER TABLE meat_poultry_egg_establishments_temp
    RENAME TO meat_poultry_egg_establishments_backup;