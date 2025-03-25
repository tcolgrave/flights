-- models/grouped_flights.sql
WITH flight_data AS (
    SELECT 
        p.flight_id,
        p.capture_datetime,
        p.baro_altitude,
        p.velocity,
        COUNT(*) OVER (PARTITION BY p.flight_id) AS record_count,
        LAG(p.capture_datetime) OVER (PARTITION BY p.flight_id ORDER BY p.capture_datetime) AS prev_capture_time
    FROM {{ ref('silver_minmax_grouped') }} p
), 
grouped_flights AS (
    SELECT 
        f.flight_id,
        f.capture_datetime,
        f.baro_altitude,
        f.velocity,
        f.record_count,
        SUM(
            CASE 
                WHEN f.prev_capture_time IS NULL 
                     OR f.capture_datetime - f.prev_capture_time > INTERVAL '90 minutes' 
                THEN 1 
                ELSE 0 
            END
        ) OVER (PARTITION BY f.flight_id ORDER BY f.capture_datetime ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS group_id
    FROM flight_data f
)
SELECT 
    g.flight_id,
    TO_CHAR(MIN(g.capture_datetime), 'MM/DD HH24:MI:SS')::character varying AS min_time,
    TO_CHAR(MAX(g.capture_datetime), 'MM/DD HH24:MI:SS')::character varying AS max_time, 
    MIN(g.baro_altitude) AS min_baro_alt,
    MAX(g.baro_altitude) AS max_baro_alt,
    MIN(g.velocity) AS min_velocity,
    MAX(g.velocity) AS max_velocity,
    COUNT(*) AS record_count,  
    g.group_id
FROM grouped_flights g
GROUP BY g.flight_id, g.group_id
ORDER BY g.flight_id, g.group_id