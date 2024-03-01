FROM golang:1.22.0-alpine
WORKDIR /go/src/app
ADD main.go .
EXPOSE 8082
RUN go get -d -v ./...
RUN go install -v ./...
CMD ["app"]
