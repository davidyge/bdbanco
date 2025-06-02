-- TABLAS INDEPENDIENTES
SELECT * FROM Cliente;
SELECT * FROM Region;
SELECT * FROM Agencia;
SELECT * FROM Region;

-- TABLAS TRANSACCIONALES
SELECT * FROM Cuenta;
SELECT * FROM TransaccionesCuenta;
SELECT * FROM ContratoServicio;
SELECT * FROM PagoServicio;

-- INSERCIÓN DE TABLAS INDEPENDIENTES
-- Región
INSERT INTO Region (id_region, nombre_region) VALUES
(1, 'Lima'),
(2, 'Cusco'),
(3, 'Arequipa'),
(4, 'Piura'),
(5, 'Huanuco');

-- Agencia
INSERT INTO Agencia (id_agencia, id_region, nombre_agencia, direccion) VALUES
(1, 1, 'Agencia Central', 'Av. Principal 123, Lima'),
(2, 2, 'Agencia Cusco', 'Calle Sol 456, Cusco'),
(3, 3, 'Agencia Arequipa', 'Av. Melgar 789, Arequipa'),
(4, 4, 'Agencia Piura', 'Jr. Comercio 321, Piura'),
(5, 5, 'Agencia Huanuco', 'Jr. 28 de julio 820, Huanuco');

-- Cliente
INSERT INTO Cliente (id_cliente, nombre, Apellido, dni, fecha_nacimiento, email, telefono) VALUES
(1, 'Juan', 'Perez', '12345678', '1990-05-10', 'juan@gmail.com', '999111222'),
(2, 'Ana', 'Lopez', '87654321', '1988-08-15', 'ana@gmail.com', '988777666'),
(3, 'Carlos', 'Sanchez', '11223344', '1995-03-22', 'carlos@gmail.com', '977888999'),
(4, 'Lucia', 'Martinez', '44332211', '2000-12-01', 'lucia@gmail.com', '966555444'),
(5, 'Mario', 'Ramos', '99887766', '1985-01-30', 'mario@gmail.com', '955333111');

-- ServiciosFinancieros
INSERT INTO ServiciosFinancieros (id_servicio, nombre_servicio, tipo_servicio, monto_maximo, tasa_interes) VALUES
(1, 'Préstamo Personal', 'Crédito', 10000.00, 12.5),
(2, 'Crédito Hipotecario', 'Hipoteca', 200000.00, 8.75),
(3, 'Crédito Vehicular', 'Vehículo', 50000.00, 10.0),
(4, 'Tarjeta Clásica', 'Tarjeta', 5000.00, 20.0),
(5, 'Tarjeta Oro', 'Tarjeta', 10000.00, 18.0);

-- INSERCIÓN DE TABLAS TRANSACCIONALES
-- 
INSERT INTO Cuenta (id_cuenta, id_cliente, id_agencia, tipo_cuenta, saldo, fecha_creacion) VALUES
(1, 1, 1, 'Ahorro', 1500.00, '2024-01-10'),
(2, 2, 2, 'Corriente', 3000.00, '2024-02-15'),
(3, 3, 3, 'Ahorro', 50.00, '2024-03-20'),        -- saldo bajo
(4, 4, 4, 'Corriente', 100.00, '2024-04-25'),   -- saldo bajo
(5, 5, 5, 'Ahorro', 1800.00, '2024-05-30'),
(6, 1, 1, 'Corriente', 0.00, '2024-06-05'),     -- sin saldo
(7, 2, 2, 'Ahorro', 4000.00, '2024-06-10'),
(8, 3, 3, 'Corriente', 100.00, '2024-06-15'),
(9, 4, 4, 'Ahorro', 0.00, '2024-06-20'),        -- sin saldo
(10, 5, 5, 'Corriente', 1600.00, '2024-06-25');

-- TransaccionesCuenta
INSERT INTO TransaccionesCuenta (id_transacciones, id_cuenta, fecha, tipo_transaccion, monto) VALUES
(1, 1, '2024-06-01 10:00:00', 'Depósito', 500.00),
(2, 1, '2024-06-03 11:00:00', 'Retiro', 200.00),
(3, 2, '2024-06-04 09:00:00', 'Depósito', 1000.00),
(4, 2, '2024-06-05 15:00:00', 'Retiro', 500.00),
(5, 3, '2024-06-06 10:00:00', 'Retiro', 300.00),      -- saldo negativo
(6, 4, '2024-06-07 11:00:00', 'Retiro', 100.00),      -- cuenta sin saldo ahora
(7, 5, '2024-06-08 08:00:00', 'Depósito', 1800.00),
(8, 6, '2024-06-09 14:00:00', 'Retiro', 1000.00),     -- cuenta sin saldo
(9, 7, '2024-06-10 16:00:00', 'Depósito', 4000.00),
(10, 8, '2024-06-11 17:00:00', 'Retiro', 100.00);

-- ContratoServicio
INSERT INTO ContratoServicio (id_contrato, id_cliente, id_servicio, id_agencia, fecha_inicio, plazo_meses, monto_contratado, estado_contrato) VALUES
(1, 1, 1, 1, '2024-01-10', 12, 5000.00, 'Activo'),
(2, 2, 2, 2, '2024-02-10', 240, 150000.00, 'Activo'),
(3, 3, 3, 3, '2024-03-15', 60, 30000.00, 'Activo'),
(4, 4, 4, 4, '2024-04-20', 24, 4000.00, 'Activo'),
(5, 5, 5, 5, '2024-05-25', 36, 8000.00, 'Inactivo'),         -- inactivo
(6, 1, 2, 1, '2024-06-01', 120, 100000.00, 'Activo'),        -- 2 contratos
(7, 2, 3, 2, '2024-06-02', 48, 25000.00, 'Activo'),
(8, 3, 1, 3, '2024-06-03', 12, 4000.00, 'Cancelado'),        -- cancelado
(9, 4, 5, 4, '2024-06-04', 24, 9000.00, 'Activo'),
(10, 5, 4, 5, '2024-06-05', 36, 6000.00, 'Activo');

-- PagoServicio
SELECT * FROM PagoServicio;

ALTER TABLE PagoServicio
ALTER COLUMN fecha_pago DATE NULL;

ALTER TABLE PagoServicio
ALTER COLUMN monto_pagado DECIMAL(10,2) NULL;

INSERT INTO PagoServicio (id_pago, id_contrato, fecha_pago, monto_pagado, nro_cuota, estado_pago) VALUES
(1, 1, '2024-02-10', 500.00, 1, 'Pagado'),
(2, 2, '2024-03-11', 625.00, 1, 'Pagado'),
(3, 2, '2024-04-11', 625.00, 2, 'Pagado'),
(4, 3, '2024-04-12', 500.00, 1, 'Atrasado'),             -- pago incompleto
(5, 3, NULL, NULL, 2, 'Pendiente'),                      -- sin pago
(6, 4, NULL, NULL, 1, 'Pendiente'),                      -- sin pagar
(7, 5, '2024-06-14', 222.22, 1, 'Pagado'),               -- contrato inactivo
(8, 6, '2024-07-01', 1000.00, 1, 'Pagado'),
(9, 7, NULL, NULL, 1, 'Pendiente'),                      -- cliente con deuda
(10, 9, '2024-07-04', 375.00, 1, 'Pagado');

