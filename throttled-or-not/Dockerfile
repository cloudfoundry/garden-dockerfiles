FROM golang

WORKDIR /go/src/app
COPY . .

RUN go build -mod vendor /go/src/app/main.go

CMD [ "/go/src/app/main" ]
