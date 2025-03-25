SELECT 
    p.flight_id,
    p.capture_datetime,
    p.baro_altitude,
    p.velocity
FROM {{ ref('parto_clean') }} p
WHERE p.baro_altitude >= 500
  AND p.velocity >= 50
