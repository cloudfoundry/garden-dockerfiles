FROM cloudfoundry/golang-ci
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

ENV GOPATH /root/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN go get github.com/onsi/ginkgo/ginkgo
RUN go install github.com/onsi/ginkgo/ginkgo
