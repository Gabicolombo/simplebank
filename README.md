To run the migration:

```json
migrate -path db/migration -database "postgresql://admin:admin123@localhost:5433/simple_bank?sslmode=disable" -verbose up
```