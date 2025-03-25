{{ config(materialized='table') }}  -- Place this line at the very top of your SQL file

WITH time_diff_cte AS (
    SELECT 
         c.flight_id,
         c.capture_datetime,
         c.vertical_rate,
         c.baro_altitude,
         COALESCE(s.velocity, m.velocity, f.velocity) AS velocity,
         MAX(c.capture_datetime) OVER (PARTITION BY c.flight_id) - MIN(c.capture_datetime) OVER (PARTITION BY c.flight_id) AS time_diff_for_count
    FROM {{ ref('silver_descending') }} c
    LEFT OUTER JOIN {{ ref('silver_vel_slow') }} s 
        ON c.flight_id = s.flight_id AND c.capture_datetime = s.capture_datetime
    LEFT OUTER JOIN {{ ref('silver_vel_mid') }} m 
        ON c.flight_id = m.flight_id AND c.capture_datetime = m.capture_datetime
    LEFT OUTER JOIN {{ ref('silver_vel_fast') }} f 
        ON c.flight_id = f.flight_id AND c.capture_datetime = f.capture_datetime
    WHERE c.capture_datetime > '2025-03-04 14:12'
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
