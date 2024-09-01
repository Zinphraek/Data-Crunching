-- Speeding up queries with indexing.
-- Indexing enlarge the database, and should be used only when needed
------------------------------------------------------------------------------------------
CREATE TABLE new_york_addresses (
    longitude numeric(9,6),
    latitude numeric(9,6),
    street_number text,
    street text,
    unit text,
    postcode text,
    id integer CONSTRAINT new_york_key PRIMARY KEY
);

COPY new_york_addresses
FROM '/tmp/city_of_new_york.csv'
WITH (FORMAT CSV, HEADER);

SELECT * FROM new_york_addresses LIMIT 10;


------------------------------------------------------------------------------------------
-- Benchmarking queries for index performance
EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'BROADWAY';

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = '52 STREET';

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'ZWICKY AVENUE';


------------------------------------------------------------------------------------------
-- Creating a B-tree index on the new_york_addresses table
CREATE INDEX street_idx ON new_york_addresses (street);

-- Removing an index
DROP INDEX street_idx;