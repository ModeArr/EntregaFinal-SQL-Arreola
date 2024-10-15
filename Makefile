#!make
include .env

COMPOSE_PROJECT_NAME=mysql

SERVICE_NAME=mysql
HOST=localhost
PORT=3306
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


.PHONY: all up objects population clean roles

all: up objects population

up:

	@echo "Create the instance of docker"
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build

	@echo "Waiting for MySQL to be ready..."
	bash wait_docker.sh

	@echo "Create the import and run de script"
	docker exec -e MYSQL_PWD=$(PASSWORD) mysql mysql -u root -e "source $(DATABASE_CREATION);"
	@if [ $$? -eq 0 ]; then \
		echo "La Base de datos '$(DATABASE_NAME)' fue creada correctamente"; \
	else \
		echo "Error al crear la Base de datos '$(DATABASE_NAME)'"; \
	fi
	
objects:
	@echo "Create objects in database"
	@for file in $(FILES); do \
	    echo "Process $$file and add to the database: $(DATABASE_NAME)"; \
	docker exec -e MYSQL_PWD=$(PASSWORD) mysql mysql -u root -e "source $$file"; \
	done

population:
	@echo "Populate fields"
	docker exec -e MYSQL_PWD=$(PASSWORD) mysql mysql -u root -e "source $(DATABASE_POPULATION)";
	@if [ $$? -eq 0 ]; then \
		echo "La Base de datos '$(DATABASE_NAME)' fue populada con datos correctamente"; \
	else \
		echo "Error al popular con dato la  Base de datos '$(DATABASE_NAME)'"; \
	fi

roles:
	@echo "Create Users and Roles"
	@cat $(DATABASE_ROLES) | docker exec -i -e MYSQL_PWD=$(PASSWORD) mysql mysql -u root -h $(HOST) $(DATABASE_NAME)
	@cat $(DATABASE_USERS) | docker exec -i -e MYSQL_PWD=$(PASSWORD) mysql mysql -u root -h $(HOST) $(DATABASE_NAME)

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
	docker exec -e MYSQL_PWD=$(PASSWORD) mysql mysql -u root --host $(HOST) --port $(PORT) -e "DROP DATABASE IF EXISTS $(DATABASE_NAME);"
	@echo "Bye"
	
backup-db:
	@echo "Backup the Database"
	@mkdir -p $(BACKUP_DIR)
	docker exec -e MYSQL_PWD=$(PASSWORD) mysql mysqldump -u root --host $(HOST) --port $(PORT) $(DATABASE_NAME) --skip-comments > $(BACKUP_FILE)
	@if [ $$? -eq 0 ]; then \
		echo "Backup de la base de datos '$(DATABASE_NAME)' creado exitosamente en $(BACKUP_FILE)"; \
	else \
		echo "Error al crear el backup de la base de datos"; \
	fi