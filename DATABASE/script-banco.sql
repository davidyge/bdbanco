
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni CHAR(8) UNIQUE NOT NULL,
    fecha_nacimiento DATE,
    email VARCHAR(150),
    telefono VARCHAR(20)
);

CREATE TABLE ServiciosFinancieros (
    id_servicio INT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    tipo_servicio VARCHAR(50) NOT NULL,
    monto_maximo DECIMAL(12,2),
    tasa_interes DECIMAL(5,2)
);

CREATE TABLE Region (
    id_region INT PRIMARY KEY,
    nombre_region VARCHAR(100) NOT NULL
);

CREATE TABLE Agencia (
    id_agencia INT PRIMARY KEY,
    nombre_agencia VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    id_region INT NOT NULL,
    FOREIGN KEY (id_region) REFERENCES Region(id_region)
);

CREATE TABLE Cuenta (
    id_cuenta INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_agencia INT NOT NULL,
    tipo_cuenta VARCHAR(50) NOT NULL,
    saldo DECIMAL(12,2) NOT NULL,
    fecha_creacion DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_agencia) REFERENCES Agencia(id_agencia)
);

CREATE TABLE TransaccionesCuenta (
    id_transacciones INT PRIMARY KEY,
    id_cuenta INT NOT NULL,
    fecha DATETIME NOT NULL,
    tipo_transaccion VARCHAR(50) NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (id_cuenta) REFERENCES Cuenta(id_cuenta)
);

CREATE TABLE ContratoServicio (
    id_contrato INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_servicio INT NOT NULL,
    id_agencia INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    plazo_meses INT NOT NULL,
    monto_contratado DECIMAL(12,2) NOT NULL,
    estado_contrato VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_servicio) REFERENCES ServiciosFinancieros(id_servicio),
    FOREIGN KEY (id_agencia) REFERENCES Agencia(id_agencia)
);

CREATE TABLE PagoServicio (
    id_pago INT PRIMARY KEY,
    id_contrato INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto_pagado DECIMAL(12,2) NOT NULL,
    nro_cuota INT NOT NULL,
    estado_pago VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_contrato) REFERENCES ContratoServicio(id_contrato)
);
