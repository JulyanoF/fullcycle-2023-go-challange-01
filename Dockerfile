# Build Stage
FROM golang:1.20-alpine3.17 as base
WORKDIR /builder
RUN apk add upx

ENV GO111MODULE=on CGO_ENABLED=0

COPY go.mod /builder/
RUN go mod download

COPY . .
RUN go build -o /builder/main /builder/fullcycle.go
RUN upx -9 /builder/main

# < 2MB
# Final Stage
# FROM gcr.io/distroless/static:latest
# WORKDIR /app
# COPY --from=base /builder/main fullcycle
FROM scratch
COPY --from=base /builder/main /fullcycle

ENTRYPOINT ["/fullcycle"]