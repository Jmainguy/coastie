FROM golang:1.21.1-alpine
WORKDIR /go/src/app
ADD main.go .
EXPOSE 8080
RUN go get -d -v ./...
RUN go install -v ./...
CMD ["app"]
