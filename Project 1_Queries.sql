-- Question 1

select distinct(replacement_cost)as Replacementcost from film
group by distinct(replacement_cost)
order by Replacementcost asc limit 1

--Question 2

select case
when replacement_cost>=9.99 and replacement_cost<=19.99 then 'low'
when replacement_cost>=20.00 and replacement_cost<=24.99 then 'medium'
when replacement_cost>=25.00 and replacement_cost<=29.99 then 'high'
end as replacement_cost_group,count(film_id)
from film
group by replacement_cost_group

--Question 3

select film.title, round (avg (film.length), 0) as length, category.name from film
left join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where category.name in ('Drama', 'Sports')
group by film.title, category.name
order by avg (film.length) desc

--Question 4

select category.name, count(film.title) as category_name from film
left join film_category
on film.film_id = film_category.film_id
left join category
on film_category.category_id = category.category_id
group by category.name
order by count(film.title) desc

--Question 5

select (actor.first_name || ' ' || actor.last_name) as actors, count(film.title) as total_movies_part_in from film
left join film_actor
on film.film_id = film_actor.film_id
left join actor
on film_actor.actor_id = actor.actor_id
group by actors
order by total_movies_part_in desc

-- question 6

select address.address from address
left join customer
on customer.address_id = address.address_id
where customer.address_id is null

-- Question 7

select city.city as Customer_city, sum (payment.amount) as total_amount from customer
left join payment on customer.customer_id = payment.customer_id
left join address
on customer.address_id = address.address_id
left join city
on address.city_id = city.city_id
group by Customer_city
order by total_amount desc

-- Question 8

select (country.country || ', ' || city.city) as country_city, sum(payment.amount) as revenue from customer
left join address
on customer.address_id = address.address_id
left join payment
on customer.customer_id = payment.customer_id
left join city
on address.city_id = city.city_id
left join country
on city.country_id = country.country_id
group by country.country, city.city
order by revenue asc

-- Question 9

select staff_id, round (sum (amount)/count (distinct customer_id), 2) as average_amount
from payment
group by staff_id
order by average_amount desc

-- Question 10

SELECT ROUND (AVG(daily_revenue), 2) AS average_sunday_revenue
FROM (
    SELECT 
        DATE_TRUNC('day', payment_date) AS date,
        SUM(amount) AS daily_revenue
    FROM payment
    WHERE EXTRACT(DOW FROM payment_date) = 0  -- 0 represents Sunday in PostgreSQL
    GROUP BY DATE_TRUNC('day', payment_date)
) AS sunday_revenues

--Question 11

select title, length, replacement_cost from film
where film.length > (select avg(length) from film as f2 where f2.replacement_cost = film.replacement_cost group by replacement_cost)
group by title, length, replacement_cost
order by length asc limit 2

-- Question 12

SELECT
district,
ROUND(AVG(total),2) avg_customer_spent
FROM
(SELECT 
c.customer_id,
district,
SUM(amount) total
FROM payment p
INNER JOIN customer c
ON c.customer_id=p.customer_id
INNER JOIN address a
ON c.address_id=a.address_id
GROUP BY district, c.customer_id) sub
GROUP BY district
ORDER BY 2 DESC
	
-- Question 13

SELECT
title,
amount,
name,
payment_id,
(SELECT SUM(amount) FROM payment p
LEFT JOIN rental r
ON r.rental_id=p.rental_id
LEFT JOIN inventory i
ON i.inventory_id=r.inventory_id
LEFT JOIN film f
ON f.film_id=i.film_id
LEFT JOIN film_category fc
ON fc.film_id=f.film_id
LEFT JOIN category c1
ON c1.category_id=fc.category_id
WHERE c1.name=c.name)
FROM payment p
LEFT JOIN rental r
ON r.rental_id=p.rental_id
LEFT JOIN inventory i
ON i.inventory_id=r.inventory_id
LEFT JOIN film f
ON f.film_id=i.film_id
LEFT JOIN film_category fc
ON fc.film_id=f.film_id
LEFT JOIN category c
ON c.category_id=fc.category_id
ORDER BY name













