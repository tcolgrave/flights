WITH cleaned_data AS (
    SELECT * FROM {{ ref('clean_flights_data') }}
)
SELECT
    flight_id,
    origin_country,
    callsign,
    departure_time,
    velocity,
    'Fast' AS flight_speed
FROM cleaned_data
WHERE velocity > 500
