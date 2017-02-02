FROM ubuntu:14.04
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

ENV GOPATH /root/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

ADD scripts/* scripts/
RUN scripts/passwordless_sudo.sh
RUN scripts/provision.sh
RUN scripts/build_tar.sh
RUN scripts/build_iptables.sh
RUN scripts/cleanup.sh
RUN scripts/grootfs_setup.sh

ADD dependencies/busybox.tar /opt/warden/rootfs
ADD dependencies/ubuntu.tar /opt/warden/nestable-rootfs
ADD dependencies/docker_registry.tar /opt/warden/docker-registry-rootfs
ADD dependencies/docker_registry_v2.tar /opt/warden/docker-registry-v2-rootfs
ADD dependencies/preexisting_users.tar /opt/warden/preexisting-users-rootfs
ADD dependencies/fuse.tar /opt/warden/fuse-rootfs

RUN mkdir /opt/warden/empty
ADD dependencies/hello /opt/warden/empty
RUN chmod 0777 /opt/warden/empty/hello; \
  mkdir -p /opt/warden/empty/etc; \
  touch /opt/warden/empty/etc/passwd; \
  touch /opt/warden/empty/etc/group; \
  useradd -R /opt/warden/empty -U alice; \
  useradd -R /opt/warden/empty -U alice
