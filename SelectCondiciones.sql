USE tienda;

SELECT * 
FROM producto
WHERE precio BETWEEN 500000 AND 800000;

SELECT *
FROM producto
WHERE precio > 200000 OR stock > 15;

SELECT *
FROM producto
WHERE precio > 10
ORDER BY precio DESC;