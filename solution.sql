use sakila;

-- 1. Select all the actors with the first name ‘Scarlett’.
SELECT 
    *
FROM
    actor
WHERE
    LOWER(first_name) = 'scarlett';

-- 2. How many films (movies) are available for rent and how many films have been rented?
-- Films that the store rent (counting all instances of a movie) with all rental transactions

-- Solution 1
SELECT
	(SELECT COUNT(*) FROM inventory) AS movies_for_rent,
    (SELECT COUNT(*) FROM rental) AS rented_movies
FROM
	dual;

-- Solution 2    
SELECT 
    'all movies' AS type, COUNT(film_id) AS movies_for_rent
FROM
    inventory 
UNION SELECT 
    'rented movies' AS type, COUNT(inventory_id) AS rented_movies
FROM
    rental;

-- Solution 3 => drop movies that have never been rented
SELECT 
    COUNT(DISTINCT inventory_id) AS movies_for_rent,
    COUNT(rental_id) AS rented_movies
FROM
    rental;

-- Films that are currently not rented (available) ==> we cannot because all transactions are in the past


-- 3.What are the shortest and longest movie duration? Name the values max_duration and min_duration.
SELECT 
    MIN(length) AS min_duration, MAX(length) AS max_duration
FROM
    film;


-- 4. What's the average movie duration expressed in format (hours, minutes)?
SELECT 
    CONCAT(FLOOR(AVG(length) / 60),
            ' hour(s) ',
            ROUND(AVG(length) % 60, 0),
            ' minute(s)') AS avg_duration_hour_min,
    CAST(CONCAT(FLOOR(AVG(length) / 60),
                ':',
                ROUND(AVG(length) % 60, 0))
        AS TIME) AS avg_duration_time
FROM
    film;

-- 5. How many distinct (different) actors' last names are there?
SELECT 
    COUNT(DISTINCT (last_name)) AS distinct_last_names
FROM
    actor;

-- 6. Since how many days has the company been operating (check DATEDIFF() function)?
SELECT 
    DATEDIFF(MAX(last_update), MIN(rental_date)) AS nb_operating_days
FROM
    rental;

-- 7. Show rental info with additional columns month and weekday. Get 20 results.
SELECT 
    *,
    (MONTH(rental_date)) AS rental_date_month,
    (WEEKDAY(rental_date)) AS rental_date_weekday,
    (MONTH(return_date)) AS return_date_month,
    (WEEKDAY(return_date)) AS return_date_weekday
FROM
    sakila.rental
LIMIT 20;

-- 8. Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT 
    *,
    MONTH(rental_date) AS rental_date_month,
    WEEKDAY(rental_date) AS rental_date_weekday,
    CASE WEEKDAY(rental_date)
        WHEN 5 & 6 THEN 'weekend'
        ELSE 'workday'
    END AS day_type,
    MONTH(return_date) AS return_date_month,
    WEEKDAY(return_date) AS return_date_weekday,
    CASE WEEKDAY(return_date)
        WHEN 5 & 6 THEN 'weekend'
        ELSE 'workday'
    END AS day_type
FROM
    sakila.rental
LIMIT 20;

-- 9. Get release years.
SELECT DISTINCT
    (release_year) AS distinct_release_years
FROM
    film;

-- 10. Get all films with ARMAGEDDON in the title.
SELECT 
    *
FROM
    film
WHERE
    title LIKE UPPER('%ARMAGEDDON%');

-- 11. Get all films which title ends with APOLLO.
SELECT 
    *
FROM
    film
WHERE
    title LIKE UPPER('%APOLLO');

-- 12. Get 10 the longest films.
SELECT 
    *
FROM
    film
ORDER BY length DESC
LIMIT 10;

-- 13. How many films include Behind the Scenes content?
SELECT 
    COUNT(*) AS nb_films_with_behind_the_scenes
FROM
    film
WHERE
    special_features LIKE UPPER('%BEHIND THE SCENES%');