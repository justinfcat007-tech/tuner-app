FROM golang:1.25-alpine AS build

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /tuner-api .

FROM alpine:3.21
RUN addgroup -S tuner && adduser -S tuner -G tuner
WORKDIR /app
COPY --from=build /tuner-api /app/tuner-api
USER tuner
EXPOSE 8080
ENTRYPOINT ["/app/tuner-api"]
