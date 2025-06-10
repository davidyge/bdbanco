-- 1. CONSULTAS
-- 1 Mostrar el saldo total que maneja cada cliente, detallar nombres y ordenadar saldo de manera descendente.
SELECT c.id_cliente, c.nombre + ' ' + c.Apellido AS Cliente, SUM(cu.saldo) AS SaldoTotal 
FROM 
Cliente c JOIN Cuenta cu ON c.id_cliente = cu.id_cliente 
GROUP BY 
c.id_cliente, c.nombre, c.Apellido ORDER BY SaldoTotal DESC;

-- 2 ¿Qué contratos tienen cuotas vencidas y cuántos días de atraso suman los clientes?
SELECT csd.id_contrato, c.nombre + ' ' + c.apellido AS Cliente, 
    COUNT(*) AS CuotasVencidas, SUM(DATEDIFF(DAY, csd.fecha_programada, GETDATE())) AS DiasAtraso 
FROM
    ContratoServicioDet csd JOIN 
    ContratoServicio cs ON csd.id_contrato = cs.id_contrato JOIN Cliente c ON cs.id_cliente = c.id_cliente 
WHERE csd.estado_cuota IN ('Pendiente','Atrasado') AND csd.fecha_programada < GETDATE()
GROUP BY csd.id_contrato, c.nombre, c.apellido;

--3 Mostrar las 3 agencias con mayor monto contratado activo de forma descendente
SELECT TOP (3) a.id_agencia, a.nombre_agencia, SUM(cs.monto_contratado) AS TotalActivo 
FROM 
Agencia a JOIN ContratoServicio cs ON a.id_agencia = cs.id_agencia 
WHERE cs.estado_contrato = 'Activo' GROUP BY a.id_agencia, a.nombre_agencia ORDER BY TotalActivo DESC;

--4 Mostar clientes sin movimientos en sus cuentas en los últimos 60 días
SELECT DISTINCT c.id_cliente, c.nombre, c.Apellido 
FROM 
Cliente c JOIN Cuenta cu ON c.id_cliente = cu.id_cliente 
LEFT JOIN TransaccionesCuenta t ON cu.id_cuenta = t.id_cuenta AND t.fecha >= DATEADD(DAY,-60,GETDATE()) 
WHERE t.id_transacciones IS NULL;

--5 Mostral el cliente que realizo el prestamo más alto entre los demás
SELECT TOP 1 c.nombre, c.apellido,  cs.monto_contratado
FROM 
    ContratoServicio cs JOIN 
    Cliente c ON cs.id_cliente = c.id_cliente
ORDER BY cs.monto_contratado DESC;

-- 6 Muestra el nombre del cliente y la cantidad de cuentas que tiene
SELECT c.nombre, c.apellido,
    COUNT(ct.id_cuenta) AS cantidad_cuentas
FROM Cliente c LEFT JOIN Cuenta ct ON c.id_cliente = ct.id_cliente
GROUP BY c.nombre, c.apellido;

-- 7 Mostrar las agencias que tienen más contratos de servicios activos de manera descentente
SELECT a.nombre_agencia, COUNT(cs.id_contrato) AS contratos_activos
FROM Agencia a JOIN ContratoServicio cs ON a.id_agencia = cs.id_agencia
WHERE cs.estado_contrato = 'Activo' 
GROUP BY a.nombre_agencia
ORDER BY contratos_activos DESC;

--8 Mostrar el total pagado por cada cliente en sus contratos de servicio
SELECT c.nombre, c.apellido, SUM(p.monto_pagado) AS total_pagado
FROM Cliente c
JOIN ContratoServicio cs ON c.id_cliente = cs.id_cliente
JOIN PagoServicio p ON cs.id_contrato = p.id_contrato
GROUP BY c.nombre, c.apellido;
	SELECT * FROM PagoServicio;
	SELECT * FROM ContratoServicioDet;

--9 Mostrar la transacción más reciente registrada en el sistema
SELECT TOP 1 tc.id_transacciones, tc.fecha, tc.tipo_transaccion, tc.monto, c.nombre, c.apellido
FROM TransaccionesCuenta tc
JOIN 
    Cuenta ct ON tc.id_cuenta = ct.id_cuenta
JOIN 
    Cliente c ON ct.id_cliente = c.id_cliente
ORDER BY 
    tc.fecha DESC;

--10 Mostrar el servicio financiero tiene la tasa de interés más alta
SELECT TOP 1 
    nombre_servicio,
    tipo_servicio,
    tasa_interes
FROM 
    ServiciosFinancieros
ORDER BY 
    tasa_interes DESC;

SELECT * FROM ServiciosFinancieros;

-- FUNCIONES

--11 Crea una funcion para mostrar el saldo total de un cliente recibiendo el parametro idcliente 
CREATE OR ALTER FUNCTION fn_SaldoCliente (@IdCliente INT)
RETURNS 
DECIMAL(10,2)
AS
BEGIN
    RETURN (SELECT SUM(saldo) FROM Cuenta WHERE id_cliente = @IdCliente);
END;

SELECT dbo.fn_SaldoCliente(1) AS 'Saldo';

--12  Mostrar el monto pendiente de un contrato a traves del id contrato
CREATE OR ALTER FUNCTION fn_MontoPendienteContrato (@IdContrato INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @pendiente DECIMAL(10,2);
    SELECT @pendiente  = cs.monto_contratado - ISNULL(SUM(ps.monto_pagado),0)
    FROM ContratoServicio cs
    LEFT JOIN PagoServicio ps ON cs.id_contrato = ps.id_contrato
    WHERE cs.id_contrato = @IdContrato
    GROUP BY cs.monto_contratado;
    RETURN ISNULL(@pendiente,0);
END;
SELECT id_contrato,dbo.fn_MontoPendienteContrato(id_contrato) AS 'moto_pendiente' FROM ContratoServicio;
SELECT * FROM Cuenta;
-- 13 Cree una funcion para calcular el saldo total de una cuenta sumando depósitos y restando retiros
CREATE OR ALTER FUNCTION fn_SaldoCuenta (@IdCuenta INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Saldo DECIMAL(10, 2);

    SELECT @Saldo = ISNULL(SUM(
        CASE 
            WHEN tipo_transaccion = 'Depósito' THEN monto
            WHEN tipo_transaccion = 'Retiro' THEN -monto
            ELSE 0
        END
    ), 0)
    FROM TransaccionesCuenta
    WHERE id_cuenta = @IdCuenta;
    RETURN @Saldo;
END;
SELECT * FROM TransaccionesCuenta;
SELECT dbo.fn_SaldoCuenta(1) AS saldo;

--14  Cree una funcion y muestra el número total de transacciones de cada cuenta y de cada cliente
CREATE OR ALTER FUNCTION fn_TotalTransxPorCuentaCliente()
RETURNS TABLE
AS
RETURN (
    SELECT 
        cl.id_cliente,
        cl.nombre + ' ' + cl.apellido AS nombre_completo,
        c.id_cuenta, c.tipo_cuenta,
        COUNT(t.id_transacciones) AS total_transacciones
    FROM Cliente cl
    INNER JOIN Cuenta c ON cl.id_cliente = c.id_cliente
    LEFT JOIN TransaccionesCuenta t ON c.id_cuenta = t.id_cuenta
    GROUP BY cl.id_cliente, cl.nombre, cl.apellido, c.id_cuenta, c.tipo_cuenta
);
SELECT * FROM fn_TotalTransxPorCuentaCliente();

SELECT c.id_cuenta, c.tipo_cuenta, dbo.fn_TotalTransxCuenta(c.id_cuenta) AS 'total_transacciones'
FROM Cuenta c;

--15 Crear una función para mostrar las cuotas pagadas y cuotas pendientes a traves de un id_contrato
CREATE OR ALTER FUNCTION fn_ResumenCuotasContrato (@IdContrato INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        @IdContrato AS id_contrato,
        COUNT(DISTINCT ps.id_contratoDet) AS cuotas_pagadas,
        (
            SELECT COUNT(*) 
            FROM ContratoServicioDet 
            WHERE id_contrato = @IdContrato
        ) - COUNT(DISTINCT ps.id_contratoDet) AS cuotas_pendientes
    FROM PagoServicio ps
    INNER JOIN ContratoServicioDet csd ON ps.id_contratoDet = csd.id_contratoDet
    WHERE csd.id_contrato = @IdContrato
);
SELECT * FROM dbo.fn_ResumenCuotasContrato(1);
SELECT * FROM ContratoServicioDet WHERE id_contrato=1;

-- PROCEDIMIENTOS ALMACENADOS
--16  Crea un procedure para mostrar los días de atraso de un cliente a traves del Id cliente
CREATE OR ALTER PROCEDURE sp_DiasAtrasoPorCliente
    @id_cliente INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.id_cliente,
        c.nombre + ' ' + c.apellido AS nombre_completo,
        cs.id_contrato,
        csd.nro_cuota,
        csd.fecha_programada,
        ps.fecha_pago,
        DATEDIFF(DAY, csd.fecha_programada, ISNULL(ps.fecha_pago, GETDATE())) AS dias_atraso
    FROM Cliente c
    INNER JOIN ContratoServicio cs ON cs.id_cliente = c.id_cliente
    INNER JOIN ContratoServicioDet csd ON cs.id_contrato = csd.id_contrato
    LEFT JOIN PagoServicio ps ON ps.id_contratoDet = csd.id_contratoDet
    WHERE c.id_cliente = @id_cliente
      AND DATEDIFF(DAY, csd.fecha_programada, ISNULL(ps.fecha_pago, GETDATE())) > 0
    ORDER BY cs.id_contrato, csd.nro_cuota;
END;

EXEC sp_DiasAtrasoPorCliente @id_cliente = 1;

--17  Crear un procedimiento que muestre el resumen financiero de un cliente donde muestre su saldo total 
-- y la cantidad de contratos activos.
CREATE OR ALTER PROCEDURE sp_ResumenCliente @IdCliente INT
AS
BEGIN
    SELECT 'SaldoTotal' AS Indicador, dbo.fn_SaldoCliente(@IdCliente) AS Valor
    UNION ALL
    SELECT 'ContratosActivos', 
           CAST((SELECT COUNT(*) 
                 FROM ContratoServicio 
                 WHERE id_cliente = @IdCliente AND estado_contrato = 'Activo') AS INT);
END;

EXEC sp_ResumenCliente @idCliente = 1;
SELECT * FROM Cuenta where id_cliente=1;
SELECT * FROM ContratoServicio where id_cliente=1;

--18  Crear un procedimiento para depositar en cuenta y generar transacción
-- mostrar antes y despues de la operación
CREATE OR ALTER PROCEDURE sp_DepositoCuenta
    @IdCuenta INT,
    @Monto  DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Cuenta SET saldo += @Monto WHERE id_cuenta = @IdCuenta;

    INSERT INTO TransaccionesCuenta(id_transacciones,id_cuenta, fecha, tipo_transaccion, monto)
    VALUES (31,@IdCuenta, SYSDATETIME(), 'Depósito', @Monto);
END;
EXEC sp_DepositoCuenta @IdCuenta = 1, @Monto = 300.00;
SELECT * FROM Cuenta;
SELECT * FROM TransaccionesCuenta

-- //////////////////////////// DISPARADORES /////////////////////////////////////////
/*19 Cree un trigger llamado trg_GenerarCuotas que, al insertar un nuevo préstamo en la tabla Prestamos, 
genere automáticamente los pagos mensuales (cuotas) del cliente, distribuyendo el monto total (con interés)
en partes iguales durante el plazo del préstamo.
*/
ALTER TRIGGER trg_GenerarCuotas
ON ContratoServicio
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT,
            @id_contrato INT,
            @plazo INT,
            @monto DECIMAL(10,2),
            @cuota DECIMAL(10,2),
            @fecha_inicio DATE,
            @id_servicio INT,
            @tasa_interes DECIMAL(5,2),
            @monto_total DECIMAL(10,2);

    -- Cursor para recorrer los contratos insertados
    DECLARE contrato_cursor CURSOR FOR
        SELECT id_contrato, plazo_meses, monto_contratado, fecha_inicio, id_servicio
        FROM inserted;

    OPEN contrato_cursor;

    FETCH NEXT FROM contrato_cursor INTO @id_contrato, @plazo, @monto, @fecha_inicio, @id_servicio;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Obtener tasa de interés desde ServiciosFinancieros
        SELECT @tasa_interes = tasa_interes
        FROM ServiciosFinancieros
        WHERE id_servicio = @id_servicio;

        -- Calcular monto total con interés simple proporcional al plazo
        SET @monto_total = @monto * (1 + (@tasa_interes / 100.0));

        -- Calcular monto de cada cuota
        SET @cuota = ROUND(@monto_total / @plazo, 2);
        SET @i = 1;

        WHILE @i <= @plazo
        BEGIN
            INSERT INTO ContratoServicioDet (
                id_contrato, nro_cuota, fecha_programada, monto_cuota, estado_cuota, fecha_pagada
            )
            VALUES (
                @id_contrato,
                @i,
                DATEADD(MONTH, @i, @fecha_inicio),
                @cuota,
                'Pendiente',
                NULL
            );

            SET @i = @i + 1;
        END;

        FETCH NEXT FROM contrato_cursor INTO @id_contrato, @plazo, @monto, @fecha_inicio, @id_servicio;
    END;

    CLOSE contrato_cursor;
    DEALLOCATE contrato_cursor;
END;

/*
20 Crear un trigger para actualizar automáticamente el estado de una cuota como "Pagado" y registrar la fecha del pago.
*/
CREATE TRIGGER trg_ActualizarCuotaPagada
ON PagoServicio
AFTER INSERT
AS
BEGIN
    -- Actualiza la cuota correspondiente como Pagado
    UPDATE csd
    SET 
        csd.estado_cuota = 'Pagado',
        csd.fecha_pagada = i.fecha_pago
    FROM ContratoServicioDet csd
    INNER JOIN inserted i ON csd.id_contratoDet = i.id_contratoDet;
END;
