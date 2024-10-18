include .env

COMPOSE_PROJECT_NAME=mysql

SERVICE_NAME=mysql
PASSWORD=${ROOT_PASSWORD}
DATABASE=${DATABASE_NAME}

TIMESTAMP=$(shell date +"%F_%H-%M-%S")

BACKUP_DIR="./backups"
DATABASE_CREATION=./structure/database-structure.sql
DATABASE_POPULATION=./structure/population.sql
DATABASE_ROLES=./roles/roles.sql
DATABASE_USERS=./roles/users.sql

DOCKER_COMPOSE_FILE=./docker-compose.yml
BACKUP_FILE="$(BACKUP_DIR)/$(DATABASE)-$(TIMESTAMP).sql"

FILES := $(wildcard ./objects/*.sql)


.PHONY: all up objects population clean roles show-roles-users test-db access-db clean-db backup-db restore-db restore-latest

all: up objects population roles

up:
	@echo "Create the instance of docker"
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build

	@echo "Waiting for MySQL to be ready..."
	bash wait_docker.sh

	@echo "Create the database structure"
	docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -e "source $(DATABASE_CREATION);"
	@if [ $$? -eq 0 ]; then \
		echo "La Base de datos '$(DATABASE_NAME)' fue creada correctamente"; \
	else \
		echo "Error al crear la Base de datos '$(DATABASE_NAME)'"; \
	fi
	
objects:
	@echo "Create objects in database"
	@for file in $(FILES); do \
	    echo "Process $$file and add to the database: $(DATABASE_NAME)"; \
	    docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -e "source $$file"; \
	    if [ $$? -ne 0 ]; then \
	        echo "Error al procesar el archivo $$file"; \
	        exit 1; \
	    fi; \
	done

population:
	@echo "Populate fields"
	docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -e "source $(DATABASE_POPULATION)";
	@if [ $$? -eq 0 ]; then \
		echo "La Base de datos '$(DATABASE_NAME)' fue populada con datos correctamente"; \
	else \
		echo "Error al popular la Base de datos '$(DATABASE_NAME)'"; \
	fi

roles:
	@echo "Create Users and Roles"
	@cat $(DATABASE_ROLES) | docker exec -i -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root $(DATABASE_NAME)
	@cat $(DATABASE_USERS) | docker exec -i -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root $(DATABASE_NAME)

show-roles-users:
	@echo "Show all users and their roles"
	docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -e "\
		SELECT user AS 'User', host AS 'Host' FROM mysql.user;" | column -t
	@echo "Privileges for each user:"
	docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -e "\
		SELECT grantee AS 'User', table_schema AS 'Database', privilege_type AS 'Privilege' \
		FROM information_schema.schema_privileges \
		WHERE privilege_type IN ('ALL', 'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP', 'GRANT OPTION', 'REFERENCES', 'INDEX', 'ALTER', 'CREATE TEMPORARY TABLES', 'LOCK TABLES', 'EXECUTE');" | column -t

test-db:
	@echo "Testing the tables"
	@TABLES=$$(docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -N -B -e "USE $(DATABASE_NAME); SHOW TABLES;"); \
	for TABLE in $$TABLES; do \
		echo "Table: $$TABLE"; \
		docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -N -B -e "USE $(DATABASE_NAME); SELECT * FROM $$TABLE LIMIT 5;"; \
		echo "----------------------------------------------"; \
	done

access-db:
	@echo "Access to db-client"
	docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root

clean-db:
	@echo "Remove the Database"
	docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -e "DROP DATABASE IF EXISTS $(DATABASE_NAME);"
	@echo "La Base de datos '$(DATABASE_NAME)' fue eliminada."
	
backup-db:
	@echo "Backup the Database"
	@mkdir -p $(BACKUP_DIR)
	docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysqldump -u root $(DATABASE_NAME) --skip-comments > $(BACKUP_FILE)
	@if [ $$? -eq 0 ]; then \
		echo "Backup de la base de datos '$(DATABASE_NAME)' creado exitosamente en $(BACKUP_FILE)"; \
	else \
		echo "Error al crear el backup de la base de datos"; \
	fi

restore-db:
	@echo "Restoring the Database from backup"
	@if [ -z "$$FILE" ]; then \
		echo "Por favor, proporciona el archivo de backup usando FILE=<ruta_del_backup>"; \
		exit 1; \
	fi
	@echo "Creating the database '$(DATABASE_NAME)' if it does not exist"
	docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -e "CREATE DATABASE IF NOT EXISTS $(DATABASE_NAME);"
	@echo "Restoring from $$FILE"
	docker exec -i -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root $(DATABASE_NAME) < $$FILE
	@if [ $$? -eq 0 ]; then \
		echo "La Base de datos '$(DATABASE_NAME)' fue restaurada correctamente desde el backup"; \
	else \
		echo "Error al restaurar la base de datos desde el backup"; \
	fi

restore-latest:
	@echo "Restoring the most recent backup"
	@LATEST_BACKUP=$$(ls -t $(BACKUP_DIR)/*.sql | head -n 1); \
	if [ -z "$$LATEST_BACKUP" ]; then \
		echo "No hay backups disponibles en la carpeta $(BACKUP_DIR)"; \
		exit 1; \
	fi; \
	echo "Creating the database '$(DATABASE_NAME)' if it does not exist"; \
	docker exec -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root -e "CREATE DATABASE IF NOT EXISTS $(DATABASE_NAME);"; \
	echo "Restoring from $$LATEST_BACKUP"; \
	docker exec -i -e MYSQL_PWD=$(PASSWORD) $(SERVICE_NAME) mysql -u root $(DATABASE_NAME) < $$LATEST_BACKUP; \
	if [ $$? -eq 0 ]; then \
		echo "La Base de datos '$(DATABASE_NAME)' fue restaurada correctamente desde el backup más reciente"; \
	else \
		echo "Error al restaurar la base de datos desde el backup más reciente"; \
	fi