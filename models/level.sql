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
    'Level' AS flight_status
FROM cleaned_data
WHERE ABS(vertical_rate) <= 0.1  -- Adjust threshold as needed
