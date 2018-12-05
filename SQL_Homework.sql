use sakila;


# 1a. Display the first and last names of all actors from the table `actor`.
select first_name, last_name from actor;


## 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select concat(upper(left(first_name,1)) , substring(lower(first_name), 2, length(first_name)) , " " , 
		upper(left(last_name,1)) , substring(lower(last_name), 2, length(last_name))
	) as 'Actor Name' from actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor where first_name = "Joe";


#  2b. Find all actors whose last name contain the letters `GEN`:
select * from actor where last_name like "%GEN%";



# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select * from actor where last_name like "%LI%" order by last_name, first_name;


# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country  from country 
where country in ("Afghanistan", "Bangladesh", "China");



# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` 
#named `description` 
#and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
alter table actor add description BLOB;



# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
alter table actor drop column description;


# 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) from actor group by last_name;


# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) from actor group by last_name having count(*) >= 2;


# 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor 
set first_name = "HARPO"
where first_name = "GROUCHO" and last_name = "Williams";


# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
#It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor 
set first_name = "GROUCHO"
where first_name = "HARPO" and last_name = "Williams";



# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
#  * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)
show create table address;



# 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select st.first_name, st.last_name, addr.address, c.city, ctry.country, addr.postal_code
from staff st
left join address addr on addr.address_id = st.address_id 
left join city c on c.city_id = addr.city_id
left join country ctry on ctry.country_id = c.country_id
;



# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select st.first_name, st.last_name, sum(amount) as total_amount
from staff st 
join payment p on st.staff_id = p.staff_id
group by  st.first_name, st.last_name;


# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select f.film_id, f.title, count(fa.actor_id) as 'Number of Actors'
from film f
join film_actor fa on fa.film_id = f.film_id
group by f.film_id, f.title;





# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select f.title, count(*) Copies 
from inventory i
join film f on f.film_id = i.film_id 
where f.title = "Hunchback Impossible"
group by f.film_id;



# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
# ![Total amount paid](Images/total_payment.png)
select c.first_name, c.last_name, sum(p.amount) Total_paid 
from customer c 
join payment p on p.customer_id = c.customer_id 
group by c.first_name, c.last_name
order by c.last_name;

 

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select film_id, title 
from film
where (title like 'K%' or title like 'Q%') 
and language_id in (select language_id from language where name = "English");


# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select first_name, last_name from actor 
where actor_id in 
	(select actor_id from film_actor where film_id in 
		(select film_id from film where title = "Alone Trip")
	);

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information.
select c.first_name, last_name, email 
from customer c 
join address a on a.address_id = c.address_id 
join city ct on ct.city_id = a.city_id
join country ctry on ctry.country_id = ct.country_id 
where ctry.country = "Canada";




# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as _family_ films.
select f.title, c.name as category
from film f 
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id 
where c.name = "Family";


# 7e. Display the most frequently rented movies in descending order.
select f.film_id, f.title, count(r.inventory_id) as Times_Rented
from rental r 
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id 
group by r.inventory_id
order by count(*) desc ;




# 7f. Write a query to display how much business, in dollars, each store brought in.
select st.store_id, sum(amount) Total_Amount
from payment p 
join staff s on s.staff_id = p.staff_id
join store st on st.store_id = s.store_id 
group by st.store_id
order by sum(amount) desc;


select * from store;

# 7g. Write a query to display for each store its store ID, city, and country.
select st.store_id, c.city, ctry.country 
from store st 
join address a on a.address_id = st.address_id
join city c on a.city_id = c.city_id
join country ctry on ctry.country_id = c.country_id ;



# 7h. List the top five genres in gross revenue in descending order. 
#(**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select cat.name as Genre, sum(p.amount) as Gross_Revenue 
from category cat
join film_category fc on fc.category_id = cat.category_id
join inventory i on i.film_id = fc.film_id 
left join rental  r on r.inventory_id = i.inventory_id 
left join payment p on p.rental_id = r.rental_id
group by cat.name 
order by count(*) desc
limit 5;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view  sakila.Genre_Revenue_vw as
	select cat.name as Genre, sum(p.amount) as Gross_Revenue 
	from category cat
	join film_category fc on fc.category_id = cat.category_id
	join inventory i on i.film_id = fc.film_id 
	left join rental  r on r.inventory_id = i.inventory_id 
	left join payment p on p.rental_id = r.rental_id
	group by cat.name 
	order by count(*) desc
	limit 5;

# 8b. How would you display the view that you created in 8a?
select * from sakila.Genre_Revenue_vw;

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view sakila.Genre_Revenue_vw;