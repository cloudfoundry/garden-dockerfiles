FROM ubuntu:14.04
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

ENV GOPATH /root/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

ADD scripts/* scripts/
RUN scripts/passwordless_sudo.sh
RUN scripts/provision.sh
RUN scripts/build_static_assets.sh
RUN scripts/build_apparmor.sh
RUN scripts/cleanup.sh

COPY dependencies/busybox.tar /opt/warden/rootfs.tar
COPY dependencies/ubuntu.tar /opt/warden/nestable-rootfs.tar
COPY dependencies/docker_registry.tar /opt/warden/docker-registry-rootfs.tar
COPY dependencies/docker_registry_v2.tar /opt/warden/docker-registry-v2-rootfs.tar
COPY dependencies/preexisting_users.tar /opt/warden/preexisting-users-rootfs.tar
COPY dependencies/fuse.tar /opt/warden/fuse-rootfs.tar

RUN mkdir /opt/warden/empty
ADD dependencies/hello /opt/warden/empty
RUN chmod 0777 /opt/warden/empty/hello; \
  mkdir -p /opt/warden/empty/etc; \
  touch /opt/warden/empty/etc/passwd; \
  touch /opt/warden/empty/etc/group; \
  useradd -R /opt/warden/empty -U alice; \
  useradd -R /opt/warden/empty -U alice
