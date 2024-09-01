-- Working with date and time.
-- Creating a date-time database
CREATE TABLE date_time_types (
    timestamp_column timestamp with time zone,
    interval_column interval
);

-- Inserting data in the table
INSERT INTO date_time_types
VALUES
    ('2022-12-31 01:00 EST','2 days'),
    ('2022-12-31 01:00 -8','1 month'),
    ('2022-12-31 01:00 Australia/Melbourne','1 century'),
    (now(),'1 week');

-- Displaying the data.
SELECT * FROM date_time_types;

-- Working with timestamp
SELECT
    timestamp_column,
    interval_column,
    timestamp_column - interval_column AS new_date
FROM date_time_types;

-- Data type casting explicit version
SELECT timestamp_column, CAST(timestamp_column AS varchar(10))
FROM date_time_types;

-- Data type casting shorcut version (PostgreSQl specific)
SELECT timestamp_column::varchar(10)
FROM date_time_types;
