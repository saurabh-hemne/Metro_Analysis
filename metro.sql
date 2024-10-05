CREATE DATABASE `metro`;

USE `metro`;

CREATE TABLE `agency`(
    `agency_id` CHAR(5),
    `agency_name` VARCHAR(20),
    `agency_url` VARCHAR(25),
    `agency_timezone` VARCHAR(12),
    `agency_lang` CHAR(2),
    `agency_fare_url` VARCHAR(36),
    `agency_email` VARCHAR(28),
    `agency_phone` VARCHAR(16),
    PRIMARY KEY (`agency_id`)
);

CREATE TABLE `calendar`(
    `service_id` CHAR(2),
    `monday` TINYINT,
    `tuesday` TINYINT,
    `wednesday` TINYINT,
    `thursday` TINYINT,
    `friday` TINYINT,
    `saturday` TINYINT,
    `sunday` TINYINT,
    `start_date` DATE,
    `end_date` DATE,
    PRIMARY KEY (`service_id`)
);

CREATE TABLE `fare_attribute` (
    `fare_id` CHAR(5),
    `price` TINYINT,
    `payment_method` TINYINT,
    `agency_id` CHAR(4),
    PRIMARY KEY(`fare_id`),
    FOREIGN KEY (`agency_id`) REFERENCES `agency`(`agency_id`)
);

CREATE TABLE `route` (
    `route_id` VARCHAR(5),
    `agency_id` CHAR(4),
    `route_short_name` VARCHAR(8),
    `route_long_name` VARCHAR(59),
    `route_type` TINYINT,
    `route_color` VARCHAR(6),
    `route_text_color` VARCHAR(6),
    `route_sort_order` TINYINT,
    PRIMARY KEY(`route_id`),
    FOREIGN KEY (`agency_id`) REFERENCES `agency`(`agency_id`)
);

CREATE TABLE `trip` (
    `service_id` CHAR(2),
    `route_id` VARCHAR(5),
    `trip_id` VARCHAR(9),
    `direction_id` TINYINT,
    `trip_headsign` VARCHAR(26),
    `block_id` VARCHAR(9),
    PRIMARY KEY(`trip_id`),
    FOREIGN KEY (`service_id`) REFERENCES `calendar`(`service_id`),
    FOREIGN KEY (`route_id`) REFERENCES `route`(`route_id`)
);

CREATE TABLE `stop`(
    `stop_id` VARCHAR(12),
    `stop_name` VARCHAR(50),
    `stop_lat` DECIMAL(9,7),
    `stop_lon` DECIMAL(9,7),
    `zone_id` VARCHAR(12),
    `location_type` TINYINT,
    `parent_station` VARCHAR(5),
    `platform_code` TINYINT,
    PRIMARY KEY(`stop_id`)
);

CREATE TABLE `stop_time` (
    `trip_id` VARCHAR(9),
    `stop_sequence` TINYINT,
    `stop_id` VARCHAR(4),
    `arrival_time` TIME,
    `departure_time` TIME,
    `timepoint` TINYINT,
    PRIMARY KEY (`trip_id`, `stop_sequence`),
    FOREIGN KEY (`trip_id`) REFERENCES `trip`(`trip_id`),
    FOREIGN KEY (`stop_id`) REFERENCES `stop`(`stop_id`)
);

CREATE TABLE `fare_rule` (
    `origin_id` VARCHAR(5),
    `destination_id` VARCHAR(5),
    `fare_id` CHAR(5),
    PRIMARY KEY (`origin_id`, `destination_id`, `fare_id`),
    FOREIGN KEY (`fare_id`) REFERENCES `fare_attribute`(`fare_id`)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/agency.csv'
INTO TABLE `agency`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/calendar.csv'
INTO TABLE `calendar`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fare_attribute.csv'
INTO TABLE `fare_attribute`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/route.csv'
INTO TABLE `route`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trip.csv'
INTO TABLE `trip`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@service_id, @route_id, @trip_id, @direction_id, @trip_headsign, @block_id)
SET
service_id = REPLACE(@service_id, '"', ''),
route_id = REPLACE(@route_id, '"', ''),
trip_id = REPLACE(@trip_id, '"', ''),
direction_id = REPLACE(@direction_id, '"', ''),
trip_headsign = REPLACE(@trip_headsign, '"', ''),
block_id = REPLACE(@block_id, '"', '');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stop.csv'
INTO TABLE `stop`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@stop_id, @stop_name, @stop_lat, @stop_lon, @zone_id, @location_type, @parent_station, @platform_code)
SET
stop_id = REPLACE(@stop_id, '"', ''),
stop_name = REPLACE(@stop_name, '"', ''),
stop_lat = REPLACE(@stop_lat, '"', ''),
stop_lon = REPLACE(@stop_lon, '"', ''),
zone_id = REPLACE(@zone_id, '"', ''),
location_type = REPLACE(@location_type, '"', ''),
parent_station = REPLACE(@parent_station, '"', ''),
platform_code = REPLACE(@platform_code, '"', '');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stop_time.csv'
INTO TABLE `stop_time`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@trip_id, @stop_sequence, @stop_id, @arrival_time, @departure_time, @timepoint)
SET
trip_id = REPLACE(@trip_id, '"', ''),
stop_sequence = REPLACE(@stop_sequence, '"', ''),
stop_id = REPLACE(@stop_id, '"', ''),
arrival_time = REPLACE(@arrival_time, '"', ''),
departure_time = REPLACE(@departure_time, '"', ''),
timepoint = REPLACE(@timepoint, '"', '');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fare_rule.csv'
INTO TABLE `fare_rule`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@origin_id, @destination_id, @fare_id)
SET
origin_id = REPLACE(@origin_id, '"', ''),
destination_id = REPLACE(@destination_id, '"', ''),
fare_id = REPLACE(@fare_id, '"', '');

--------------------------------------------- Tables created ------------------------------------------------

-- create an index on stop_time and trip column.
CREATE INDEX idx_stop_id ON stop_time(stop_id);
CREATE INDEX idx_trip ON trip(trip_id);

-- Q1. Retrieve all the trips that have a direction_id of 1.
SELECT trip_id, route_id, service_id
FROM trip
WHERE direction_id = 1;

-- Q2. Retrieve all the stop times for a specific trip.
SELECT stop_id, stop_sequence, arrival_time, departure_time
FROM stop_time
WHERE trip_id like 'SU%';

-- Q3. List services that operate on both Monday and Friday.
SELECT service_id
FROM calendar
WHERE monday = 1 AND friday = 1;

-- Q4. List all the trips along with their route_id and service_id.
SELECT trip_id, route_id, service_id
FROM trip
WHERE service_id = 'WK';

-- Q5. Retrieve all trips that operate on Sundays and order them by their starting date.
SELECT service_id, start_date, end_date
FROM calendar
WHERE sunday = 1
ORDER BY start_date;

-- Q6. What is the average price of all fare attributes?
SELECT AVG(price) AS average_price
FROM fare_attribute;

-- Q7. Find the total number of trips for each route.
SELECT route_id, COUNT(trip_id) AS total_trips
FROM trip
GROUP BY route_id;

-- Q8. List all routes where the agency_id is associated with fares above 50.
SELECT route.route_id, route.route_short_name
FROM route
WHERE route.agency_id IN (
    SELECT agency_id
    FROM fare_attribute
    WHERE price > 50
);

/* Q9. Show the fare ID and a price label as "Expensive" if the price is greater than 35, 
otherwise display "Affordable". */
SELECT fare_id, 
CASE 
	WHEN price > 35 THEN 'Expensive'
	ELSE 'Affordable'
END AS price_label
FROM fare_attribute;

-- Q10. check whether the service operates on Mondays.
SELECT service_id
FROM calendar
WHERE monday = 1 
AND start_date >= '2024-01-01';

-- Q11. Find the top 3 routes with the highest number of trips.
SELECT route.route_id, route.route_short_name, COUNT(trip.trip_id) AS total_trips
FROM trip
JOIN route ON trip.route_id = route.route_id
GROUP BY route.route_id
ORDER BY total_trips DESC
LIMIT 3;

/* Q12.  Retrieve all stops and their corresponding trip information for a specific route
 showing route_id, stop_name and trip_headsign */
SELECT stop.stop_id, stop.stop_name, trip.trip_headsign
FROM stop
JOIN stop_time ON stop.stop_id = stop_time.stop_id
JOIN trip ON stop_time.trip_id = trip.trip_id
WHERE trip.route_id = 'RED';

-- Q13. Find total no. of trips for each route and rank them.
SELECT route_id, COUNT(trip_id) AS total_trips,
       ROW_NUMBER() OVER (ORDER BY COUNT(trip_id) DESC) AS `rank`
FROM trip
GROUP BY route_id;

-- Q14. For each stop calculate the difference in arrival time between consecutive trips.
SELECT stop_id, trip_id, arrival_time,
TIMEDIFF(arrival_time, LAG(arrival_time) OVER (PARTITION BY stop_id ORDER BY arrival_time)) AS arrival_difference
FROM stop_time;

-- Q15. Find the most frequently used stop by trips.
SELECT stop_id, COUNT(*) AS trip_count
FROM stop_time
GROUP BY stop_id
ORDER BY trip_count DESC
LIMIT 1;

-- Q16. Write a query to find the maximum fare price for agency_id which has more than 2 routes.
SELECT fare_attribute.agency_id, MAX(fare_attribute.price) AS max_fare
FROM fare_attribute
JOIN route ON fare_attribute.agency_id = route.agency_id
GROUP BY fare_attribute.agency_id
HAVING COUNT(route.route_id) > 2;

-- Q17. Calculate the average trip duration between consecutive stops.
SELECT trip_id, stop_id, departure_time,
TIMEDIFF(LEAD(departure_time) OVER (PARTITION BY trip_id ORDER BY stop_sequence), departure_time) AS trip_duration
FROM stop_time;
