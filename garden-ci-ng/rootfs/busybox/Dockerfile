FROM busybox:1.27.2
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

ADD seed /etc/seed
RUN chmod 0644 /etc/seed
RUN adduser -D alice
