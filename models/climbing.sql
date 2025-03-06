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
    'Climbing' AS flight_status
FROM cleaned_data
WHERE vertical_rate > 0
