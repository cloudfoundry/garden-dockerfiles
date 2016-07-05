FROM ubuntu:14.04
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

RUN apt-get update && apt-get -y install iptables quota && apt-get clean
RUN useradd -m -U alice

