WITH raw_data AS (
    SELECT * FROM {{ source('flights_source', 'raw_flights') }}
)
SELECT
    capture_datetime,
    icao24 AS flight_id,  
    origin_country,
    callsign,
    squawk,
    latitude,
    longitude,
    geo_altitude,
    baro_altitude,
    vertical_rate,
    true_track,
    velocity,
    time_position AS departure_time,
    last_contact AS arrival_time,
    CASE
        WHEN time_position IS NULL THEN 'Unknown'
        ELSE 'Scheduled'
    END AS status
FROM raw_data
WHERE time_position IS NOT NULL
