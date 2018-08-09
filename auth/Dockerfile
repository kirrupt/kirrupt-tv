FROM golang:1.9-alpine
WORKDIR /go/src/app
RUN apk add --update openssl git gcc build-base && \
    wget -O /usr/local/bin/dep https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 && \
    chmod +x /usr/local/bin/dep
RUN go get -u golang.org/x/lint/golint
ENV GIN_MODE release

ADD Gopkg.toml Gopkg.lock ./
RUN dep ensure --vendor-only
RUN echo "package main" >> /go/src/app/main.go && \
    echo "import (" >> /go/src/app/main.go && \
    echo '_ "github.com/gin-gonic/gin"' >> /go/src/app/main.go && \
    echo '_ "github.com/jinzhu/gorm"' >> /go/src/app/main.go && \
    echo '_ "github.com/jinzhu/gorm/dialects/mysql"' >> /go/src/app/main.go && \
    echo ")" >> /go/src/app/main.go && \
    echo "func main() {}" >> /go/src/app/main.go && \
    go build -i
ADD . .
RUN go build

CMD ./app
