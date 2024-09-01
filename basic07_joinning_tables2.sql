-- Joinning tables

CREATE TABLE district_2020 (
    id integer CONSTRAINT id_key_2020 PRIMARY KEY,
    school_2020 text
);

CREATE TABLE district_2035 (
    id integer CONSTRAINT id_key_2035 PRIMARY KEY,
    school_2035 text
);

-- Inserting data in the tables 
INSERT INTO district_2020 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (5, 'Dover Middle School'),
    (6, 'Webutuck High School');

INSERT INTO district_2035 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (3, 'Morrison Elementary'),
    (4, 'Chase Magnet Academy'),
    (6, 'Webutuck High School');


-------------------------------------------------------------------------------------------------------
-- Viewing the tables with the INNER JOIN (aka JOIN)
-- This return only rows with matching ids from both tables.
SELECT *
FROM district_2020 JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;


-------------------------------------------------------------------------------------------------------
-- Viewing the tables with the INNER JOIN (aka JOIN) with the USING clause.
-- This return only rows with matching ids from both tables. Redundant columns are displayed only once.
SELECT *
FROM district_2020 JOIN district_2035
USING (id)
ORDER BY district_2020.id;


-------------------------------------------------------------------------------------------------------
-- Viewing the tables with the LEFT JOIN.
-- This return all rows from the table on the left side of the 'JOIN' clause,
-- and those of the table from its right side with matching identifiers.
-- If no ids (could be anay other column) are matched, the row from the left table is returned, and the right table is left blank on that row.
SELECT *
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;


-------------------------------------------------------------------------------------------------------
-- Viewing the tables with the RIGHT JOIN.
-- This behave similarly to the 'LEFT JOIN', but on the oposite side.
SELECT *
FROM district_2020 RIGHT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2035.id


-------------------------------------------------------------------------------------------------------
-- Viewing data with the 'FULL AOUTER JOIN' clause.
-- This will return all tables being joinned including matching and missing rows.
SELECT *
FROM district_2020 FULL OUTER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;


-------------------------------------------------------------------------------------------------------
-- View data with the 'CROSS JOIN' (also known as a Cartesian product) clause.
-- This lines up each row in the left table with each row in the right table to present all possible combinations of rows.
SELECT *
FROM district_2020 CROSS JOIN district_2035
ORDER BY district_2020.id, district_2035.id;


-------------------------------------------------------------------------------------------------------
-- Set operators 'UNION'.
-- The columns in the second query must match those in the first and have compatible data types.
SELECT * FROM district_2020
UNION
SELECT * FROM district_2035
ORDER BY id;


-------------------------------------------------------------------------------------------------------
-- Set operators 'UNION ALL', this return all column including dublicated one.
-- The columns in the second query must match those in the first and have compatible data types.
SELECT * FROM district_2020
UNION ALL
SELECT * FROM district_2035
ORDER BY id;


-------------------------------------------------------------------------------------------------------
-- Distinguishing the table source of the data.
SELECT '2020' AS year,
     	school_2020 AS school
FROM district_2020

UNION ALL

SELECT '2035' AS year,
       school_2035
FROM district_2035
ORDER BY school, year;

-------------------------------------------------------------------------------------------------------
-- Intersection
-- This returns just the rows that exist in the results of both queries and eliminates duplicates.
SELECT * FROM district_2020
INTERSECT
SELECT * FROM district_2035
ORDER BY id;

-------------------------------------------------------------------------------------------------------
-- Exception
-- This returns rows that exist in the first query but not in the second, also eliminating duplicates if present.
SELECT * FROM district_2020
EXCEPT
SELECT * FROM district_2035
ORDER BY id;