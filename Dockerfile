# Build stage
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

# Run stage
FROM golang:1.24-alpine
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .
COPY start.sh .
RUN chmod +x /app/start.sh
COPY db/migration ./db/migration
COPY --from=builder /app/db/migration ./db/migration  

EXPOSE 8088
CMD ["/app/main"]
ENTRYPOINT ["/app/start.sh"]