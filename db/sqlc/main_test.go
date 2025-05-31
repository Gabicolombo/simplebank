package db

import (
	"context"
	"log"
	"os"
	"testing"

	"github.com/jackc/pgx/v5/pgxpool"
	_ "github.com/lib/pq"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://admin:admin123@localhost:5433/simple_bank?sslmode=disable"
)

var testQueries *Queries
var testStore *Store

func TestMain(m *testing.M) {
	ctx := context.Background()

	connPool, err := pgxpool.New(ctx, dbSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	testQueries = New(connPool)
	testStore = NewStore(connPool)

	os.Exit(m.Run())
}
