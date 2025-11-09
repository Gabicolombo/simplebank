.PHONY: up down createdb dropdb migrateup migratedown db_docs db_schema sqlc test mock server

# Variáveis de ambiente (podem ser sobrescritas pelo CI)
DB_HOST ?= localhost
DB_PORT ?= 5433
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

db_docs:
	dbdocs build docs/db.dbml

db_schema:
	dbml2sql --postgres -o docs/schema.sql docs/db.dbml

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/techschool/simplebank/db/sqlc Store

# here we need to force the regenaration using `make -B proto`
proto:
	rm -f pb/*.go
	protoc --proto_path=proto --proto_path=third_party/googleapis --go_out=pb --go-grpc_out=pb --go_opt=paths=source_relative \
	--go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
	proto/*.proto

server:
	go run main.go