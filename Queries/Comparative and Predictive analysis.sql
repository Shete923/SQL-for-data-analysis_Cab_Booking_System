use cab_booking_system;

-- revenue generated from Sedan and SUV
SELECT 
    c.cab_type,
    SUM(t.fare) AS total_revenue,
    COUNT(*) AS total_trips,
    ROUND(AVG(t.fare), 2) AS avg_fare
FROM bookings b
JOIN trip_details t 
    ON b.booking_id = t.booking_id
JOIN cabs c 
    ON b.cab_id = c.cab_id
WHERE b.status = 'Completed'
  AND c.cab_type IN ('Sedan', 'SUV')
GROUP BY c.cab_type;

-- Which Cusrtomer will likely to stop using service
SELECT 
    c.customer_id,
    c.name,
    COUNT(b.booking_id) AS total_trips,
    MAX(b.booking_time) AS last_booking_date,
    DATEDIFF(CURDATE(), MAX(b.booking_time)) AS days_since_last_trip,
    CASE 
        WHEN DATEDIFF(CURDATE(), MAX(b.booking_time)) > 90 THEN 'High Churn Risk'
        WHEN COUNT(b.booking_id) < 5 THEN 'Medium Churn Risk'
        ELSE 'Low Churn Risk'
    END AS churn_prediction
FROM customers c
LEFT JOIN bookings b 
    ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.name
ORDER BY churn_prediction DESC, days_since_last_trip DESC;


-- weekday vs weekend revenue and average fares

SELECT 
    CASE 
        WHEN DAYOFWEEK(b.booking_time) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS booking_type,
    COUNT(b.booking_id) AS total_bookings,
    SUM(t.fare) AS total_revenue,
    AVG(t.fare) AS avg_fare
FROM bookings b
JOIN trip_details t ON b.booking_id = t.booking_id
GROUP BY booking_type;


