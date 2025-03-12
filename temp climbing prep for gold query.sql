SELECT 
    flight_id
   ,capture_datetime
   ,vertical_rate
   ,baro_altitude AS baro_alt
   ,velocity
   ,record_count
FROM (
    SELECT 
        c.flight_id
       ,c.capture_datetime
       ,c.vertical_rate
       ,c.baro_altitude
       ,COALESCE(s.velocity, m.velocity, f.velocity) AS velocity
       ,COUNT(c.flight_id) OVER (PARTITION BY c.flight_id) AS record_count
    FROM climbing c
    LEFT OUTER JOIN vel_slow s ON c.flight_id = s.flight_id AND c.capture_datetime = s.capture_datetime
    LEFT OUTER JOIN vel_mid m ON c.flight_id = m.flight_id AND c.capture_datetime = m.capture_datetime
    LEFT OUTER JOIN vel_fast f ON c.flight_id = f.flight_id AND c.capture_datetime = f.capture_datetime
    WHERE c.capture_datetime > '2025-03-04 14:12'
) AS subquery
WHERE record_count > 10
ORDER BY flight_id, capture_datetime;
