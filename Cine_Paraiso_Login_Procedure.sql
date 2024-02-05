-- Trabajo Práctico N° 2
-- 4. Cree un procedimiento almacenado que reciba como parámetros un usuario y una contraseña,
-- y devuelva 1 si el login es correcto (es decir, coincide usuario, contraseña, y el plan está activo)
-- y 0 en cualquier otro caso.
USE CineParaiso;
GO
CREATE PROCEDURE usp_login_correcto (@user VARCHAR(20), @password VARCHAR(10))
AS
BEGIN
	DECLARE @login_correcto BIT
	DECLARE @id_user INT
	SET @login_correcto = 0

		IF EXISTS (SELECT Clientes.usuario, Clientes.contrasenia from Clientes where Clientes.usuario = @user and Clientes.contrasenia = @password)
			SET @id_user = (SELECT Clientes.cliente_id FROM Clientes WHERE Clientes.usuario = @user AND Clientes.contrasenia = @password)
			IF (SELECT Suscripciones.estado FROM Suscripciones WHERE Suscripciones.cliente_id = @id_user) = 1
				SET @login_correcto = 1

	RETURN @login_correcto

END;
GO

DECLARE @Return1 INT
EXEC @Return1 = usp_login_correcto 'Lionel Messi', '1234'
SELECT @Return1 AS login_correcto;
GO
DECLARE @Return2 INT
EXEC @Return2 = usp_login_correcto 'Kylian Mbappé', '5678'
SELECT @Return2 AS login_correcto;
GO