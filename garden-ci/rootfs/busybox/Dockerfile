ARG BUSYBOX_VERSION
FROM busybox:${BUSYBOX_VERSION}
ARG BUSYBOX_VERSION
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

ADD seed /etc/seed
RUN chmod 0644 /etc/seed
RUN echo "BUSYBOX_VERSION: ${BUSYBOX_VERSION}" >  /base-image-version.txt
RUN adduser -D alice
