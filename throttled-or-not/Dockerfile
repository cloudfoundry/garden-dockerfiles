FROM golang as builder

WORKDIR /go/src/app
COPY . .

RUN CGO_ENABLED=0 go build -mod vendor /go/src/app/main.go

FROM busybox

COPY --from=builder /go/src/app/main /go/src/app/main
CMD [ "/main" ]
