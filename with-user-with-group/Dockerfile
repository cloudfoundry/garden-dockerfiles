FROM busybox
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

RUN addgroup gardenparty -g 1010
RUN addgroup gardenparty2 -g 1011
RUN adduser -D -G gardenparty alice
RUN adduser alice gardenparty2
