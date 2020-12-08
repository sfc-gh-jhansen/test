-- Returns 0 records when the test is successful
-- Find any trips which have a 0 for either start or stop station id
SELECT
     *
FROM {{ ref('trips') }}
WHERE 1 = 1
    AND (START_STATION_ID <= 0 OR END_STATION_ID <= 0)
