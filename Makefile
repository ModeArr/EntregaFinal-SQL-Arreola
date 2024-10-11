#!make
include .env

COMPOSE_PROJECT_NAME=mysql

SERVICE_NAME=mysql
HOST=127.0.0.1
PORT=3306
PASSWORD=${ROOT_PASSWORD}
DATABASE=${DATABASE_NAME}

TIMESTAMP=$(shell date +"%F_%H-%M-%S")

BACKUP_DIR="./backups"
DATABASE_CREATION=./structure/database-structure.sql
DATABASE_POPULATION=./structure/population.sql

DOCKER_COMPOSE_FILE=./docker-compose.yml
BACKUP_FILE="$(BACKUP_DIR)/$(DATABASE)-$(TIMESTAMP).sql"

FILES := $(wildcard ./objects/*.sql)


.PHONY: all up objects clean

all: up objects

up:

	@echo "Create the instance of docker"
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build

	@echo "Waiting for MySQL to be ready..."
	bash wait_docker.sh

	@echo "Create the import and run de script"
	docker exec -it mysql mysql -u root -p$(PASSWORD) -e "source $(DATABASE_CREATION);"
	
objects:
	@echo "Create objects in database"
	@for file in $(FILES); do \
	    echo "Process $$file and add to the database: $(DATABASE_NAME)"; \
	docker exec -it mysql mysql -u root -p$(PASSWORD) -e "source $$file"; \
	done

population:
	@echo "Populate fields"
	docker exec -it mysql mysql -u root -p$(PASSWORD) -e "source $(DATABASE_POPULATION)"
	done

test-db:
	@echo "Testing the tables"
	@TABLES=$$(docker exec -it $(SERVICE_NAME) mysql -u root -p$(PASSWORD) -N -B -e "USE $(DATABASE_NAME); SHOW TABLES;"); \
	for TABLE in $$TABLES; do \
		echo "Table: $$TABLE"; \
		docker exec -it $(SERVICE_NAME) mysql -u root -p$(PASSWORD) -N -B -e "USE $(DATABASE_NAME); SELECT * FROM $$TABLE LIMIT 5;"; \
		echo "----------------------------------------------"; \
	done

access-db:
	@echo "Access to db-client"
	docker exec -it $(SERVICE_NAME) mysql -u root -p$(PASSWORD)

clean-db:
	@echo "Remove the Database"
	docker exec -it mysql mysql -u root -p$(PASSWORD) --host $(HOST) --port $(PORT) -e "DROP DATABASE IF EXISTS $(DATABASE_NAME);"
	@echo "Bye"
	
backup-db:
	@echo "Backup the Database"
	docker exec -it mysql mysqldump -u root -p$(PASSWORD) --host $(HOST) --port $(PORT) $(DATABASE_NAME) --skip-comments > $(BACKUP_FILE)
	@if [ $$? -eq 0 ]; then \
		echo "Backup de la base de datos '$(DATABASE_NAME)' creado exitosamente en $(BACKUP_FILE)"; \
	else \
		echo "Error al crear el backup de la base de datos"; \
	fi