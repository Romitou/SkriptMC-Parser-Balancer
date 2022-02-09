FROM alpine:3.14 AS build

WORKDIR /app/go/

RUN apk update
RUN apk upgrade
RUN apk add --update go

ADD . .
ENV GOPATH /app

RUN go get
RUN CGO_ENABLED=1 GOOS=linux go build -ldflags "-s -w" -o skmc-parser

FROM alpine:3.14

WORKDIR /app

COPY --from=build /app/go/skmc-parser /app/skmc-parser
RUN chmod +x ./skmc-parser

EXPOSE 8000

CMD ["./skmc-parser"]
