To run the migration:

```json
migrate -path db/migration -database "postgresql://admin:admin123@localhost:5433/simple_bank?sslmode=disable" -verbose up
```

To create an image:

```bash
docker build -t simplebank:latest .

```

# To generate dbdocs

```bash
dbdocs login
dbdocs build docs/db.dbml
```