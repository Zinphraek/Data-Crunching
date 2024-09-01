-- Doing basic math operations
SELECT county_name AS county,
       state_name AS state,
       births_2019 AS births,
       deaths_2019 AS deaths,
       births_2019 - deaths_2019 AS natural_increase
FROM us_counties_pop_est_2019
ORDER BY state_name, county_name;

-- Verifiying 2019 population estimation
SELECT county_name AS county,
	   state_name AS state,
	   pop_est_2019 AS pop,
	   pop_est_2018 + births_2019 - deaths_2019 +
	       international_migr_2019 + domestic_migr_2019 +
		   residual_2019 AS component_total,
	   pop_est_2019 - (pop_est_2018 + births_2019 - deaths_2019 +
           international_migr_2019 + domestic_migr_2019 +
           residual_2019) AS difference
FROM us_counties_pop_est_2019
ORDER BY difference DESC;

-- Computing the area percentage that is water in each county
SELECT county_name AS county,
       state_name AS state,
	   area_water::numeric / (area_land + area_water) * 100 AS pct_water
FROM us_counties_pop_est_2019
ORDER BY pct_water DESC;

-- Data aggregation
SELECT sum(pop_est_2019) AS county_sum,
       round(avg(pop_est_2019), 0) AS county_average
FROM us_counties_pop_est_2019;

-- Average vs median
SELECT sum(pop_est_2019) AS county_sum,
       round(avg(pop_est_2019), 0) AS county_average,
	   percentile_cont(.5)
	   WITHIN GROUP (ORDER BY pop_est_2019) AS county_median
FROM us_counties_pop_est_2019;

-- Quartiles
SELECT percentile_cont(ARRAY[.25, .5, .75])
       WITHIN GROUP (ORDER BY pop_est_2019) AS quartiles
FROM us_counties_pop_est_2019;

-- More readble Quartiles
SELECT unnest(
            percentile_cont(ARRAY[.25,.5,.75])
            WITHIN GROUP (ORDER BY pop_est_2019)
            ) AS quartiles
FROM us_counties_pop_est_2019;