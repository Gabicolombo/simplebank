.PHONY: up down createdb dropdb migrateup migratedown
# Makefile for managing Docker containers and PostgreSQL database

up: 
	docker-compose up -d
down:
	docker-compose down

createdb:
	docker exec -i simple_bank psql -U admin -d simple_bank -c "CREATE DATABASE simple_bank;"

dropdb:
	docker exec -i simple_bank psql -U admin -d simple_bank -c "DROP DATABASE simple_bank;"

migrateup:
	migrate -path db/migration -database "postgresql://admin:admin123@localhost:5433/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://admin:admin123@localhost:5433/simple_bank?sslmode=disable" -verbose down