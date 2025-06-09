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

SELECT * FROM TransaccionesCuenta;

--5 Rentabilidad por tipo de servicio (contratado vs. cobrado)
SELECT sf.nombre_servicio, SUM(cs.monto_contratado) AS Contratado, SUM(ISNULL(ps.monto_pagado,0)) AS Cobrado 
FROM 
ServiciosFinancieros sf JOIN ContratoServicio cs ON sf.id_servicio = cs.id_servicio 
LEFT JOIN PagoServicio ps ON cs.id_contrato = ps.id_contrato GROUP BY sf.nombre_servicio ORDER BY Contratado DESC;

-- FUNCIONES
--6 Crea una funcion para mostrar el saldo total de un cliente recibiendo el parametro idcliente 
CREATE OR ALTER FUNCTION fn_SaldoCliente (@IdCliente INT)
RETURNS 
MONEY
AS
BEGIN
    RETURN (SELECT SUM(saldo) FROM Cuenta WHERE id_cliente = @IdCliente);
END;

SELECT dbo.fn_SaldoCliente(1);

--7  Mostrar el monto pendiente de un contrato a traves del id contrato
CREATE OR ALTER FUNCTION fn_MontoPendienteContrato (@IdContrato INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @pendiente MONEY;
    SELECT @pendiente  = cs.monto_contratado - ISNULL(SUM(ps.monto_pagado),0)
    FROM ContratoServicio cs
    LEFT JOIN PagoServicio ps ON cs.id_contrato = ps.id_contrato
    WHERE cs.id_contrato = @IdContrato
    GROUP BY cs.monto_contratado;
    RETURN ISNULL(@pendiente,0);
END;
SELECT estado_contrato, dbo.fn_MontoPendienteContrato(id_contrato) AS 'moto_prestado' FROM ContratoServicio

--8  Mostrar los días de atraso de un pago a traves del id pago
-- AGREGAR ISNULL
CREATE OR ALTER FUNCTION fn_DiasAtrasoPago (@IdPago INT)
RETURNS INT
AS
BEGIN
    DECLARE @dias INT;
    SELECT @dias = DATEDIFF(DAY, fecha_pago, GETDATE())
    FROM PagoServicio WHERE id_pago = @IdPago;
    RETURN ISNULL(@dias,-1)
END;
SELECT id_pago, estado_pago,
  CASE 
    WHEN dbo.fn_DiasAtrasoPago(id_pago) = -1 AND  THEN 'Sin pago'
    ELSE CAST(dbo.fn_DiasAtrasoPago(id_pago) AS VARCHAR)
  END AS Dias_atraso
FROM PagoServicio;
SELECT estado_pago, dbo.fn_DiasAtrasoPago(1) AS 'Dias_atraso' FROM PagoServicio;

--9  Número total de transacciones de una cuenta 
CREATE OR ALTER FUNCTION fn_TotalTransxCuenta (@IdCuenta INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM TransaccionesCuenta WHERE id_cuenta = @IdCuenta);
END;
GO

--10  Estado lógico del contrato (Activo|Saldado)
CREATE OR ALTER FUNCTION fn_EstadoLogicoContrato (@IdContrato INT)
RETURNS VARCHAR(20)
AS
BEGIN
    IF dbo.fn_MontoPendienteContrato(@IdContrato) = 0
        RETURN 'Saldado';
    RETURN (SELECT estado_contrato FROM ContratoServicio WHERE id_contrato = @IdContrato);
END;
GO

-- PROCEDIMIENTOS ALMACENADOS
--11  Registrar un pago y actualizar estado
CREATE OR ALTER PROC sp_RegistrarPago
    @IdContrato  INT,
    @FechaPago   DATE,
    @Monto       MONEY,
    @NroCuota    INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PagoServicio (id_contrato, fecha_pago, monto_pagado, nro_cuota, estado_pago)
    VALUES (@IdContrato, @FechaPago, @Monto, @NroCuota, 'Pagado');

    IF dbo.fn_MontoPendienteContrato(@IdContrato) = 0
        UPDATE ContratoServicio SET estado_contrato = 'Saldado'
        WHERE id_contrato = @IdContrato;
END;


--12  Resumen financiero de un cliente 
CREATE OR ALTER PROC sp_ResumenCliente @IdCliente INT
AS
BEGIN
    SELECT 'SaldoTotal' AS Indicador, dbo.fn_SaldoCliente(@IdCliente) AS Valor
    UNION ALL
    SELECT 'ContratosActivos', COUNT(*) 
    FROM ContratoServicio 
    WHERE id_cliente = @IdCliente AND estado_contrato = 'Activo';
END;
GO

--13  Depositar en cuenta y generar transacción 
CREATE OR ALTER PROC sp_DepositoCuenta
    @IdCuenta INT,
    @Monto    MONEY
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Cuenta SET saldo += @Monto WHERE id_cuenta = @IdCuenta;

    INSERT INTO TransaccionesCuenta (id_cuenta, fecha, tipo_transaccion, monto)
    VALUES (@IdCuenta, SYSDATETIME(), 'Depósito', @Monto);
END;
GO

-- 14  Cerrar un contrato manualmente (cambia a Cancelado) 
CREATE OR ALTER PROC sp_CerrarContrato @IdContrato INT
AS
BEGIN
    UPDATE ContratoServicio
    SET estado_contrato = 'Cancelado'
    WHERE id_contrato = @IdContrato;
END;
GO

-- 15  Reporte de operaciones de una agencia en un rango 
CREATE OR ALTER PROC sp_ReporteAgencia
    @IdAgencia INT,
    @FechaIni  DATE,
    @FechaFin  DATE
AS
BEGIN
    -- Contratos generados
    SELECT 'Contratos Nuevos' AS Concepto, COUNT(*) AS Total
    FROM ContratoServicio
    WHERE id_agencia = @IdAgencia
      AND fecha_inicio BETWEEN @FechaIni AND @FechaFin;

    -- Transacciones
    SELECT 'Transacciones' AS Concepto, COUNT(*) AS Total
    FROM TransaccionesCuenta t
    JOIN Cuenta cu ON t.id_cuenta = cu.id_cuenta
    WHERE cu.id_agencia = @IdAgencia
      AND t.fecha BETWEEN @FechaIni AND @FechaFin;
END;


-- FUNCIONES CON VALORES DE TABLAS
--16  Historial completo de pagos por contrato 
CREATE OR ALTER FUNCTION tvf_HistorialPagosContrato (@IdContrato INT)
RETURNS TABLE
AS
RETURN (
    SELECT id_pago, fecha_pago, monto_pagado, nro_cuota, estado_pago
    FROM PagoServicio
    WHERE id_contrato = @IdContrato
);

--17  Todas las cuentas de un cliente 
CREATE OR ALTER FUNCTION tvf_CuentasCliente (@IdCliente INT)
RETURNS TABLE
AS
RETURN (
    SELECT id_cuenta, tipo_cuenta, saldo, fecha_creacion
    FROM Cuenta
    WHERE id_cliente = @IdCliente
);

--18  Contratos de un cliente con pendiente calculado 
CREATE OR ALTER FUNCTION tvf_ContratosCliente (@IdCliente INT)
RETURNS TABLE
AS
RETURN (
    SELECT cs.id_contrato,
           cs.estado_contrato,
           cs.monto_contratado,
           dbo.fn_MontoPendienteContrato(cs.id_contrato) AS MontoPendiente
    FROM ContratoServicio cs
    WHERE cs.id_cliente = @IdCliente
);

--19  Transacciones en un periodo con datos del cliente 
CREATE OR ALTER FUNCTION tvf_TransaccionesPeriodo (@Desde DATE, @Hasta DATE)
RETURNS TABLE
AS
RETURN (
    SELECT t.id_transacciones,
           t.fecha,
           t.tipo_transaccion,
           t.monto,
           c.nombre + ' ' + c.Apellido AS Cliente
    FROM TransaccionesCuenta t
    JOIN Cuenta cu ON t.id_cuenta = cu.id_cuenta
    JOIN Cliente c ON cu.id_cliente = c.id_cliente
    WHERE t.fecha BETWEEN @Desde AND @Hasta
);

--18  Vista de pagos pendientes (todas las cuotas sin cancelar) 
CREATE OR ALTER FUNCTION tvf_PagosPendientes ()
RETURNS TABLE
AS
RETURN (
    SELECT ps.id_pago,
           ps.id_contrato,
           ps.nro_cuota,
           ps.fecha_pago,
           ps.monto_pagado,
           cs.id_cliente,
           c.nombre + ' ' + c.Apellido AS Cliente
    FROM PagoServicio ps
    JOIN ContratoServicio cs ON ps.id_contrato = cs.id_contrato
    JOIN Cliente c ON cs.id_cliente = c.id_cliente
    WHERE ps.estado_pago IN ('Pendiente','Atrasado')
);

SELECT 

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
