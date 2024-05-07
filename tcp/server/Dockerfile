FROM golang:1.22.3-alpine
WORKDIR /go/src/app
ADD main.go .
EXPOSE 8081
RUN go get -d -v ./...
RUN go install -v ./...
CMD ["app"]
