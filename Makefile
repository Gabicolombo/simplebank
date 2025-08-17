.PHONY: up down createdb dropdb migrateup migratedown sqlc test mock migrateup1 migratedown1

DB_HOST ?= localhost
DB_PORT ?= 5433
DB_USER ?= admin
DB_PASSWORD ?= admin123
DB_NAME ?= simple_bank
DB_SOURCE = postgresql://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable

up: 
	docker-compose up -d

down:
	docker-compose down

createdb:
	docker exec -i simple_bank psql -U $(DB_USER) -d $(DB_NAME) -c "CREATE DATABASE $(DB_NAME);"

dropdb:
	docker exec -i simple_bank psql -U $(DB_USER) -d $(DB_NAME) -c "DROP DATABASE $(DB_NAME);"

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
	mockgen -source=db/sqlc/store.go -destination=db/mock/store.go -package=mockdb

server:
	go run main.go