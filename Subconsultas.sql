-- SUBCONSULTA
-- Consulta dentro de una consulta. Puede estar en un SELECT, WHERE, HAVING o FROM.
-- Son útiles cuando se deben hacer muchos filtros para llegar a la información.
-- Campos anidados
-- Con SELECT -> obtiene un valor de una columna para la consulta principal (columna)
-- Con WHERE -> filtra los resultados basados en el resultado de la subconsulta (único valor)
-- Con FROM -> utiliza los resultados de la subconsulta como una tabla temporal (tabla)
-- Con EXITS -> verifica la existencia de las filas que cumplen con ciertas condiciones
-- Con IN -> compara valores con un conjunto de resultados (listas)
-- Subconsulta escalar: devuelve un solo valor (una celda).
-- Subconsulta de filas: devuelve una fila de datos.
-- Subconsulta de tabla: devuelve un conjunto de filas y columnas

USE sakila;

-- Películas que duran la duración máxima
SELECT title AS titulo
FROM film 
WHERE LENGTH = (SELECT MAX(LENGTH) FROM film);

-- Nombre del actor con mayor número de películas
SELECT first_name AS nombre, last_name AS apellido, 
(SELECT COUNT(*) FROM film_actor WHERE actor_id = actor.actor_id) AS numero_peliculas
FROM actor
ORDER BY numero_peliculas DESC
LIMIT 1;

-- Clientes con al menos 25 alquileres
SELECT first_name AS nombre, last_name AS apellido
FROM customer
WHERE customer_id IN (SELECT customer_id
					  FROM rental 
                      GROUP BY customer_id
                      HAVING COUNT(customer_id) >= 25);
                      
SELECT c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS total_rentas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) >= 25;

-- Genere un análisis de datos para cada representante de ventas, donde se observe los ingresos en dinero y porcentaje de participación
SELECT s.first_name AS nombre, s.last_name AS apellido, SUM(p.amount) AS total_ingresos,
	ROUND((SUM(p.amount) / (SELECT SUM(amount) FROM payment)) * 100, 2) AS porcentaje_participacion
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY total_ingresos DESC;

-- Obtén los nombres de las películas que tienen una duración mayor al promedio de duración de todas las películas
SELECT title AS nombre, length AS duracion
FROM film 
WHERE length > (SELECT AVG(length) FROM film);

-- Lista los nombres y apellidos de los clientes que han realizado pagos superiores al promedio de todos los pagos realizados
SELECT DISTINCT CONCAT(c.first_name, ' ', c.last_name) AS clientes
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount > (SELECT AVG(amount) FROM payment);

-- Muestra el nombre y apellido del cliente que ha pagado el monto más alto
SELECT CONCAT(c.first_name, ' ', c.last_name) AS cliente
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount = (SELECT MAX(amount) FROM payment)
LIMIT 1;

-- Encuentra la película con la duración más corta.
SELECT title AS titulo
FROM film 
WHERE length = (SELECT MIN(length) FROM film);