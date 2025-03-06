-- This test checks that the departure_time is earlier than arrival_time
SELECT *
FROM {{ ref('clean_flights') }}
WHERE departure_time > arrival_time
