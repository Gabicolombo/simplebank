.PHONY: up down createdb dropdb migrateup migratedown sqlc test mock server

# Variáveis de ambiente (podem ser sobrescritas pelo CI)
DB_HOST ?= localhost
DB_PORT ?= 5432
DB_USER ?= admin
DB_PASSWORD ?= admin123
DB_NAME ?= simple_bank

# Garantir que variáveis do ambiente sobrescrevam
export DB_HOST
export DB_PORT
export DB_USER
export DB_PASSWORD
export DB_NAME

DB_SOURCE = postgresql://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable

up:
	docker-compose up -d

down:
	docker-compose down

createdb:
	docker exec -i simple_bank psql -U $(DB_USER) -c "CREATE DATABASE $(DB_NAME);"

dropdb:
	docker exec -i simple_bank psql -U $(DB_USER) -c "DROP DATABASE $(DB_NAME);"

migrateup:
	migrate -path db/migration -database "$(DB_SOURCE)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_SOURCE)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_SOURCE)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_SOURCE)" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

mock:
	mockgen -source=db/sqlc/querier.go -destination=db/mock/store.go -package=mockdb

server:
	go run main.go