WITH cleaned_data AS (
    SELECT * FROM {{ ref('clean_flights_data') }}
)
SELECT
    flight_id,
    origin_country,
    callsign,
    departure_time,
    vertical_rate,
    'Neutral' AS flight_status
FROM cleaned_data
WHERE ABS(vertical_rate) <= 0.1  -- Adjust threshold as needed
