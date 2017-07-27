FROM alpine:3.6
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

ADD https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.28-linux-amd64 /opt/bin/bosh
RUN chmod +x /opt/bin/bosh
ENV PATH=/opt/bin:$PATH

RUN apk update && apk add bash git
