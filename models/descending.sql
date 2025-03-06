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
    'Descending' AS flight_status
FROM cleaned_data
WHERE vertical_rate < 0
