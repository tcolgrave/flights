{{ config(materialized='table') }}  -- Place this line at the very top of your SQL file

WITH cleaned_data AS (
    SELECT * FROM {{ ref('clean_flights') }}
)
SELECT
    flight_id,
    capture_datetime,
    callsign,
    squawk,
    origin_country,
    velocity,
    baro_altitude,
    vertical_rate,
    'Level' AS flight_status
FROM cleaned_data
WHERE ABS(vertical_rate) <= 5  -- Adjust threshold as needed
