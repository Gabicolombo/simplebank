package db

import (
	"context"
	"log"
	"os"
	"testing"

	"github.com/jackc/pgx/v5"
	_ "github.com/lib/pq"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://admin:admin123@localhost:5433/simple_bank?sslmode=disable"
)

var testQueries *Queries

func TestMain(m *testing.M) {
	conn, err := pgx.Connect(context.Background(), dbSource)

	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	testQueries = New(conn)
	os.Exit(m.Run())
}
