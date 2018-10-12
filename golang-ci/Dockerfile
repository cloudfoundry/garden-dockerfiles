FROM golang:1.11.1-alpine3.7

RUN apk update && apk add curl git

RUN go get github.com/onsi/ginkgo/ginkgo

# Install cf to /opt, because it doesn't come from the package manager
ADD cache/cf-cli_6.33.1_linux_x86-64.tgz /opt/cf
RUN mkdir /opt/bin && ln -s /opt/cf/cf /opt/bin/cf
ENV PATH=/opt/bin:$PATH

# Many of our CI scripts are written for /bin/bash, not /bin/sh.
# Also, you can't concourse-hijack without /bin/bash! Remove this after
# https://github.com/concourse/concourse/issues/1073 is closed.
RUN apk add bash
