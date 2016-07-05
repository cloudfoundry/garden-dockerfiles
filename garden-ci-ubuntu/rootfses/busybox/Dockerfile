FROM busybox:latest
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

ADD seed /etc/seed
RUN chmod 0644 /etc/seed
RUN adduser -D alice
