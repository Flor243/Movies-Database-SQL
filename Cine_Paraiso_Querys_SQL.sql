USE CineParaiso;

-- Consultas

-- 4. Escriba consultas SQL que aporten la información para responder las siguientes preguntas.
-- Tenga en cuenta que puede ser  ́util agregar nuevas filas a las tablas, a modo de facilitar el
-- testeo de las consultas.

-- a. ¿Cuántas funciones hay en la sucursal La Plata (no importa si la función ya ocurrió o no)?
SELECT ciudad, COUNT(funcion_id) AS CANT_FUNCIONES 
FROM Sucursales
INNER JOIN Funciones
ON Sucursales.sucursal_id = Funciones.sucursal_id
WHERE ciudad like 'La Plata'
GROUP BY ciudad;

-- b. ¿Cuáles son las películas en cartelera en una fecha determinada (fije la fecha que prefiera)
-- en la sucursal Córdoba?
SELECT  DISTINCT dbo.Peliculas.titulo, Funciones.dia
FROM Peliculas
INNER JOIN Funciones
ON Funciones.pelicula_id = Peliculas.pelicula_id
INNER JOIN Sucursales
ON Sucursales.sucursal_id = Funciones.sucursal_id
WHERE dia = '2022-10-24' and ciudad = 'Córdoba';


-- c. ¿Cuáles son los horarios disponibles para ver la película Argentina, 1985 en una fecha
-- determinada (fije la fecha) en la sucursal Rosario?
SELECT horario, titulo, ciudad
FROM Funciones
INNER JOIN Peliculas
ON Funciones.pelicula_id = Peliculas.pelicula_id
INNER JOIN Sucursales
ON Sucursales.sucursal_id = Funciones.sucursal_id
WHERE dia = '2022-10-26' and titulo like 'Argentina, 1985' and ciudad like 'Rosario';


-- d. ¿Cuáles son los horarios disponibles para ver la película Argentina, 1985 en una fecha
-- determinada (fije la fecha) para cada sucursal? Muestre estos resultados ordenados cro-
-- nológicamente de forma creciente.
SELECT horario, titulo, ciudad
FROM Funciones
INNER JOIN Peliculas
ON Funciones.pelicula_id = Peliculas.pelicula_id
INNER JOIN Sucursales
ON Sucursales.sucursal_id = Funciones.sucursal_id
WHERE dia = '2022-10-28' and titulo like 'Argentina, 1985' and ciudad in ('Rosario', 'Córdoba', 'La Plata')
ORDER BY horario;


-- e. ¿Cuáles películas de ciencia ficción hay en cartelera la semana del 24 de octubre de 2022
-- en la sucursal Rosario?
SELECT DISTINCT titulo, genero, ciudad
FROM Peliculas
INNER JOIN Funciones
ON Funciones.pelicula_id = Peliculas.pelicula_id
INNER JOIN Sucursales
ON Sucursales.sucursal_id = Funciones.sucursal_id
WHERE dia BETWEEN '2022-10-24' and '2022-10-31' and genero like '%Ciencia Ficción%' and ciudad like 'Rosario';


-- f. ¿Cuáles son las butacas vendidas para ver Argentina, 1985 en Córdoba en una función
-- determinada (fije la función)?
SELECT titulo, funcion_id
FROM Peliculas
INNER JOIN Funciones
ON Funciones.pelicula_id = Peliculas.pelicula_id
WHERE titulo like 'Argentina, 1985';

SELECT Butacas.detalle, Butacas.butaca_id, titulo, ciudad, Funciones.funcion_id
FROM Butacas
INNER JOIN Funciones_Butacas
ON Butacas.butaca_id = Funciones_Butacas.butaca_id
INNER JOIN Funciones
ON Funciones.funcion_id = Funciones_Butacas.funcion_id
INNER JOIN Peliculas
ON Funciones.pelicula_id = Peliculas.pelicula_id
INNER JOIN Sucursales
ON Sucursales.sucursal_id = Funciones.sucursal_id
WHERE Funciones_Butacas.disponible = 0 and titulo like 'Argentina, 1985' and ciudad like 'Córdoba' and Funciones.funcion_id = 1;


-- g. ¿Cuáles son las butacas libres para ver Argentina, 1985 en Córdoba en una función de-
-- terminada (fije la función)?
SELECT Butacas.detalle AS butacas_libres, Butacas.butaca_id, titulo, ciudad, Funciones.funcion_id
FROM Butacas
INNER JOIN Funciones_Butacas
ON Butacas.butaca_id = Funciones_Butacas.butaca_id
INNER JOIN Funciones
ON Funciones.funcion_id = Funciones_Butacas.funcion_id
INNER JOIN Peliculas
ON Funciones.pelicula_id = Peliculas.pelicula_id
INNER JOIN Sucursales
ON Sucursales.sucursal_id = Funciones.sucursal_id
WHERE Funciones_Butacas.disponible = 1 and titulo like 'Argentina, 1985' and ciudad like 'Córdoba' and Funciones.funcion_id = 1;


-- h. ¿Cuántas peliculas por género están o estuvieron en cartelera en el Cine Paraíso?
SELECT genero, COUNT(pelicula_id) AS cantidad_peliculas FROM Peliculas
GROUP BY genero;


-- 5. Suponga que, una vez creada la base de datos, se pide hacer una pequeña modificación para
-- poder guardar información respecto al precio de las entradas. Determine qué alteraciones sería
-- conveniente realizar en las tablas en los siguientes casos, justificando la respuesta:

-- a. El precio de la entrada depende únicamente de la sucursal.
-- b. El precio de la entrada depende únicamente de la película.
-- c. El preico de la entrada depende únicamente de la ubicación de la butaca.

-- a. Se añadiría una columna a la tabla Sucursales de la base de datos, llamada 'precio_entrada' que sea decimal(7,2) y el valor correspondería
-- a la entrada de la sucursal a la que corresponda la fila donde se actualice.

-- En instrucciones sql las modificaciones se harían como sigue:
ALTER TABLE Sucursales
ADD precio_entrada DECIMAL(7,2);

-- Luego, hacemos un SELECT en Sucursales para conocer cómo se ha modificado
SELECT * FROM Sucursales;

-- Finalmente, insertamos los valores de las entradas por sucursal, actualizando las filas ya existentes:
UPDATE Sucursales
SET precio_entrada = 900
WHERE ciudad = 'Rosario';

UPDATE Sucursales
SET precio_entrada = 1200
WHERE ciudad = 'La Plata';

UPDATE Sucursales
SET precio_entrada = 1000
WHERE ciudad = 'Córdoba';


-- b. Se añadiría una columna a la tabla Peliculas de la base de datos, llamada 'precio_entrada' que sea decimal(7,2) y el valor correspondería
-- a la entrada de la película a la que hace referencia la fila donde se actualice.

-- En instrucciones sql las modificaciones se harían como sigue:
ALTER TABLE Peliculas
ADD precio_entrada DECIMAL(7,2);

-- Luego, hacemos un SELECT en Peliculas para conocer cómo se ha modificado
SELECT * FROM Peliculas;

-- Finalmente, insertamos los valores de las entradas a cada película:
UPDATE Peliculas
SET precio_entrada = 900
WHERE titulo = 'Argentina, 1985';

UPDATE Peliculas
SET precio_entrada = 1000
WHERE titulo in ('Black Adam');

-- Este UPDATE se realizaría hasta tener actualizados todos los precios de las entradas para las películas disponibles;


-- c. Se añadiría una columna a la tabla Butacas de la base de datos, llamada 'precio_entrada' que sea decimal(7,2) y el valor correspondería
-- al precio de la butaca a la que corresponda la fila donde se actualice.

-- En instrucciones sql las modificaciones se harían como sigue:
ALTER TABLE Butacas
ADD precio_entrada DECIMAL(7,2);

-- Luego, hacemos un SELECT en Butacas para conocer cómo se ha modificado
SELECT * FROM Butacas;

-- Finalmente, insertamos los valores de las entradas por butaca, actualizando las filas ya existentes:
UPDATE Butacas
SET precio_entrada = 900
WHERE detalle = 'A1';

UPDATE Butacas
SET precio_entrada = 1200
WHERE detalle like 'B%';

-- Este UPDATE se realizaría hasta tener actualizados todos los precios de las entradas para las butacas disponibles


-- 6. Suponga ahora que el Cine Paraíso finalmente decide fijar el precio de las entradas única-
-- mente en función de la película. Realice las modificaciones necesarias para que el modelo se
-- corresponda a este nuevo requerimiento, y escriba consultas SQL que cumplan los siguientes
-- requisitos:

SELECT * FROM Peliculas;

ALTER TABLE Peliculas
ADD precio_entrada DECIMAL(7,2);


-- Fijamos los precios de entradas según el título de la película:

UPDATE Peliculas
SET precio_entrada = 910
WHERE titulo = 'Black Adam';

UPDATE Peliculas
SET precio_entrada = 920
WHERE titulo = 'El fotógrafo de minamata';

UPDATE Peliculas
SET precio_entrada = 930
WHERE titulo = 'Hallowen, la noche final';

UPDATE Peliculas
SET precio_entrada = 940
WHERE titulo = 'Princesa por accidente';

UPDATE Peliculas
SET precio_entrada = 950
WHERE titulo = 'Argentina, 1985';

UPDATE Peliculas
SET precio_entrada = 960
WHERE titulo = 'Tadeo el explorador: la leyenda de la momia';

UPDATE Peliculas
SET precio_entrada = 970
WHERE titulo = 'Amsterdam';

UPDATE Peliculas
SET precio_entrada = 980
WHERE titulo = 'Pasaje al paraíso';

UPDATE Peliculas
SET precio_entrada = 990
WHERE titulo = 'Pantera Negra: Wakanda por siempre';

UPDATE Peliculas
SET precio_entrada = 1000
WHERE titulo = 'Spiderhead';

SELECT * FROM Peliculas;


-- a. Determine el total recaudado por función.
SELECT Funciones_Butacas.funcion_id AS funcion_id, SUM(Peliculas.precio_entrada) AS total_recaudado
FROM Funciones
INNER JOIN Funciones_Butacas
ON Funciones.funcion_id = Funciones_Butacas.funcion_id
INNER JOIN Peliculas
ON Funciones.pelicula_id = Peliculas.pelicula_id
WHERE Funciones_Butacas.disponible = 0
GROUP BY Funciones_Butacas.funcion_id
ORDER BY total_recaudado DESC;


-- b. Determine el promedio recaudado por función para cada pel ́ıcula. Es decir, si la película
-- Argentina, 1985 tuvo dos funciones, y en una recaudó 1000 pesos, y en la otra recaudó
-- 3000 pesos, el promedio recaudado por función para esta película es 2000 pesos.

SELECT total_recaudado_por_funcion.titulo, AVG(total_recaudado) as promedio_recaudado
FROM (SELECT Peliculas.titulo, Funciones.funcion_id AS funcion_id, SUM(Peliculas.precio_entrada) AS total_recaudado
FROM Funciones
INNER JOIN Funciones_Butacas
ON Funciones.funcion_id = Funciones_Butacas.funcion_id
INNER JOIN Peliculas
ON Funciones.pelicula_id = Peliculas.pelicula_id
WHERE Funciones_Butacas.disponible = 0
GROUP BY Peliculas.titulo, Funciones.funcion_id) as total_recaudado_por_funcion
GROUP BY titulo;


-- c. Determine el porcentaje de entradas vendidas por función, y muestre película, sucursal,
-- hora y día, solo para aquellas en las que se vendió menos del 50 %.

SELECT Peliculas.titulo AS Pelicula ,Funciones.dia, Funciones.horario, Sucursales.ciudad AS sucursal
FROM Funciones
INNER JOIN (SELECT ocupadas.id, ROUND(CAST(ocupadas.total AS float)/ CAST(totales.total AS float), 2)  AS promedio_de_ocupacion
FROM
(
 SELECT Funciones.funcion_id AS id, COUNT (*) AS total
 FROM Funciones
 INNER JOIN Funciones_Butacas
 ON Funciones_Butacas.funcion_id = Funciones.funcion_id AND Funciones_Butacas.disponible = 0
 GROUP BY Funciones.funcion_id
) ocupadas
JOIN
(
 SELECT Funciones.funcion_id AS id, COUNT (*) AS total
 FROM Funciones
 INNER JOIN Funciones_Butacas
 ON Funciones_Butacas.funcion_id = Funciones.funcion_id
 GROUP BY Funciones.funcion_id
) totales
ON ocupadas.id = totales.id
WHERE ROUND(CAST(ocupadas.total AS float)/ CAST(totales.total AS float), 2) < 0.50) AS porcentaje
ON porcentaje.id = Funciones.funcion_id
INNER JOIN Peliculas
ON Peliculas.pelicula_id = Funciones.pelicula_id
INNER JOIN Sucursales
ON Sucursales.sucursal_id = Funciones.sucursal_id
ORDER BY sucursal;

-- d. Determine, para cada película, cuál fue la función que más recaudó.

SELECT pelicula_max.pelicula_id, pelicula_funcion_max.funcion_id AS funcion_id_que_mas_recaudo
FROM
(	SELECT Funciones.pelicula_id, MAX(total_ocupacion.ocupacion) AS max_ocupacion
	FROM Funciones
	INNER JOIN(
		SELECT funcion_id, COUNT(funcion_id) AS ocupacion
		FROM Funciones_Butacas
		WHERE disponible = 1
		GROUP BY funcion_id
	) total_ocupacion
	ON Funciones.funcion_id = total_ocupacion.funcion_id
	GROUP BY Funciones.pelicula_id
)pelicula_max
JOIN
(	SELECT Funciones.pelicula_id, Funciones.funcion_id, MAX(total_ocupacion.ocupacion) AS max_ocupacion
	FROM Funciones
	INNER JOIN(
		SELECT funcion_id, COUNT(funcion_id) AS ocupacion
		FROM Funciones_Butacas
		WHERE disponible = 1
		GROUP BY funcion_id
	) total_ocupacion
	ON Funciones.funcion_id = total_ocupacion.funcion_id
	GROUP BY Funciones.pelicula_id, Funciones.funcion_id
) pelicula_funcion_max
ON pelicula_max.max_ocupacion = pelicula_funcion_max.max_ocupacion AND pelicula_max.pelicula_id = pelicula_funcion_max.pelicula_id;