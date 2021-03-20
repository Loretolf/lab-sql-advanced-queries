-- 3.06 Lab
use sakila;

select fa.actor_id, a.first_name, a.last_name, count(fa.film_id) as films_acted
from sakila.film_actor as fa
join sakila.actor as a
on fa.actor_id = a.actor_id
group by fa.actor_id, a.first_name
order by films_acted desc
limit 1;

select f.film_id, f.title, fa.actor_id
from sakila.film as f
join sakila.film_actor as fa
on f.film_id = fa.film_id
where fa.actor_id = 107
group by f.film_id, f.title, fa.actor_id;

select f.film_id, f.title, a.actor_id, concat(a.first_name, ' ', a.last_name) as actor_name
from sakila.film as f
join sakila.film_actor as fa
on f.film_id = fa.film_id
join sakila.actor as a
on a.actor_id = fa.actor_id
where a.actor_id = (  #select only actor_id in subquery. Use =  instead of in
    select actor_id from (
    select a.actor_id, count(fa.film_id) as films_acted
    from sakila.film_actor as fa
    join sakila.actor as a
    on fa.actor_id = a.actor_id
    group by fa.actor_id, a.first_name
    order by films_acted desc
    limit 1) sub1
    );

CREATE table tablea
SELECT actor_table.actor_id,first_name,last_name,film_id
FROM sakila.actor as actor_table
JOIN sakila.film_actor as film_actor_table on actor_table.actor_id = film_actor_table.actor_id;

SELECT tablea_1.actor_id, tablea_2.actor_id, tablea_1.film_id, tablea_1.first_name, tablea_2.first_name
FROM sakila.tablea as tablea_1
JOIN sakila.tablea as tablea_2 on tablea_1.film_id = tablea_2.film_id and tablea_1.actor_id < tablea_2.actor_id;

SELECT tablea_1.actor_id as act_1, tablea_2.actor_id as act_2, tablea_1.film_id, row_number() over (partition by tablea_1.actor_id, tablea_2.actor_id order by tablea_1.actor_id, tablea_2.actor_id) as ranking,
tablea_1.first_name as name1, tablea_2.first_name as name2
FROM sakila.tablea as tablea_1
JOIN sakila.tablea as tablea_2 on tablea_1.film_id = tablea_2.film_id and tablea_1.actor_id < tablea_2.actor_id;

SELECT act_1, act_2, name1, name2
FROM (SELECT tablea_1.actor_id as act_1, tablea_2.actor_id as act_2, tablea_1.film_id, 
	row_number() over (partition by tablea_1.actor_id, tablea_2.actor_id order by tablea_1.actor_id, tablea_2.actor_id) as ranking,
    tablea_1.first_name as name1, tablea_2.first_name as name2
FROM sakila.tablea as tablea_1
JOIN sakila.tablea as tablea_2 on tablea_1.film_id = tablea_2.film_id and tablea_1.actor_id < tablea_2.actor_id) as sub
WHERE ranking = 1;
