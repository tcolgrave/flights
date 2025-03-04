WITH cleaned_data AS (
    SELECT * FROM {{ ref('clean_flights_data') }}
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
