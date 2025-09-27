# Build stage
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main .

# Run stage
FROM golang:1.24-alpine
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .

EXPOSE 8088
CMD ["/app/main"]