-- This test checks that the departure_time is earlier than arrival_time
SELECT *
FROM {{ ref('bronze_parto_clean') }}
WHERE departure_time > arrival_time

