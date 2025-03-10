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
    'Fast' AS flight_speed
FROM cleaned_data
WHERE velocity > 500
