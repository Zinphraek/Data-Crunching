-- Updating data across tables
CREATE TABLE state_regions (
    st text CONSTRAINT st_key PRIMARY KEY,
    region text NOT NULL
);

COPY state_regions
FROM '/tmp/state_regions.csv'
WITH (FORMAT CSV, HEADER);

-- Adding and updating an inspection_deadline column.
ALTER TABLE meat_poultry_egg_establishments
	ADD COLUMN inspection_deadline timestamp with time zone;

UPDATE meat_poultry_egg_establishments establishments
SET inspection_deadline = '2024-12-01 00:00 EST'
WHERE EXISTS (SELECT state_regions.region
			  FROM state_regions
			  WHERE establishments.st = state_regions.st
			  		AND state_regions.region = 'New England');

-- Inspecting the operation success
SELECT st, inspection_deadline
FROM meat_poultry_egg_establishments
GROUP BY st, inspection_deadline
ORDER BY st;


-- Transactionnal operations
-- Transaction block
START TRANSACTION;

UPDATE meat_poultry_egg_establishments
SET company = 'AGRO Merchants Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

SELECT company
FROM meat_poultry_egg_establishments
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- Commiting the change
COMMIT;

ROLLBACK; -- Rolling back due to typo.