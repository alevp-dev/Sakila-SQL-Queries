-- CTE -> Common Table Expressions
-- Son expreciones de tablas temporales que permite estructurar consultas de una forma más clara y legible.
-- Se definen con la cláusula WITH y actuan como una vista temporal dentro de la consulta.
-- Mejora la legibilidad de consultas anidadas.
-- Evita subconsultas repetitivas.
-- Recursividad.

USE sakila;
-- JOINs
-- Lista todas las películas junto con su categoría, uniendo las tablas correspondientes.
SELECT f.title AS peliculas, c.name AS categoria
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

-- Muestra los nombres de los clientes junto con su dirección completa, incluyendo ciudad y país.
SELECT c.first_name AS nombre, a.address AS direccion, ci.city AS ciudad, co.country AS pais
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- Muestra los pagos realizados por los clientes junto con el título de la película correspondiente al alquiler.
SELECT p.amount AS pago, c.first_name AS nombre, f.title AS pelicula
FROM payment p
JOIN rental r ON  p.rental_id = r.rental_id
JOIN inventory i ON  r.inventory_id = i.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN film f ON i.film_id = f.film_id;

-- SUBCONSULTAS
-- Encuentra las películas cuyo tiempo de duración sea mayor que la duración promedio de todas las películas.
SELECT title AS peliculas, length AS duracion
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- Lista los clientes que hayan alquilado más películas que el promedio de películas alquiladas por cliente.
SELECT CONCAT(c.first_name,' ', c.last_name) AS cliente, COUNT(r.rental_id) AS total_rentas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, cliente
HAVING COUNT(r.rental_id) > (
    SELECT AVG(rentas_por_cliente)
    FROM (
        SELECT customer_id, COUNT(rental_id) AS rentas_por_cliente
        FROM rental
        GROUP BY customer_id
    ) AS promedio
)
ORDER BY total_rentas DESC;

-- Muestra las películas que nunca han sido alquiladas. (NOT IN)
SELECT f.title AS peliculas
FROM film f
WHERE f.film_id NOT IN (SELECT DISTINCT i.film_id 
				   FROM rental r
                   JOIN inventory i ON r.inventory_id = i.inventory_id);
                   
-- CTEs
-- muestra los clientes que han realizado más de 30 alquileres.
WITH rentas_por_cliente AS (
    SELECT customer_id, COUNT(*) AS total_rentas
    FROM rental
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name, r.total_rentas
FROM customer c
JOIN rentas_por_cliente r ON c.customer_id = r.customer_id
WHERE r.total_rentas > 30;

-- calcula el ingreso total generado por cada tienda.
WITH ingresos_por_empleado AS (
    SELECT s.store_id, SUM(p.amount) AS total_ingresos
    FROM payment p
    JOIN staff s ON p.staff_id = s.staff_id
    GROUP BY s.store_id
)
SELECT store_id, total_ingresos
FROM ingresos_por_empleado;

-- lista los actores junto con el número de películas en las que han participado.
WITH peliculas_por_actor AS (
    SELECT actor_id, COUNT(*) AS total_peliculas
    FROM film_actor
    GROUP BY actor_id
)
SELECT a.actor_id, a.first_name, a.last_name, p.total_peliculas
FROM actor a
JOIN peliculas_por_actor p ON a.actor_id = p.actor_id;

-- Encuentra los 5 clientes que han gastado más dinero en total, mostrando su nombre, apellido y total gastado.
WITH gasto_por_cliente AS (
    SELECT customer_id, SUM(amount) AS total_gastado
    FROM payment
    GROUP BY customer_id
) 
SELECT c.customer_id, c.first_name AS nombre, c.last_name as apellido, g.total_gastado
FROM customer c
JOIN gasto_por_cliente g ON c.customer_id = g.customer_id
ORDER BY g.total_gastado DESC
LIMIT 5;

-- Muestra los 10 actores cuyos filmes han sido rentados más veces, ordenados por número de alquileres.
WITH rentas_por_actor AS (
    SELECT fa.actor_id, COUNT(*) AS total_rentas
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_actor fa ON f.film_id = fa.film_id
    GROUP BY fa.actor_id
)
SELECT a.actor_id, a.first_name, a.last_name, r.total_rentas
FROM actor a
JOIN rentas_por_actor r ON a.actor_id = r.actor_id
ORDER BY r.total_rentas DESC
LIMIT 10;

-- Calcula cuál de las dos tiendas (store_id) ha generado más ingresos totales en pagos.
WITH ingresos_por_tienda AS (
    SELECT s.store_id, SUM(p.amount) AS total_ingresos
    FROM payment p
    JOIN staff s ON p.staff_id = s.staff_id
    GROUP BY s.store_id
)
SELECT store_id, total_ingresos
FROM ingresos_por_tienda
ORDER BY total_ingresos DESC
LIMIT 1;

-- Usa una CTE para obtener una lista de clientes con la cantidad de alquileres realizados. Luego, filtra solo aquellos que no han rentado nada en los últimos 3 meses.
WITH rentas_recientes AS (
    SELECT customer_id, MAX(rental_date) AS ultima_renta
    FROM rental
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name, r.ultima_renta
FROM customer c
JOIN rentas_recientes r ON c.customer_id = r.customer_id
WHERE r.ultima_renta < NOW() - INTERVAL 3 MONTH;

-- Lista las 5 películas que han generado más ingresos en pagos, mostrando su nombre y el total de dinero recaudado.
WITH ingresos_por_pelicula AS (
    SELECT i.film_id, SUM(p.amount) AS total_ingresos
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    GROUP BY i.film_id
)
SELECT f.title, i.total_ingresos
FROM film f
JOIN ingresos_por_pelicula i ON f.film_id = i.film_id
ORDER BY i.total_ingresos DESC
LIMIT 5;

-- Determina qué empleados (staff_id) han procesado más alquileres, mostrando su nombre, apellido y cantidad de alquileres gestionados.
WITH rentas_por_empleado AS (
    SELECT staff_id, COUNT(*) AS total_rentas
    FROM rental
    GROUP BY staff_id
)
SELECT s.staff_id, s.first_name, s.last_name, r.total_rentas
FROM staff s
JOIN rentas_por_empleado r ON s.staff_id = r.staff_id
ORDER BY r.total_rentas DESC;

-- Muestra los tres clientes que han alquilado más películas en cada ciudad, junto con la cantidad de alquileres.
WITH rentas_por_cliente AS (
    SELECT cu.customer_id, ci.city, COUNT(*) AS total_rentas,
           RANK() OVER (PARTITION BY ci.city ORDER BY COUNT(*) DESC) AS ranking
    FROM rental r
    JOIN customer cu ON r.customer_id = cu.customer_id
    JOIN address a ON cu.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    GROUP BY cu.customer_id, ci.city
)
SELECT customer_id, city, total_rentas
FROM rentas_por_cliente
WHERE ranking <= 3;

-- Agrupa los pagos por año y mes, calculando la cantidad total de pagos y el monto total recaudado.
WITH pagos_mensuales AS (
    SELECT YEAR(payment_date) AS año, MONTH(payment_date) AS mes,
           COUNT(*) AS total_pagos, SUM(amount) AS total_ingresos
    FROM payment
    GROUP BY YEAR(payment_date), MONTH(payment_date)
)
SELECT * FROM pagos_mensuales;

-- Encuentra las películas que tienen más de 10 actores asociados y muestra su nombre y cantidad de actores.
WITH actores_por_pelicula AS (
    SELECT film_id, COUNT(*) AS total_actores
    FROM film_actor
    GROUP BY film_id
)
SELECT f.title, a.total_actores
FROM film f
JOIN actores_por_pelicula a ON f.film_id = a.film_id
WHERE a.total_actores > 10;
