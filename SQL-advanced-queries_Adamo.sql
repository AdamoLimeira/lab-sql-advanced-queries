use sakila;

#1. List each pair of actors that have worked together.
select fa1.actor_id as actor_id_1, a1.first_name as actor_1_first_name, a1.last_name as actor_1_last_name,
 fa2.actor_id as actor_id_2, a2.first_name as actor_2_first_name, a2.last_name as actor_2_last_name, f.title as film_title
	from film_actor fa1
		join film_actor fa2 on fa1.film_id = fa2.film_id and fa1.actor_id < fa2.actor_id
		join actor a1 on fa1.actor_id = a1.actor_id
		join actor a2 on fa2.actor_id = a2.actor_id
		join film f on fa1.film_id = f.film_id
			order by fa1.actor_id, fa2.actor_id;


#2. For each film, list actor that has acted in more films.
with ActorFilmCounts as (select fa.actor_id, COUNT(*) as total_films
    from film_actor fa group by fa.actor_id),
		FilmActorRanks as (select f.film_id, f.title as film_title,
        a.actor_id, a.first_name, a.last_name, afc.total_films,
        rank() over(partition by f.film_id order by afc.total_films desc)
        as ranking
    from film f
			join film_actor fa on f.film_id = fa.film_id
			join actor a on fa.actor_id = a.actor_id
            join ActorFilmCounts afc on a.actor_id = afc.actor_id)

select film_id, film_title, actor_id, first_name, last_name, total_films
	from FilmActorRanks
		where ranking = 1;