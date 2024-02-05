-- Trabajo Práctico N° 2

-- 3. Suponga que se desea verificar mensualmente si los planes de cada uno de los usuarios están
-- al día con los pagos y, en función de eso, actualizar el plan como activo o inactivo. Cree el
-- procedimiento almacenado correspondiente, y proponga los criterios a tener en cuenta para
-- pasar un plan de activo a inactivo.

-- Criterios para mantener activo el plan:
--	Premium o familiar mensual:
--		- Tener efectuado el pago mensual como máximo el día 20 de cada mes
--  Premium o familiar anual:
--		- No debe haber pasado 1 año (12 meses) desde la contratación anual más reciente y hay tiempo hasta el día 20
USE CineParaiso;
GO
CREATE PROCEDURE usp_verificar_pagos_y_actualizar_usuarios
AS
BEGIN

	DECLARE @client_id INT
	DECLARE @es_suscripcion_anual BIT
	DECLARE @fecha_pago DATE
	DECLARE @dia_limite_pago TINYINT
	DECLARE @fecha_de_revision DATE
	DECLARE @plan_de_la_suscripcion INT
	DECLARE @id_premium INT
	DECLARE @id_familiar INT
	SET @fecha_de_revision = CAST(GETDATE() AS DATE)
	SET @dia_limite_pago = 20
	SET @id_premium = (SELECT Planes.plan_id FROM Planes WHERE Planes.nombre = 'Premium')
	SET @id_familiar = (SELECT Planes.plan_id FROM Planes WHERE Planes.nombre = 'Familiar')
	

	DECLARE verificar_pago_por_usuario CURSOR
	FOR SELECT Clientes.cliente_id
		FROM Clientes;

	OPEN verificar_pago_por_usuario
	FETCH NEXT FROM verificar_pago_por_usuario
	INTO @client_id
		
	WHILE @@FETCH_STATUS = 0  
		BEGIN
				SET @plan_de_la_suscripcion = (SELECT Suscripciones.plan_id FROM Suscripciones WHERE Suscripciones.cliente_id = @client_id)
				IF (SELECT Suscripciones.anual FROM Suscripciones WHERE Suscripciones.cliente_id = @client_id) = 0 
				AND ((@plan_de_la_suscripcion = @id_premium) OR (@plan_de_la_suscripcion = @id_familiar))
					SET @fecha_pago = (SELECT TOP 1 Pagos.fecha FROM Pagos WHERE Pagos.cliente_id = @client_id ORDER BY Pagos.fecha DESC)
			
					IF YEAR(@fecha_pago) = YEAR(@fecha_de_revision)
					-- Si el mes de la u´ltima fecha de pago y el de la revision son el mismo. En caso de que la fecha de pago fuera posterior al día 20. Estado inactivo
						IF MONTH(@fecha_pago) = MONTH(@fecha_de_revision)
							IF DAY(@fecha_pago) > @dia_limite_pago
								UPDATE Suscripciones
								SET estado = 0
								WHERE Suscripciones.cliente_id = @client_id
						-- Si el mes de la última fecha de pago es anterior al de revision
						ELSE IF MONTH(@fecha_pago) < MONTH(@fecha_de_revision)
							-- Si es solo un mes antes, comprobar el dia de la fecha de revision. Si es mayor a 20, estado inactivo
							IF (MONTH(@fecha_de_revision) - MONTH(@fecha_pago)) = 1
								IF DAY(@fecha_de_revision) > @dia_limite_pago
									UPDATE Suscripciones
									SET estado = 0
									WHERE Suscripciones.cliente_id = @client_id
							-- Si se pasa en más de un mes en su última fecha de pago con respecto al mes actual, estado inactivo
							ELSE IF (MONTH(@fecha_de_revision) - MONTH(@fecha_pago)) > 1
								UPDATE Suscripciones
								SET estado = 0
								WHERE Suscripciones.cliente_id = @client_id

					IF YEAR(@fecha_pago) < YEAR(@fecha_de_revision)
						IF (DATEDIFF(DAY, @fecha_pago, @fecha_de_revision)) > 30 AND DAY(@fecha_de_revision) > @dia_limite_pago
							UPDATE Suscripciones
							SET estado = 0
							WHERE Suscripciones.cliente_id = @client_id

				IF (SELECT Suscripciones.anual FROM Suscripciones WHERE Suscripciones.cliente_id = @client_id) = 1
				AND ((@plan_de_la_suscripcion = @id_premium) OR (@plan_de_la_suscripcion = @id_familiar))
					SET @fecha_pago = (SELECT TOP 1 Pagos.fecha FROM Pagos WHERE Pagos.cliente_id = @client_id ORDER BY Pagos.fecha DESC)
			
					IF DATEDIFF(MONTH, @fecha_pago, @fecha_de_revision) > 12
						UPDATE Suscripciones
						SET estado = 0
						WHERE Suscripciones.cliente_id = @client_id
					ELSE IF DATEDIFF(MONTH, @fecha_pago, @fecha_de_revision) = 12 AND (DAY(@fecha_de_revision)) > @dia_limite_pago
						UPDATE Suscripciones
						SET estado = 0
						WHERE Suscripciones.cliente_id = @client_id

			FETCH NEXT FROM verificar_pago_por_usuario
			INTO @client_id
		
		END
	CLOSE verificar_pago_por_usuario;  
	DEALLOCATE verificar_pago_por_usuario; 

END
GO

EXECUTE usp_verificar_pagos_y_actualizar_usuarios;
SELECT * FROM Suscripciones;
GO

