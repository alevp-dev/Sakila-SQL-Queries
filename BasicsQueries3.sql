USE sakila;

-- Encuentra las películas que fueron lanzadas hace exactamente 18 años desde la fecha actual.
SELECT title, release_year 
FROM film
WHERE release_year = YEAR(CURDATE()) - 18;

-- Calcula cuántos días han pasado desde el alquiler más reciente en la base de datos.
-- DATEDIFF es una función que calcula el número de intervalos entre dos fechas
SELECT DATEDIFF(CURDATE(), MAX(rental_date)) 
AS cantidad_dias
FROM rental;

-- Extrae el año en que se realizó la primera renta registrada en la base de datos.
SELECT YEAR(MIN(rental_date))
AS anio_primera_renta
FROM rental;

SELECT rental_date, COUNT(*) AS cantidad
FROM rental
GROUP BY rental_date
ORDER BY cantidad DESC
LIMIT 1;

-- Muestra el día de la semana en que se realizó la mayor cantidad de rentas.
-- DAYNAME devuelve el nombre del día de la semana para una fecha
SELECT rental_date, DAYNAME(rental_date) AS dia_semana, COUNT(*) AS cantidad
FROM rental
GROUP BY rental_date
ORDER BY cantidad DESC
LIMIT 1;

-- Muestra todas las películas alquiladas entre el 1 de enero de 2005 y el 31 de diciembre de 2005
SELECT film.film_id, film.title, rental.rental_date
FROM rental 
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.rental_date BETWEEN '2005-01-01' AND '2005-12-31'
ORDER BY rental.rental_date;

-- Trae una lista de los clientes cuyo nombre comience con la letra 'J'.
SELECT first_name
FROM customer
WHERE first_name LIKE 'J%';

-- Muestra el nombre y apellido de los empleados, concatenados en una sola columna y en mayúsculas.
SELECT UPPER(CONCAT(first_name, ' ', last_name))
AS nombre_completo_staff
FROM staff;

-- Reemplaza todas las ocurrencias de la palabra "ACTION" por "AVENTURA" en los nombres de las categorías de películas.
UPDATE category
SET name = 'Aventura'
WHERE name LIKE '%Action%';

-- Encuentra los actores cuyo nombre tenga exactamente 5 letras.
SELECT first_name
FROM actor
WHERE LENGTH(first_name) = 5;

-- Muestra los primeros tres caracteres del título de cada película.
SELECT title, LEFT(title, 3) AS primeros_tres_caracteres
FROM film;

-- Calcula el número total de películas alquiladas por cada cliente.
-- LEFT devuelve la parte izquierda de una cadena de caracteres con el número de caracteres especificado
SELECT LEFT(title, 3) 
AS primeros_caracteres
FROM film;

-- Encuentra el monto total recaudado por rentas en cada tienda.
SELECT customer_id, COUNT(rental_id) 
AS total_rentas
FROM rental
GROUP BY customer_id
ORDER BY total_rentas DESC;

SELECT staff.store_id, SUM(payment.amount) 
AS total
FROM payment
JOIN staff ON payment.staff_id = staff.staff_id
GROUP BY staff.store_id;

-- Muestra el promedio de la duración de las películas por cada categoría.
SELECT category.name, AVG(film.length) AS duracion_promedio
FROM film 
JOIN film_category fc ON film.film_id = fc.film_id
JOIN category ON fc.category_id = category.category_id
GROUP BY category.name
ORDER BY duracion_promedio DESC;

-- Calcula el ingreso total generado por cada película en la base de datos.
SELECT film.title, SUM(payment.amount) AS ingreso_total
FROM payment 
JOIN rental  ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film  ON inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY ingreso_total DESC;

-- Encuentra la categoría con la mayor cantidad de películas y muestra cuántas películas pertenecen a esa categoría.
SELECT category.name AS categoria, COUNT(fc.film_id) AS total_peliculas
FROM film_category fc
JOIN category ON fc.category_id = category.category_id
GROUP BY category.name
ORDER BY total_peliculas DESC
LIMIT 1;



