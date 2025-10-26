use cab_booking_system;

describe feedback;

-- average waiting time for different location
SELECT 
    t.pickup_location,
    AVG(TIMESTAMPDIFF(MINUTE, b.booking_time, b.start_time)) AS avg_waiting_time_minutes
FROM bookings b
JOIN trip_details t 
    ON b.booking_id = t.booking_id
WHERE b.status = 'Completed'
GROUP BY t.pickup_location
ORDER BY avg_waiting_time_minutes DESC;


-- most common reasons for trip cancellation
SELECT 
    cancellation_reason,
    COUNT(*) AS total_cancellations
FROM feedback
WHERE cancellation_reason IS NOT NULL
GROUP BY cancellation_reason
ORDER BY total_cancellations DESC;

-- Distance wise contribution in revenue
SELECT 
    CASE 
        WHEN t.distance_km < 5 THEN 'Short (<5 km)'
        WHEN t.distance_km BETWEEN 5 AND 15 THEN 'Medium (5-15 km)'
        ELSE 'Long (>15 km)'
    END AS trip_category,
    COUNT(*) AS total_trips,
    SUM(t.fare) AS total_revenue,
    ROUND(100 * SUM(t.fare) / (SELECT SUM(fare) FROM trip_details), 2) AS revenue_percentage
FROM trip_details t
JOIN bookings b 
    ON b.booking_id = t.booking_id
WHERE b.status = 'Completed'
GROUP BY trip_category
ORDER BY total_revenue DESC;





