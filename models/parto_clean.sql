{{ config(materialized='table') }}  -- This will create a table in the database

WITH clean_flights AS (
    SELECT * 
    FROM {{ ref('clean_flights') }}  -- Referring to the clean_flights model
)
SELECT
    capture_datetime,
    flight_id,  
    origin_country,
    callsign,
    squawk,
    on_ground_flag,     
    latitude,
    longitude,
    geo_altitude,
    baro_altitude,
    vertical_rate,
    true_track,
    velocity,
    last_contact
FROM clean_flights
WHERE capture_datetime IS NOT NULL
  AND flight_id IS NOT NULL
  AND NOT (on_ground_flag IS TRUE AND (velocity > 175 OR vertical_rate != 0))
