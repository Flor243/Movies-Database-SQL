-- Creación y selección de la base de datos
CREATE DATABASE CineParaiso;
GO
USE CineParaiso;
GO

-- Creación de las tablas y sus relaciones
CREATE TABLE CineParaiso.dbo.Sucursales(sucursal_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						ciudad VARCHAR(50) NOT NULL,
						direccion VARCHAR(100),
						telefono VARCHAR(25));


CREATE TABLE CineParaiso.dbo.Butacas(butaca_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						detalle VARCHAR(5) NOT NULL);


CREATE TABLE CineParaiso.dbo.Generos(genero_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						detalle VARCHAR(20) NOT NULL);


CREATE TABLE CineParaiso.dbo.Peliculas(pelicula_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						titulo VARCHAR(100) NOT NULL,
						duracion_minutos INT,
						apta_todo_publico BIT,
						subtitulada BIT,
						sinopsis VARCHAR(1000),
						genero_id INT CONSTRAINT FK_generoid FOREIGN KEY (genero_id) REFERENCES Generos(genero_id) ON DELETE SET NULL,
						cartelera BIT,
						streaming BIT);


CREATE TABLE CineParaiso.dbo.Sucursales_Peliculas(sucursal_pelicula_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						sucursal_id INT CONSTRAINT FK_sucursalid FOREIGN KEY (sucursal_id) REFERENCES Sucursales(sucursal_id) ON DELETE CASCADE,
						pelicula_id INT CONSTRAINT FK_peliculaid FOREIGN KEY (pelicula_id) REFERENCES Peliculas(pelicula_id) ON DELETE CASCADE);


CREATE TABLE CineParaiso.dbo.Salas(sala_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						metros_cuadrados DECIMAL,
						detalle varchar(10) NOT NULL,
						sucursal_id INT CONSTRAINT FK_sala_sucursalid FOREIGN KEY (sucursal_id) REFERENCES Sucursales(sucursal_id) ON DELETE CASCADE);


CREATE TABLE CineParaiso.dbo.Salas_Butacas(sala_butaca_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						sala_id INT CONSTRAINT FK_salaid FOREIGN KEY (sala_id) REFERENCES Salas(sala_id) ON DELETE CASCADE,
						butaca_id INT CONSTRAINT FK_butacaid FOREIGN KEY (butaca_id) REFERENCES Butacas(butaca_id));


CREATE TABLE CineParaiso.dbo.Funciones(funcion_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						dia DATE NOT NULL,
						horario TIME NOT NULL,
						pelicula_id INT CONSTRAINT FK_funcion_peliculaid FOREIGN KEY (pelicula_id) REFERENCES Peliculas(pelicula_id) ON DELETE CASCADE,
						sala_id INT CONSTRAINT FK_funcion_salaid FOREIGN KEY (sala_id) REFERENCES Salas(sala_id) ON DELETE CASCADE,
						sucursal_id INT CONSTRAINT FK_funcion_sucursalid FOREIGN KEY (sucursal_id) REFERENCES Sucursales(sucursal_id) ON DELETE NO ACTION);


CREATE TABLE CineParaiso.dbo.Funciones_Butacas(funcion_butaca_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						butaca_id INT CONSTRAINT FK_funcion_butacaid FOREIGN KEY (butaca_id) REFERENCES Butacas(butaca_id),
						funcion_id INT CONSTRAINT FK_butaca_funcionid FOREIGN KEY (funcion_id) REFERENCES Funciones(funcion_id) ON DELETE CASCADE,
						disponible BIT);


CREATE TABLE CineParaiso.dbo.Clientes(cliente_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						usuario varchar(20) NOT NULL,
						contrasenia varchar(10) NOT NULL);


CREATE TABLE CineParaiso.dbo.Planes(plan_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						nombre varchar(10) NOT NULL,
						descripcion varchar(100),
						precio_mensual DECIMAL(6,2) NOT NULL,
						precio_anual DECIMAL(7,2) NOT NULL);


CREATE TABLE CineParaiso.dbo.Peliculas_Planes(pelicula_plan_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						pelicula_id INT CONSTRAINT FK_plan_peliculaid FOREIGN KEY (pelicula_id) REFERENCES Peliculas(pelicula_id) ON DELETE CASCADE,
						plan_id INT CONSTRAINT FK_pelicula_planid FOREIGN KEY (plan_id) REFERENCES Planes(plan_id) ON DELETE CASCADE);


CREATE TABLE CineParaiso.dbo.Suscripciones(suscripcion_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						anual BIT NOT NULL,
						estado BIT NOT NULL,
						cliente_id INT CONSTRAINT FK_clienteid FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id) ON DELETE CASCADE,
						plan_id INT CONSTRAINT FK_planid FOREIGN KEY (plan_id) REFERENCES Planes(plan_id) ON DELETE CASCADE);


CREATE TABLE CineParaiso.dbo.Pagos(pago_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
						fecha DATE NOT NULL,
						cliente_id INT CONSTRAINT FK_pago_clienteid FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id) ON DELETE CASCADE,
						suscripcion_id INT CONSTRAINT FK_suscripcionid FOREIGN KEY (suscripcion_id) REFERENCES Suscripciones(suscripcion_id) ON DELETE NO ACTION);


-- 3. Escriba instrucciones SQL para la inserción de datos, de modo de tener información sobre:
--	a. Las 3 sucursales existentes actualmente.
--	b. Al menos 3 salas por sucursal.
--	c. Al menos 20 butacas por sala.
--	d. Al menos 5 pel ́ıculas (una de ellas es Argentina, 1985, y otra de ellas es de g ́enero ciencia
--	ficci ́on).
--	e. Al menos 5 funciones (algunas de ellas deben ocurrir entre el 24 y el 31 de octubre de
--	2022).

-- Inserción de datos

INSERT INTO Sucursales VALUES ('Rosario', 'Av. Francia 1523', '(0341)4856748'), ('Córdoba', 'Av. Alberdi 2023', '(0351)4856348'), ('La Plata', 'Av. Libertador 1223', '(0221)4856848');
-- Comprobación inserción de datos
SELECT * FROM Sucursales;

INSERT INTO Salas VALUES (127.5, 'C_A1', 2), (110, 'C_E2', 2), (210, 'C_B3', 2), (144, 'R_B1', 1), (144, 'R_C3', 1), (355, 'R_A2', 1), (144, 'LP_B2', 3), (180, 'LP_B4', 3), (540, 'LP_I2', 3);
-- Comprobación inserción de datos
SELECT * FROM Salas;

INSERT INTO Generos VALUES ('Acción'), ('Drama'), ('Terror'), ('Infantil'), ('Comedia'), ('Aventura'), ('Ciencia Ficción');
-- Comprobación inserción de datos
SELECT * FROM Generos;

INSERT INTO Butacas VALUES 	('A1'), ('A2'), ('A3'), ('A4'), ('A5'), 
							('B1'), ('B2'), ('B3'), ('B4'), ('B5'), 
							('C1'), ('C2'), ('C3'), ('C4'), ('C5'),
							('D1'), ('D2'), ('D3'), ('D4'), ('D5'),
							('E6'), ('E7'), ('E8'), ('E9'), ('E10'),
							('F6'), ('F7'), ('F8'), ('F9'), ('F10'),
							('G6'), ('G7'), ('G8'), ('G9'), ('G10'),
							('H6'), ('H7'), ('H8'), ('H9'), ('H10'),
							('I1'), ('I2'), ('I3'), ('I4'), ('I5'),
							('J6'), ('J7'), ('J8'), ('J9'), ('J10'),
							('K1'), ('K2'), ('K3'), ('K4'), ('K5'),
							('L6'), ('L7'), ('L8'), ('L9'), ('L10');
-- Comprobación inserción de datos
SELECT * FROM Butacas;

INSERT INTO Salas_Butacas VALUES (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,7), (1,8), (1,9), (1,10),
								(1,11), (1,12), (1,13), (1,14), (1,15), (1,16), (1,17), (1,18), (1,19), (1,20),
								(1,21), (1,22), (1,23), (1,24), (1,25), (1,26), (1,27), (1,28), (1,29), (1,30),
								(1,31), (1,32), (1,33), (1,34), (1,35), (1,36), (1,37), (1,38), (1,39), (1,40),
								
								(2, 1),(2, 2), (2, 3),(2, 4),(2, 5),(2, 6),(2, 7),(2, 8),(2, 9),(2, 10),
								(2, 11),(2, 12),(2, 13),(2, 14),(2, 15),(2, 16),(2, 17),(2, 18),(2, 19),(2, 20),
								(2, 21),(2, 22),(2, 23),(2, 24),(2, 25),(2, 26),(2, 27),(2, 28),(2, 29),(2, 30),
								(2, 31),(2, 32),(2, 33),(2, 34),(2, 35),(2, 36),(2, 37),(2, 38),(2, 39),(2, 40),
								
								(3, 1),(3, 2), (3, 3),(3, 4),(3, 5),(3, 6),(3, 7),(3, 8),(3, 9),(3, 10),
								(3, 11),(3, 12),(3, 13),(3, 14),(3, 15),(3, 16),(3, 17),(3, 18),(3, 19),(3, 20),
								(3, 21),(3, 22),(3, 23),(3, 24),(3, 25),(3, 26),(3, 27),(3, 28),(3, 29),(3, 30),
								(3, 31),(3, 32),(3, 33),(3, 34),(3, 35),(3, 36),(3, 37),(3, 38),(3, 39),(3, 40),
								(3, 41),(3, 42),(3, 43),(3, 44),(3, 45),(3, 46),(3, 47),(3, 48),(3, 49),(3, 50),
								
								(4, 1),(4, 2), (4, 3),(4, 4),(4, 5),(4, 6),(4, 7),(4, 8),(4, 9),(4, 10),
								(4, 11),(4, 12),(4, 13),(4, 14),(4, 15),(4, 16),(4, 17),(4, 18),(4, 19),(4, 20),
								(4, 21),(4, 22),(4, 23),(4, 24),(4, 25),(4, 26),(4, 27),(4, 28),(4, 29),(4, 30),
								(4, 31),(4, 32),(4, 33),(4, 34),(4, 35),(4, 36),(4, 37),(4, 38),(4, 39),(4, 40),
								
								(5, 1),(5, 2), (5, 3),(5, 4),(5, 5),(5, 6),(5, 7),(5, 8),(5, 9),(5, 10),
								(5, 11),(5, 12),(5, 13),(5, 14),(5, 15),(5, 16),(5, 17),(5, 18),(5, 19),(5, 20),
								(5, 21),(5, 22),(5, 23),(5, 24),(5, 25),(5, 26),(5, 27),(5, 28),(5, 29),(5, 30),
								(5, 31),(5, 32),(5, 33),(5, 34),(5, 35),(5, 36),(5, 37),(5, 38),(5, 39),(5, 40),
								
								(6, 1),(6, 2), (6, 3),(6, 4),(6, 5),(6, 6),(6, 7),(6, 8),(6, 9),(6, 10),
								(6, 11),(6, 12),(6, 13),(6, 14),(6, 15),(6, 16),(6, 17),(6, 18),(6, 19),(6, 20),
								(6, 21),(6, 22),(6, 23),(6, 24),(6, 25),(6, 26),(6, 27),(6, 28),(6, 29),(6, 30),
								(6, 31),(6, 32),(6, 33),(6, 34),(6, 35),(6, 36),(6, 37),(6, 38),(6, 39),(6, 40),
								(6, 41),(6, 42),(6, 43),(6, 44),(6, 45),(6, 46),(6, 47),(6, 48),(6, 49),(6, 50),
								
								(7, 1),(7, 2), (7, 3),(7, 4),(7, 5),(7, 6),(7, 7),(7, 8),(7, 9),(7, 10),
								(7, 11),(7, 12),(7, 13),(7, 14),(7, 15),(7, 16),(7, 17),(7, 18),(7, 19),(7, 20),
								(7, 21),(7, 22),(7, 23),(7, 24),(7, 25),(7, 26),(7, 27),(7, 28),(7, 29),(7, 30),
								(7, 31),(7, 32),(7, 33),(7, 34),(7, 35),(7, 36),(7, 37),(7, 38),(7, 39),(7, 40),
								
								(8, 1),(8, 2), (8, 3),(8, 4),(8, 5),(8, 6),(8, 7),(8, 8),(8, 9),(8, 10),
								(8, 11),(8, 12),(8, 13),(8, 14),(8, 15),(8, 16),(8, 17),(8, 18),(8, 19),(8, 20),
								(8, 21),(8, 22),(8, 23),(8, 24),(8, 25),(8, 26),(8, 27),(8, 28),(8, 29),(8, 30),
								(8, 31),(8, 32),(8, 33),(8, 34),(8, 35),(8, 36),(8, 37),(8, 38),(8, 39),(8, 40),
								(8, 41),(8, 42),(8, 43),(8, 44),(8, 45),(8, 46),(8, 47),(8, 48),(8, 49),(8, 50),
								
								(9, 1),(9, 2), (9, 3),(9, 4),(9, 5),(9, 6),(9, 7),(9, 8),(9, 9),(9, 10),
								(9, 11),(9, 12),(9, 13),(9, 14),(9, 15),(9, 16),(9, 17),(9, 18),(9, 19),(9, 20),
								(9, 21),(9, 22),(9, 23),(9, 24),(9, 25),(9, 26),(9, 27),(9, 28),(9, 29),(9, 30),
								(9, 31),(9, 32),(9, 33),(9, 34),(9, 35),(9, 36),(9, 37),(9, 38),(9, 39),(9, 40),
								(9, 41),(9, 42),(9, 43),(9, 44),(9, 45),(9, 46),(9, 47),(9, 48),(9, 49),(9, 50),
								(9, 51),(9, 52), (9, 53),(9, 54),(9, 55),(9, 56),(9, 57),(9, 58),(9, 59),(9, 60);
-- Comprobación inserción de datos
SELECT * FROM Salas_Butacas;


INSERT INTO Peliculas VALUES ('Black Adam', 124, 0, 1, 'Casi 5.000 años después de haber sido dotado de los poderes omnipotentes de los antiguos dioses y encarcelado con la misma rapidez, Black Adam (Johnson) es liberado de su tumba terrenal, listo para desatar su forma única de justicia en el mundo moderno.', 1,1,1),
								('El fotógrafo de minamata', 115, 0, 1, 'Nueva York, 1971. Tras sus celebrados días como uno de los fotoperiodistas más venerados de la II Guerra Mundial, W. Eugene Smith se siente desconectado de la sociedad y de su carrera. La revista Life lo envía a la ciudad costera japonesa de Minamata, cuya población ha sido devastada por el envenenamiento por mercurio, resultado de décadas de negligencia industrial. Smith se sumerge en la comunidad y sus imágenes le dan al desastre una dimensión humana desgarradora.', 2,1,1),
								('Hallowen, la noche final', 111, 0, 0, 'Cuatro años después de los acontecimientos de Halloween Kills, Laurie vive con su nieta Allyson (Andi Matichak) y está a punto de terminar de escribir sus memorias. Nadie ha vuelto a ver a Michael Myers desde entonces. Laurie, después de permitir que el espectro de Myers controlara su realidad durante décadas, ha decidido por fin dejar atrás el miedo y la rabia para dedicarse a vivir. Pero cuando acusan a Corey Cunningham (Rohan Campbell) de matar al niño al que cuidaba, se desencadena una cascada de violencia que obligará a Laurie a enfrentarse de una vez por todas con una maldad que no puede controlar.', 3,1,1),
								('Princesa por accidente', 89, 1, 0, 'Pil es una pequeña huérfana que vive en la calle, en la ciudad medieval de Roc-en-Brume. Junto a sus tres comadrejas amaestradas, Pil sobrevive robando comida en el castillo del siniestro rey Tristain, que ha usurpado el trono.', 4,1,0),
								('Argentina, 1985', 141, 0, 0, 'Argentina, 1985 está inspirada en la historia real de los fiscales Julio Strassera y Luis Moreno Ocampo, que en 1985 se atrevieron a investigar y enjuiciar a la dictadura militar más sangrienta de la historia argentina. Sin dejarse intimidar por la todavía considerable influencia militar en la nueva y frágil democracia, Strassera y Moreno Ocampo reunieron un joven equipo jurídico de inesperados héroes para su batalla de David contra Goliat. Bajo amenaza constante sobre ellos y sus familias, corrieron contra el tiempo para hacer justicia por las víctimas de la junta militar.', 2,1,1),
								('Tadeo el explorador: la leyenda de la momia', 89, 1, 0, 'A Tadeo le encantaría que sus colegas arqueólogos le aceptaran como a uno más, pero siempre acaba arruinándolo: cuando destroza un sarcófago y desata un conjuro, pone en peligro la vida de sus amigos, Momia, Jeff y Belzoni. Con todos en contra y solo ayudado por Sara, Tadeo emprenderá una huida llena de aventuras, que le llevará de México a Chicago y de París a Egipto, para encontrar la manera de acabar con la maldición de la momia.', 4,1,0),
								('Amsterdam', 134, 0, 1, 'De 20th Century Studios, New Regency y el aclamado cineasta David O. Russell llega ÁMSTERDAM, una épica historia de un crimen romántico sobre tres íntimos amigos que se ven envueltos en el medio de una de las tramas secretas más escandalosas de la historia norteamericana. Basada en hechos de ficción, la película es protagonizada por el ganador de un premio Oscar® Christian Bale, la dos veces nominada a los Oscar® Margot Robbie, John David Washington, Alessandro Nivola, Andrea Riseborough, Anya Taylor-Joy, Chris Rock, Matthias Schoenaerts, Michael Shannon, Mike Myers, Taylor Swift, Timothy Olyphant, Zoe Saldana, el ganador de un Oscar® Rami Malek y el dos veces ganador de un Oscar® Robert De Niro. Escrita y dirigida por el cinco veces nominado a los premios de la Academia® David O. Russell, AMSTERDAM es producida por Arnon Milchan, Matthew Budman, Anthony Katagas, David O. Russell y Christian Bale. Yariv Milchan, Michael Schaefer y Sam Hanson son los productores ejecutivos.', 2,1,1),
								('Pasaje al paraíso', 104, 0, 1, 'Los artistas galardonados con el Premio de la Academia® GEORGE CLOONEY y JULIA ROBERTS se reúnen en la pantalla grande interpretando a los ex esposos David y Georgia, quienes se encuentran en una misión compartida para evitar que su enamorada hija cometa el mismo error que ellos, tiempo atrás.Pasaje al Paraíso es una comedia romántica sobre la dulce sorpresa de las segundas oportunidades.', 5,1,0),
								('Pantera Negra: Wakanda por siempre', 161, 0, 1, 'En PANTERA NEGRA: WAKANDA POR SIEMPRE de Marvel Studios, la reina Ramonda (Angela Bassett), Shuri (Letitia Wright), MBaku (Winston Duke), Okoye (Danai Gurira) y las Dora Milaje (incluida Florence Kasumba) luchan por proteger a su nación de las potencias mundiales que intervienen tras la muerte del Rey TChalla. Mientras los habitantes de Wakanda se esfuerzan embarcarse en un nuevo capítulo, los héroes deben unirse con la ayuda de War Dog Nakia (Lupita Nyong"o) y Everett Ross (Martin Freeman) y forjar un nuevo camino para el reino de Wakanda.', 6,1,0),
								('Spiderhead', 106, 0, 1, '¿Hasta dónde llegarías para corregir la naturaleza humana?En un futuro próximo, se ofrece a presidiarios la oportunidad de someterse a experimentos médicos para acortar su sentencia. Uno de los sujetos, inyectado con una droga que genera sentimientos de amor, empieza a cuestionar sus emociones.', 7,1,0),
								
								('El bueno, el malo y el feo (1966)', 110, 0, 1, 'El decimo puesto lo ocupa El bueno, el malo y el feo, una película de Sergio Leone, lanzada en 1966. La trama transcurre en el viejo oeste durante la época de la Guerra civil de Estados Unidos y cuenta la historia de la alianza entre dos hombres, quienes buscan una fortuna enterrada en un cementerio.', 1,0,1),
								('El Padrino (1972)', 130, 0, 1, 'Muestra la organización criminal de la familia Corleone en Nueva York de los años 40 y 50. Francis Ford Coppola fue el encargado de dirigir y escribir el guion de la cinta, la cual fue lanzada en 1972.', 2,0,1),
								('El Padrino: Parte II', 135, 0, 1, 'Narra los comienzos de Vito Corleone dentro de la mafia. Un dato bastante curioso es que la película fue producida con un presupuesto de 13 millones de dólares, el doble del que se usó en la primera entrega.', 2,0,1),
								('El Padrino: Parte III', 145, 0, 1, 'La última entrega de la saga Corleone empieza en 1979. Michael Corleone se encuentra en los finales de sus cincuenta años; sus hijos ya son adultos; y no ha visto a su exesposa Kay Adams, que contrajo matrimonio con un Juez, en ocho años. Tom Hagen ha muerto y su hijo, Andrew, se ha convertido en Sacerdote.', 2,0,1),
								('El Señor de los Anillos: la Comunidad del Anillo', 178, 1, 1, 'En la Segunda Edad de la Tierra Media, los señores de los Elfos, los Enanos y los Hombres reciben anillos de poder. Sin saberlo, el Señor Oscuro Sauron forja el anillo Único en el Monte del Destino, infundiendo en él una gran parte de su poder para dominar, a través de él y a distancia, los otros Anillos, para que pueda conquistar la Tierra Media. Una alianza final de hombres y elfos lucha contra las fuerzas de Sauron en Mordor, donde el príncipe Isildur de Gondor corta el dedo de Sauron, y el Anillo con él, destruyendo así su forma física.', 6,0,1),
								('El Señor de los Anillos: las dos torres', 179, 1, 1, 'Tras internarse en Emyn Muil, Frodo Bolsón y Sam Gamyi se encuentran con la criatura Gollum, que intenta quitarles el Anillo por la fuerza pero, al verse vencido, promete a los hobbits guiarlos hasta Mordor. Tras sacarlos de Emyn Muil y atravesar la Ciénaga de los Muertos, llegan al Morannon, la «Puerta Negra» de Mordor. No obstante, la gran protección que tiene les imposibilita entrar por ahí y Gollum les propone tomar el camino secreto de Cirith Ungol.', 6,0,1),
								('El Señor de los Anillos: el retorno del Rey', 201, 1, 1, 'La historia comienza con un recuerdo de cómo el hobbit Smeágol llegó a poseer el Anillo de Poder, tras matar a su amigo Déagol, quien lo había encontrado en el fondo de un río (donde cayó muchos años antes, como se vio en la primera película, cuando unos orcos asesinaron a Isildur, quien había cortado el dedo a Sauron en el Sitio de Barad-dûr, que concluyó la Guerra de la Última Alianza, y había conservado el Anillo a pesar de las advertencias de Elrond). A partir de entonces continúa el relato en donde se dejó mientras Gollum lleva a Frodo y Sam a través de la entrada cercana a Minas Morgul, en donde ven a sus ejércitos partir a la guerra.', 6,0,1),
								('Iron Man', 201, 1, 1, 'Anthony Edward Stark, que ha heredado la empresa de armamento Stark Industries de su padre, está en una Afganistán devastada por la guerra con su amigo y enlace militar, el teniente coronel James Rhodes, para demostrar del nuevo misil «Jericó». Luego de la demostración, el convoy sufre una emboscada y Stark es herido de gravedad por un misil que usan los terroristas: irónicamente uno de los propios misiles de su compañía.', 1,0,1),
								('Iron Man 2', 124, 1, 1, 'Seis meses después de los eventos de Iron Man, Tony Stark se resiste a los llamados del gobierno de los Estados Unidos para entregar la tecnología de Iron Man, al mismo tiempo que combate su salud deteriorada debido al reactor arc en su pecho. Mientras tanto, el malvado científico ruso Ivan Vanko ha desarrollado la misma tecnología y construido armas propias para vengarse de la familia Stark, uniendo fuerzas con el empresario rival de Stark, Justin Hammer, en el proceso.', 1,0,1),
								('Iron Man 3', 131, 1, 1, 'En Iron Man 3, Tony Stark lucha con las ramificaciones de los eventos de The Avengers, durante una campaña nacional de terrorismo en los Estados Unidos al mando del misterioso Mandarín.', 1,0,1);

-- Comprobación inserción de datos
SELECT * FROM Peliculas;



INSERT INTO Sucursales_Peliculas VALUES (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,7), (1,8), (1,9), (1,10),
										(2, 1),(2, 2), (2, 3),(2, 4),(2, 5),(2, 6),(2, 7),(2, 8),(2, 9),(2, 10),
										(3, 1),(3, 2), (3, 3),(3, 4),(3, 5),(3, 6),(3, 7),(3, 8),(3, 9),(3, 10);
-- Comprobación inserción de datos
SELECT * FROM Sucursales_Peliculas;


INSERT INTO Funciones VALUES ('2022-10-24', '14:25:00', 5, 1,2), ('2022-10-25', '19:15:00', 5, 2,2), ('2022-10-24', '15:25:00', 5, 3,2),
								('2022-10-26', '15:30:00', 5, 4,1), ('2022-10-27', '16:10:00', 5, 5,1), ('2022-10-28', '15:25:00', 5, 6,1),
								 ('2022-10-26', '20:45:00', 5, 6,1),
								('2022-10-28', '17:25:00', 5, 7,3), ('2022-10-29', '18:25:00', 5, 8,3), ('2022-10-30', '15:00:00', 5, 9,3),

								('2022-10-25', '14:25:00', 1, 1,2), ('2022-10-26', '19:15:00', 1, 2,2), ('2022-10-25', '15:25:00', 1, 3,2),
								('2022-10-25', '15:30:00', 1, 4,1), ('2022-10-25', '16:40:00', 1, 5,1), ('2022-10-30', '16:00:00', 1, 6,1), -- 15

								('2022-10-24', '15:30:00', 2, 4,1), ('2022-10-28', '16:40:00', 2, 5,1), ('2022-10-29', '15:25:00', 2, 6,1),
								('2022-10-25', '14:10:00', 2, 7,3), ('2022-10-27', '15:45:00', 2, 8,3), ('2022-10-29', '14:15:00', 2, 9,3), -- 21

								('2022-10-23', '17:25:00', 3, 7,3), ('2022-10-22', '18:25:00', 3, 8,3), ('2022-10-31', '15:00:00', 3, 9,3),
								('2022-10-25', '18:10:00', 3, 4,1), ('2022-10-26', '16:40:00', 3, 5,1), ('2022-10-25', '16:00:00', 3, 6,1), -- 27

								('2022-10-25', '17:25:00', 4, 1,2), ('2022-10-26', '14:15:00', 4, 2,2), ('2022-10-25', '13:00:00', 4, 3,2), -- 30
								('2022-10-24', '14:10:00', 4, 7,3), ('2022-10-29', '15:45:00', 4, 8,3), ('2022-10-29', '16:30:00', 4, 9,3),

								('2022-10-24', '13:15:00', 6, 4,1), ('2022-10-28', '14:10:00', 6, 5,1), ('2022-10-29', '18:10:00', 6, 6,1), -- 36
								('2022-10-24', '17:15:00', 6, 1,2), ('2022-10-28', '14:10:00', 6, 2,2), ('2022-10-29', '18:10:00', 6, 3,2), -- 39

								('2022-10-25', '17:25:00', 7, 7,3), ('2022-10-22', '13:25:00', 7, 8,3), ('2022-10-31', '18:00:00', 7, 9,3), -- 42
								('2022-10-30', '13:15:00', 7, 4,1), ('2022-10-25', '14:10:00', 7, 5,1), ('2022-10-31', '18:10:00', 7, 6,1), -- 45

								('2022-10-26', '17:25:00', 8, 1,2), ('2022-10-27', '14:15:00', 8, 2,2), ('2022-10-28', '13:00:00', 8, 3,2), -- 48
								('2022-10-27', '14:10:00', 4, 7,3), ('2022-10-28', '15:45:00', 8, 8,3), ('2022-10-25', '16:30:00', 8, 9,3), -- 51

								('2022-10-27', '13:15:00', 9, 4,1), ('2022-10-24', '14:10:00', 9, 5,1), ('2022-10-28', '18:10:00', 9, 6,1), -- 54
								('2022-10-29', '17:25:00', 9, 1,2), ('2022-10-27', '17:45:00', 9, 2,2), ('2022-10-28', '16:45:00', 9, 3,2), --57

								('2022-10-27', '16:15:00', 10, 4,1), ('2022-10-24', '17:15:00', 10, 5,1), ('2022-10-30', '18:10:00', 10, 6,1), -- 60
								('2022-10-23', '14:45:00', 10, 7,3), ('2022-10-27', '18:25:00', 10, 8,3), ('2022-10-30', '18:00:00', 10, 9,3); -- 63

-- Comprobación inserción de datos
SELECT * FROM Funciones;


INSERT INTO Funciones_Butacas VALUES (1,1,1), (2,1,1), (3,1,0), (4,1,1), (5,1,1), (6,1,1), (7,1,0), (8,1,1), (9,1,0), (10,1,0),
										(11,1,0), (12,1,0), (13,1,1), (14,1,0), (15,1,1), (16,1,1), (17,1,1), (18,1,0), (19,1,1), (20,1,0),
										(21,1,0), (22,1,0), (23,1,1), (24,1,0), (25,1,0), (26,1,1), (27,1,0), (28,1,0), (29,1,1), (30,1,0),
										(31,1,1), (32,1,1), (33,1,1), (34,1,0), (35,1,1), (36,1,0), (37,1,1), (38,1,0), (39,1,0), (40,1,0),

										(1,10,1), (2,10,1), (3,10,0), (4,10,0), (5,10,0), (6,10,0), (7,10,0), (8,10,1), (9,10,0), (10,10,0),
										(11,10,1), (12,10,0), (13,10,1), (14,10,0), (15,10,0), (16,10,0), (17,10,1), (18,10,0), (19,10,0), (20,10,1),
										(21,10,0), (22,10,0), (23,10,1), (24,10,0), (25,10,1), (26,10,0), (27,10,1), (28,10,1), (29,10,1), (30,10,1),
										(31,10,1), (32,10,1), (33,10,0), (34,10,1), (35,10,0), (36,10,1), (37,10,0), (38,10,0), (39,10,1), (40,10,0),

										(1,28,0), (2,28,0), (3,28,0), (4,28,0), (5,28,0), (6,28,0), (7,28,1), (8,28,0), (9,28,0), (10,28,1),
										(11,28,0), (12,28,1), (13,28,0), (14,28,1), (15,28,0), (16,28,1), (17,28,1), (18,28,0), (19,28,0), (20,28,1),
										(21,28,0), (22,28,1), (23,28,0), (24,28,0), (25,28,0), (26,28,1), (27,28,0), (28,28,1), (29,28,1), (30,28,0),
										(31,28,1), (32,28,0), (33,28,0), (34,28,1), (35,28,0), (36,28,0), (37,28,1), (38,28,1), (39,28,1), (40,28,0),

										(1,37,0), (2,37,1), (3,37,1), (4,37,0), (5,37,0), (6,37,1), (7,37,0), (8,37,1), (9,37,1), (10,37,0),
										(11,37,1), (12,37,1), (13,37,0), (14,37,1), (15,37,1), (16,37,1), (17,37,0), (18,37,0), (19,37,0), (20,37,1),
										(21,37,1), (22,37,0), (23,37,1), (24,37,0), (25,37,1), (26,37,0), (27,37,0), (28,37,1), (29,37,0), (30,37,0),
										(31,37,1), (32,37,0), (33,37,0), (34,37,1), (35,37,0), (36,37,1), (37,37,1), (38,37,1), (39,37,1), (40,37,0);

INSERT INTO Funciones_Butacas VALUES	(1,46,1), (2,46,0), (3,46,1), (4,46,1), (5,46,0), (6,46,1), (7,46,1), (8,46,1), (9,46,1), (10,46,1),
										(11,46,0), (12,46,1), (13,46,0), (14,46,0), (15,46,0), (16,46,1), (17,46,0), (18,46,0), (19,46,0), (20,46,1),
										(21,46,0), (22,46,0), (23,46,0), (24,46,0), (25,46,1), (26,46,0), (27,46,0), (28,46,0), (29,46,1), (30,46,0),
										(31,46,0), (32,46,1), (33,46,1), (34,46,1), (35,46,0), (36,46,0), (37,46,0), (38,46,0), (39,46,1), (40,46,0),

										(1,55,1), (2,55,1), (3,55,1), (4,55,0), (5,55,0), (6,55,0), (7,55,1), (8,55,0), (9,55,0), (10,55,0),
										(11,55,0), (12,55,0), (13,55,1), (14,55,1), (15,55,0), (16,55,0), (17,55,1), (18,55,0), (19,55,1), (20,55,0),
										(21,55,0), (22,55,0), (23,55,1), (24,55,1), (25,55,0), (26,55,1), (27,55,1), (28,55,0), (29,55,1), (30,55,1),
										(31,55,1), (32,55,1), (33,55,1), (34,55,0), (35,55,1), (36,55,0), (37,55,0), (38,55,0), (39,55,0), (40,55,0),

										(1,2,1), (2,2,1), (3,2,0), (4,2,1), (5,2,1), (6,2,1), (7,2,0), (8,2,0), (9,2,0), (10,2,1),
										(11,2,0), (12,2,0), (13,2,1), (14,2,0), (15,2,0), (16,2,0), (17,2,1), (18,2,1), (19,2,0), (20,2,1),
										(21,2,0), (22,2,1), (23,2,0), (24,2,0), (25,2,0), (26,2,0), (27,2,1), (28,2,0), (29,2,0), (30,2,1),
										(31,2,1), (32,2,0), (33,2,1), (34,2,1), (35,2,0), (36,2,1), (37,2,1), (38,2,0), (39,2,1), (40,2,1),

										(1,11,1), (2,11,1), (3,11,1), (4,11,1), (5,11,0), (6,11,1), (7,11,0), (8,11,1), (9,11,1), (10,11,1),
										(11,11,0), (12,11,0), (13,11,0), (14,11,0), (15,11,0), (16,11,0), (17,11,1), (18,11,1), (19,11,0), (20,11,0),
										(21,11,1), (22,11,0), (23,11,0), (24,11,1), (25,11,0), (26,11,0), (27,11,1), (28,11,1), (29,11,1), (30,11,1),
										(31,11,0), (32,11,1), (33,11,0), (34,11,0), (35,11,1), (36,11,1), (37,11,0), (38,11,0), (39,11,1), (40,11,0);

INSERT INTO Funciones_Butacas VALUES	(1,29,0), (2,29,1), (3,29,0), (4,29,1), (5,29,0), (6,29,0), (7,29,1), (8,29,1), (9,29,0), (10,29,0),
										(11,29,1), (12,29,1), (13,29,0), (14,29,0), (15,29,1), (16,29,0), (17,29,1), (18,29,1), (19,29,1), (20,29,0),
										(21,29,0), (22,29,1), (23,29,0), (24,29,1), (25,29,1), (26,29,1), (27,29,1), (28,29,1), (29,29,1), (30,29,1),
										(31,29,1), (32,29,1), (33,29,1), (34,29,0), (35,29,0), (36,29,1), (37,29,0), (38,29,0), (39,29,1), (40,29,0),

										(1,38,0), (2,38,0), (3,38,0), (4,38,0), (5,38,0), (6,38,0), (7,38,1), (8,38,1), (9,38,1), (10,38,0),
										(11,38,1), (12,38,1), (13,38,0), (14,38,1), (15,38,1), (16,38,0), (17,38,1), (18,38,1), (19,38,1), (20,38,0),
										(21,38,0), (22,38,0), (23,38,1), (24,38,0), (25,38,0), (26,38,1), (27,38,1), (28,38,1), (29,38,0), (30,38,1),
										(31,38,1), (32,38,1), (33,38,1), (34,38,1), (35,38,1), (36,38,1), (37,38,0), (38,38,0), (39,38,1), (40,38,0),

										(1,47,1), (2,47,1), (3,47,0), (4,47,1), (5,47,0), (6,47,0), (7,47,1), (8,47,1), (9,47,1), (10,47,1),
										(11,47,0), (12,47,0), (13,47,1), (14,47,1), (15,47,0), (16,47,0), (17,47,1), (18,47,1), (19,47,0), (20,47,0),
										(21,47,1), (22,47,1), (23,47,0), (24,47,1), (25,47,1), (26,47,1), (27,47,1), (28,47,0), (29,47,1), (30,47,1),
										(31,47,1), (32,47,0), (33,47,0), (34,47,1), (35,47,0), (36,47,0), (37,47,0), (38,47,1), (39,47,1), (40,47,0),

										(1,56,0), (2,56,1), (3,56,1), (4,56,1), (5,56,0), (6,56,0), (7,56,0), (8,56,1), (9,56,1), (10,56,0),
										(11,56,0), (12,56,0), (13,56,1), (14,56,0), (15,56,0), (16,56,0), (17,56,0), (18,56,1), (19,56,0), (20,56,0),
										(21,56,1), (22,56,0), (23,56,0), (24,56,1), (25,56,1), (26,56,0), (27,56,1), (28,56,1), (29,56,1), (30,56,1),
										(31,56,1), (32,56,0), (33,56,0), (34,56,0), (35,56,1), (36,56,0), (37,56,0), (38,56,0), (39,56,0), (40,56,0);

INSERT INTO Funciones_Butacas VALUES	(1,4,1), (2,4,1), (3,4,0), (4,4,1), (5,4,0), (6,4,1), (7,4,0), (8,4,1), (9,4,0), (10,4,1),
										(11,4,0), (12,4,1), (13,4,0), (14,4,1), (15,4,0), (16,4,1), (17,4,1), (18,4,0), (19,4,1), (20,4,0),
										(21,4,0), (22,4,0), (23,4,0), (24,4,0), (25,4,1), (26,4,0), (27,4,0), (28,4,0), (29,4,1), (30,4,0),
										(31,4,1), (32,4,1), (33,4,1), (34,4,0), (35,4,0), (36,4,0), (37,4,0), (38,4,0), (39,4,1), (40,4,1),

										(1,13,0), (2,13,0), (3,13,0), (4,13,0), (5,13,1), (6,13,0), (7,13,0), (8,13,1), (9,13,1), (10,13,1),
										(11,13,0), (12,13,0), (13,13,0), (14,13,0), (15,13,1), (16,13,0), (17,13,0), (18,13,0), (19,13,0), (20,13,1),
										(21,13,1), (22,13,0), (23,13,0), (24,13,0), (25,13,0), (26,13,1), (27,13,1), (28,13,0), (29,13,0), (30,13,0),
										(31,13,1), (32,13,0), (33,13,0), (34,13,0), (35,13,0), (36,13,0), (37,13,0), (38,13,1), (39,13,1), (40,13,1),

										(1,16,1), (2,16,1), (3,16,1), (4,16,1), (5,16,0), (6,16,0), (7,16,0), (8,16,0), (9,16,0), (10,16,0),
										(11,16,0), (12,16,1), (13,16,1), (14,16,0), (15,16,1), (16,16,1), (17,16,0), (18,16,1), (19,16,1), (20,16,0),
										(21,16,1), (22,16,1), (23,16,0), (24,16,0), (25,16,0), (26,16,0), (27,16,1), (28,16,1), (29,16,0), (30,16,0),
										(31,16,1), (32,16,0), (33,16,1), (34,16,1), (35,16,1), (36,16,0), (37,16,1), (38,16,1), (39,16,1), (40,16,1),

										(1,25,0), (2,25,1), (3,25,1), (4,25,0), (5,25,0), (6,25,1), (7,25,0), (8,25,0), (9,25,1), (10,25,1),
										(11,25,0), (12,25,0), (13,25,1), (14,25,0), (15,25,1), (16,25,1), (17,25,1), (18,25,1), (19,25,1), (20,25,0),
										(21,25,0), (22,25,1), (23,25,1), (24,25,1), (25,25,0), (26,25,1), (27,25,1), (28,25,0), (29,25,0), (30,25,0),
										(31,25,0), (32,25,0), (33,25,0), (34,25,0), (35,25,1), (36,25,0), (37,25,0), (38,25,1), (39,25,1), (40,25,1);

INSERT INTO Funciones_Butacas VALUES	(1,34,0), (2,34,0), (3,34,0), (4,34,0), (5,34,1), (6,34,1), (7,34,1), (8,34,0), (9,34,1), (10,34,1),
										(11,34,0), (12,34,1), (13,34,0), (14,34,0), (15,34,0), (16,34,0), (17,34,0), (18,34,1), (19,34,0), (20,34,1),
										(21,34,0), (22,34,1), (23,34,0), (24,34,1), (25,34,1), (26,34,1), (27,34,0), (28,34,1), (29,34,1), (30,34,1),
										(31,34,0), (32,34,1), (33,34,0), (34,34,0), (35,34,1), (36,34,0), (37,34,1), (38,34,0), (39,34,1), (40,34,0),

										(1,43,0), (2,43,0), (3,43,0), (4,43,1), (5,43,1), (6,43,1), (7,43,1), (8,43,0), (9,43,0), (10,43,0),
										(11,43,1), (12,43,0), (13,43,1), (14,43,1), (15,43,1), (16,43,1), (17,43,0), (18,43,1), (19,43,1), (20,43,0),
										(21,43,0), (22,43,0), (23,43,1), (24,43,0), (25,43,0), (26,43,1), (27,43,0), (28,43,1), (29,43,1), (30,43,1),
										(31,43,1), (32,43,0), (33,43,0), (34,43,1), (35,43,0), (36,43,0), (37,43,0), (38,43,1), (39,43,0), (40,43,1),

										(1,52,1), (2,52,1), (3,52,0), (4,52,0), (5,52,0), (6,52,1), (7,52,1), (8,52,1), (9,52,1), (10,52,1),
										(11,52,1), (12,52,1), (13,52,1), (14,52,1), (15,52,0), (16,52,0), (17,52,0), (18,52,1), (19,52,1), (20,52,0),
										(21,52,1), (22,52,0), (23,52,0), (24,52,1), (25,52,0), (26,52,0), (27,52,0), (28,52,0), (29,52,1), (30,52,1),
										(31,52,0), (32,52,1), (33,52,1), (34,52,0), (35,52,1), (36,52,1), (37,52,1), (38,52,1), (39,52,0), (40,52,0),

										(1,58,0), (2,58,0), (3,58,0), (4,58,0), (5,58,1), (6,58,1), (7,58,1), (8,58,0), (9,58,0), (10,58,1),
										(11,58,0), (12,58,1), (13,58,0), (14,58,1), (15,58,1), (16,58,0), (17,58,1), (18,58,1), (19,58,1), (20,58,0),
										(21,58,0), (22,58,1), (23,58,0), (24,58,1), (25,58,1), (26,58,1), (27,58,0), (28,58,1), (29,58,1), (30,58,0),
										(31,58,1), (32,58,1), (33,58,1), (34,58,0), (35,58,0), (36,58,1), (37,58,0), (38,58,1), (39,58,0), (40,58,1),

										(1,5,0), (2,5,0), (3,5,0), (4,5,1), (5,5,1), (6,5,0), (7,5,0), (8,5,1), (9,5,1), (10,5,1),
										(11,5,0), (12,5,1), (13,5,0), (14,5,0), (15,5,1), (16,5,1), (17,5,1), (18,5,1), (19,5,1), (20,5,1),
										(21,5,0), (22,5,1), (23,5,0), (24,5,0), (25,5,1), (26,5,0), (27,5,0), (28,5,1), (29,5,0), (30,5,0),
										(31,5,1), (32,5,0), (33,5,0), (34,5,0), (35,5,1), (36,5,0), (37,5,0), (38,5,0), (39,5,1), (40,5,1),

										(1,14,1), (2,14,1), (3,14,0), (4,14,0), (5,14,1), (6,14,1), (7,14,0), (8,14,0), (9,14,0), (10,14,1),
										(11,14,0), (12,14,0), (13,14,1), (14,14,1), (15,14,0), (16,14,0), (17,14,1), (18,14,0), (19,14,1), (20,14,0),
										(21,14,0), (22,14,1), (23,14,0), (24,14,0), (25,14,0), (26,14,0), (27,14,0), (28,14,0), (29,14,1), (30,14,1),
										(31,14,1), (32,14,1), (33,14,1), (34,14,1), (35,14,1), (36,14,1), (37,14,1), (38,14,1), (39,14,1), (40,14,1),

										(1,17,1), (2,17,0), (3,17,1), (4,17,0), (5,17,1), (6,17,1), (7,17,0), (8,17,1), (9,17,0), (10,17,1),
										(11,17,0), (12,17,0), (13,17,1), (14,17,0), (15,17,1), (16,17,0), (17,17,1), (18,17,0), (19,17,0), (20,17,0),
										(21,17,1), (22,17,1), (23,17,1), (24,17,1), (25,17,1), (26,17,1), (27,17,0), (28,17,1), (29,17,0), (30,17,0),
										(31,17,0), (32,17,1), (33,17,1), (34,17,0), (35,17,0), (36,17,0), (37,17,0), (38,17,1), (39,17,0), (40,17,0),

										(1,26,1), (2,26,0), (3,26,0), (4,26,1), (5,26,1), (6,26,0), (7,26,1), (8,26,1), (9,26,0), (10,26,0),
										(11,26,0), (12,26,1), (13,26,0), (14,26,1), (15,26,0), (16,26,0), (17,26,1), (18,26,0), (19,26,1), (20,26,1),
										(21,26,0), (22,26,1), (23,26,0), (24,26,1), (25,26,1), (26,26,0), (27,26,0), (28,26,1), (29,26,1), (30,26,0),
										(31,26,0), (32,26,0), (33,26,1), (34,26,1), (35,26,1), (36,26,1), (37,26,1), (38,26,1), (39,26,1), (40,26,0);

INSERT INTO Funciones_Butacas VALUES	(1,35,1), (2,35,0), (3,35,1), (4,35,0), (5,35,1), (6,35,1), (7,35,0), (8,35,1), (9,35,1), (10,35,1),
										(11,35,0), (12,35,0), (13,35,0), (14,35,0), (15,35,0), (16,35,1), (17,35,0), (18,35,1), (19,35,0), (20,35,1),
										(21,35,1), (22,35,0), (23,35,0), (24,35,1), (25,35,0), (26,35,0), (27,35,0), (28,35,0), (29,35,1), (30,35,1),
										(31,35,0), (32,35,0), (33,35,1), (34,35,1), (35,35,0), (36,35,1), (37,35,1), (38,35,0), (39,35,0), (40,35,1),

										(1,44,1), (2,44,1), (3,44,0), (4,44,0), (5,44,0), (6,44,0), (7,44,0), (8,44,0), (9,44,1), (10,44,0),
										(11,44,0), (12,44,1), (13,44,0), (14,44,1), (15,44,1), (16,44,0), (17,44,1), (18,44,0), (19,44,1), (20,44,0),
										(21,44,1), (22,44,1), (23,44,0), (24,44,0), (25,44,0), (26,44,0), (27,44,0), (28,44,1), (29,44,0), (30,44,0),
										(31,44,0), (32,44,0), (33,44,1), (34,44,1), (35,44,1), (36,44,1), (37,44,0), (38,44,0), (39,44,0), (40,44,1),

										(1,53,1), (2,53,0), (3,53,0), (4,53,1), (5,53,1), (6,53,0), (7,53,0), (8,53,1), (9,53,1), (10,53,0),
										(11,53,0), (12,53,1), (13,53,1), (14,53,1), (15,53,0), (16,53,0), (17,53,0), (18,53,0), (19,53,1), (20,53,1),
										(21,53,0), (22,53,1), (23,53,1), (24,53,1), (25,53,0), (26,53,0), (27,53,1), (28,53,0), (29,53,0), (30,53,0),
										(31,53,1), (32,53,1), (33,53,0), (34,53,0), (35,53,0), (36,53,0), (37,53,1), (38,53,0), (39,53,1), (40,53,1),

										(1,59,0), (2,59,1), (3,59,1), (4,59,1), (5,59,1), (6,59,0), (7,59,1), (8,59,1), (9,59,0), (10,59,0),
										(11,59,1), (12,59,0), (13,59,0), (14,59,0), (15,59,1), (16,59,1), (17,59,0), (18,59,0), (19,59,0), (20,59,0),
										(21,59,0), (22,59,1), (23,59,1), (24,59,1), (25,59,0), (26,59,1), (27,59,1), (28,59,1), (29,59,0), (30,59,0),
										(31,59,1), (32,59,0), (33,59,1), (34,59,0), (35,59,1), (36,59,0), (37,59,1), (38,59,0), (39,59,1), (40,59,1),

										(1,7,1), (2,7,0), (3,7,0), (4,7,0), (5,7,1), (6,7,0), (7,7,1), (8,7,1), (9,7,0), (10,7,1),
										(11,7,1), (12,7,0), (13,7,1), (14,7,0), (15,7,1), (16,7,0), (17,7,1), (18,7,0), (19,7,0), (20,7,0),
										(21,7,1), (22,7,0), (23,7,0), (24,7,1), (25,7,0), (26,7,1), (27,7,1), (28,7,1), (29,7,0), (30,7,1),
										(31,7,0), (32,7,1), (33,7,1), (34,7,0), (35,7,0), (36,7,0), (37,7,0), (38,7,1), (39,7,1), (40,7,0),

										(1,19,0), (2,19,1), (3,19,1), (4,19,1), (5,19,0), (6,19,1), (7,19,1), (8,19,1), (9,19,1), (10,19,0),
										(11,19,1), (12,19,0), (13,19,1), (14,19,1), (15,19,1), (16,19,0), (17,19,0), (18,19,1), (19,19,1), (20,19,0),
										(21,19,0), (22,19,0), (23,19,1), (24,19,1), (25,19,1), (26,19,0), (27,19,0), (28,19,1), (29,19,0), (30,19,0),
										(31,19,1), (32,19,1), (33,19,1), (34,19,0), (35,19,1), (36,19,1), (37,19,1), (38,19,1), (39,19,1), (40,19,1),

										(1,22,0), (2,22,0), (3,22,1), (4,22,1), (5,22,0), (6,22,1), (7,22,0), (8,22,0), (9,22,1), (10,22,1),
										(11,22,1), (12,22,0), (13,22,1), (14,22,1), (15,22,0), (16,22,0), (17,22,1), (18,22,1), (19,22,1), (20,22,0),
										(21,22,0), (22,22,0), (23,22,1), (24,22,1), (25,22,1), (26,22,0), (27,22,0), (28,22,1), (29,22,1), (30,22,1),
										(31,22,0), (32,22,1), (33,22,0), (34,22,0), (35,22,1), (36,22,1), (37,22,0), (38,22,0), (39,22,1), (40,22,1),

										(1,31,1), (2,31,1), (3,31,1), (4,31,0), (5,31,1), (6,31,1), (7,31,1), (8,31,1), (9,31,0), (10,31,1),
										(11,31,1), (12,31,1), (13,31,1), (14,31,1), (15,31,1), (16,31,0), (17,31,1), (18,31,1), (19,31,1), (20,31,1),
										(21,31,0), (22,31,1), (23,31,1), (24,31,1), (25,31,0), (26,31,0), (27,31,0), (28,31,1), (29,31,0), (30,31,0),
										(31,31,0), (32,31,1), (33,31,1), (34,31,0), (35,31,1), (36,31,1), (37,31,1), (38,31,1), (39,31,1), (40,31,1);

INSERT INTO Funciones_Butacas VALUES	(1,40,0), (2,40,0), (3,40,0), (4,40,1), (5,40,1), (6,40,0), (7,40,0), (8,40,1), (9,40,0), (10,40,0),
										(11,40,1), (12,40,0), (13,40,0), (14,40,0), (15,40,0), (16,40,0), (17,40,0), (18,40,1), (19,40,0), (20,40,0),
										(21,40,0), (22,40,1), (23,40,0), (24,40,0), (25,40,0), (26,40,0), (27,40,1), (28,40,1), (29,40,0), (30,40,1),
										(31,40,0), (32,40,0), (33,40,0), (34,40,0), (35,40,1), (36,40,0), (37,40,1), (38,40,1), (39,40,1), (40,40,1),

										(1,49,0), (2,49,0), (3,49,1), (4,49,1), (5,49,1), (6,49,0), (7,49,0), (8,49,0), (9,49,1), (10,49,1),
										(11,49,0), (12,49,0), (13,49,1), (14,49,1), (15,49,0), (16,49,0), (17,49,0), (18,49,1), (19,49,0), (20,49,1),
										(21,49,0), (22,49,0), (23,49,1), (24,49,1), (25,49,0), (26,49,1), (27,49,0), (28,49,1), (29,49,0), (30,49,1),
										(31,49,1), (32,49,1), (33,49,0), (34,49,1), (35,49,1), (36,49,0), (37,49,1), (38,49,1), (39,49,0), (40,49,0),

										(1,61,0), (2,61,1), (3,61,0), (4,61,0), (5,61,0), (6,61,0), (7,61,0), (8,61,1), (9,61,1), (10,61,0),
										(11,61,1), (12,61,0), (13,61,0), (14,61,1), (15,61,1), (16,61,0), (17,61,1), (18,61,0), (19,61,0), (20,61,1),
										(21,61,0), (22,61,1), (23,61,0), (24,61,0), (25,61,1), (26,61,0), (27,61,0), (28,61,1), (29,61,0), (30,61,1),
										(31,61,0), (32,61,1), (33,61,0), (34,61,1), (35,61,1), (36,61,0), (37,61,0), (38,61,1), (39,61,0), (40,61,1),

										(1,3,0), (2,3,0), (3,3,1), (4,3,0), (5,3,1), (6,3,0), (7,3,1), (8,3,1), (9,3,1), (10,3,0),
										(11,3,0), (12,3,0), (13,3,0), (14,3,1), (15,3,1), (16,3,0), (17,3,0), (18,3,0), (19,3,0), (20,3,0),
										(21,3,1), (22,3,1), (23,3,1), (24,3,0), (25,3,1), (26,3,0), (27,3,0), (28,3,0), (29,3,0), (30,3,1),
										(31,3,0), (32,3,1), (33,3,1), (34,3,1), (35,3,0), (36,3,0), (37,3,0), (38,3,1), (39,3,0), (40,3,0),
										(41,3,1), (42,3,1), (43,3,1), (44,3,0), (45,3,1), (46,3,1), (47,3,0), (48,3,1), (49,3,1), (50,3,1),

										(1,12,0), (2,12,1), (3,12,1), (4,12,1), (5,12,0), (6,12,0), (7,12,0), (8,12,1), (9,12,0), (10,12,1),
										(11,12,0), (12,12,0), (13,12,0), (14,12,1), (15,12,1), (16,12,1), (17,12,0), (18,12,0), (19,12,0), (20,12,0),
										(21,12,0), (22,12,0), (23,12,0), (24,12,1), (25,12,0), (26,12,0), (27,12,0), (28,12,1), (29,12,1), (30,12,1),
										(31,12,1), (32,12,0), (33,12,0), (34,12,0), (35,12,0), (36,12,0), (37,12,1), (38,12,1), (39,12,1), (40,12,1),
										(41,12,1), (42,12,1), (43,12,1), (44,12,0), (45,12,0), (46,12,1), (47,12,1), (48,12,1), (49,12,1), (50,12,0),

										(1,30,0), (2,30,1), (3,30,1), (4,30,1), (5,30,1), (6,30,0), (7,30,0), (8,30,1), (9,30,1), (10,30,0),
										(11,30,0), (12,30,1), (13,30,1), (14,30,0), (15,30,0), (16,30,0), (17,30,1), (18,30,1), (19,30,0), (20,30,0),
										(21,30,1), (22,30,1), (23,30,0), (24,30,0), (25,30,0), (26,30,1), (27,30,0), (28,30,1), (29,30,0), (30,30,1),
										(31,30,1), (32,30,1), (33,30,0), (34,30,1), (35,30,1), (36,30,0), (37,30,1), (38,30,0), (39,30,0), (40,30,1),
										(41,30,1), (42,30,1), (43,30,1), (44,30,0), (45,30,1), (46,30,1), (47,30,1), (48,30,1), (49,30,0), (50,30,1),

										(1,39,1), (2,39,0), (3,39,1), (4,39,1), (5,39,1), (6,39,1), (7,39,1), (8,39,0), (9,39,1), (10,39,1),
										(11,39,0), (12,39,1), (13,39,0), (14,39,1), (15,39,1), (16,39,1), (17,39,1), (18,39,0), (19,39,1), (20,39,0),
										(21,39,0), (22,39,0), (23,39,0), (24,39,0), (25,39,0), (26,39,1), (27,39,0), (28,39,0), (29,39,1), (30,39,1),
										(31,39,1), (32,39,0), (33,39,0), (34,39,1), (35,39,0), (36,39,1), (37,39,1), (38,39,1), (39,39,0), (40,39,1),
										(41,39,0), (42,39,1), (43,39,1), (44,39,1), (45,39,1), (46,39,0), (47,39,1), (48,39,0), (49,39,1), (50,39,0),

										(1,48,0), (2,48,1), (3,48,1), (4,48,0), (5,48,1), (6,48,1), (7,48,0), (8,48,1), (9,48,0), (10,48,0),
										(11,48,0), (12,48,0), (13,48,0), (14,48,0), (15,48,0), (16,48,1), (17,48,1), (18,48,1), (19,48,0), (20,48,0),
										(21,48,0), (22,48,1), (23,48,0), (24,48,0), (25,48,0), (26,48,1), (27,48,0), (28,48,1), (29,48,1), (30,48,0),
										(31,48,0), (32,48,0), (33,48,1), (34,48,1), (35,48,0), (36,48,0), (37,48,0), (38,48,1), (39,48,0), (40,48,1),
										(41,48,0), (42,48,0), (43,48,1), (44,48,1), (45,48,1), (46,48,1), (47,48,1), (48,48,0), (49,48,0), (50,48,0);

INSERT INTO Funciones_Butacas VALUES	(1,57,1), (2,57,1), (3,57,0), (4,57,1), (5,57,0), (6,57,1), (7,57,1), (8,57,1), (9,57,1), (10,57,1),
										(11,57,0), (12,57,0), (13,57,1), (14,57,1), (15,57,0), (16,57,0), (17,57,1), (18,57,1), (19,57,1), (20,57,0),
										(21,57,1), (22,57,1), (23,57,1), (24,57,0), (25,57,0), (26,57,0), (27,57,0), (28,57,0), (29,57,1), (30,57,0),
										(31,57,0), (32,57,0), (33,57,1), (34,57,1), (35,57,1), (36,57,0), (37,57,0), (38,57,1), (39,57,0), (40,57,0),
										(41,57,0), (42,57,1), (43,57,0), (44,57,1), (45,57,1), (46,57,0), (47,57,0), (48,57,0), (49,57,1), (50,57,0),

										(1,6,0), (2,6,1), (3,6,0), (4,6,1), (5,6,1), (6,6,1), (7,6,0), (8,6,0), (9,6,1), (10,6,0),
										(11,6,1), (12,6,0), (13,6,0), (14,6,1), (15,6,1), (16,6,1), (17,6,0), (18,6,1), (19,6,1), (20,6,0),
										(21,6,0), (22,6,1), (23,6,0), (24,6,1), (25,6,1), (26,6,0), (27,6,0), (28,6,1), (29,6,0), (30,6,0),
										(31,6,0), (32,6,0), (33,6,0), (34,6,1), (35,6,1), (36,6,1), (37,6,1), (38,6,0), (39,6,1), (40,6,0),
										(41,6,0), (42,6,0), (43,6,1), (44,6,1), (45,6,1), (46,6,0), (47,6,1), (48,6,0), (49,6,1), (50,6,0),

										(1,15,0), (2,15,1), (3,15,0), (4,15,0), (5,15,0), (6,15,1), (7,15,0), (8,15,1), (9,15,1), (10,15,1),
										(11,15,0), (12,15,1), (13,15,0), (14,15,0), (15,15,0), (16,15,0), (17,15,0), (18,15,0), (19,15,1), (20,15,0),
										(21,15,0), (22,15,0), (23,15,0), (24,15,1), (25,15,0), (26,15,1), (27,15,0), (28,15,0), (29,15,0), (30,15,1),
										(31,15,0), (32,15,0), (33,15,0), (34,15,1), (35,15,0), (36,15,0), (37,15,1), (38,15,0), (39,15,1), (40,15,1),
										(41,15,0), (42,15,0), (43,15,1), (44,15,0), (45,15,1), (46,15,1), (47,15,1), (48,15,1), (49,15,0), (50,15,0),

										(1,18,1), (2,18,0), (3,18,0), (4,18,1), (5,18,0), (6,18,1), (7,18,1), (8,18,0), (9,18,1), (10,18,0),
										(11,18,1), (12,18,0), (13,18,0), (14,18,1), (15,18,0), (16,18,0), (17,18,0), (18,18,0), (19,18,1), (20,18,0),
										(21,18,1), (22,18,1), (23,18,0), (24,18,0), (25,18,1), (26,18,0), (27,18,0), (28,18,1), (29,18,0), (30,18,0),
										(31,18,1), (32,18,1), (33,18,1), (34,18,1), (35,18,1), (36,18,1), (37,18,1), (38,18,0), (39,18,0), (40,18,0),
										(41,18,1), (42,18,1), (43,18,1), (44,18,0), (45,18,1), (46,18,1), (47,18,0), (48,18,1), (49,18,1), (50,18,0),

										(1,27,0), (2,27,1), (3,27,0), (4,27,1), (5,27,0), (6,27,1), (7,27,0), (8,27,1), (9,27,0), (10,27,1),
										(11,27,1), (12,27,0), (13,27,1), (14,27,1), (15,27,0), (16,27,0), (17,27,0), (18,27,0), (19,27,1), (20,27,1),
										(21,27,1), (22,27,0), (23,27,1), (24,27,0), (25,27,1), (26,27,0), (27,27,0), (28,27,0), (29,27,1), (30,27,1),
										(31,27,1), (32,27,1), (33,27,1), (34,27,0), (35,27,0), (36,27,0), (37,27,0), (38,27,1), (39,27,1), (40,27,1),
										(41,27,1), (42,27,1), (43,27,0), (44,27,0), (45,27,0), (46,27,0), (47,27,0), (48,27,0), (49,27,1), (50,27,1),

										(1,36,0), (2,36,1), (3,36,0), (4,36,0), (5,36,0), (6,36,1), (7,36,0), (8,36,0), (9,36,0), (10,36,1),
										(11,36,1), (12,36,1), (13,36,1), (14,36,0), (15,36,1), (16,36,0), (17,36,1), (18,36,0), (19,36,1), (20,36,1),
										(21,36,0), (22,36,1), (23,36,1), (24,36,0), (25,36,0), (26,36,1), (27,36,0), (28,36,0), (29,36,1), (30,36,0),
										(31,36,1), (32,36,0), (33,36,0), (34,36,1), (35,36,0), (36,36,0), (37,36,0), (38,36,0), (39,36,0), (40,36,0),
										(41,36,0), (42,36,0), (43,36,1), (44,36,1), (45,36,1), (46,36,1), (47,36,0), (48,36,0), (49,36,0), (50,36,0),

										(1,45,0), (2,45,1), (3,45,0), (4,45,0), (5,45,1), (6,45,0), (7,45,0), (8,45,1), (9,45,1), (10,45,0),
										(11,45,1), (12,45,0), (13,45,1), (14,45,0), (15,45,1), (16,45,0), (17,45,1), (18,45,1), (19,45,0), (20,45,0),
										(21,45,0), (22,45,0), (23,45,0), (24,45,1), (25,45,1), (26,45,1), (27,45,0), (28,45,1), (29,45,0), (30,45,1),
										(31,45,0), (32,45,1), (33,45,0), (34,45,0), (35,45,1), (36,45,0), (37,45,0), (38,45,1), (39,45,1), (40,45,0),
										(41,45,0), (42,45,1), (43,45,0), (44,45,1), (45,45,1), (46,45,1), (47,45,1), (48,45,1), (49,45,0), (50,45,0),

										(1,54,1), (2,54,1), (3,54,0), (4,54,0), (5,54,0), (6,54,1), (7,54,0), (8,54,1), (9,54,1), (10,54,1),
										(11,54,0), (12,54,0), (13,54,0), (14,54,0), (15,54,1), (16,54,0), (17,54,1), (18,54,0), (19,54,1), (20,54,0),
										(21,54,0), (22,54,0), (23,54,0), (24,54,0), (25,54,1), (26,54,1), (27,54,0), (28,54,0), (29,54,1), (30,54,0),
										(31,54,1), (32,54,1), (33,54,0), (34,54,0), (35,54,0), (36,54,0), (37,54,0), (38,54,0), (39,54,1), (40,54,1),
										(41,54,0), (42,54,0), (43,54,0), (44,54,1), (45,54,0), (46,54,1), (47,54,0), (48,54,0), (49,54,1), (50,54,1);

INSERT INTO Funciones_Butacas VALUES	(1,60,0), (2,60,0), (3,60,0), (4,60,0), (5,60,0), (6,60,0), (7,60,1), (8,60,1), (9,60,0), (10,60,0),
										(11,60,1), (12,60,1), (13,60,1), (14,60,1), (15,60,1), (16,60,0), (17,60,1), (18,60,1), (19,60,0), (20,60,0),
										(21,60,0), (22,60,0), (23,60,1), (24,60,1), (25,60,0), (26,60,1), (27,60,1), (28,60,0), (29,60,0), (30,60,0),
										(31,60,1), (32,60,0), (33,60,0), (34,60,1), (35,60,0), (36,60,0), (37,60,1), (38,60,1), (39,60,0), (40,60,0),
										(41,60,1), (42,60,1), (43,60,0), (44,60,0), (45,60,0), (46,60,0), (47,60,0), (48,60,0), (49,60,1), (50,60,0),

										(1,8,0), (2,8,1), (3,8,1), (4,8,0), (5,8,0), (6,8,0), (7,8,1), (8,8,1), (9,8,1), (10,8,0),
										(11,8,0), (12,8,1), (13,8,1), (14,8,0), (15,8,1), (16,8,1), (17,8,0), (18,8,1), (19,8,0), (20,8,1),
										(21,8,1), (22,8,1), (23,8,1), (24,8,0), (25,8,1), (26,8,1), (27,8,0), (28,8,1), (29,8,1), (30,8,1),
										(31,8,1), (32,8,1), (33,8,0), (34,8,0), (35,8,0), (36,8,0), (37,8,1), (38,8,1), (39,8,1), (40,8,0),
										(41,8,1), (42,8,0), (43,8,1), (44,8,0), (45,8,1), (46,8,1), (47,8,0), (48,8,1), (49,8,1), (50,8,1),

										(1,20,0), (2,20,1), (3,20,1), (4,20,1), (5,20,1), (6,20,1), (7,20,0), (8,20,1), (9,20,0), (10,20,0),
										(11,20,1), (12,20,0), (13,20,1), (14,20,1), (15,20,1), (16,20,1), (17,20,1), (18,20,1), (19,20,0), (20,20,1),
										(21,20,1), (22,20,1), (23,20,0), (24,20,1), (25,20,1), (26,20,0), (27,20,0), (28,20,0), (29,20,1), (30,20,0),
										(31,20,1), (32,20,1), (33,20,1), (34,20,1), (35,20,0), (36,20,0), (37,20,1), (38,20,0), (39,20,0), (40,20,0),
										(41,20,1), (42,20,1), (43,20,1), (44,20,0), (45,20,1), (46,20,0), (47,20,0), (48,20,1), (49,20,0), (50,20,0),

										(1,23,1), (2,23,0), (3,23,1), (4,23,0), (5,23,1), (6,23,0), (7,23,1), (8,23,1), (9,23,0), (10,23,0),
										(11,23,0), (12,23,1), (13,23,0), (14,23,1), (15,23,0), (16,23,1), (17,23,0), (18,23,1), (19,23,0), (20,23,0),
										(21,23,1), (22,23,1), (23,23,0), (24,23,0), (25,23,0), (26,23,1), (27,23,0), (28,23,0), (29,23,0), (30,23,0),
										(31,23,1), (32,23,1), (33,23,1), (34,23,0), (35,23,1), (36,23,0), (37,23,0), (38,23,0), (39,23,1), (40,23,1),
										(41,23,1), (42,23,0), (43,23,1), (44,23,0), (45,23,0), (46,23,0), (47,23,1), (48,23,0), (49,23,1), (50,23,0),

										(1,32,1), (2,32,0), (3,32,0), (4,32,1), (5,32,1), (6,32,0), (7,32,0), (8,32,0), (9,32,0), (10,32,0),
										(11,32,0), (12,32,0), (13,32,0), (14,32,1), (15,32,1), (16,32,0), (17,32,0), (18,32,0), (19,32,0), (20,32,0),
										(21,32,0), (22,32,0), (23,32,1), (24,32,1), (25,32,1), (26,32,0), (27,32,1), (28,32,0), (29,32,1), (30,32,1),
										(31,32,0), (32,32,1), (33,32,0), (34,32,0), (35,32,0), (36,32,1), (37,32,1), (38,32,1), (39,32,1), (40,32,1),
										(41,32,1), (42,32,1), (43,32,1), (44,32,0), (45,32,1), (46,32,1), (47,32,0), (48,32,0), (49,32,1), (50,32,0),

										(1,41,1), (2,41,0), (3,41,0), (4,41,0), (5,41,1), (6,41,0), (7,41,0), (8,41,1), (9,41,1), (10,41,1),
										(11,41,1), (12,41,1), (13,41,1), (14,41,1), (15,41,1), (16,41,1), (17,41,1), (18,41,0), (19,41,0), (20,41,0),
										(21,41,1), (22,41,1), (23,41,0), (24,41,0), (25,41,0), (26,41,0), (27,41,0), (28,41,0), (29,41,0), (30,41,1),
										(31,41,0), (32,41,0), (33,41,0), (34,41,1), (35,41,1), (36,41,0), (37,41,1), (38,41,1), (39,41,1), (40,41,1),
										(41,41,1), (42,41,1), (43,41,1), (44,41,1), (45,41,1), (46,41,1), (47,41,0), (48,41,1), (49,41,1), (50,41,0),

										(1,50,1), (2,50,1), (3,50,1), (4,50,0), (5,50,0), (6,50,1), (7,50,1), (8,50,0), (9,50,0), (10,50,0),
										(11,50,0), (12,50,1), (13,50,1), (14,50,0), (15,50,0), (16,50,1), (17,50,1), (18,50,0), (19,50,0), (20,50,0),
										(21,50,1), (22,50,0), (23,50,0), (24,50,1), (25,50,1), (26,50,1), (27,50,1), (28,50,1), (29,50,0), (30,50,1),
										(31,50,0), (32,50,1), (33,50,0), (34,50,0), (35,50,1), (36,50,1), (37,50,1), (38,50,1), (39,50,1), (40,50,1),
										(41,50,1), (42,50,1), (43,50,1), (44,50,0), (45,50,0), (46,50,0), (47,50,0), (48,50,0), (49,50,1), (50,50,1),

										(1,62,1), (2,62,1), (3,62,1), (4,62,0), (5,62,1), (6,62,0), (7,62,0), (8,62,1), (9,62,0), (10,62,0),
										(11,62,0), (12,62,0), (13,62,0), (14,62,0), (15,62,0), (16,62,1), (17,62,1), (18,62,1), (19,62,0), (20,62,1),
										(21,62,1), (22,62,0), (23,62,1), (24,62,1), (25,62,1), (26,62,0), (27,62,0), (28,62,1), (29,62,1), (30,62,0),
										(31,62,0), (32,62,1), (33,62,1), (34,62,0), (35,62,1), (36,62,0), (37,62,0), (38,62,0), (39,62,1), (40,62,0),
										(41,62,0), (42,62,0), (43,62,1), (44,62,0), (45,62,0), (46,62,0), (47,62,1), (48,62,0), (49,62,0), (50,62,0),

										(1,9,0), (2,9,1), (3,9,0), (4,9,1), (5,9,0), (6,9,1), (7,9,0), (8,9,0), (9,9,1), (10,9,1),
										(11,9,0), (12,9,1), (13,9,0), (14,9,1), (15,9,0), (16,9,0), (17,9,0), (18,9,0), (19,9,0), (20,9,0),
										(21,9,1), (22,9,0), (23,9,0), (24,9,0), (25,9,0), (26,9,0), (27,9,1), (28,9,0), (29,9,0), (30,9,1),
										(31,9,1), (32,9,1), (33,9,1), (34,9,0), (35,9,0), (36,9,0), (37,9,1), (38,9,0), (39,9,1), (40,9,0),
										(41,9,1), (42,9,0), (43,9,0), (44,9,1), (45,9,1), (46,9,1), (47,9,1), (48,9,0), (49,9,1), (50,9,0),
										(51,9,0), (52,9,0), (53,9,0), (54,9,0), (55,9,0), (56,9,0), (57,9,0), (58,9,0), (59,9,1), (60,9,0),

										(1,21,0), (2,21,1), (3,21,1), (4,21,1), (5,21,0), (6,21,1), (7,21,1), (8,21,0), (9,21,1), (10,21,1),
										(11,21,0), (12,21,0), (13,21,0), (14,21,1), (15,21,1), (16,21,0), (17,21,1), (18,21,0), (19,21,1), (20,21,0),
										(21,21,1), (22,21,1), (23,21,0), (24,21,0), (25,21,1), (26,21,1), (27,21,0), (28,21,1), (29,21,0), (30,21,0),
										(31,21,1), (32,21,1), (33,21,0), (34,21,1), (35,21,1), (36,21,0), (37,21,1), (38,21,1), (39,21,1), (40,21,1),
										(41,21,1), (42,21,0), (43,21,1), (44,21,1), (45,21,1), (46,21,0), (47,21,0), (48,21,1), (49,21,0), (50,21,1),
										(51,21,1), (52,21,0), (53,21,1), (54,21,0), (55,21,1), (56,21,1), (57,21,0), (58,21,0), (59,21,1), (60,21,0),

										(1,24,1), (2,24,1), (3,24,0), (4,24,1), (5,24,1), (6,24,1), (7,24,1), (8,24,0), (9,24,1), (10,24,1),
										(11,24,0), (12,24,1), (13,24,1), (14,24,1), (15,24,1), (16,24,1), (17,24,0), (18,24,0), (19,24,1), (20,24,1),
										(21,24,1), (22,24,0), (23,24,1), (24,24,0), (25,24,0), (26,24,1), (27,24,1), (28,24,1), (29,24,1), (30,24,1),
										(31,24,1), (32,24,1), (33,24,0), (34,24,1), (35,24,1), (36,24,1), (37,24,1), (38,24,1), (39,24,1), (40,24,1),
										(41,24,0), (42,24,0), (43,24,0), (44,24,1), (45,24,1), (46,24,0), (47,24,0), (48,24,0), (49,24,0), (50,24,0),
										(51,24,1), (52,24,1), (53,24,1), (54,24,1), (55,24,1), (56,24,0), (57,24,1), (58,24,1), (59,24,1), (60,24,1),

										(1,33,0), (2,33,1), (3,33,1), (4,33,0), (5,33,1), (6,33,0), (7,33,1), (8,33,1), (9,33,0), (10,33,1),
										(11,33,1), (12,33,1), (13,33,0), (14,33,0), (15,33,1), (16,33,0), (17,33,0), (18,33,1), (19,33,1), (20,33,0),
										(21,33,0), (22,33,1), (23,33,1), (24,33,1), (25,33,0), (26,33,1), (27,33,1), (28,33,1), (29,33,0), (30,33,1),
										(31,33,1), (32,33,1), (33,33,1), (34,33,1), (35,33,1), (36,33,1), (37,33,1), (38,33,0), (39,33,1), (40,33,1),
										(41,33,1), (42,33,0), (43,33,1), (44,33,1), (45,33,1), (46,33,0), (47,33,0), (48,33,1), (49,33,1), (50,33,0),
										(51,33,0), (52,33,1), (53,33,0), (54,33,1), (55,33,0), (56,33,1), (57,33,0), (58,33,0), (59,33,1), (60,33,0),

										(1,42,0), (2,42,0), (3,42,0), (4,42,0), (5,42,0), (6,42,0), (7,42,1), (8,42,1), (9,42,1), (10,42,0),
										(11,42,0), (12,42,0), (13,42,0), (14,42,1), (15,42,1), (16,42,0), (17,42,0), (18,42,0), (19,42,1), (20,42,1),
										(21,42,0), (22,42,0), (23,42,1), (24,42,1), (25,42,0), (26,42,1), (27,42,1), (28,42,0), (29,42,1), (30,42,1),
										(31,42,0), (32,42,1), (33,42,0), (34,42,1), (35,42,1), (36,42,1), (37,42,0), (38,42,0), (39,42,0), (40,42,1),
										(41,42,1), (42,42,0), (43,42,1), (44,42,0), (45,42,0), (46,42,1), (47,42,0), (48,42,0), (49,42,0), (50,42,1),
										(51,42,0), (52,42,0), (53,42,0), (54,42,0), (55,42,0), (56,42,1), (57,42,1), (58,42,1), (59,42,0), (60,42,1),

										(1,51,0), (2,51,0), (3,51,0), (4,51,0), (5,51,1), (6,51,1), (7,51,0), (8,51,0), (9,51,0), (10,51,0),
										(11,51,1), (12,51,1), (13,51,0), (14,51,0), (15,51,0), (16,51,0), (17,51,1), (18,51,0), (19,51,1), (20,51,1),
										(21,51,1), (22,51,0), (23,51,0), (24,51,0), (25,51,0), (26,51,1), (27,51,1), (28,51,0), (29,51,1), (30,51,0),
										(31,51,0), (32,51,0), (33,51,0), (34,51,0), (35,51,1), (36,51,1), (37,51,1), (38,51,1), (39,51,0), (40,51,0),
										(41,51,0), (42,51,0), (43,51,1), (44,51,1), (45,51,1), (46,51,1), (47,51,0), (48,51,0), (49,51,1), (50,51,1),
										(51,51,0), (52,51,1), (53,51,0), (54,51,1), (55,51,1), (56,51,1), (57,51,1), (58,51,1), (59,51,0), (60,51,0),

										(1,63,0), (2,63,1), (3,63,1), (4,63,1), (5,63,1), (6,63,0), (7,63,0), (8,63,0), (9,63,1), (10,63,0),
										(11,63,0), (12,63,1), (13,63,1), (14,63,1), (15,63,0), (16,63,0), (17,63,1), (18,63,0), (19,63,1), (20,63,1),
										(21,63,1), (22,63,0), (23,63,0), (24,63,1), (25,63,1), (26,63,0), (27,63,1), (28,63,0), (29,63,1), (30,63,0),
										(31,63,1), (32,63,1), (33,63,0), (34,63,1), (35,63,1), (36,63,0), (37,63,1), (38,63,0), (39,63,0), (40,63,1),
										(41,63,0), (42,63,0), (43,63,0), (44,63,0), (45,63,1), (46,63,1), (47,63,1), (48,63,1), (49,63,1), (50,63,1),
										(51,63,1), (52,63,0), (53,63,1), (54,63,1), (55,63,0), (56,63,1), (57,63,0), (58,63,0), (59,63,0), (60,63,1);

-- Comprobación inserción de datos
SELECT * FROM Funciones_Butacas;


INSERT INTO Clientes VALUES ('Lionel Messi', '1234'), ('Paulo Dybala','1234'), ('Ángel Di María','1234'), ('Kylian Mbappé', '5678');
-- Comprobación inserción de datos
SELECT * FROM Clientes;


INSERT INTO Planes VALUES ('Gratuito', 'Acceso restringido a 10 películas por mes', 0.0, 0.0), ('Premium', 'Acceso a algunas películas en cartelera', 2000.00, 18000.00), ('Familiar', 'Incluye las películas del plan premium, y peliculas infantiles', 2500.00, 18500.00);
-- Comprobación inserción de datos
SELECT * FROM Planes;


INSERT INTO Peliculas_Planes VALUES (11, 1), (12, 1), (13,1), (14,1), (15,1), (16,1), (17,1), (18,1), (19,1), (20,1),
										(1,2), (2,2), (3,2), (7,2), (5,2), (11, 2), (12, 2), (13,2), (14,2), (15,2), (16,2), (17,2), (18,2), (19,2), (20,2),
										(1,3), (2,3), (3,3), (4,3), (5,3), (6,3), (7,3), (11, 3), (12, 3), (13,3), (14,3), (15,3), (16,3), (17,3), (18,3), (19,3), (20,3);
-- Comprobación inserción de datos
SELECT * FROM Peliculas_Planes;


INSERT INTO Suscripciones VALUES (1, 1, 1, 3), (0, 1, 2, 1), (0, 1, 3, 3), (0, 1, 4, 2);
-- Comprobación inserción de datos
SELECT * FROM Suscripciones;


INSERT INTO Pagos VALUES ('2022-01-02', 1, 1), ('2021-01-02', 1, 1), 
						('2022-01-05', 3, 3), ('2022-02-04', 3, 3), ('2022-03-05', 3, 3), ('2022-04-05', 3, 3), ('2022-05-05', 3, 3), ('2022-06-05', 3, 3), ('2022-07-05', 3, 3), ('2022-08-05', 3, 3), ('2022-09-05', 3, 3), ('2022-10-05', 3, 3), ('2022-11-05', 3, 3), ('2022-12-04', 3, 3),
						('2021-08-07', 4, 4), ('2021-09-07', 4, 4), ('2021-10-07', 4, 4);
-- Comprobación inserción de datos
SELECT * FROM Pagos;


GO