USE `ecommerce`;
-- -----------------------------------------------------
-- Triggers de modificacion update
-- -----------------------------------------------------

-- Trigger para la tabla `product_inventory`
DELIMITER //
CREATE TRIGGER before_product_inventory_update_modified
BEFORE UPDATE ON product_inventory
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `discount`
DELIMITER //
CREATE TRIGGER before_discount_update_modified
BEFORE UPDATE ON discount
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `product_category`
DELIMITER //
CREATE TRIGGER before_product_category_update_modified
BEFORE UPDATE ON product_category
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `product`
DELIMITER //
CREATE TRIGGER before_product_update_modified
BEFORE UPDATE ON product
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `user`
DELIMITER //
CREATE TRIGGER before_user_update_modified
BEFORE UPDATE ON user
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `order_details`
DELIMITER //
CREATE TRIGGER before_order_details_update_modified
BEFORE UPDATE ON order_details
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `payment_details`
DELIMITER //
CREATE TRIGGER before_payment_details_update_modified
BEFORE UPDATE ON payment_details
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `order_items`
DELIMITER //
CREATE TRIGGER before_order_items_update_modified
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `user_address`
DELIMITER //
CREATE TRIGGER before_user_address_update_modified
BEFORE UPDATE ON user_address
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `user_payment`
DELIMITER //
CREATE TRIGGER before_user_payment_update_modified
BEFORE UPDATE ON user_payment
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `shopping_session`
DELIMITER //
CREATE TRIGGER before_shopping_session_update_modified
BEFORE UPDATE ON shopping_session
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- Trigger para la tabla `cart_item`
DELIMITER //
CREATE TRIGGER before_cart_item_update_modified
BEFORE UPDATE ON cart_item
FOR EACH ROW
BEGIN
  SET NEW.modified_at = NOW();
END //
DELIMITER ;

-- -----------------------------------------------------
-- Triggers de creacion insert
-- -----------------------------------------------------

-- Trigger para establecer el created_at en la tabla product_inventory
DELIMITER //
CREATE TRIGGER before_product_inventory_insert_created
BEFORE INSERT ON product_inventory
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla discount
DELIMITER //
CREATE TRIGGER before_discount_insert_created
BEFORE INSERT ON discount
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla product_category
DELIMITER //
CREATE TRIGGER before_product_category_insert_created
BEFORE INSERT ON product_category
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla product
DELIMITER //
CREATE TRIGGER before_product_insert_created
BEFORE INSERT ON product
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla order_details
DELIMITER //
CREATE TRIGGER before_order_details_insert_created
BEFORE INSERT ON order_details
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla payment_details
DELIMITER //
CREATE TRIGGER before_payment_details_insert_created
BEFORE INSERT ON payment_details
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla user
DELIMITER //
CREATE TRIGGER before_user_insert_created
BEFORE INSERT ON user
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla order_items
DELIMITER //
CREATE TRIGGER before_order_items_insert_created
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla user_address
DELIMITER //
CREATE TRIGGER before_user_address_insert_created
BEFORE INSERT ON user_address
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla user_payment
DELIMITER //
CREATE TRIGGER before_user_payment_insert_created
BEFORE INSERT ON user_payment
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla shopping_session
DELIMITER //
CREATE TRIGGER before_shopping_session_insert_created
BEFORE INSERT ON shopping_session
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- Trigger para establecer el created_at en la tabla cart_item
DELIMITER //
CREATE TRIGGER before_cart_item_insert_created
BEFORE INSERT ON cart_item
FOR EACH ROW
BEGIN
  SET NEW.created_at = NOW();
END //
DELIMITER ;


-- -----------------------------------------------------
-- Triggers de Validacion Basicos
-- -----------------------------------------------------

-- Trigger para validar que el precio del producto no sea negativo
DELIMITER //
CREATE TRIGGER before_product_insert_validation
BEFORE INSERT ON product
FOR EACH ROW
BEGIN
  IF NEW.price < 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El precio del producto no puede ser negativo';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_product_update_validation
BEFORE UPDATE ON product
FOR EACH ROW
BEGIN
  IF NEW.price < 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El precio del producto no puede ser negativo';
  END IF;
END //
DELIMITER ;

-- Trigger para validar que la cantidad en el inventario no sea negativa
DELIMITER //
CREATE TRIGGER before_product_inventory_insert_validation
BEFORE INSERT ON product_inventory
FOR EACH ROW
BEGIN
  IF NEW.quantity < 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'La cantidad en inventario no puede ser negativa';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_product_inventory_update_validation
BEFORE UPDATE ON product_inventory
FOR EACH ROW
BEGIN
  IF NEW.quantity < 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'La cantidad en inventario no puede ser negativa';
  END IF;
END //
DELIMITER ;

-- Trigger para validar que el porcentaje de descuento esté entre 0 y 100
DELIMITER //
CREATE TRIGGER before_discount_insert_validation
BEFORE INSERT ON discount
FOR EACH ROW
BEGIN
  IF NEW.discount_percent < 0 OR NEW.discount_percent > 100 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El porcentaje de descuento debe estar entre 0 y 100';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_discount_update_validation
BEFORE UPDATE ON discount
FOR EACH ROW
BEGIN
  IF NEW.discount_percent < 0 OR NEW.discount_percent > 100 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El porcentaje de descuento debe estar entre 0 y 100';
  END IF;
END //
DELIMITER ;

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

-- Trigger para validar que el total del pedido sea mayor que 0
DELIMITER //
CREATE TRIGGER before_order_details_insert_validation
BEFORE INSERT ON order_details
FOR EACH ROW
BEGIN
  IF NEW.total <= 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El total del pedido debe ser mayor que 0';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_order_details_update_validation
BEFORE UPDATE ON order_details
FOR EACH ROW
BEGIN
  IF NEW.total <= 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El total del pedido debe ser mayor que 0';
  END IF;
END //
DELIMITER ;

-- Trigger para validar que la cantidad de productos en el carrito sea mayor que 0
DELIMITER //
CREATE TRIGGER before_cart_item_insert_validation
BEFORE INSERT ON cart_item
FOR EACH ROW
BEGIN
  IF NEW.quantity <= 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'La cantidad de productos en el carrito debe ser mayor que 0';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_cart_item_update_validation
BEFORE UPDATE ON cart_item
FOR EACH ROW
BEGIN
  IF NEW.quantity <= 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'La cantidad de productos en el carrito debe ser mayor que 0';
  END IF;
END //
DELIMITER ;