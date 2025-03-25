{{ config(materialized='table') }}  -- Place this line at the very top of your SQL file

WITH cleaned_data AS (
    SELECT * FROM {{ ref('bronze_parto_clean') }}
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
    'Slow' AS flight_speed
FROM cleaned_data
WHERE velocity < 120
