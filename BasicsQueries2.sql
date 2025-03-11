USE sakila;

-- ¿Cuántas películas tienen una calificación de clasificación 'PG'?
SELECT COUNT(*)
AS clasificacion_pg
FROM film
WHERE rating = 'PG';

-- ¿Cuántos alquileres se realizaron en cada día de la semana?
-- DAYNAME devuelve el nombre del día de la semana en una fecha determinada
SELECT DAYNAME(rental_date) 
AS dia_semana, COUNT(*) AS total_rentas
FROM rental
GROUP BY dia_semana;

-- ¿Cuál es la película con el título más largo?
-- LENGTH devuelve el número de carácteres de una cadena o variable
SELECT title, LENGTH(title) 
AS longitud_titulo 
FROM film 
ORDER BY longitud_titulo DESC 
LIMIT 1;

-- Listar los apellidos de los actores y el número de actores que tienen ese apellido, pero solo para los apellidos que son compartidos por al menos dos actores.
SELECT last_name, COUNT(*) 
AS total_actores 
FROM actor 
GROUP BY last_name 
HAVING total_actores >= 2;

-- El actor HARPO WILLIAMS fue accidentalmente ingresado en la tabla de actores como GROUCHO WILLIAMS, el nombre del esposo del segundo primo de Harpo. Escribe una consulta para corregir el registro.
UPDATE actor 
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' 
AND last_name = 'WILLIAMS';
SELECT first_name, last_name FROM actor
WHERE first_name = 'HARPO';

-- ¿Qué actores tienen el nombre 'Scarlett'?
SELECT * FROM actor 
WHERE first_name = 'Scarlett';

-- ¿Qué actores tienen el apellido 'Johansson'?
SELECT * FROM actor 
WHERE last_name = 'Johansson';

-- ¿Cuántos apellidos distintos de actores hay?
SELECT COUNT(DISTINCT last_name) 
AS total_apellidos_uq
FROM actor;

-- ¿Qué apellidos no se repiten?
-- GROUP BY agrupa las filas de una tabla que tienen valores similares en una o más columnas
-- HAVING se usa después de GB para filtrar los grupos resultantes con una condición, es como un WHERE pero aplicado a grupos
-- agrupa los apellidos que solo aparecen una vez
SELECT last_name 
FROM actor 
GROUP BY last_name 
HAVING COUNT(*) = 1;

-- ¿Qué apellidos aparecen más de una vez?
-- Cuenta todos los apellidos, los agrupa por apellidos iguales y trae la cantidad de veces repetidos
SELECT last_name, COUNT(*) 
AS total_apelidos_rep
FROM actor 
GROUP BY last_name 
HAVING total_apelidos_rep > 1;

-- ¿Cuántas películas tienen una duración mayor a 120 minutos?
SELECT COUNT(*) 
AS total_peliculas 
FROM film 
WHERE length > 120;

-- ¿Cuántos clientes se registraron después del año 2020?
SELECT COUNT(*) 
AS total_clientes 
FROM customer 
WHERE YEAR(create_date) > 2020;

-- ¿Cuántos alquileres de películas se realizaron por mes y por año?
SELECT YEAR(rental_date) AS anio, MONTH(rental_date) AS mes, COUNT(*) AS total_rentas
FROM rental
GROUP BY anio, mes
ORDER BY anio, mes;

-- ¿Cuántas películas tienen una clasificación de "R" y una duración menor a 90 minutos?
SELECT COUNT(*) 
AS total_peliculas 
FROM film 
WHERE rating = 'R' AND length < 90;

-- ¿Cuántos actores tienen un nombre que comienza con la letra "A"?
SELECT COUNT(*) AS total_actores 
FROM actor 
WHERE first_name LIKE 'A%';
