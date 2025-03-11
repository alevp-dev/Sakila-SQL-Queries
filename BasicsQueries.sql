USE sakila;

-- ¿Cuántas películas hay en la base de datos?
SELECT COUNT(*) 
AS cantidad_peliculas
FROM film;

-- ¿Cuántos empleados hay en la tienda?
SELECT COUNT(*) 
AS cantidad_empleados 
FROM staff;

-- ¿Cuántos registros de rentas tenemos?
SELECT COUNT(*) 
AS cantidad_rentas 
FROM rental;

-- ¿Tenemos películas en cuántos idiomas?
SELECT COUNT(DISTINCT language_id) 
AS cantidad_idiomas
FROM film;

-- Trae la lista de nombres y apellidos de los actores.
SELECT actor.first_name, actor.last_name
FROM actor;

-- Trae en una sola columna el nombre completo de todos los actores (nombre y apellido).
SELECT CONCAT(actor.first_name,' ', actor.last_name)
AS nombre_completo
FROM actor;

-- ¿Cuál es la película con mayor duración que tenemos y cuál es la de menor duración?
SELECT title, length
FROM film
ORDER BY length DESC 
LIMIT 1;

SELECT title, length
FROM film
ORDER BY length ASC 
LIMIT 1;

-- ¿Cuál es la película más vieja que tenemos y cuál es la más nueva?
SELECT title, release_year
FROM film
ORDER BY length DESC 
LIMIT 1;

SELECT title, release_year
FROM film
ORDER BY length ASC 
LIMIT 1;

-- ¿Cuáles y cuántas categorías de películas tenemos?
SELECT COUNT(DISTINCT category_id)
AS cantidad_categorias
FROM film_category;

SELECT DISTINCT name 
AS categorias
FROM category;

-- ¿Cuántos clientes hay registrados en la base de datos?
SELECT COUNT(*)
AS total_clientes
FROM customer;
