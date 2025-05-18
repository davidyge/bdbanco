# bdbanco
PERFIL FINANCIERO DE CLIENTES Y DISTRIBUCIÓN DE PRODUCTOS BANCARIOS POR REGIÓN

Este sistema de base de datos está diseñado para gestionar la información de clientes bancarios, sus productos financieros (como cuentas corrientes o de ahorros), las agencias bancarias donde operan, y sus ubicaciones geográficas.

Se almacenan datos clave como:

-Datos personales y financieros del cliente.

-El tipo de cliente (natural o jurídica).

-Los productos financieros adquiridos.

-Información de las cuentas (tipo, número, monto, fecha de apertura).

-Sueldo mensual y cantidad de productos del cliente.

-Ubicación de atención (agencia y región).

Este modelo permite tener un control estructurado y flexible de la billetera financiera de los clientes.

Objetivo:
Analizar cómo varían los productos bancarios, montos de cuenta y tipos de cliente en función de su región, agencia y perfil financiero.
Análisis	Pregunta	Datos que necesitas
- Número de productos por cliente	¿Cuántos productos tiene cada tipo de cliente?	cantidad_productos, tipo_cliente
- Sueldo promedio por tipo de cliente	¿Ganan más las personas naturales o jurídicas?	sueldo_mensual, tipo_cliente
- Distribución de cuentas por región	¿En qué regiones hay más cuentas activas?	cuentas, agencia, región
- Monto promedio en cuentas por tipo	¿Dónde se maneja más dinero, en cuentas corporativas o personales?	tipo_cuenta, monto
- Antigüedad de clientes	¿Cuántos años tiene en promedio una cuenta por región?	fecha_apertura, región
- Concentración de clientes por agencia	¿Qué agencias manejan más clientes y cuentas?	agencia, id_cliente

Resultados
-Mejorar estrategias de marketing según tipo de cliente y región.
-Identificar zonas con menor penetración bancaria para tomar decisiones comerciales.
-Crear productos financieros más personalizados según el comportamiento del cliente.
-Analizar el crecimiento de clientes o cuentas por año.
-Calcular el lifetime value de un cliente con base en su número de productos y saldo promedio.
