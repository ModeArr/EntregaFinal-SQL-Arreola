USE `ecommerce`;

-- Inserción de datos en la tabla payment_providers
INSERT INTO payment_providers (name, description)
VALUES ('PayPal', 'Online payment provider'),
       ('Visa', 'Credit and Debit card provider'),
       ('MasterCard', 'Credit card provider');

-- Inserción de datos en la tabla product_inventory
INSERT INTO product_inventory (quantity) 
VALUES (100),
       (200),
       (50),
       (150),
       (300);

-- Inserción de datos en la tabla discount
INSERT INTO discount (name, description, discount_percent, active) 
VALUES ('Black Friday', 'Descuento especial del Black Friday', 20, 1),
       ('Cyber Monday', 'Descuento especial del Cyber Monday', 25, 1),
       ('Verano', 'Descuento de verano', 15, 1);

-- Inserción de datos en la tabla product_category
INSERT INTO product_category (name, description) 
VALUES ('Electronics', 'Productos electrónicos'),
       ('Home Appliances', 'Electrodomésticos'),
       ('Books', 'Libros de todo tipo'),
       ('Clothing', 'Ropa y accesorios');

-- Inserción de datos en la tabla product
INSERT INTO product (name, description, SKU, category_id, inventory_id, price, discount_id) 
VALUES ('Smartphone X', 'Último modelo de smartphone con 128GB', 'SKU123', 1, 1, 699.99, 1),
       ('Smart TV 4K', 'Televisión inteligente de 55 pulgadas', 'SKU456', 2, 2, 1199.99, 2),
       ('Laptop Gaming', 'Laptop de 16GB RAM y 1TB SSD', 'SKU789', 1, 3, 1299.99, 3),
       ('Aire Acondicionado', 'Aire acondicionado 18000 BTU', 'SKU321', 2, 4, 499.99, 1),
       ('Camiseta Negra', 'Camiseta de algodón', 'SKU654', 4, 5, 19.99, 2),
       ('Harry Potter y la Piedra Filosofal', 'Libro de la saga Harry Potter', 'SKU987', 3, 1, 9.99, 3);

-- Inserción de datos en la tabla user
INSERT INTO user (username, password, first_name, last_name, address, telephone) 
VALUES ('jdoe', 'pass1234', 'John', 'Doe', '123 Main St', '555-1234'),
       ('asmith', 'pass5678', 'Alice', 'Smith', '456 Oak St', '555-5678'),
       ('bwayne', 'batman123', 'Bruce', 'Wayne', '1007 Mountain Dr', '555-1010'),
       ('ckent', 'superman1', 'Clark', 'Kent', '81 Metropolis Ave', '555-2020'),
       ('pjackson', 'password98', 'Peter', 'Jackson', '987 Hill St', '555-3030');

-- Inserción de datos en la tabla payment_details
INSERT INTO payment_details (amount, provider_id, status) 
VALUES (699.99, 2, 'COMPLETED'),
       (1199.99, 3, 'PENDING'),
       (1299.99, 1, 'COMPLETED'),
       (499.99, 2, 'FAILED'),
       (9.99, 3, 'COMPLETED');
       
-- Inserción de datos en la tabla order_details
INSERT INTO order_details (user_id, total, payment_id) 
VALUES (1, 699.99, 2),
       (2, 1199.99, 3),
       (3, 1299.99, 4),
       (4, 499.99, 1),
       (5, 9.99, 5);

-- Inserción de datos en la tabla shopping_session
INSERT INTO shopping_session (user_id, total) 
VALUES (1, 1699.97),
       (2, 1299.99),
       (3, 499.99),
       (4, 19.99),
       (5, 9.99);

-- Inserción de datos en la tabla cart_item
INSERT INTO cart_item (session_id, product_id, quantity) 
VALUES (1, 1, 1),
       (1, 2, 2),
       (2, 3, 1),
       (3, 4, 1),
       (4, 5, 3),
       (5, 6, 1);

-- Inserción de datos en la tabla order_items
INSERT INTO order_items (order_id, product_id, quantity) 
VALUES (1, 1, 10),
       (1, 2, 4),
       (2, 3, 5),
       (3, 4, 8),
       (4, 5, 5),
       (5, 6, 2);

-- Inserción de datos en la tabla user_address
INSERT INTO user_address (user_id, address_line1, address_line2, city, postal_code, country, telephone, mobile) 
VALUES (1, '123 Main St', 'Apt 1', 'New York', '10001', 'USA', '555-1234', '555-9876'),
       (2, '456 Oak St', NULL, 'Los Angeles', '90001', 'USA', '555-5678', '555-7654'),
       (3, '1007 Mountain Dr', NULL, 'Gotham', '07001', 'USA', '555-1010', '555-1111'),
       (4, '81 Metropolis Ave', 'Floor 2', 'Metropolis', '08001', 'USA', '555-2020', '555-2222'),
       (5, '987 Hill St', 'House 5', 'Chicago', '06001', 'USA', '555-3030', '555-3333');

-- Inserción de datos en la tabla user_payment
INSERT INTO user_payment (user_id, payment_type, provider_id, account_no, expiry) 
VALUES (1, 'Credit Card', 2, '1234567890123456', '12/24'),
       (2, 'PayPal', 1, 'asmith@gmail.com', '12/24'), 
       (3, 'Credit Card', 3, '6543210987654321', '11/23'),
       (4, 'Debit Card', 2, '1122334455667788', '10/25'), 
       (5, 'Credit Card', 2, '2233445566778899', '09/23'); 
