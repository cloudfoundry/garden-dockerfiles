FROM ubuntu:14.04
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

RUN apt-get update && apt-get -y install \
  fuse \
  libfuse-dev \
  pkg-config

RUN cd /usr/share/doc/libfuse-dev/examples && \
  bash -c "gcc -Wall hello.c $(pkg-config fuse --cflags --libs) -o /usr/bin/hellofs"

RUN useradd -m -U alice
