USE `ecommerce`;

DELIMITER //

-- Calcular el total de la orden con descuento
CREATE FUNCTION calculate_order_total (
    p_order_id INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(p.price * oi.quantity * (1 - IFNULL(d.discount_percent, 0) / 100))
    INTO total
    FROM order_items oi
    JOIN product p ON oi.product_id = p.id_product
    LEFT JOIN discount d ON p.discount_id = d.id_discount
    WHERE oi.order_id = p_order_id;
    
    RETURN total;
END //

-- Obtener el stock de un producto
CREATE FUNCTION get_product_stock (
    p_product_id INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock INT;
    
    SELECT pi.quantity
    INTO stock
    FROM product_inventory pi
    JOIN product p ON p.inventory_id = pi.id_product_inventory
    WHERE p.id_product = p_product_id;
    
    RETURN stock;
END //

-- Calcular el total de una sesión de compra
CREATE FUNCTION calculate_cart_total (
    p_session_id INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(p.price * ci.quantity)
    INTO total
    FROM cart_item ci
    JOIN product p ON ci.product_id = p.id_product
    WHERE ci.session_id = p_session_id;
    
    RETURN total;
END //

-- Obtener el estado de pago de una orden
CREATE FUNCTION get_payment_status (
    p_order_id INT
)
RETURNS ENUM('PENDING', 'COMPLETED', 'FAILED')
DETERMINISTIC
BEGIN
    DECLARE status ENUM('PENDING', 'COMPLETED', 'FAILED');
    
    SELECT pd.status
    INTO status
    FROM payment_details pd
    WHERE pd.order_id = p_order_id;
    
    RETURN status;
END //

-- Verificar si un usuario tiene una dirección registrada
CREATE FUNCTION has_user_address (
    p_user_id INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE address_count INT;
    
    SELECT COUNT(*)
    INTO address_count
    FROM user_address
    WHERE user_id = p_user_id;
    
    RETURN (address_count > 0);
END //

-- Calcular el valor total de pagos completados por un usuario
CREATE FUNCTION get_total_completed_payments (
    p_user_id INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(pd.amount)
    INTO total
    FROM payment_details pd
    JOIN order_details od ON pd.order_id = od.id_order_details
    WHERE od.user_id = p_user_id
    AND pd.status = 'COMPLETED';
    
    RETURN total;
END //

-- Obtener el proveedor de pago de un usuario
CREATE FUNCTION get_user_payment_provider (
    p_user_id INT
)
RETURNS VARCHAR(45)
DETERMINISTIC
BEGIN
    DECLARE provider VARCHAR(45);
    
    SELECT up.provider
    INTO provider
    FROM user_payment up
    WHERE up.user_id = p_user_id
    LIMIT 1;
    
    RETURN provider;
END //

-- Calcular el valor promedio de las órdenes de un usuario
CREATE FUNCTION get_average_order_value (
    p_user_id INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_value DECIMAL(10,2);
    
    SELECT AVG(od.total)
    INTO avg_value
    FROM order_details od
    WHERE od.user_id = p_user_id;
    
    RETURN avg_value;
END //

DELIMITER ;