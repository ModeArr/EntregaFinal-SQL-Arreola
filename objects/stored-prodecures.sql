USE `ecommerce`;

DELIMITER //

CREATE PROCEDURE log_event (
    IN p_log_type ENUM('INFO', 'WARNING', 'ERROR', 'DEBUG'),
    IN p_message VARCHAR(255),
    IN p_user_id INT,
    IN p_table_name VARCHAR(50),
    IN p_operation ENUM('INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT')
)
BEGIN
    INSERT INTO system_logs (log_type, message, user_id, table_name, operation)
    VALUES (p_log_type, p_message, p_user_id, p_table_name, p_operation);
END //

CREATE PROCEDURE add_product (
    IN p_name VARCHAR(100),
    IN p_description VARCHAR(300),
    IN p_SKU VARCHAR(50),
    IN p_category_id INT,
    IN p_quantity INT UNSIGNED,
    IN p_price DECIMAL(10,2),
    IN p_discount_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL log_event('ERROR', 'Error al agregar producto', p_user_id, 'product', 'INSERT');
    END;

    START TRANSACTION;

    INSERT INTO product_inventory (quantity)
    VALUES (p_quantity);

    SET @inventory_id = LAST_INSERT_ID();

    INSERT INTO product (name, description, SKU, category_id, inventory_id, price, discount_id)
    VALUES (p_name, p_description, p_SKU, p_category_id, @inventory_id, p_price, p_discount_id);


    CALL log_event('INFO', 'Producto agregado', p_user_id, 'product', 'INSERT');

    COMMIT;
END; //

CREATE PROCEDURE update_product_inventory (
    IN p_inventory_id INT,
    IN p_quantity INT,
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL log_event('ERROR', 'Error al actualizar inventario', p_user_id, 'product_inventory', 'UPDATE');
    END;

    START TRANSACTION;

    UPDATE product_inventory 
    SET quantity = p_quantity
    WHERE id_product_inventory = p_inventory_id;


    CALL log_event('INFO', 'Inventario actualizado', p_user_id, 'product_inventory', 'UPDATE');

    COMMIT;
END; //

CREATE PROCEDURE add_payment_details (
    IN p_amount DECIMAL(10,2),
    IN p_provider_id INT,
    IN p_status ENUM('PENDING', 'COMPLETED', 'FAILED'),
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL log_event('ERROR', 'Error al agregar detalles de pago', p_user_id, 'payment_details', 'INSERT');
    END;

    START TRANSACTION;

    INSERT INTO payment_details (amount, provider_id, status)
    VALUES (p_amount, p_provider_id, p_status);


    CALL log_event('INFO', 'Detalles de pago agregados', p_user_id, 'payment_details', 'INSERT');

    COMMIT;
END; //

CREATE PROCEDURE add_order_items (
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT UNSIGNED,
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL log_event('ERROR', 'Error al agregar ítems a la orden', p_user_id, 'order_items', 'INSERT');
    END;

    START TRANSACTION;

    INSERT INTO order_items (order_id, product_id, quantity)
    VALUES (p_order_id, p_product_id, p_quantity);


    CALL log_event('INFO', 'Ítems agregados a la orden', p_user_id, 'order_items', 'INSERT');

    COMMIT;
END; //

CREATE PROCEDURE create_shopping_session (
    IN p_user_id INT,
    IN p_total DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL log_event('ERROR', 'Error al crear sesión de compra', p_user_id, 'shopping_session', 'INSERT');
    END;

    START TRANSACTION;

    INSERT INTO shopping_session (user_id, total)
    VALUES (p_user_id, p_total);


    CALL log_event('INFO', 'Sesión de compra creada', p_user_id, 'shopping_session', 'INSERT');

    COMMIT;
END; //

CREATE PROCEDURE update_payment_status (
    IN p_payment_id INT,
    IN p_status ENUM('PENDING', 'COMPLETED', 'FAILED'),
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL log_event('ERROR', 'Error al actualizar estado de pago', p_user_id, 'payment_details', 'UPDATE');
    END;

    START TRANSACTION;

    UPDATE payment_details
    SET status = p_status
    WHERE id_payment_details = p_payment_id;


    CALL log_event('INFO', 'Estado de pago actualizado', p_user_id, 'payment_details', 'UPDATE');

    COMMIT;
END; //

CREATE PROCEDURE update_user (
    IN p_user_id INT,
    IN p_first_name VARCHAR(45),
    IN p_last_name VARCHAR(45),
    IN p_address VARCHAR(85),
    IN p_telephone VARCHAR(15)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL log_event('ERROR', 'Error al actualizar datos de usuario', p_user_id, 'user', 'UPDATE');
    END;

    START TRANSACTION;

    UPDATE user 
    SET first_name = p_first_name, last_name = p_last_name, address = p_address, telephone = p_telephone
    WHERE id_user = p_user_id;


    CALL log_event('INFO', 'Datos de usuario actualizados', p_user_id, 'user', 'UPDATE');

    COMMIT;
END; //

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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL log_event('ERROR', 'Error al agregar dirección de usuario', p_user_id, 'user_address', 'INSERT');
    END;

    START TRANSACTION;

    INSERT INTO user_address (user_id, address_line1, address_line2, city, postal_code, country, telephone, mobile)
    VALUES (p_user_id, p_address_line1, p_address_line2, p_city, p_postal_code, p_country, p_telephone, p_mobile);


    CALL log_event('INFO', 'Dirección de usuario agregada', p_user_id, 'user_address', 'INSERT');

    COMMIT;
END; //

CREATE PROCEDURE get_available_products ()
BEGIN
    SELECT p.name, p.description, p.SKU, p.price, pi.quantity
    FROM product p
    INNER JOIN product_inventory pi ON p.inventory_id = pi.id_product_inventory
    WHERE pi.quantity > 0;
END //

DELIMITER ;