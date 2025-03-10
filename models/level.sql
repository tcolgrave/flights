{{ config(materialized='table') }}  -- Place this line at the very top of your SQL file

WITH cleaned_data AS (
    SELECT * FROM {{ ref('clean_flights') }}
)
SELECT
    flight_id,
    callsign,
    squawk,
    origin_country,
    departure_time,
    velocity,
    baro_altitude,
    vertical_rate,
    'Level' AS flight_status
FROM cleaned_data
WHERE ABS(vertical_rate) <= 0.1  -- Adjust threshold as needed
