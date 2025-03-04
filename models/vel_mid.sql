WITH cleaned_data AS (
    SELECT * FROM {{ ref('clean_flights_data') }}
)
SELECT
    flight_id,
    origin_country,
    callsign,
    departure_time,
    velocity,
    'Neutral' AS flight_speed
FROM cleaned_data
WHERE velocity BETWEEN 100 AND 500
