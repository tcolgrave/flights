{{ config(materialized='table') }} 

WITH time_diff_cte AS (
    SELECT 
         l.flight_id,
         l.capture_datetime,
         l.vertical_rate,
         l.baro_altitude,
         s.velocity,
         MAX(l.capture_datetime) OVER (PARTITION BY l.flight_id) - MIN(l.capture_datetime) OVER (PARTITION BY l.flight_id) AS time_diff_for_count
    FROM {{ ref('level') }} l
    LEFT OUTER JOIN {{ ref('vel_slow') }} s 
        ON l.flight_id = s.flight_id AND l.capture_datetime = s.capture_datetime
    WHERE l.capture_datetime > '2025-03-04 14:12'
)
, windowed_data AS (
    SELECT 
         flight_id,
         vertical_rate,
         baro_altitude AS baro_alt,
         velocity,
         capture_datetime,
         capture_datetime - LAG(capture_datetime) OVER (PARTITION BY flight_id ORDER BY capture_datetime) AS time_diff,
         COUNT(flight_id) OVER (PARTITION BY flight_id) AS record_count
    FROM time_diff_cte
    WHERE time_diff_for_count <= INTERVAL '30 Minutes'  
)
SELECT *
FROM windowed_data
WHERE record_count > 10
ORDER BY flight_id, capture_datetime