-- Taller JOINS
-- INNER JOIN: une dos tablas y devuelve solo las filas donde haya coincidencias en ambas.
-- LEFT JOIN: devuelve todas las filas de la tabla izquierda y las coincidencias de la tabla derecha, si no hay coincidencia NULL
-- RIGHT JOIN: devuelve todas las filas de la tabla derecha
-- ON: especifica la condición de unión entre las tablas
-- GROUP BY: agrupa filas que tienen valores en común en columnas especificas
-- ORDER BY: ordena los resultados según una columna
-- WHERE: filtra los resultados según una condición

USE sakila;

-- Utilice JOIN para mostrar el monto total facturado por cada miembro del personal en agosto de 2005
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_facturado 
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id -- relación tabla staff y payment con staff_id
WHERE DATE_FORMAT(p.payment_date, '%Y-%m') = '2005-08' -- pagos filtrados por fecha
GROUP BY s.staff_id, s.first_name, s.last_name; -- agrupa resultados por empleado

-- Enumere cada película y el número de actores que están listados para esa película
SELECT f.title, COUNT(fa.actor_id) AS numero_actores
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id -- relación film con film_actor con film_id
GROUP BY f.title -- agrupa por título
ORDER BY numero_actores DESC; -- ver películas con más actores

-- ¿Cuántas copias de la película "Hunchback Impossible" existen en el sistema de inventario?
SELECT f.title, COUNT(i.inventory_id) AS numero_copias
FROM film f
JOIN inventory i ON f.film_id = i.film_id -- relación film y inventory con film_id
WHERE f.title = 'Hunchback Impossible' -- filtro nombre de la película
GROUP BY f.title;

-- Liste el total pagado por cada cliente. Enumere los clientes en orden alfabético por apellido
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_pagado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id -- relación customer y payment con customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.last_name; -- ordena alfabeticamente

-- Obtener nombres y correos electrónicos de todos los clientes canadienses
SELECT c.first_name, c.last_name, c.email, ci.country_id
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id -- multiples joins para conectar customer, address, city y country
WHERE co.country = 'Canada'; -- filtra Canadá

--  Identifique todas las películas categorizadas como películas familiares
SELECT f.title, c.name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id -- relación film_category y film con film_id
JOIN category c ON fc.category_id = c.category_id -- relación category y film_category co category_id
WHERE c.name = 'Family'; -- filtra la categoría family

-- Mostrar para cada tienda su ID de tienda, ciudad y país
SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- Mostrar los ingresos de cada tienda
SELECT s.store_id, SUM(p.amount) AS total_ingresos
FROM store s
JOIN staff st ON s.store_id = st.store_id -- relación staff con store
JOIN payment p ON st.staff_id = p.staff_id -- relación payment con staff
GROUP BY s.store_id;

-- Enumere los cinco géneros principales en ingresos brutos en orden descendente
SELECT c.name AS categoria, SUM(p.amount) AS ingresos
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id -- relación category con payment a través de film_category, inventory y rental
GROUP BY c.name
ORDER BY ingresos DESC
LIMIT 5;

-- ¿Cuántas películas se alquilaron por categoría?
SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquiladas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_alquiladas DESC;

-- Encuentra la película más rentable y muestra su título junto con el total recaudado en alquileres
SELECT f.title AS pelicula, SUM(p.amount) AS total_recaudado
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY total_recaudado DESC
LIMIT 1;

-- Encuentra el cliente con el mayor gasto en alquileres y muestra su nombre, apellido y el total gastado.
 SELECT c.first_name, c.last_name, SUM(p.amount) AS total_gastado
 FROM customer c
 JOIN payment p ON c.customer_id = p.customer_id
 GROUP BY c.customer_id, c.first_name, c.last_name
 ORDER BY total_gastado DESC
 LIMIT 1;
