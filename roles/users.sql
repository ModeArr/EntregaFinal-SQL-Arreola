USE `ecommerce`;

-- Crear usuarios y asignar roles

-- 1. Usuario admin_user: Usuario para administración total
CREATE USER IF NOT EXISTS 'admin_user'@'%' IDENTIFIED BY 'admin_password';
GRANT db_admin TO 'admin_user'@'%';

-- 2. Usuario app_user: Usuario para operaciones de lectura/escritura (utilizado por la aplicación)
CREATE USER IF NOT EXISTS 'app_user'@'%' IDENTIFIED BY 'app_password';
GRANT db_read_write TO 'app_user'@'%';

-- 3. Usuario readonly_user: Usuario solo para consultas de lectura
CREATE USER IF NOT EXISTS 'readonly_user'@'%' IDENTIFIED BY 'readonly_password';
GRANT db_read_only TO 'readonly_user'@'%';

-- 4. Usuario audit_user: Usuario para auditorías y consultas de logs
CREATE USER IF NOT EXISTS 'audit_user'@'%' IDENTIFIED BY 'audit_password';
GRANT db_audit TO 'audit_user'@'%';

-- Aplicar los privilegios
FLUSH PRIVILEGES;
