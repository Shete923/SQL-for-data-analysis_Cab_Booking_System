use cab_booking_system;

describe customers;
describe bookings;
describe cabs;
describe drivers;
describe trip_details;


-- Customers Who Completed most bookings
select c.customer_id,c.name,count(b.booking_id) as TotalBookings
from customers c
join bookings b on
c.customer_id = b.customer_id
where b.status='Completed'
group by c.customer_id,c.name
order by TotalBookings desc
Limit 5;

-- Customers with > 30 % Cancellation with reason
SELECT 
c.customer_id,
c.name,
GROUP_CONCAT(DISTINCT f.cancellation_reason SEPARATOR ', ') AS cancellation_reasons,
SUM(CASE WHEN b.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled,
COUNT(*) AS total,
(SUM(CASE WHEN b.status = 'cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS CancelledPercentage
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
LEFT JOIN feedback f ON b.booking_id = f.booking_id
GROUP BY c.customer_id, c.name
HAVING CancelledPercentage > 30
ORDER BY CancelledPercentage DESC
-- limit 5
;



-- Busiest Day Of the Week
SELECT DAYNAME(booking_time) AS day_of_week,
       COUNT(*) AS total_bookings
FROM bookings
GROUP BY DAYNAME(booking_time)
ORDER BY total_bookings DESC
LIMIT 1;

-- ------------------------------------------------------------------------------------------------------
-- Customer Who generates Highest Revenue
select c.customer_id,c.name,sum(t.fare) as Total_Revenue
from customers c
join bookings b on c.customer_id=b.customer_id
join trip_details t on b.booking_id= t.booking_id
where b.status='completed'
group by c.customer_id,c.name
order by Total_Revenue desc
limit 1;

--  trips per customer per month 
select c.customer_id,c.name,
year(b.booking_time) Year,
monthname(b.booking_time) Month,
count(b.booking_id) as Total_Trips
from customers c 
join bookings b on c.customer_id=b.booking_id
where b.status='completed'
group by c.customer_id,c.name;

