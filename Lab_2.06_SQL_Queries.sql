/* 1. In the table actor, which are the actors whose last names are not repeated? 
For example if you would sort the data in the table actor by last_name, 
you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. 
These three actors have the same last name. So we do not want to include this last name in our output. 
Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list. */

USE sakila;

SELECT first_name, last_name FROM sakila.actor;

SELECT first_name, last_name 
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY last_name ORDER BY last_name) As rn
    FROM sakila.actor) a
WHERE rn = 1;


/* 2. Which last names appear more than once? 
We would use the same logic as in the previous question 
but this time we want to include the last names of the actors where the last name was present more than once */

select first_name, last_name
from 
  ( select *, 
           count(1) over (partition by last_name) as occurs
    from sakila.actor
  ) AS a
where occurs > 1 ;

/* 3. Using the rental table, find out how many rentals were processed by each employee. */

SELECT staff_id, count(rental_id) FROM sakila.rental
GROUP BY staff_id 
ORDER BY staff_id;

/* 4. Using the film table, find out how many films were released each year. */

SELECT release_year, count(film_id) FROM sakila.film
GROUP BY release_year
Order By release_year;

/* 5. Using the film table, find out for each rating how many films were there. */

SELECT rating, count(film_id) as "How many films" FROM sakila.film
GROUP BY rating
ORDER BY count(film_id) DESC;


/* 6. What is the mean length of the film for each rating type. Round off the average lengths to two decimal places ? */

SELECT rating, count(film_id) as "How many films", round(avg(length),2) as "Mean length" FROM sakila.film
GROUP BY rating
ORDER BY round(avg(length),2),count(film_id) DESC;


/* 7. Which kind of movies (rating) have a mean duration of more than two hours?
Answer: PG-13  */

SELECT rating, count(film_id) as "How many films", round(avg(length),2) as "Mean length" FROM sakila.film
GROUP BY rating
HAVING round(avg(length),2) > 120;

/* 8. Rank films by length (filter out the rows that have nulls or 0s in length column). 

In your output, only select the columns title, length, and the rank. */
 

SELECT title, film.length,  Dense_RANK() OVER(ORDER BY length DESC) AS "rank" FROM sakila.film
WHERE (length IS NOT NULL) and length != 0
ORDER BY Dense_RANK() OVER(ORDER BY length DESC);
 
