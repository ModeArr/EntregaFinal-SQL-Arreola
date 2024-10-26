USE ecommerce;

DELIMITER //

DROP TABLE IF EXISTS test_results//
CREATE TABLE test_results (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(100),
    test_result VARCHAR(20),
    error_message VARCHAR(255),
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)//

CREATE PROCEDURE cleanup_test_data()
BEGIN

    DELETE FROM system_logs WHERE message LIKE 'Test%';
    DELETE FROM order_items WHERE order_id IN (SELECT id_order_details FROM order_details WHERE user_id = 99999);
    DELETE FROM order_details WHERE user_id = 99999;
    DELETE FROM product WHERE SKU LIKE 'TEST%';
    DELETE FROM product_inventory WHERE id_product_inventory NOT IN (SELECT inventory_id FROM product);
    DELETE FROM payment_details WHERE amount = 100.00 AND provider_id = 99999;
    DELETE FROM shopping_session WHERE user_id = 99999;
    DELETE FROM user_address WHERE user_id = 99999;
    DELETE FROM user WHERE id_user = 99999;
    

    TRUNCATE TABLE test_results;
END//

CREATE PROCEDURE register_test_result(
    IN p_test_name VARCHAR(100),
    IN p_result VARCHAR(20),
    IN p_error_message VARCHAR(255)
)
BEGIN
    INSERT INTO test_results (test_name, test_result, error_message)
    VALUES (p_test_name, p_result, p_error_message);
END//

CREATE PROCEDURE test_log_event()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_log_event', 'FAILED', 'Error al ejecutar log_event');
        ROLLBACK;
    END;
    
    START TRANSACTION;

    CALL log_event('INFO', 'Test message', 99999, 'test_table', 'INSERT');
    

    IF EXISTS (SELECT 1 FROM system_logs WHERE message = 'Test message' AND log_type = 'INFO') THEN
        CALL register_test_result('test_log_event', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_log_event', 'FAILED', 'Log no encontrado');
    END IF;
    COMMIT;
END//

CREATE PROCEDURE test_add_product()
BEGIN
    DECLARE v_product_id INT;
    DECLARE v_inventory_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_add_product', 'FAILED', 'Error al ejecutar add_product');
        ROLLBACK;
    END;
    
    START TRANSACTION;
    

    CALL add_product('Test Product', 'Test Description', 'TEST001', 1, 10, 99.99, NULL, 99999);
    

    SELECT id_product_inventory INTO v_inventory_id 
    FROM product_inventory 
    WHERE quantity = 10 
    ORDER BY created_at DESC 
    LIMIT 1;
    
    SELECT id_product INTO v_product_id 
    FROM product 
    WHERE name = 'Test Product' 
    AND SKU = 'TEST001';
    
    IF v_product_id IS NOT NULL AND v_inventory_id IS NOT NULL THEN
        CALL register_test_result('test_add_product', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_add_product', 'FAILED', 'Producto no encontrado');
    END IF;
    
    COMMIT;
END//

CREATE PROCEDURE test_update_product_inventory()
BEGIN
    DECLARE v_inventory_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_update_product_inventory', 'FAILED', 'Error en la prueba');
        ROLLBACK;
    END;
    
    START TRANSACTION;
    

    INSERT INTO product_inventory (quantity, created_at) VALUES (10, NOW());
    SET v_inventory_id = LAST_INSERT_ID();
    
    INSERT INTO product (name, SKU, inventory_id, price, created_at)
    VALUES ('Test Product Inv', 'TEST002', v_inventory_id, 99.99, NOW());
    

    CALL update_product_inventory(v_inventory_id, 20, 99999);
    

    IF EXISTS (SELECT 1 FROM product_inventory WHERE id_product_inventory = v_inventory_id AND quantity = 20) THEN
        CALL register_test_result('test_update_product_inventory', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_update_product_inventory', 'FAILED', 'Actualización fallida');
    END IF;
    
    COMMIT;
END//

CREATE PROCEDURE test_add_payment_details()
BEGIN
    DECLARE v_payment_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_add_payment_details', 'FAILED', 'Error en la prueba');
        ROLLBACK;
    END;
    
    START TRANSACTION;
    

    CALL add_payment_details(100.00, 1, 'PENDING', 1);
    

    SELECT id_payment_details INTO v_payment_id 
    FROM payment_details 
    WHERE amount = 100.00 
    AND provider_id = 1
    ORDER BY created_at DESC 
    LIMIT 1;
    
    IF v_payment_id IS NOT NULL THEN
        CALL register_test_result('test_add_payment_details', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_add_payment_details', 'FAILED', 'Pago no encontrado');
    END IF;
    
    COMMIT;
END//

CREATE PROCEDURE test_add_order_items()
BEGIN
    DECLARE v_order_item_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_add_order_items', 'FAILED', 'Error en la prueba');
        ROLLBACK;
    END;
    
    START TRANSACTION;
    

    INSERT INTO order_details (user_id, created_at) VALUES (99999, NOW());
    SET @order_id = LAST_INSERT_ID();
    

    IF NOT EXISTS (SELECT 1 FROM product WHERE SKU = 'TEST001') THEN
        CALL add_product('Test Product', 'Test Description', 'TEST001', 1, 10, 99.99, NULL, 99999);
    END IF;
    
    SET @product_id = (SELECT id_product FROM product WHERE SKU = 'TEST001');
    

    CALL add_order_items(@order_id, @product_id, 2, 99999);
    

    IF EXISTS (SELECT 1 FROM order_items WHERE order_id = @order_id AND quantity = 2) THEN
        CALL register_test_result('test_add_order_items', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_add_order_items', 'FAILED', 'Item no encontrado');
    END IF;
    
    COMMIT;
END//

CREATE PROCEDURE test_create_shopping_session()
BEGIN
    DECLARE v_session_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_create_shopping_session', 'FAILED', 'Error en la prueba');
        ROLLBACK;
    END;
    
    START TRANSACTION;
    

    CALL create_shopping_session(1, 150.00);
    

    SELECT id_shopping_session INTO v_session_id 
    FROM shopping_session 
    WHERE user_id = 1 
    AND total = 150.00
    ORDER BY created_at DESC 
    LIMIT 1;
    
    IF v_session_id IS NOT NULL THEN
        CALL register_test_result('test_create_shopping_session', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_create_shopping_session', 'FAILED', 'Sesión no encontrada');
    END IF;
    
    COMMIT;
END//

CREATE PROCEDURE test_update_payment_status()
BEGIN
    DECLARE v_payment_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_update_payment_status', 'FAILED', 'Error en la prueba');
        ROLLBACK;
    END;
    
    START TRANSACTION;
    

    INSERT INTO payment_details (amount, provider_id, status, created_at) 
    VALUES (100.00, 99999, 'PENDING', NOW());
    SET v_payment_id = LAST_INSERT_ID();
    

    CALL update_payment_status(v_payment_id, 'COMPLETED', 99999);
    

    IF EXISTS (SELECT 1 FROM payment_details WHERE id_payment_details = v_payment_id AND status = 'COMPLETED') THEN
        CALL register_test_result('test_update_payment_status', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_update_payment_status', 'FAILED', 'Estado no actualizado');
    END IF;
    
    COMMIT;
END//

CREATE PROCEDURE test_update_user()
BEGIN
    DECLARE v_user_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_update_user', 'FAILED', 'Error en la prueba');
        ROLLBACK;
    END;
    
    START TRANSACTION;
    

    INSERT INTO user (id_user, first_name, last_name, created_at) 
    VALUES (99999, 'Old', 'Name', NOW());
    

    CALL update_user(99999, 'New', 'Name', 'Test Address', '123456789');
    

    IF EXISTS (SELECT 1 FROM user 
              WHERE id_user = 99999 
              AND first_name = 'New' 
              AND last_name = 'Name') THEN
        CALL register_test_result('test_update_user', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_update_user', 'FAILED', 'Usuario no actualizado');
    END IF;
    
    COMMIT;
END//

CREATE PROCEDURE test_add_user_address()
BEGIN
    DECLARE v_address_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_add_user_address', 'FAILED', 'Error en la prueba');
        ROLLBACK;
    END;
    
    START TRANSACTION;
    

    IF NOT EXISTS (SELECT 1 FROM user WHERE id_user = 99999) THEN
        INSERT INTO user (id_user, first_name, last_name, created_at) 
        VALUES (99999, 'Test', 'User', NOW());
    END IF;
    

    CALL add_user_address(99999, 'Test Line 1', 'Test Line 2', 'Test City', '12345', 'Test Country', '123456', '654321');
    

    SELECT id_user_address INTO v_address_id 
    FROM user_address 
    WHERE user_id = 99999 
    AND address_line1 = 'Test Line 1'
    ORDER BY created_at DESC 
    LIMIT 1;
    
    IF v_address_id IS NOT NULL THEN
        CALL register_test_result('test_add_user_address', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_add_user_address', 'FAILED', 'Dirección no encontrada');
    END IF;
    
    COMMIT;
END//

CREATE PROCEDURE test_get_available_products()
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL register_test_result('test_get_available_products', 'FAILED', 'Error en la prueba');
        ROLLBACK;
    END;
    
    START TRANSACTION;
    

    IF NOT EXISTS (SELECT 1 FROM product WHERE SKU = 'TEST001') THEN
        CALL add_product('Test Available Product', 'Test Description', 'TEST001', 1, 10, 99.99, NULL, 99999);
    END IF;
    

    CALL get_available_products();
    

    IF EXISTS (SELECT 1 FROM product p 
              INNER JOIN product_inventory pi ON p.inventory_id = pi.id_product_inventory
              WHERE pi.quantity > 0 AND p.SKU = 'TEST001') THEN
        CALL register_test_result('test_get_available_products', 'PASSED', NULL);
    ELSE
        CALL register_test_result('test_get_available_products', 'FAILED', 'Producto no encontrado en resultados');
    END IF;
    
    COMMIT;
END//

CREATE PROCEDURE run_all_tests()
BEGIN

    CALL cleanup_test_data();
    

    CALL test_log_event();
    CALL test_add_product();
    CALL test_update_product_inventory();
    CALL test_add_payment_details();
    CALL test_add_order_items();
    CALL test_create_shopping_session();
    CALL test_update_payment_status();
    CALL test_update_user();
    CALL test_add_user_address();
    CALL test_get_available_products();
    

    SELECT test_name, test_result, error_message, execution_time 
    FROM test_results 
    ORDER BY test_id;
    

    CALL cleanup_test_data();
END//

DELIMITER ;
