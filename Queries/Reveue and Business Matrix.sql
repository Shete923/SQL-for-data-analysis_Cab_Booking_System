use cab_booking_system;

describe bookings;
describe trip_details;
-- Total Revenue of last 6 months
SELECT SUM(t.fare) AS total_revenue
FROM bookings b
JOIN trip_details t 
    ON b.booking_id = t.booking_id
WHERE b.status = 'Completed'
  AND date(b.booking_time) >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- TOP 3 most traveled rotes based on pickup and drop location
SELECT t.pickup_location, t.dropoff_location, COUNT(*) AS trip_count
FROM trip_details t
JOIN bookings b 
    ON t.booking_id = b.booking_id
WHERE b.status = 'Completed'
GROUP BY t.pickup_location, t.dropoff_location
ORDER BY trip_count DESC
LIMIT 3;

-- trips, revenue, and average rating
SELECT d.driver_id,d.name,d.rating,
    COUNT(b.booking_id) AS total_trips,
    SUM(t.fare) AS total_revenue,
    AVG(t.fare) AS avg_fare
FROM drivers d
JOIN bookings b 
ON d.driver_id = b.driver_id
JOIN trip_details t 
ON b.booking_id = t.booking_id
WHERE b.status = 'Completed'
GROUP BY d.driver_id, d.name, d.rating;
