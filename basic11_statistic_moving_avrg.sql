-- Moving average
CREATE TABLE us_exports (
    year smallint,
    month smallint,
    citrus_export_value bigint,
    soybeans_export_value bigint
);

COPY us_exports
FROM '/tmp/us_exports.csv'
WITH (FORMAT CSV, HEADER);

SELECT year, month, citrus_export_value
FROM us_exports
ORDER BY year, month;

SELECT year, month, citrus_export_value,
    round(
        avg(citrus_export_value)
            OVER(ORDER BY year, month
                ROWS BETWEEN 11 PRECEDING AND CURRENT ROW), 0)
        AS twelve_month_avg
FROM us_exports
ORDER BY year, month;
