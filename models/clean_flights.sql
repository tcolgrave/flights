{{ config(
    materialized='table',
    tags=['disabled']
) }}

WITH raw_data AS (
    SELECT * FROM {{ source('flights_source', 'raw_flights') }}
)
SELECT
    capture_datetime,
    icao24 AS flight_id,  
    origin_country,
    callsign,
    squawk,
    on_ground as on_ground_flag,     
    latitude,
    longitude,
    geo_altitude,
    baro_altitude,
    vertical_rate,
    true_track,
    velocity,
    last_contact
FROM raw_data
WHERE time_position IS NOT NULL
and icao24 is not null
and not (on_ground is true and (velocity > 175 or vertical_rate != 0))