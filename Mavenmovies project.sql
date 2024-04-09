


#                          ............project mavenmovies...........        



/*    1.Write a SQL query to count the number of characters except the spaces for each actor.
      Return first 10 actors name length along with their name.    */


# use mavenmovies;
# select* from actor;


select*,
concat(first_name,"-",last_name) as  full_name, 
length(concat(first_name,last_name)) as len_char
from actor 
limit 10;

 
 

 
#    2.List all Oscar awardees(Actors who received Oscar award) with their full names and length of their names.

# select* from actor_award;


select*,
concat(first_name,"-",last_name) as  full_name, 
length(concat(first_name,last_name)) as len_char
from actor_award
where awards like '%oscar%' ;





#    3.Find the actors who have acted in the film ‘Frost Head’.

# select* from film_actor;
# select* from actor;
# select* from film;


select a.actor_id,a.film_id,b.first_name,b.last_name,c.title
from film_actor as a
inner join actor as b on a.actor_id=b.actor_id
inner join film as c on a.film_id=c.film_id
where title='frost head';


# select* from film_actor where film_id=341;


#    4. Pull all the films acted by the actor ‘Will Wilson’.

# select* from film_actor;
# select* from actor;
# select* from film;


select a.actor_id, a.film_id,b.first_name,b.last_name,c.title
from film_actor as a
inner join actor as b on a.actor_id=b.actor_id
inner join film as c on a.film_id=c.film_id
where first_name='will' and last_name='wilson';


# select* from film_actor where actor_id = 168;





#    5.Pull all the films which were rented and return in the month of May.

# select* from inventory;
# select* from rental;
# select* from film;


select a.inventory_id,a.film_id,b.rental_date,b.return_date,c.title
from inventory as a
inner join rental as b on a.inventory_id=b.inventory_id
inner join film as c on a.film_id=c.film_id
where monthname(rental_date) like '%may%' and monthname(return_date) like '%may%';



/* select* from (select*, extract(month from rental_date) as rental_month,
		extract(month from return_date) as return_month from rental) as new_table
		where rental_month=5 and return_month=5;   */



#    6.Pull all the films with ‘Comedy’ category.

# select* from film_category;
# select* from category;
# select* from film;


select a.category_id,a.film_id,b.name,c.title
from film_category as a
inner join category as b on a.category_id=b.category_id
inner join film as c on a.film_id=c.film_id
where name='comedy';


# select* from film_category where category_id=5; 





