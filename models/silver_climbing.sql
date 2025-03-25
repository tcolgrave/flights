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
    'Climbing' AS flight_status
FROM cleaned_data
WHERE vertical_rate > 5
