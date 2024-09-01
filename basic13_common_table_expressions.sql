-- Common Table Expression (CTE), used to generate temporary table that can be refferenced in the main query.

---------------------------------------------------------------------------------------------------------------------------
-- Simple usage
WITH large_counties (county_name, state_name, pop_est_2019)
AS (
    SELECT county_name, state_name, pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE pop_est_2019 >= 100000
   )
SELECT state_name, count(*)
FROM large_counties
GROUP BY state_name
ORDER BY count(*) DESC;

---------------------------------------------------------------------------------------------------------------------------
-- Usage with join table
WITH
    counties (st, pop_est_2018) AS
    (SELECT state_name, sum(pop_est_2018)
     FROM us_counties_pop_est_2019
     GROUP BY state_name),

    establishments (st, establishment_count) AS
    (SELECT st, sum(establishments) AS establishment_count
     FROM cbp_naics_72_establishments
     GROUP BY st)

SELECT counties.st,
       pop_est_2018,
       establishment_count,
       round((establishments.establishment_count /
              counties.pop_est_2018::numeric(10,1)) * 1000, 1)
           AS estabs_per_thousand
FROM counties JOIN establishments
ON counties.st = establishments.st
ORDER BY estabs_per_thousand DESC;

---------------------------------------------------------------------------------------------------------------------------
-- Using CTEs to minimize redundant code
--------------------------------------------------------
-- Redundant code:
SELECT county_name,
       state_name AS st,
       pop_est_2019,
       pop_est_2019 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY pop_est_2019) 1
                       FROM us_counties_pop_est_2019) AS diff_from_median
FROM us_counties_pop_est_2019
WHERE (pop_est_2019 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY pop_est_2019) 2
                       FROM us_counties_pop_est_2019))
       BETWEEN -1000 AND 1000;

--------------------------------------------------------
-- Simplified code using CTE:
WITH us_median AS
    (SELECT percentile_cont(.5)
     WITHIN GROUP (ORDER BY pop_est_2019) AS us_median_pop
     FROM us_counties_pop_est_2019)

SELECT county_name,
       state_name AS st,
       pop_est_2019,
       us_median_pop,
       pop_est_2019 - us_median_pop AS diff_from_median
FROM us_counties_pop_est_2019 CROSS JOIN us_median
WHERE (pop_est_2019 - us_median_pop)
    BETWEEN -1000 AND 1000;
