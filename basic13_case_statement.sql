-- The 'CASE' expression act as an if-else statement.
-- Syntax
-- CASE WHEN condition THEN result
     -- WHEN another_condition THEN result
     -- ELSE result
-- END;
------------------------------------------------------------------------------------
-- Application:
-- Reclassifying temperature data with CASE
CREATE TABLE temperature_readings (
    station_name text,
    observation_date date,
    max_temp integer,
    min_temp integer,
    CONSTRAINT temp_key PRIMARY KEY (station_name, observation_date)
);

COPY temperature_readings
FROM '/tmp/temperature_readings.csv'
WITH (FORMAT CSV, HEADER);

SELECT max_temp,
       CASE WHEN max_temp >= 90 THEN 'Hot'
            WHEN max_temp >= 70 AND max_temp < 90 THEN 'Warm'
            WHEN max_temp >= 50 AND max_temp < 70 THEN 'Pleasant'
            WHEN max_temp >= 33 AND max_temp < 50 THEN 'Cold'
            WHEN max_temp >= 20 AND max_temp < 33 THEN 'Frigid'
            WHEN max_temp < 20 THEN 'Inhumane'
            ELSE 'No reading'
        END AS temperature_group
FROM temperature_readings
ORDER BY station_name, observation_date;

------------------------------------------------------------------------------------
-- Using 'CASE' in a 'CTE'
-- Reclassifying, counting and grouping temperatures by station name to find general climate classifications of each city
WITH temps_collapsed (station_name, max_temperature_group) AS
    (SELECT station_name,
           CASE WHEN max_temp >= 90 THEN 'Hot'
                WHEN max_temp >= 70 AND max_temp < 90 THEN 'Warm'
                WHEN max_temp >= 50 AND max_temp < 70 THEN 'Pleasant'
                WHEN max_temp >= 33 AND max_temp < 50 THEN 'Cold'
                WHEN max_temp >= 20 AND max_temp < 33 THEN 'Frigid'
                WHEN max_temp < 20 THEN 'Inhumane'
                ELSE 'No reading'
            END
     FROM temperature_readings)

SELECT station_name, max_temperature_group, count(*)
FROM temps_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY station_name, count(*) DESC;