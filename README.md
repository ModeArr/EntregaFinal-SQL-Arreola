# <center>Entrega de Proyecto Final</center>
Alumno: Modesto Rafael Alejandro Arreola Lira

Comisión 59410 SQL

Tutor: Melina Solorzano

Docente: Anderson Michel Torres

---

### **Consignas:**
- El documento debe contener:
    - Introducción
    - Objetivo
    - Situación problemática
    - Modelo de negocio
    - Diagrama de entidad relación
    - Listado de tablas con descripción de estructura (columna,descripción, tipo de datos, tipo de clave)
    - Vistas
    - Funciones
    - Stored Procedures
    - Triggers

---

## Introducción
Se busca hacer una base de datos relacional para un ecommerce, que permita hacer compras de manera eficiente y dinámica; esto mediante un carrito de compras.

## Objetivo
Proveer de un sistema simple que permita realizar compras y asi mismo mantener datos para uso de marketing de todas las ventas y usuarios.

## Modelo de negocio
1. **Registrar usuarios y guardar su datos**: Necesitamos que la base de datos guarde usuarios y sus datos como son direcciones y métodos de pagos, esto para dar una experiencia mejorada al usuario.

2. **Gestión de productos**: Es importante tener un sistema que permita guardar los productos asi como manejar su inventario y categorías. Asi también se necesita tener un control de los descuentos.

3. **Compra mediante un carrito de compras**: La base de datos debe permitirnos hacer la compra de productos mediante un carrito de compras y poder registrar las sesiones de compras de cada carrito para tener un control de marketing de donde y cuando se quedan en el proceso de compras.

4. **Registro de ventas**: Necesitamos un sistema que pueda registrar de manera detallada cada compra hecha y todos sus detalles y que esta sea fácil para el departamento de ventas poder verificarla a fondo.

## Diagrama entidad relación (DER)
![Diagrama Entidad Relacion](https://github.com/user-attachments/assets/c0e5c876-79c9-44ee-9865-015973529c96)

## Listado de tablas y descripción
### Tabla `product_inventory`
Esta tabla almacena la información del inventario de los productos, incluyendo la cantidad disponible y las fechas de creación, modificación y eliminación.

| Columna       | Tipo de Dato  | Atributo                                 | Descripción                                   |
|---------------|---------------|------------------------------------------|-----------------------------------------------|
| `id`          | INT           | PRIMARY KEY, AUTO_INCREMENT, NOT NULL    | Identificador único de inventario.            |
| `quantity`    | INT UNSIGNED  | NOT NULL                                 | Cantidad disponible en inventario.            |
| `created_at`  | DATETIME      | NOT NULL                                 | Fecha y hora de creación del registro.        |
| `modified_at` | DATETIME      |                                          | Fecha y hora de la última modificación.       |
| `deleted_at`  | DATETIME      |                                          | Fecha y hora de la eliminación lógica.        |

### Tabla `discount`
Esta tabla contiene la información relacionada con los descuentos aplicables a los productos, incluyendo el nombre, porcentaje de descuento y su estado de activación.

| Columna            | Tipo de Dato     | Atributo                                 | Descripción                                   |
|--------------------|------------------|------------------------------------------|-----------------------------------------------|
| `id`               | INT              | PRIMARY KEY, AUTO_INCREMENT, NOT NULL    | Identificador único del descuento.            |
| `name`             | VARCHAR(80)      | NOT NULL                                 | Nombre del descuento.                         |
| `description`      | VARCHAR(120)     |                                          | Descripción breve del descuento.              |
| `discount_percent` | TINYINT UNSIGNED | NOT NULL                                 | Porcentaje de descuento aplicado.             |
| `active`           | TINYINT(1)       | NOT NULL, DEFAULT 0                      | Estado del descuento (1: activo, 0: inactivo).|
| `created_at`       | DATETIME         | NOT NULL                                 | Fecha y hora de creación del registro.        |
| `modified_at`      | DATETIME         |                                          | Fecha y hora de la última modificación.       |
| `deleted_at`       | DATETIME         |                                          | Fecha y hora de la eliminación lógica.        |

### Tabla `product_category`
Esta tabla almacena las categorías de los productos, permitiendo organizar los productos en diferentes grupos.

| Columna       | Tipo de Dato  | Atributo                                 | Descripción                                   |
|---------------|---------------|------------------------------------------|-----------------------------------------------|
| `id`          | INT           | PRIMARY KEY, AUTO_INCREMENT, NOT NULL    | Identificador único de la categoría.          |
| `name`        | VARCHAR(80)   | NOT NULL                                 | Nombre de la categoría de producto.           |
| `description` | VARCHAR(180)  |                                          | Descripción breve de la categoría.            |
| `created_at`  | DATETIME      | NOT NULL                                 | Fecha y hora de creación del registro.        |
| `modified_at` | DATETIME      |                                          | Fecha y hora de la última modificación.       |
| `deleted_at`  | DATETIME      |                                          | Fecha y hora de la eliminación lógica.        |

### Tabla `product`
Esta tabla contiene información sobre los productos disponibles para la venta, incluyendo su nombre, descripción, SKU, categoría, inventario, precio y descuentos aplicables.

| Columna       | Tipo de Dato  | Atributo                                 | Descripción                                   |
|---------------|---------------|------------------------------------------|-----------------------------------------------|
| `id`          | INT           | PRIMARY KEY, AUTO_INCREMENT, NOT NULL    | Identificador único del producto.             |
| `name`        | VARCHAR(100)  | NOT NULL                                 | Nombre del producto.                          |
| `description` | VARCHAR(300)  |                                          | Descripción detallada del producto.           |
| `SKU`         | VARCHAR(50)   | NOT NULL                                 | Código único de inventario del producto (SKU).|
| `category_id` | INT           | NOT NULL                                 | Clave foránea a la tabla `product_category`.  |
| `inventory_id`| INT           | NOT NULL                                 | Clave foránea a la tabla `product_inventory`. |
| `price`       | DECIMAL(10,2) | NOT NULL                                 | Precio del producto.                          |
| `discount_id` | INT           | NOT NULL, DEFAULT 0                      | Clave foránea a la tabla `discount`.          |
| `created_at`  | DATETIME      | NOT NULL                                 | Fecha y hora de creación del registro.        |
| `modified_at` | DATETIME      |                                          | Fecha y hora de la última modificación.       |
| `deleted_at`  | DATETIME      |                                          | Fecha y hora de la eliminación lógica.        |

### Tabla `order_details`
Esta tabla almacena los detalles de los pedidos realizados por los usuarios, incluyendo el total del pedido y el método de pago.

| Columna       | Tipo de Dato  | Atributo                                 | Descripción                                   |
|---------------|---------------|------------------------------------------|-----------------------------------------------|
| `id`          | INT           | PRIMARY KEY, AUTO_INCREMENT, NOT NULL    | Identificador único del pedido.               |
| `user_id`     | INT           | NOT NULL                                 | Clave foránea a la tabla `user`.              |
| `total`       | DECIMAL(10,2) | NOT NULL                                 | Total del pedido.                             |
| `payment_id`  | INT           | NOT NULL                                 | Clave foránea a la tabla `payment_details`.   |
| `created_at`  | DATETIME      | NOT NULL                                 | Fecha y hora de creación del registro.        |
| `modified_at` | DATETIME      |                                          | Fecha y hora de la última modificación.       |

### Tabla `payment_details`
Esta tabla guarda los detalles de los pagos realizados, incluyendo el proveedor de pagos y el estado del pago.

| Columna        | Tipo de Dato        | Atributo        | Descripción                                                                 |
|--------------------|-------------------------|---------------------|---------------------------------------------------------------------------------|
| `id_payment_details`| INT                     | PRIMARY KEY, NOT NULL, AUTO_INCREMENT | Identificador único del detalle de pago.                                         |
| `order_id`         | INT                     | NOT NULL            | Identificador de la orden asociada al pago. Referencia a `order_details`.        |
| `amount`           | DECIMAL(10,2)           | NOT NULL            | Monto total pagado por la orden.                                                |
| `provider`         | VARCHAR(45)             | NOT NULL            | Proveedor del servicio de pago (ej. PayPal, Stripe, Banco, etc.).                |
| `status`           | ENUM('pending', 'successful', 'failed', 'refunded') | NOT NULL, DEFAULT 'pending' | Estado del pago: pendiente, exitoso, fallido o reembolsado.                    |
| `payment_method`    | VARCHAR(45)             | NOT NULL            | Método de pago utilizado (ej. tarjeta de crédito, transferencia bancaria, etc.). |
| `transaction_id`   | VARCHAR(100)            | NULL                | Identificador de transacción proporcionado por el proveedor de pago (opcional).  |
| `payment_date`     | DATETIME                | NULL                | Fecha en la que se realizó el pago (opcional, útil si el pago no es inmediato).  |
| `created_at`       | DATETIME                | NOT NULL            | Fecha y hora en que se creó el registro del detalle del pago.                    |
| `modified_at`      | DATETIME                | NULL                | Fecha y hora de la última modificación del registro (opcional).                  |


### Tabla `user`
Esta tabla almacena la información de los usuarios registrados en la plataforma, incluyendo datos personales y credenciales.

| Columna       | Tipo de Dato  | Atributo                                 | Descripción                                   |
|---------------|---------------|------------------------------------------|-----------------------------------------------|
| `id`          | INT           | PRIMARY KEY, AUTO_INCREMENT, NOT NULL    | Identificador único del usuario.              |
| `username`    | VARCHAR(45)   | NOT NULL                                 | Nombre de usuario.                            |
| `password`    | VARCHAR(40)   | NOT NULL                                 | Contraseña encriptada del usuario.            |
| `first_name`  | VARCHAR(45)   | NOT NULL                                 | Nombre del usuario.                           |
| `last_name`   | VARCHAR(45)   | NOT NULL                                 | Apellido del usuario.                         |
| `address`     | VARCHAR(85)   |                                          | Dirección del usuario.                        |
| `telephone`   | VARCHAR(15)   |                                          | Teléfono del usuario.                         |
| `created_at`  | DATETIME      | NOT NULL                                 | Fecha y hora de creación del registro.        |
| `modified_at` | DATETIME      |                                          | Fecha y hora de la última modificación.       |

### Tabla `order_items`
Esta tabla almacena los productos específicos que forman parte de un pedido, relacionando un pedido con los productos que contiene.

| Columna       | Tipo de Dato  | Atributo                                 | Descripción                                   |
|---------------|---------------|------------------------------------------|-----------------------------------------------|
| `id`          | INT           | PRIMARY KEY, AUTO_INCREMENT, NOT NULL    | Identificador único del artículo en el pedido.|
| `order_id`    | INT           | NOT NULL                                 | Clave foránea a la tabla `order_details`.     |
| `product_id`  | INT           | NOT NULL                                 | Clave foránea a la tabla `product`.           |
| `quantity`    | INT           | NOT NULL                                 | Cantidad de productos productos que contiene. |
| `created_at`  | DATETIME      | NOT NULL                                 | Fecha y hora de creación del registro.        |
| `modified_at` | DATETIME      |                                          | Fecha y hora de la última modificación.       |

### Tabla `user_address`
Esta tabla almacena las direcciones asociadas a los usuarios, permitiendo que un usuario tenga múltiples direcciones.

| Columna        | Tipo de Dato  | Atributo                                 | Descripción                                   |
|----------------|---------------|------------------------------------------|-----------------------------------------------|
| `id`           | INT           | PRIMARY KEY, AUTO_INCREMENT, NOT NULL    | Identificador único de la dirección.          |
| `user_id`      | INT           | NOT NULL                                 | Clave foránea a la tabla `user`.              |
| `address_line1`| VARCHAR(60)   | NOT NULL                                 | Primera línea de la dirección del usuario.    |
| `address_line2`| VARCHAR(45)   |                                          | Segunda línea de la dirección (opcional).     |
| `city`         | VARCHAR(45)   | NOT NULL                                 | Ciudad de la dirección.                       |
| `postal_code`  | VARCHAR(10)   | NOT NULL                                 | Código postal de la dirección.                |
| `country`      | VARCHAR(45)   | NOT NULL                                 | País de la dirección.                         |
| `telephone`    | VARCHAR(15)   |                                          | Teléfono asociado a la dirección.             |
| `mobile`       | VARCHAR(15)  | NULL                                      | Número de móvil asociado a la dirección (opcional). |

## `user_payment`

**Descripción:**
La tabla `user_payment` almacena la información de los métodos de pago de los usuarios. Cada fila representa un método de pago.

| Columna       | Tipo         | Atributos               | Descripción                                              |
|---------------|--------------|-------------------------|----------------------------------------------------------|
| `id`           | INT          | NOT NULL, PRIMARY KEY, AUTO_INCREMENT   | Identificador único del método de pago.                 |
| `user_id`      | INT          | NOT NULL                | Identificador del usuario asociado al método de pago.   |
| `payment_type` | VARCHAR(45)  | NOT NULL                | Tipo de pago (ej. tarjeta de crédito, PayPal).          |
| `provider`     | VARCHAR(45)  | NOT NULL                | Proveedor del método de pago (ej. Visa, Mastercard).    |
| `account_no`   | VARCHAR(20)  | NOT NULL                | Número de cuenta o tarjeta del método de pago.          |
| `expiry`       | CHAR(5)      | NULL                    | Fecha de vencimiento del método de pago.                |

## `shopping_session`

**Descripción:**
La tabla `shopping_session` gestiona las sesiones de compras activas de los usuarios. Cada fila representa una sesión de compra.

| Columna       | Tipo         | Atributos               | Descripción                                              |
|---------------|--------------|-------------------------|----------------------------------------------------------|
| `id`           | INT          | NOT NULL, PRIMARY KEY, AUTO_INCREMENT   | Identificador único de la sesión de compra.             |
| `user_id`      | INT          | NOT NULL                | Identificador del usuario asociado a la sesión.        |
| `total`        | DECIMAL(10,2)          | NOT NULL                | Total acumulado de la sesión de compra.                 |
| `created_at`   | DATETIME     | NOT NULL                | Fecha y hora en que se creó la sesión de compra.        |
| `modified_at`  | DATETIME     | NULL                    | Fecha y hora de la última modificación de la sesión.     |

## `cart_item`

**Descripción:**
La tabla `cart_item` almacena los productos que los usuarios han agregado a sus carritos de compra. Cada fila representa un producto en un carrito de compra.

| Columna       | Tipo         | Atributos               | Descripción                                              |
|---------------|--------------|-------------------------|----------------------------------------------------------|
| `id`           | INT          | NOT NULL, PRIMARY KEY, AUTO_INCREMENT   | Identificador único del ítem del carrito.               |
| `session_id`   | INT          | NOT NULL                | Identificador de la sesión de compra a la que pertenece el ítem. |
| `product_id`   | INT          | NOT NULL                | Identificador del producto en el carrito.               |
| `quantity`     | INT          | NOT NULL, UNSIGNED      | Cantidad del producto en el carrito.                    |
| `created_at`   | DATETIME     | NOT NULL                | Fecha y hora en que se creó el ítem del carrito.        |
| `modified_at`   | DATETIME     | NULL                | Fecha y hora en que se modifico el ítem del carrito.        |

## `payment_providers`

La tabla `payment_providers` contiene información sobre los proveedores de pago disponibles en el sistema de ecommerce. Estos proveedores permiten gestionar las transacciones de los usuarios y procesar los pagos.

| Columna           | Tipo           | Atributos         | Descripción                                                                 |
|-------------------|----------------|-------------------|-----------------------------------------------------------------------------|
| `id_payment_provider` | INT            | PRIMARY KEY, AUTO_INCREMENT | Identificador único para cada proveedor de pago.              |
| `provider_name`    | VARCHAR(100)    | NOT NULL          | Nombre del proveedor de pago (ej: PayPal, Stripe, etc.).                  |
| `provider_code`    | VARCHAR(20)     | NOT NULL, UNIQUE  | Código único asignado al proveedor de pago (ej: PPL para PayPal).         |
| `active`           | TINYINT(1)      | NOT NULL, DEFAULT 1 | Indica si el proveedor de pago está activo (1) o inactivo (0).          |
| `created_at`       | DATETIME        | NOT NULL          | Fecha y hora en que se creó el registro del proveedor de pago.            |
| `modified_at`      | DATETIME        | NULL              | Fecha y hora en que se modificó por última vez el registro del proveedor. |


# VISTAS

## 1. Vista: `view_products_with_inventory_and_discount`
### Descripción:
Esta vista proporciona información detallada de los productos, incluyendo su inventario actual y los descuentos aplicables, mostrando también el precio después del descuento.

### Columnas:
- **id_product**: Identificador único del producto.
- **product_name**: Nombre del producto.
- **product_description**: Descripción del producto.
- **SKU**: Código de identificación del producto (Stock Keeping Unit).
- **price**: Precio del producto antes de descuentos.
- **stock_quantity**: Cantidad de producto disponible en inventario.
- **discount_name**: Nombre del descuento aplicado (si existe).
- **discount_percent**: Porcentaje de descuento aplicado.
- **discounted_price**: Precio final después de aplicar el descuento.

### Ejemplo de Consulta:
```sql
SELECT * FROM view_products_with_inventory_and_discount WHERE stock_quantity > 0;
```

## 2. Vista: `view_order_details`

### Descripción:
Muestra información detallada sobre las órdenes realizadas por los usuarios, incluyendo los detalles del usuario y el método de pago.

### Columnas:
- **id_order_details**: Identificador único de la orden.
- **user_name**: Nombre de usuario que realizó la orden.
- **first_name**: Primer nombre del usuario.
- **last_name**: Apellido del usuario.
- **shipping_address**: Dirección de envío proporcionada por el usuario.
- **order_total**: Total de la orden.
- **payment_provider**: Proveedor del servicio de pago utilizado.
- **payment_status**: Estado del pago (PENDING, COMPLETED, FAILED).
- **order_date**: Fecha en la que se creó la orden.

### Ejemplo de Consulta:
```sql
SELECT * FROM view_order_details WHERE payment_status = 'COMPLETED';
```

## 3. Vista: `view_cart_history`

### Descripción:
Proporciona el historial de los productos añadidos a los carritos de compras por los usuarios, junto con la información de la sesión y el usuario.

### Columnas:
- **id_cart_item**: Identificador único del ítem en el carrito.
- **user_id**: Identificador del usuario.
- **username**: Nombre de usuario.
- **product_name**: Nombre del producto en el carrito.
- **quantity**: Cantidad de productos añadidos al carrito.
- **session_total**: Total de la sesión de compra.
- **session_date**: Fecha en la que se creó la sesión de compra.

### Ejemplo de Consulta:
```sql
SELECT * FROM view_cart_history WHERE username = 'johndoe';
```

## 4. Vista: `view_user_addresses`

### Descripción:
Muestra las direcciones de envío asociadas a los usuarios, útil para la gestión de envíos y la validación de la información del cliente.

### Columnas:
- **id_user**: Identificador único del usuario.
- **username**: Nombre de usuario.
- **first_name**: Primer nombre del usuario.
- **last_name**: Apellido del usuario.
- **address_line1**: Primera línea de la dirección de envío.
- **address_line2**: Segunda línea de la dirección de envío (opcional).
- **city**: Ciudad de la dirección.
- **postal_code**: Código postal de la dirección.
- **country**: País de la dirección.
- **telephone**: Teléfono fijo del usuario (opcional).
- **mobile**: Teléfono móvil del usuario (opcional).

### Ejemplo de Consulta:
```sql
SELECT * FROM view_user_addresses WHERE city = 'Madrid';
```

## 5. Vista: `view_inventory_summary`

### Descripción:
Proporciona un resumen del inventario de productos, mostrando la cantidad disponible y el precio de cada producto.

### Columnas:
- **id_product**: Identificador único del producto.
- **product_name**: Nombre del producto.
- **available_stock**: Cantidad de producto disponible en inventario.
- **price**: Precio del producto.

### Ejemplo de Consulta:
```sql
SELECT * FROM view_inventory_summary WHERE available_stock > 10;
```
---

# FUNCIONES

## 1. Funcion: `calculate_order_total`

### Descripción:
Calcula el total de una orden, aplicando los descuentos correspondientes a los productos incluidos en la orden.

### Parámetros:
- **p_order_id (INT)**: ID de la orden.

### Retorno:
- **DECIMAL(10,2)**: El total calculado de la orden.

### Ejemplo de uso:
```sql
SELECT calculate_order_total(1);
```

## 2. Funcion: `get_product_stock`

### Descripción:
Obtiene la cantidad disponible de un producto específico en el inventario.

### Parámetros:
- **p_product_id (INT)**: ID del producto.

### Retorno:
- **INT**: La cantidad de stock disponible para el producto.

### Ejemplo de uso:
```sql
SELECT get_product_stock(5);
```

## 3. Funcion: `calculate_cart_total`

### Descripción:
Calcula el total de los productos en una sesión de carrito de compras.

### Parámetros:
- **p_session_id (INT)**: ID de la sesión de compras.

### Retorno:
- **DECIMAL(10,2)**: El total de la sesión de compras.

### Ejemplo de uso:
```sql
SELECT calculate_cart_total(10);
```

## 4. Funcion: `get_payment_status`

# get_payment_status

### Descripción:
Obtiene el estado de pago de una orden.

### Parámetros:
- **p_order_id (INT)**: ID de la orden.

### Retorno:
- **ENUM('PENDING', 'COMPLETED', 'FAILED')**: El estado de pago de la orden.

### Ejemplo de uso:
```sql
SELECT get_payment_status(2);
```

## 5. Funcion: `has_user_address`

### Descripción:
Verifica si un usuario tiene una dirección registrada.

### Parámetros:
- **p_user_id (INT)**: ID del usuario.

### Retorno:
- **BOOLEAN**: `TRUE` si el usuario tiene una dirección registrada, `FALSE` en caso contrario.

### Ejemplo de uso:
```sql
SELECT has_user_address(3);
```

## 6. Funcion: `get_total_completed_payments`

### Descripción:
Calcula el valor total de los pagos completados por un usuario.

### Parámetros:
- **p_user_id (INT)**: ID del usuario.

### Retorno:
- **DECIMAL(10,2)**: El total de pagos completados por el usuario.

### Ejemplo de uso:
```sql
SELECT get_total_completed_payments(4);
```

## 7. Funcion: `get_user_payment_provider`

### Descripción:
Obtiene el proveedor de pago preferido por un usuario.

### Parámetros:
- **p_user_id (INT)**: ID del usuario.

### Retorno:
- **VARCHAR(45)**: El nombre del proveedor de pago.

### Ejemplo de uso:
```sql
SELECT get_user_payment_provider(5);
```

## 8. Funcion: `get_average_order_value`

### Descripción:
Calcula el valor promedio de las órdenes realizadas por un usuario.

### Parámetros:
- **p_user_id (INT)**: ID del usuario.

### Retorno:
- **DECIMAL(10,2)**: El valor promedio de las órdenes.

### Ejemplo de uso:
```sql
SELECT get_average_order_value(6);
```

---

# Stored Procedures

## 1. Procedimiento: `add_product`

### Descripción:
Este procedimiento almacenado permite agregar un nuevo producto en la base de datos, vinculando el producto con el inventario y aplicando descuentos si es necesario.

### Parámetros:
- **p_name (VARCHAR(100))**: Nombre del producto.
- **p_description (VARCHAR(300))**: Descripción del producto.
- **p_SKU (VARCHAR(50))**: Código de identificación del producto (SKU).
- **p_category_id (INT)**: ID de la categoría del producto.
- **p_inventory_id (INT)**: ID del inventario asociado al producto.
- **p_price (DECIMAL(10,2))**: Precio del producto.
- **p_discount_id (INT)**: ID del descuento (opcional).

### Retorno:
No tiene retorno directo; inserta un registro en la tabla `product` con los datos proporcionados.

### Ejemplo de Uso:
```sql
CALL add_product('Laptop', 'High-end gaming laptop', 'LPT123', 1, 10, 1200.00, 2);
```

## 2. Procedimiento: `add_inventory`

### Descripción:
Este procedimiento almacenado permite agregar un nuevo registro en la tabla `product_inventory`, que se utiliza para gestionar el stock de productos.

### Parámetros:
- **p_inventory_id (INT)**: Id del producto al que se le va agregar el inventario
- **p_quantity (INT)**: Cantidad inicial del producto en inventario.

### Retorno:
No tiene retorno directo; inserta un nuevo registro en la tabla `product_inventory` con la cantidad proporcionada.

### Ejemplo de Uso:
```sql
CALL add_inventory(50);
```

## 3. Procedimiento: `update_product_price`

## Descripción:
Este procedimiento almacenado actualiza el precio de un producto existente en la base de datos.

### Parámetros:
- **p_product_id (INT)**: ID del producto cuyo precio se desea actualizar.
- **p_new_price (DECIMAL(10,2))**: Nuevo precio del producto.

### Retorno:
No tiene retorno directo; actualiza el precio del producto en la tabla `product`.

### Ejemplo de Uso:
```sql
CALL update_product_price(1, 999.99);
```

## 4. Procedimiento: `delete_product`

### Descripción:
Este procedimiento almacenado elimina (lógicamente) un producto de la base de datos marcándolo con la fecha de eliminación.

### Parámetros:
- **p_product_id (INT)**: ID del producto a eliminar.

### Retorno:
No tiene retorno directo; actualiza el campo `deleted_at` del producto en la tabla `product`.

### Ejemplo de Uso:
```sql
CALL delete_product(1);
```

## 5. Procedimiento: `add_discount`

### Descripción:
Este procedimiento permite agregar un nuevo descuento a la base de datos, que puede ser aplicado a productos.

### Parámetros:
- **p_name (VARCHAR(80))**: Nombre del descuento.
- **p_description (VARCHAR(120))**: Descripción del descuento.
- **p_discount_percent (TINYINT)**: Porcentaje de descuento que se aplicará.

### Retorno:
No tiene retorno directo; inserta un nuevo registro en la tabla `discount` con la información proporcionada.

### Ejemplo de Uso:
```sql
CALL add_discount('Verano', 'Descuento especial de verano', 15);
```
---

# Triggers

## Triggers para campos `modified_at` y `created_at`

### Descripción General
Estos triggers se encargan de actualizar automáticamente los campos `modified_at` y `created_at` en diversas tablas cuando se realizan operaciones de `UPDATE` o `INSERT`, respectivamente. Su función es registrar la fecha y hora en que se modificó o creó cada registro.

### Tablas Afectadas
- `product_inventory`
- `discount`
- `product_category`
- `product`
- `user`
- `order_details`
- `payment_details`
- `order_items`
- `user_address`
- `user_payment`
- `shopping_session`
- `cart_item`

### Trigger para `modified_at`
Actualiza el campo `modified_at` con la fecha y hora actuales al modificarse un registro.

- **Evento**: `BEFORE UPDATE`
- **Acción**: Establece `modified_at` a `NOW()`.

```sql
DELIMITER //
CREATE TRIGGER before_[tabla]_update_modified
BEFORE UPDATE ON [tabla]
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;
```

### Trigger para `created_at`
Establece el campo `created_at` con la fecha y hora actuales al crearse un nuevo registro.

- **Evento**: `BEFORE INSERT`
- **Acción**: Establece `created_at` a `NOW()`.

```sql
DELIMITER //
CREATE TRIGGER before_[tabla]_insert_created
BEFORE INSERT ON [tabla]
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;
```

## Triggers de Validación

### Trigger para validar que el precio del producto no sea negativo
Este trigger impide que se inserte o actualice un producto cuyo precio sea menor a 0.

- **Tabla**: `product`
- **Eventos**: `BEFORE INSERT` y `BEFORE UPDATE`
- **Acción**: Si el precio es menor a 0, se genera un error.

```sql
DELIMITER //
CREATE TRIGGER before_product_[evento]_validation
BEFORE [evento] ON product
FOR EACH ROW
BEGIN
  IF NEW.price < 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El precio del producto no puede ser negativo';
  END IF;
END //
DELIMITER ;
```

### Trigger para validar que la cantidad en el inventario no sea negativa
Este trigger asegura que no se inserte o actualice una cantidad negativa en el inventario.

- **Tabla**: `product_inventory`
- **Eventos**: `BEFORE INSERT` y `BEFORE UPDATE`
- **Acción**: Si la cantidad es menor a 0, se genera un error.

```sql
DELIMITER //
CREATE TRIGGER before_product_inventory_[evento]_validation
BEFORE [evento] ON product_inventory
FOR EACH ROW
BEGIN
  IF NEW.quantity < 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'La cantidad en inventario no puede ser negativa';
  END IF;
END //
DELIMITER ;
```

### Trigger para validar que el porcentaje de descuento esté entre 0 y 100
Este trigger valida que el porcentaje de descuento esté en un rango aceptable.

- **Tabla**: `discount`
- **Eventos**: `BEFORE INSERT` y `BEFORE UPDATE`
- **Acción**: Si el porcentaje es menor a 0 o mayor a 100, se genera un error.

```sql
DELIMITER //
CREATE TRIGGER before_discount_[evento]_validation
BEFORE [evento] ON discount
FOR EACH ROW
BEGIN
  IF NEW.discount_percent < 0 OR NEW.discount_percent > 100 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El porcentaje de descuento debe estar entre 0 y 100';
  END IF;
END //
DELIMITER ;
```

### Trigger para validar la fecha de expiración del método de pago
Este trigger asegura que la fecha de expiración de un método de pago no sea en el pasado.

- **Tabla**: `user_payment`
- **Evento**: `BEFORE UPDATE`
- **Acción**: Si la fecha de expiración es anterior a la fecha actual, se genera un error.

```sql
DELIMITER //
CREATE TRIGGER before_user_payment_update_validation
BEFORE UPDATE ON user_payment
FOR EACH ROW
BEGIN
  IF STR_TO_DATE(CONCAT('01-', NEW.expiry), '%d-%m-%Y') < CURDATE() THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'La fecha de expiración del método de pago no puede ser en el pasado';
  END IF;
END //
DELIMITER ;
```

### Trigger para validar que el total del pedido sea mayor que 0
Este trigger impide que se inserte o actualice un pedido con total menor o igual a 0.

- **Tabla**: `order_details`
- **Eventos**: `BEFORE INSERT` y `BEFORE UPDATE`
- **Acción**: Si el total es menor o igual a 0, se genera un error.

```sql
DELIMITER //
CREATE TRIGGER before_order_details_[evento]_validation
BEFORE [evento] ON order_details
FOR EACH ROW
BEGIN
  IF NEW.total <= 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El total del pedido debe ser mayor que 0';
  END IF;
END //
DELIMITER ;
```

### Trigger para validar que la cantidad de productos en el carrito sea mayor que 0
Este trigger asegura que no se inserten o actualicen cantidades no válidas en el carrito de compras.

- **Tabla**: `cart_item`
- **Eventos**: `BEFORE INSERT` y `BEFORE UPDATE`
- **Acción**: Si la cantidad es menor o igual a 0, se genera un error.

```sql
DELIMITER //
CREATE TRIGGER before_cart_item_[evento]_validation
BEFORE [evento] ON cart_item
FOR EACH ROW
BEGIN
  IF NEW.quantity <= 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'La cantidad de productos en el carrito debe ser mayor que 0';
  END IF;
END //
DELIMITER ;
```
