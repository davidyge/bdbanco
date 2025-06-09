DELETE FROM Cliente;
DELETE FROM Region;
DELETE FROM Agencia;
DELETE FROM Cuenta; --
DELETE FROM TransaccionesCuenta;
DELETE FROM ContratoServicio;
DELETE FROM PagoServicio;
DELETE FROM ServiciosFinancieros;

-- TABLAS INDEPENDIENTES
SELECT * FROM Cliente;
SELECT * FROM Region;
SELECT * FROM Agencia;
SELECT * FROM ServiciosFinancieros;

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
(5, 'Huanuco'),
(6, 'Tacna'),
(7, 'Ica'),
(8, 'Chiclayo'),
(9, 'Puno'),
(10, 'Tarapoto');

-- Agencia
INSERT INTO Agencia (id_agencia, id_region, nombre_agencia, direccion) VALUES
(1, 1, 'Agencia Central', 'Av. Principal 123, Lima'),
(2, 2, 'Agencia Cusco', 'Calle Sol 456, Cusco'),
(3, 3, 'Agencia Arequipa', 'Av. Melgar 789, Arequipa'),
(4, 4, 'Agencia Piura', 'Jr. Comercio 321, Piura'),
(5, 5, 'Agencia Huanuco', 'Jr. 28 de julio 820, Huanuco'),
(6, 6, 'Agencia Tacna',     'Av. Bolognesi 100, Tacna'),
(7, 7, 'Agencia Ica',       'Calle Lima 250, Ica'),
(8, 8, 'Agencia Chiclayo',  'Av. Balta 455, Chiclayo'),
(9, 9, 'Agencia Puno',      'Jr. Moquegua 77, Puno'),
(10,10,'Agencia Tarapoto',  'Av. Alfonso Ugarte 300, Tarapoto');

-- ServiciosFinancieros
INSERT INTO ServiciosFinancieros (id_servicio, nombre_servicio, tipo_servicio, monto_maximo, tasa_interes) VALUES
(1, 'Préstamo Personal', 'Crédito', 10000.00, 12.5),
(2, 'Crédito Hipotecario', 'Hipoteca', 200000.00, 8.75),
(3, 'Crédito Vehicular', 'Vehículo', 50000.00, 10.0),
(4, 'Tarjeta Clásica', 'Tarjeta', 5000.00, 20.0),
(5, 'Tarjeta Oro', 'Tarjeta', 10000.00, 18.0),
(6, 'Cuenta de Ahorro Premier', 'Depósito', 0.00, 0.75),
(7, 'Seguro de Vida',           'Seguro',   200000.00, 0.00),
(8, 'Seguro Vehicular',         'Seguro',    80000.00, 0.00),
(9, 'Plazo Fijo 360',         'Inversión', 50000.00, 6.50),
(10,'Crédito PyME',             'Crédito',  150000.00, 13.0);

-- Cliente
DELETE FROM Cliente;
INSERT INTO Cliente (id_cliente, nombre, Apellido, dni, fecha_nacimiento, email, telefono) VALUES
(1, 'Juan', 'Perez', '12345678', '1990-05-10', 'juan@gmail.com', '999111222'),
(2, 'Ana', 'Lopez', '87654321', '1988-08-15', 'ana@gmail.com', '988777666'),
(3, 'Carlos', 'Sanchez', '11223344', '1995-03-22', 'carlos@gmail.com', '977888999'),
(4, 'Lucia', 'Martinez', '44332211', '2000-12-01', 'lucia@gmail.com', '966555444'),
(5, 'Mario', 'Ramos', '99887766', '1985-01-30', 'mario@gmail.com', '955333111'),
(6, 'Sandra', 'Zevallos', '55667788', '1992-07-14', 'sandra@gmail.com', '944222333'),
(7, 'Diego',  'Salazar',  '66778899', '1987-11-03', 'diego@gmail.com',  '933444555'),
(8, 'Rosa',   'Quispe',   '77889900', '1999-02-19', 'rosa@gmail.com',   '922666777'),
(9, 'Felipe', 'Nuñez',    '88990011', '1984-09-27', 'felipe@gmail.com', '911888999'),
(10,'Elena',  'Castro',   '99001122', '1996-04-05', 'elena@gmail.com',  '900111222');

-- INSERCIÓN DE TABLAS TRANSACCIONALES
-- Cuenta 
SELECT * FROM Cuenta;
INSERT INTO Cuenta (id_cuenta, id_cliente, id_agencia, tipo_cuenta, saldo, fecha_creacion) VALUES
(1, 1, 1, 'Ahorro', 1500.00, '2025-01-02'),
(2, 2, 2, 'Corriente', 3000.00, '2025-01-05'),
(3, 3, 3, 'Ahorro', 50.00, '2025-01-10'),
(4, 4, 4, 'Corriente', 100.00, '2025-01-15'),
(5, 5, 5, 'Ahorro', 1800.00, '2025-01-20'),
(6, 1, 1, 'Corriente', 0.00, '2025-01-25'),
(7, 2, 2, 'Ahorro', 4000.00, '2025-01-30'),
(8, 3, 3, 'Corriente', 100.00, '2025-02-03'),
(9, 4, 4, 'Ahorro', 0.00, '2025-02-07'),
(10, 5, 5, 'Corriente', 1600.00, '2025-02-11'),
(11, 6, 6, 'Ahorro', 2500.00, '2025-02-15'),
(12, 7, 7, 'Corriente', 1800.00, '2025-02-19'),
(13, 8, 8, 'Ahorro', 900.00, '2025-02-23'),
(14, 9, 9, 'Corriente', 200.00, '2025-02-27'),
(15, 10, 10, 'Ahorro', 4200.00, '2025-03-03'),
(16, 6, 6, 'Corriente', 0.00, '2025-03-07'),
(17, 7, 7, 'Ahorro', 500.00, '2025-03-11'),
(18, 8, 8, 'Corriente', 3700.00, '2025-03-15'),
(19, 9, 9, 'Ahorro', 1100.00, '2025-03-19'),
(20, 10, 10, 'Corriente', 600.00, '2025-03-23'),
(21, 1, 6, 'Plazo Fijo', 7000.00, '2025-03-27'),
(22, 2, 7, 'Plazo Fijo', 8000.00, '2025-03-31'),
(23, 3, 8, 'Ahorro', 300.00, '2025-04-05'),
(24, 4, 9, 'Ahorro', 0.00, '2025-04-10'),
(25, 5, 10, 'Corriente', 1800.00, '2025-04-15'),
(26, 6, 6, 'Ahorro', 1000.00, '2025-04-20'),
(27, 7, 7, 'Corriente', 50.00, '2025-04-25'),
(28, 8, 8, 'Ahorro', 2500.00, '2025-05-01'),
(29, 9, 9, 'Corriente', 9000.00, '2025-05-20'),
(30, 10, 10, 'Ahorro', 150.00, '2025-06-01');

-- TransaccionesCuenta
SELECT * FROM TransaccionesCuenta;
INSERT INTO TransaccionesCuenta (id_transacciones, id_cuenta, fecha, tipo_transaccion, monto) VALUES
(1, 1, '2025-01-03 10:00:00', 'Depósito', 500.00),
(2, 1, '2025-01-04 11:00:00', 'Retiro', 200.00),
(3, 2, '2025-01-06 09:00:00', 'Depósito', 1000.00),
(4, 2, '2025-01-07 15:00:00', 'Retiro', 500.00),
(5, 3, '2025-01-11 10:00:00', 'Depósito', 200.00),
(6, 3, '2025-01-12 11:00:00', 'Retiro', 100.00),
(7, 4, '2025-01-16 08:00:00', 'Retiro', 100.00),
(8, 5, '2025-01-21 14:00:00', 'Retiro', 500.00),
(9, 6, '2025-01-26 16:00:00', 'Depósito', 1000.00),
(10, 6, '2025-01-27 17:00:00', 'Retiro', 1000.00),
(11, 7, '2025-02-01 09:10:00', 'Depósito', 1000.00),
(12, 7, '2025-02-02 17:30:00', 'Retiro', 2000.00),
(13, 8, '2025-02-04 10:00:00', 'Depósito', 150.00),
(14, 8, '2025-02-05 12:45:00', 'Retiro', 100.00),
(15, 9, '2025-02-08 14:00:00', 'Depósito', 300.00),
(16,10, '2025-02-12 15:20:00', 'Retiro', 600.00),
(17,11, '2025-02-16 09:00:00', 'Depósito', 2000.00),
(18,11, '2025-02-17 11:15:00', 'Retiro', 500.00),
(19,12, '2025-02-20 08:10:00', 'Depósito', 1500.00),
(20,12, '2025-02-21 18:30:00', 'Retiro', 200.00),
(21,13, '2025-02-24 13:55:00', 'Retiro', 100.00),
(22,14, '2025-02-28 16:00:00', 'Depósito', 400.00),
(23,15, '2025-03-04 10:25:00', 'Retiro', 1000.00),
(24,16, '2025-03-08 14:40:00', 'Depósito', 1200.00),
(25,17, '2025-03-12 09:05:00', 'Retiro', 200.00),
(26,18, '2025-03-16 09:10:00', 'Retiro', 500.00),
(27,19, '2025-03-20 17:45:00', 'Depósito', 1100.00),
(28,20, '2025-03-24 11:00:00', 'Retiro', 600.00),
(29,21, '2025-03-28 12:15:00', 'Depósito', 500.00),
(30,22, '2025-04-01 18:20:00', 'Depósito', 1000.00);

-- ContratoServicio
DELETE ContratoServicio;
SELECT * FROM ContratoServicio;
INSERT INTO ContratoServicio (id_contrato, id_cliente, id_servicio, id_agencia,
fecha_inicio, plazo_meses, monto_contratado, estado_contrato)
VALUES
(1,  1,  1,  1,  '2025-01-10',  6,   5000.00, 'Activo');
(1,  3,  2,  1,  '2025-02-15',  3,   7000.00, 'Activo');
(1,  5,  4,  3,  '2025-01-12',  4,   4000.00, 'Activo');
(1,  4,  2,  2,  '2025-01-01',  5,   8000.00, 'Activo');
(1,  2,  3,  4,  '2025-03-10',  5,   9000.00, 'Activo');
(1,  6,  3,  4,  '2025-01-20',  4,   3000.00, 'Activo');
-- PagoServicio
SELECT * FROM PagoServicio;
INSERT INTO PagoServicio (id_pago, id_contrato, id_contratoDet, fecha_pago, monto_pagado) VALUES
(1, 1, 13, '2025-02-10', 937.50),
(2, 1, 14, '2025-03-10', 937.50);

DELETE ContratoServicioDet;
SELECT * FROM ContratoServicioDet;
INSERT INTO ContratoServicioDet (id_contrato, nro_cuota, fecha_programada, monto_cuota, estado_cuota, fecha_pagada) VALUES
(13,	1,	1,	2025-02-10,	937.50,	'Pagado',	2025-02-10),
(14,	1,	2,	2025-03-10,	937.50,	'Pagado',	2025-03-10),
(15,	1,	3,	2025-04-10,	937.50,	'Pendiente',	NULL),
(16,	1,	4,	2025-05-10,	937.50,	'Pendiente',	NULL),
(17,	1,	5,	2025-06-10,	937.50,	'Pendiente',	NULL),
(18,	1,	6,	2025-07-10,	937.50,	'Pendiente',	NULL),
(19,	6,	1,	2025-02-20,	825.00,	'Pendiente',	NULL),
(20,	6,	2,	2025-03-20,	825.00,	'Pendiente',	NULL),
(21,	6,	3,	2025-04-20,	825.00,	'Pendiente',	NULL),
(22,	6,	4,	2025-05-20,	825.00,	'Pendiente',	NULL),
(23,	5,	1,	2025-04-10,	1980.00,	'Pendiente',	NULL),
(24,	5,	2,	2025-05-10,	1980.00,	'Pendiente',	NULL),
(25,	5,	3,	2025-06-10,	1980.00,	'Pendiente',	NULL),
(26,	5,	4,	2025-07-10,	1980.00,	'Pendiente',	NULL),
(27,	5,	5,	2025-08-10,	1980.00,	'Pendiente',	NULL),
(28,	4,	1,	2025-02-01,	1740.00,	'Pendiente',	NULL),
(29,	4,	2,	2025-03-01,	1740.00,	'Pendiente',	NULL),
(30,	4,	3,	2025-04-01,	1740.00,	'Pendiente',	NULL),
(31,	4,	4,	2025-05-01,	1740.00,	'Pendiente',	NULL),
(32,	4,	5,	2025-06-01,	1740.00,	'Pendiente',	NULL),
(33,	3,	1,	2025-02-12,	1200.00,	'Pendiente',	NULL),
(34,	3,	2,	2025-03-12,	1200.00,	'Pendiente',	NULL),
(35,	3,	3,	2025-04-12,	1200.00,	'Pendiente',	NULL),
(36,	3,	4,	2025-05-12,	1200.00,	'Pendiente',	NULL),
(37,	2,	1,	2025-03-15,	2537.50,	'Pendiente',	NULL),
(38,	2,	2,	2025-04-15,	2537.50,	'Pendiente',	NULL),
(39,	2,	3,	2025-05-15,	2537.50,	'Pendiente',	NULL);
