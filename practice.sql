SELECT * FROM actor LIMIT 10;
SELECT * FROM country LIMIT 10;
SELECT * FROM city LIMIT 10;
SELECT * FROM address LIMIT 10;
SELECT * FROM category LIMIT 10;
SELECT * FROM inventory LIMIT 10;
SELECT * FROM store LIMIT 10;
SELECT * FROM customer LIMIT 10;
SELECT * FROM language LIMIT 10;
SELECT * FROM film LIMIT 10;
SELECT * FROM film_actor LIMIT 10;
SELECT * FROM film_category LIMIT 10;
SELECT * FROM staff LIMIT 10;
SELECT * FROM payment LIMIT 10;
SELECT * FROM rental LIMIT 10;


/*
Question 1. Write a query to return the titles of the 5 shortest movies by duration.
*/
SELECT title, length
FROM film
ORDER BY length
LIMIT 5;


/*
Question 2. Write a SQL query to return the staff's first name and last name whose profile image is missing.
*/
SELECT first_name, last_name
FROM staff
WHERE picture IS NULL;


/*
Question 3. Write a query to return the total movie rental revenue for each month.
*/
SELECT EXTRACT(YEAR FROM payment_date) AS year, EXTRACT(MONTH FROM payment_date) AS month, SUM(amount) AS rev
FROM payment
GROUP BY year, month
ORDER BY month; 


/*
Question 4. Write a query to return daily revenue in May, 2017
*/
SELECT DATE(payment_date) AS dt, SUM(amount) as sum
FROM payment
WHERE DATE(payment_date) >= '2017-05-01' AND DATE(payment_date) <= '2017-05-31'
GROUP BY dt;
--OR using BETWEEN clause
SELECT DATE(payment_date) AS dt, SUM(amount) as sum
FROM payment
WHERE DATE(payment_date) BETWEEN '2017-05-01' AND '2017-05-31'
GROUP BY dt;


/*
Question 5. Write a query to return the total number of unique customers for each month.
*/
SELECT EXTRACT(YEAR FROM rental_date) AS year, EXTRACT(MONTH FROM rental_date) as month, COUNT(DISTINCT customer_id) AS uu_cnt
FROM rental
GROUP BY year, month
ORDER BY year, month;


/*
Question 6. Write a query to return the average customer spend by month.
Average customer spend: total customer spend divided by the unique number of customers for that month.
*/
SELECT EXTRACT(YEAR FROM payment_date) AS year, EXTRACT(MONTH FROM payment_date) AS month, SUM(amount)/COUNT(DISTINCT customer_id) AS avg_spend
FROM payment
GROUP BY year, month;


/*
Question 7. Write a query to count the number of customers who spend more than $20 by month.
*/
SELECT EXTRACT(YEAR FROM payment_date) AS year, EXTRACT(MONTH FROM payment_date) AS month, customer_id, SUM(amount) AS amt
FROM payment
GROUP BY year, month, customer_id
HAVING SUM(amount) > 20;



SELECT year, month, COUNT(DISTINCT customer_id)
FROM (SELECT EXTRACT(YEAR FROM payment_date) AS year, EXTRACT(MONTH FROM payment_date) AS month, customer_id, SUM(amount) as amt
FROM payment
GROUP BY year, month, customer_id
HAVING SUM(amount) > 20
) AS X
GROUP BY year, month;



WITH cust_spend AS (SELECT EXTRACT(YEAR FROM payment_date) AS year, EXTRACT(MONTH FROM payment_date) AS month, customer_id, SUM(amount) AS amt
FROM payment
GROUP BY year, month, customer_id
)
SELECT year, month, COUNT(DISTINCT customer_id)
FROM cust_spend
WHERE amt > 20
GROUP BY year, month;



/*
Question 8. Write a query to return the minimum and maximum customer total spend in April 2017.
*/
SELECT customer_id, SUM(amount) AS amt
FROM payment
WHERE DATE(payment_date) BETWEEN '2017-04-01' AND '2017-04-30'
GROUP BY customer_id;

SELECT MIN(amt) as min_spend, MAX(amt) as max_spend
FROM (SELECT customer_id, SUM(amount) AS amt
FROM payment
WHERE DATE(payment_date) BETWEEN '2017-04-01' AND '2017-04-30'
GROUP BY customer_id
) AS X;



/*
Question 9. Find the number of actors whose last name is one of the following:'DAVIS', 'BRODY', 'ALLEN', 'BERRY'
*/
SELECT last_name, COUNT(*)
FROM actor
WHERE last_name IN ('DAVIS', 'BRODY', 'ALLEN', 'BERRY')
GROUP BY last_name;



/*
Question 10. Identify all actors whose last name ends in 'EN' or 'RY'.
*/
SELECT last_name, COUNT(*)
FROM actor
WHERE last_name LIKE '%EN' OR last_name LIKE '%RY'
GROUP BY last_name; 



/*
Question 11. Write a query to return the number of actors whose first name starts with 'A', 'B', 'C', or others.
You need to return 2 columns:
The first column is the group of actors based on the first letter of their first_name, use the following: 'a_actors', 'b_actors', 'c_actors', 'other_actors' to represent their groups.
Second column is the number of actors whose first name matches the pattern.
*/
SELECT
  CASE WHEN first_name LIKE 'A%' THEN 'a_actors'
       WHEN first_name LIKE 'B%' THEN 'b_actors'
       WHEN first_name LIKE 'C%' THEN 'c_actors'
       ELSE 'other_actors'
  END AS actor_category, COUNT(*)
FROM actor
GROUP BY actor_category
ORDER BY actor_category;


/*
Question 12. Write a query to return the number of good days and bad days in May 2005 based on number of daily rentals.
Return the results in one row with 2 columns from left to right: good_days, bad_days.
good day: > 100 rentals
bad day: <= 100 rentals
*/
SELECT DATE(rental_date) as dt, COUNT(*) as daily_cnt
FROM rental
WHERE DATE(rental_date) BETWEEN '2005-05-01' AND '2005-05-31'
GROUP BY dt;


SELECT
    SUM(CASE WHEN daily_cnt > 100 THEN 1 ELSE 0 END) AS good_days,
    31 - SUM(CASE WHEN daily_cnt > 100 THEN 1 ELSE 0 END) AS bad_days
FROM (
  SELECT DATE(rental_date) as dt, COUNT(*) as daily_cnt
FROM rental
WHERE DATE(rental_date) BETWEEN '2005-05-01' AND '2005-05-31'
GROUP BY dt
) AS X;


WITH daily_rentals AS (
  SELECT DATE(rental_date) as dt, COUNT(*) as daily_cnt
FROM rental
WHERE DATE(rental_date) BETWEEN '2005-05-01' AND '2005-05-31'
GROUP BY dt
)
SELECT
    SUM(CASE WHEN daily_cnt > 100 THEN 1 ELSE 0 END) AS good_days,
    31 - SUM(CASE WHEN daily_cnt > 100 THEN 1 ELSE 0 END) AS bad_days
FROM daily_rentals;




/*
Question 13. Write a query to return GROUCHO WILLIAMS' actor_id.
*/
SELECT actor_id FROM actor
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';



/*
Question 14. Write a query to return the film category id with the most films, as well as the number of films in that category.
*/
SELECT category_id, COUNT(*) as film_count
FROM film_category
GROUP BY category_id
ORDER BY film_count DESC LIMIT 1;



/*
Question 15. Write a query to return the first name and last name of the actor who appeared in the most films.
*/
SELECT actor_id, COUNT(*) AS film_cnt
FROM film_actor
GROUP BY actor_id
ORDER BY film_cnt DESC LIMIT 1;


SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(*) DESC LIMIT 1;


SELECT first_name, last_name
FROM actor
WHERE actor_id = (
  SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(*) DESC LIMIT 1
);


WITH most_film_count AS (
  SELECT actor_id, COUNT(*) AS film_cnt
FROM film_actor
GROUP BY actor_id
ORDER BY film_cnt DESC LIMIT 1
)
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id FROM most_film_count);



/*
Question 16. Write a query to return the first and last name of the customer who spent the most on movie rentals in April 2017.
*/

SELECT first_name, last_name
FROM customer
WHERE customer_id = 148

WITH cust_april_spend AS (
SELECT customer_id, SUM(amount) AS amt
FROM payment
WHERE DATE(payment_date) BETWEEN '2017-04-01' AND '2017-04-30'
GROUP BY customer_id
ORDER BY amt DESC LIMIT 1
)
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id FROM cust_april_spend);


/*
Question 17. Write a query to return the first and last name of the customer who made the most rental transactions in May 2005.
*/
WITH cust_april_transactions AS (
  SELECT customer_id, COUNT(*) AS transaction_cnt
  FROM rental
  WHERE DATE(rental_date) BETWEEN '2005-05-01' AND '2005-05-31'
  GROUP BY customer_id
  ORDER BY transaction_cnt DESC LIMIT 1
)
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id FROM cust_april_transactions);



/*
Question 18. Write a query to return the average cost on movie rentals in April 2017 per transaction.
*/
SELECT AVG(amount) as avg
FROM payment
WHERE DATE(payment_date) BETWEEN '2017-04-01' AND '2017-04-30';



/*
Question 19. Write a query to return the average movie rental spend per customer in Feb 2017.
*/
SELECT customer_id, SUM(amount) AS amt
FROM payment
WHERE DATE(payment_date) BETWEEN '2017-02-01' AND '2017-02-28'
GROUP BY customer_id;

SELECT AVG(amt) AS avg
FROM (
  SELECT customer_id, SUM(amount) AS amt
FROM payment
WHERE DATE(payment_date) BETWEEN '2017-02-01' AND '2017-02-28'
GROUP BY customer_id
) AS X;

WITH cust_feb_spend AS (
  SELECT customer_id, SUM(amount) AS amt
FROM payment
WHERE DATE(payment_date) BETWEEN '2017-02-01' AND '2017-02-28'
GROUP BY customer_id
)
SELECT AVG(amt) FROM cust_feb_spend;



/*
Question 20. Write a query to return the titles of the films with >= 10 actors.
*/
SELECT film_id, COUNT(*) AS actor_count 
FROM film_actor 
GROUP BY film_id
HAVING COUNT(*) >= 10; 

SELECT title
FROM film
WHERE film_id IN (SELECT film_id 
FROM film_actor 
GROUP BY film_id
HAVING COUNT(*) >= 10
);

WITH num_of_actors AS (
  SELECT film_id, COUNT(*) AS actor_count 
FROM film_actor 
GROUP BY film_id
HAVING COUNT(*) >= 10
)
SELECT title
FROM film
WHERE film_id IN (SELECT film_id FROM num_of_actors);


/*
Question 21. Write a query to return the title of the film with the minimum duration.
*/
SELECT title
FROM film
ORDER BY length LIMIT 1;



/*
Question 22. Write a query to return the title of the second shortest film based on its duration/length.
*/

SELECT title
FROM (
SELECT title, length
FROM film
ORDER BY length LIMIT 2
) AS X
ORDER BY length DESC LIMIT 1;

WITH second_shortest AS (
  SELECT title, length
FROM film
ORDER BY length LIMIT 2
)
SELECT title FROM second_shortest
ORDER BY length DESC LIMIT 1;



/*
Question 23. Write a query to return the title of the film with the largest cast (most actors).
*/
WITH largest_cast AS (
SELECT film_id, COUNT(*) AS actor_count
FROM film_actor
GROUP BY film_id
ORDER BY actor_count DESC LIMIT 1
)
SELECT title
FROM film
WHERE film_id IN (SELECT film_id FROM largest_cast);



/*
Question 24. Write a query to return the title of the film with the second largest cast.
*/

WITH largest_cast AS (
SELECT film_id, COUNT(*) AS actor_count
FROM film_actor
GROUP BY film_id
ORDER BY actor_count DESC LIMIT 2
)
SELECT title
FROM film
WHERE film_id IN (SELECT film_id FROM largest_cast ORDER BY actor_count LIMIT 1);



/*
Question 25. Write a query to return the name of the customer who spent the second highest for movie rentals in Feb 2017.
*/

WITH highest_spending AS (
  SELECT customer_id, SUM(amount) AS cust_spend
  FROM payment
  WHERE DATE(payment_date) BETWEEN '2017-02-01' AND '2017-02-28'
  GROUP BY customer_id
  ORDER BY cust_spend DESC LIMIT 2
)
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id FROM highest_spending ORDER BY cust_spend LIMIT 1);



/*
Question 26. Write a query to return the total number of customers who didn't rent any movies in May 2005
*/
SELECT COUNT(DISTINCT customer_id)
FROM customer
WHERE customer_id NOT IN (
SELECT  DISTINCT customer_id
FROM rental
WHERE DATE(rental_date) BETWEEN '2005-05-01' AND '2005-05-31'
);




/*
Question 27. Write a query to return the titles of the films that have not been returned by our customers.
If the movie is not returned, the return_date will be NULL in the rental table.
*/

SELECT title
FROM film
WHERE film_id IN (
SELECT DISTINCT film_id FROM inventory
WHERE inventory_id IN (
SELECT inventory_id
FROM rental
WHERE return_date IS NULL)
);


/*
Question 28. Write a query to return the number of films with no rentals in May 2005
Count the entire movie catalog from the film table.
*/

SELECT COUNT(*) FROM film
WHERE film_id NOT IN (
SELECT DISTINCT film_id
FROM inventory
WHERE inventory_id IN (
SELECT inventory_id
FROM rental
WHERE DATE(rental_date) BETWEEN '2005-05-01' AND '2005-05-31'
));


/*
Question 29. Write a query to return the number of customers who rented at lease one movie in both May 2005 and June 2005
*/

SELECT COUNT(DISTINCT customer_id)
FROM rental
WHERE customer_id IN (
SELECT DISTINCT customer_id
FROM rental
WHERE DATE(rental_date) BETWEEN '2005-05-01' AND '2005-05-31'
) AND DATE(rental_date) BETWEEN '2005-06-01' AND '2005-06-30';



/*
Question 30. Write a query to return the titles of movies with more than >7 dvd copies on the inventory.
*/

WITH inventory_count AS (
  SELECT film_id, COUNT(*) AS dvd_copies
  FROM inventory
  GROUP BY film_id
  HAVING COUNT(*) > 7
)
SELECT title FROM film
WHERE film_id IN (SELECT film_id FROM inventory_count);



/*
Question 31. Write a query to return the number of films in the following categories: short, medium, and long.
Definition:
short: less < 60 minutes
medium: >=60 minutes, but <100 minutes
long: >= 100 minutes
*/

SELECT
  CASE WHEN length<60 THEN 'short'
       WHEN length >=60 AND length < 100 THEN 'medium'
       WHEN length >= 100 THEN 'long'
  END AS film_category, COUNT(*)
FROM film
GROUP BY film_category;




/*
Question 32. Write a query to return the first name and last name of all actors in the film 'AFRICAN EGG'.
*/

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id
FROM film_actor
WHERE film_id IN (SELECT film_id
FROM film
WHERE title = 'AFRICAN EGG'));


SELECT A.first_name, A.last_name
FROM actor A INNER JOIN film_actor FA 
ON A.actor_id = FA.actor_id INNER JOIN film F ON FA.film_id = F.film_id
WHERE F.title = 'AFRICAN EGG';



/*
Question 33. Return the name of the category that has the most films.
If there are ties, return just one of them.
*/
SELECT C.name
FROM category C INNER JOIN film_category FC
ON C.category_id = FC.category_id 
GROUP BY C.name
ORDER BY COUNT(*) DESC LIMIT 1;




/*
Question 34. Write a query to return the name of the most popular film category and its category id.
If there are ties, return just one of them.
*/
SELECT C. category_id, C.name
FROM category C INNER JOIN film_category FC
ON C.category_id = FC.category_id
GROUP BY C.category_id
ORDER BY COUNT(*) DESC LIMIT 1;



/*
Question 35. Write a query to return the name of the actor who appears in the most films.
You have to use INNER JOIN in your query.
*/

SELECT A.actor_id, A.first_name, A.last_name 
FROM actor A INNER JOIN film_actor FA
ON A.actor_id = FA.actor_id
GROUP BY A.actor_id
ORDER BY COUNT(*) DESC LIMIT 1;



/*
Question 36. Write a query to return the film_id and title of the top 5 movies that were rented the most times in June 2005.
Use the rental_date column from the rental for the transaction time.
If there are ties, return any 5 of them.
*/

SELECT F.film_id, F.title, COUNT(*)
FROM film F INNER JOIN inventory I
ON F.film_id = I.film_id
INNER JOIN rental R
ON I.inventory_id = R.inventory_id
GROUP BY F.film_id
ORDER BY COUNT(*) DESC LIMIT 5;



/*
Question 37. Write a query to return the number of productive and less-productive actors.
Definition
- productive: appeared in >= 30 films
- less-productive: appeared in <30 films
*/

SELECT actor_category, COUNT(*)
FROM (
SELECT
  A.actor_id,
  CASE WHEN COUNT(DISTINCT FA.film_id) >=30 THEN 'productive'
       ELSE 'less_productive'
  END AS actor_category
FROM actor A LEFT JOIN film_actor FA
ON A.actor_id = FA.actor_id
GROUP BY A.actor_id
) AS X
GROUP BY actor_category;



/*
Question 38. Write a query to return the number of films that we have inventory vs no inventory.
A film can have multiple inventory auth.identitiesEach film dvd copy has a unique inventory ids.
*/

SELECT in_stock, COUNT(*)
FROM (
SELECT F.film_id,
  CASE WHEN COUNT(I.inventory_id) >0 THEN 'in stock' ELSE 'not in stock'
  END AS in_stock
FROM inventory I RIGHT JOIN film F
ON I.film_id = F.film_id
GROUP BY F.film_id
) AS X
GROUP BY in_stock;




/*
Question 39. Write a query to return the number of customers who rented at least one movie vs. those who didn't in May 2005.
Use customer table as the base table for all customers (asssuming all customers have signed up before May 2005)
Rented: If a customer rented at least one movie.
Develop a LEFT JOIN as well as a RIGHT JOIN solution.
*/

SELECT hass_rented, COUNT(*)
FROM (
  SELECT C.customer_id,
    CASE WHEN R.customer_id IS NOT NULL THEN 'never-rented' ELSE 'rented'
    END AS hass_rented
  FROM customer C LEFT JOIN (SELECT DISTINCT customer_id FROM rental WHERE DATE(rental_date) BETWEEN '2005-05-01' AND   '2005-05-31') AS R
  ON C.customer_id = R.customer_id
) AS X
GROUP BY hass_rented;


/*
Question 40. Write a query to return the numner of in demand and not in demand movies in May 2017.
Assumption: all films are available for rent before May.
But if a film is not in stock, it is not in demand.
Definition:
- in-demand: rented >1 times in May 2017.
- not-in-demand: rentred <=1 time in May 2017.
*/

SELECT
  F.film_id,
  CASE WHEN COUNT(R.rental_id) > 1 THEN 'in demand' ELSE 'not in demand' END AS demand_category
FROM film F LEFT JOIN inventory I 
  ON F.film_id = I.film_id LEFT JOIN (SELECT inventory_id, rental_id FROM rental WHERE DATE(rental_date) BETWEEN '2005-05-01' AND '2005-05-31') R
  ON R.inventory_id = I.inventory_id
GROUP BY F.film_id 



SELECT demand_category, COUNT(*)
FROM (SELECT
  F.film_id,
  CASE WHEN COUNT(R.rental_id) > 1 THEN 'in demand' ELSE 'not in demand' END AS demand_category
FROM film F LEFT JOIN inventory I 
  ON F.film_id = I.film_id LEFT JOIN 
  (SELECT inventory_id, rental_id FROM rental WHERE DATE(rental_date) BETWEEN '2005-05-01' AND '2005-05-31') AS R
  ON R.inventory_id = I.inventory_id
GROUP BY F.film_id) AS X
GROUP BY demand_category;



/*
Question 41. Write a query to return unique names (first_name, last_name) of our customers and actors whose last name starts with letter 'A'
*/

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE 'A%'
UNION
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'A%';



/*
Question 42. Write a query to return all actors and customers whose first name ends in 'D'.
Retrun their ids (for actor: use actor_id, customer: customer_id), first_name, last_name.
*/

SELECT customer_id, first_name, last_name
FROM customer
WHERE first_name LIKE '%D'
UNION
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE '%D';




/*
Question 43. Write a query to return the names of the top 5 cities with the most rental revenues in 2017.
Include each city's revenue in the second column.
*/

SELECT CT.city, SUM(P.amt)
FROM (SELECT customer_id, SUM(amount) as amt
FROM payment
WHERE EXTRACT(YEAR FROM payment_date) = '2017'
GROUP BY customer_id) P INNER JOIN customer C ON P.customer_id = C.customer_id
  INNER JOIN address A ON C.address_id = A.address_id
  INNER JOIN city CT ON A.city_id = CT.city_id
GROUP BY CT.city
ORDER BY SUM(P.amt) DESC LIMIT 5;



SELECT CT.city, SUM(P.amount)
FROM payment P INNER JOIN customer C ON P.customer_id = C.customer_id
  INNER JOIN address A ON C.address_id = A.address_id
  INNER JOIN city CT ON A.city_id = CT.city_id
GROUP BY CT.city
ORDER BY SUM(P.amount) DESC LIMIT 5;



/*
Question 44. Write a query to return the number of films in 3 separate groups: high, medium, low.
Definition:
- high: revenue >= $100
- medium: revenue >= $20, < $100
- low: revenue < $20  
*/
SELECT film_group, COUNT(*)
FROM (
SELECT F.film_id, 
  CASE WHEN SUM(P.amount) >= 100 THEN 'high'
       WHEN SUM(P.amount) >= 20 THEN 'medium'
       ELSE 'low' END film_group
FROM film F LEFT JOIN inventory I ON F.film_id = I.film_id
LEFT JOIN rental R ON R.inventory_id = I.inventory_id
LEFT JOIN payment P ON P.rental_id = R.rental_id
GROUP BY F.film_id
) AS X
GROUP BY film_group;



/*
Question 45. Write a query to return the number of customers in 3 separate groups: high, medium, low.
Definition:
- high: movie rental spend >= $150
- medium: movie rental spend >= $100, < $150
- low: movie rental spend < $100  
*/
SELECT customer_group, COUNT(*)
FROM (
SELECT C.customer_id,
  CASE WHEN SUM(P.amount) >= 150 THEN 'high'
       WHEN SUM(P.amount) >= 100 THEN 'medium'
       ELSE 'low' END customer_group
FROM customer C LEFT JOIN payment P ON C.customer_id = P.customer_id
GROUP BY C.customer_id
) AS X
GROUP BY customer_group;



/*
Question 46. Write a query to return the percentage of revenue for each of the following films: film_id <= 10.
Formula: revenue (film_id x) * 100.0/ revenue of all movies
*/

WITH movie_revenue AS (
SELECT I.film_id, SUM(P.amount) AS revenue
FROM payment P INNER JOIN rental R ON 
P.rental_id = R.rental_id INNER JOIN inventory I ON
I.inventory_id = R.inventory_id
GROUP BY I.film_id
)
SELECT film_id, revenue*100/SUM(revenue) OVER() AS revenue_percentage
FROM movie_revenue
ORDER BY film_id
LIMIT 10;



/*
Question 47. Write a query to return the percentage of revenue for each of the following films: film_id <= 10 by its category.
Formula: revenue (film_id x) * 100.0 / revenue of all movies in the same category.
Return 3 columns: film_id, category name, and percentage.
*/

WITH movie_revenue AS (
  SELECT I.film_id, SUM(P.amount) AS revenue
  FROM inventory I INNER JOIN rental R ON 
  I.inventory_id = R.rental_id INNER JOIN payment P ON
  P.rental_id = R.rental_id
  GROUP BY I.film_id
)
SELECT M.film_id, C.name AS category_name, revenue*100/SUM(revenue) OVER(PARTITION BY C.name) AS revenue_percent_category
FROM movie_revenue M INNER JOIN film_category FC ON 
M.film_id = FC.film_id INNER JOIN category C ON
FC.category_id = C.category_id
ORDER BY M.film_id
LIMIT 10;



/*
Question 48. Write a query to return the number of rentals per movie, and the average number of rentals in the same category.
Only return the results for film_id <= 10
Return 4 columns: film_id, category name, number of rentals, and the average number of rentals from its category.
*/

WITH num_rentals AS (
  SELECT I.film_id, COUNT(*) AS rentals
  FROM inventory I INNER JOIN rental R ON 
  I.inventory_id = R.inventory_id
  GROUP BY I.film_id
)
SELECT NR.film_id, C.name AS category_name, rentals, AVG(rentals) OVER(PARTITION BY C.name) AS avg_rentals_category
FROM num_rentals NR INNER JOIN film_category FC ON 
NR.film_id = FC.film_id INNER JOIN category C ON 
C.category_id = FC.category_id
ORDER BY film_id;




/*
Question 49. Write a query to return a customer's life time value for the following: customer_id IN (1,100,101,200,201,300,301,400,410,500).
Add a column to compute the average LTV of all the customers from the same store.
Return 4 columns: customer_id, store_id, customer total spend, average customer spend from the same store.
Assumption: A customer can only be associated with one store.
*/

WITH life_time_value AS (
SELECT P.customer_id, SUM(P.amount) AS ltd_spend
FROM payment P INNER JOIN customer C ON 
P.customer_id = C.customer_id
GROUP BY P.customer_id
HAVING P.customer_id IN (1, 100, 101, 200, 201, 300, 301, 400, 410, 500)
)
SELECT LTV.customer_id, C.store_id, LTV.ltd_spend, AVG(ltd_spend) OVER(PARTITION BY C.store_id) AS avg
FROM life_time_value AS LTV INNER JOIN customer C ON 
LTV.customer_id = C.customer_id 


WITH life_time_value AS (
SELECT P.customer_id, C.store_id, SUM(P.amount) AS ltd_spend
FROM payment P INNER JOIN customer C ON 
P.customer_id = C.customer_id
GROUP BY P.customer_id, C.store_id
HAVING P.customer_id IN (1, 100, 101, 200, 201, 300, 301, 400, 410, 500)
)
SELECT customer_id, store_id, ltd_spend, AVG(ltd_spend) OVER(PARTITION BY store_id) AS avg
FROM life_time_value 




