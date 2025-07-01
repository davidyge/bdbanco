PERFIL FINANCIERO DE CLIENTES Y DISTRIBUCIÓN DE PRODUCTOS BANCARIOS POR REGIÓN

Descripción del Sistema

Este sistema de base de datos ha sido diseñado para gestionar y analizar de forma estructurada la información financiera de los clientes de una entidad bancaria. Permite registrar y consultar datos relacionados con:
Los clientes (Natural, juridica)
Sus cuentas bancarias
Los productos financieros que adquieren
Las agencias donde operan
La región geográfica de atención
Las transacciones realizadas por los clientes

Datos Almacenados:

El modelo contempla las siguientes entidades y relaciones clave:
Clientes: Contiene información personal, tipo de cliente (natural o jurídica), sueldo mensual y cantidad de productos adquiridos.
Cuentas: Asocia a los clientes con sus cuentas bancarias, incluyendo tipo de cuenta, número, monto y fecha de apertura.
Productos: Describe los productos financieros ofrecidos por la entidad (créditos, tarjetas, fondos, etc.).
AdquisicionProducto: Entidad intermedia que registra cada vez que un cliente adquiere un producto financiero. Incluye la agencia donde se adquirió el producto.
Agencias: Representa las oficinas bancarias físicas donde se atiende a los clientes.
Regiones: Define la ubicación geográfica de cada agencia.
Transacciones: Registra todos los movimientos financieros realizados por los clientes (depósitos, retiros, transferencias, pagos, etc.), asociados a una cuenta específica, con fecha, tipo y monto de transacción.

Objetivo del Modelo:

El propósito principal de este sistema es permitir un análisis integral del comportamiento financiero de los clientes y la distribución de productos en función de variables como:
Tipo de cliente, región geográfica, agencia bancaria, tipo de cuenta o producto, monto, frecuencia y antigüedad de las cuentas y transacciones.
Esto facilita la toma de decisiones estratégicas basadas en datos reales.

Análisis y Consultas Clave:

¿Cuántos productos tiene cada tipo de cliente?	cantidad_productos, tipo_cliente
¿Ganan más las personas naturales o las jurídicas?	sueldo_mensual, tipo_cliente
¿En qué regiones hay más cuentas activas?	cuentas, agencia, region
¿Dónde se maneja más dinero, en cuentas corporativas o personales?	tipo_cuenta, monto
¿Cuál es la antigüedad promedio de las cuentas por región?	fecha_apertura, region
¿Qué agencias concentran más clientes y cuentas?	agencia, id_cliente
¿Qué tipo de transacciones son más comunes por cliente o región? transacciones, tipo transacción, región
¿Cuál es el monto promedio por transacción según el tipo de cuenta?	transacciones, monto, tipo_cuenta
¿Qué clientes tienen mayor volumen de operaciones?	id_cliente, transacciones, monto

Resultados Esperados:

Mejorar estrategias de marketing segmentadas por tipo de cliente y región
Identificar zonas con baja penetración financiera
Personalizar productos financieros según el comportamiento del cliente
Analizar el crecimiento de clientes, cuentas y transacciones por año
Detectar patrones de uso de productos y servicios
Evaluar el riesgo y rentabilidad de los clientes según su historial transaccional

Diagra entidad relación
![BD-BANCO-DG](https://github.com/user-attachments/assets/d90d2c2c-a494-4982-b64d-994c77ab2074)

Diseño lógico
![BANCO_DIAGRAM](https://github.com/user-attachments/assets/60cb7dd8-a432-4212-9fa8-f6157788a24b)

Modelo Físico
![BANCO-D-FISICO](https://github.com/user-attachments/assets/71fb7d8b-b1ba-49df-b58e-f0ef697a7436)







