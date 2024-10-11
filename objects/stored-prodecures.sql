USE `ecommerce`;

DELIMITER //
-- Agregar un nuevo producto
CREATE PROCEDURE add_product (
    IN p_name VARCHAR(100),
    IN p_description VARCHAR(300),
    IN p_SKU VARCHAR(50),
    IN p_category_id INT,
    IN p_quantity INT UNSIGNED,
    IN p_price DECIMAL(10,2),
    IN p_discount_id INT
)
BEGIN
    INSERT INTO product_inventory (quantity)
    VALUES (p_quantity);

    SET @inventory_id = LAST_INSERT_ID();

    INSERT INTO product (name, description, SKU, category_id, inventory_id, price, discount_id)
    VALUES (p_name, p_description, p_SKU, p_category_id, @inventory_id, p_price, p_discount_id);
END; //

-- Actualizar inventario de un producto
CREATE PROCEDURE update_product_inventory (
    IN p_inventory_id INT,
    IN p_quantity INT
)
BEGIN
    UPDATE product_inventory 
    SET quantity = p_quantity
    WHERE id_product_inventory = p_inventory_id;
END //

-- Crear una nueva orden
CREATE PROCEDURE create_order (
    IN p_user_id INT,
    IN p_total DECIMAL(10,2)
)
BEGIN
    INSERT INTO order_details (user_id, total)
    VALUES (p_user_id, p_total);
END //

-- Agregar detalles de pago
CREATE PROCEDURE add_payment_details (
    IN p_amount DECIMAL(10,2),
    IN p_provider VARCHAR(45),
    IN p_status ENUM('PENDING', 'COMPLETED', 'FAILED')
)
BEGIN
    INSERT INTO payment_details (amount, provider, status)
    VALUES (p_amount, p_provider, p_status);
END //

-- Agregar ítems a una orden
CREATE PROCEDURE add_order_items (
    IN p_order_id INT,
    IN p_product_id INT
)
BEGIN
    INSERT INTO order_items (order_id, product_id)
    VALUES (p_order_id, p_product_id);
END //

-- Crear una sesión de compra
CREATE PROCEDURE create_shopping_session (
    IN p_user_id INT,
    IN p_total DECIMAL(10,2)
)
BEGIN
    INSERT INTO shopping_session (user_id, total)
    VALUES (p_user_id, p_total);
END //

-- Actualizar estado de pago
CREATE PROCEDURE update_payment_status (
    IN p_payment_id INT,
    IN p_status ENUM('PENDING', 'COMPLETED', 'FAILED')
)
BEGIN
    UPDATE payment_details
    SET status = p_status
    WHERE id_payment_details = p_payment_id;
END //

-- Actualizar datos de usuario
CREATE PROCEDURE update_user (
    IN p_user_id INT,
    IN p_first_name VARCHAR(45),
    IN p_last_name VARCHAR(45),
    IN p_address VARCHAR(85),
    IN p_telephone VARCHAR(15)
)
BEGIN
    UPDATE user 
    SET first_name = p_first_name, last_name = p_last_name, address = p_address, telephone = p_telephone
    WHERE id_user = p_user_id;
END //

-- Ver productos disponibles
CREATE PROCEDURE get_available_products ()
BEGIN
    SELECT p.name, p.description, p.SKU, p.price, pi.quantity
    FROM product p
    INNER JOIN product_inventory pi ON p.inventory_id = pi.id_product_inventory
    WHERE pi.quantity > 0;
END //

-- Agregar dirección de usuario
CREATE PROCEDURE add_user_address (
    IN p_user_id INT,
    IN p_address_line1 VARCHAR(60),
    IN p_address_line2 VARCHAR(45),
    IN p_city VARCHAR(45),
    IN p_postal_code VARCHAR(10),
    IN p_country VARCHAR(45),
    IN p_telephone VARCHAR(15),
    IN p_mobile VARCHAR(15)
)
BEGIN
    INSERT INTO user_address (user_id, address_line1, address_line2, city, postal_code, country, telephone, mobile)
    VALUES (p_user_id, p_address_line1, p_address_line2, p_city, p_postal_code, p_country, p_telephone, p_mobile);
END //

DELIMITER ;
