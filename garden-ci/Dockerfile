FROM ubuntu:xenial

RUN apt update \
    && apt upgrade --yes \
    && apt install --yes \
      autoconf \
      bison \
      libblkid-dev \
      build-essential \
      flex \
      gettext \
      git \
      iptables \
      libseccomp-dev \
      libtool \
      lsof \
      netcat \
      net-tools \
      pkg-config \
      python \
      strace \
      sudo \
      uuid-dev \
      wget \
      iputils-ping \
      uidmap \
      curl \
      jq \
      unzip \
      ruby-full


# container rootfs
RUN mkdir -p /opt/warden && chmod 0755 /opt/warden
COPY assets/busybox.tar /opt/warden/rootfs.tar
RUN chmod 0644 /opt/warden/rootfs.tar
COPY assets/docker_registry_v2.tar /opt/warden/docker-registry-v2-rootfs.tar
RUN chmod 0644 /opt/warden/docker-registry-v2-rootfs.tar
COPY assets/fuse.tar /opt/warden/fuse-rootfs.tar
RUN chmod 0644 /opt/warden/fuse-rootfs.tar

# create static assets dir
RUN mkdir -p /opt/static-assets && chmod 0755 /opt/static-assets

# install xfsprogs
ENV XFSPROGS_VERSION 4.3.0
RUN wget -qO- "http://ftp.ntu.edu.tw/linux/utils/fs/xfs/xfsprogs/xfsprogs-${XFSPROGS_VERSION}.tar.gz" | tar zxf -
RUN cd "xfsprogs-${XFSPROGS_VERSION}" \
    && ./configure \
    && make \
    && make install
RUN rm -rf "xfsprogs-${XFSPROGS_VERSION}"

# install libmnl (required by iptables)
ENV LIBMNL_VERSION 1.0.4
RUN wget -qO- "https://www.netfilter.org/projects/libmnl/files/libmnl-${LIBMNL_VERSION}.tar.bz2" | tar jxf -
RUN cd "libmnl-${LIBMNL_VERSION}" \
    && ./configure \
    && make \
    && make install
RUN rm -rf "libmnl-${LIBMNL_VERSION}"

# install libnftnl (requried by iptables)
ENV LIBNFTNL_VERSION 1.0.9
RUN wget -qO- "https://www.netfilter.org/projects/libnftnl/files/libnftnl-${LIBNFTNL_VERSION}.tar.bz2" | tar jxf -
RUN cd "libnftnl-${LIBNFTNL_VERSION}" \
    && ./configure \
    && make \
    && make install
RUN rm -rf "libnftnl-${LIBNFTNL_VERSION}"

# install iptables
ENV IPTABLES_VERSION 1.6.2
RUN wget -qO- "https://netfilter.org/projects/iptables/files/iptables-${IPTABLES_VERSION}.tar.bz2" | tar jxf -
RUN cd "iptables-${IPTABLES_VERSION}" \
    && mkdir /opt/static-assets/iptables \
    && ./configure --prefix=/opt/static-assets/iptables --enable-static --disable-shared \
    && make \
    && make install
RUN rm -rf "iptables-${IPTABLES_VERSION}"

# install tar
ENV TAR_VERSION "1.30"
RUN wget -qO- "https://ftp.gnu.org/gnu/tar/tar-${TAR_VERSION}.tar.xz" | tar xJf -
RUN cd "tar-${TAR_VERSION}" \
    && FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/opt/static-assets/tar \
    && make LDFLAGS=-static \
    && make install
RUN rm -rf "tar-${TAR_VERSION}"

# install seccomp
ENV SECCOMP_VERSION 2.3.3
RUN wget -qO- "https://github.com/seccomp/libseccomp/releases/download/v${SECCOMP_VERSION}/libseccomp-${SECCOMP_VERSION}.tar.gz" | tar zxf -
RUN cd "libseccomp-${SECCOMP_VERSION}" \
    && ./configure --prefix=/opt/static-assets/libseccomp \
    && make \
    && make install
RUN rm -rf "libseccomp-${SECCOMP_VERSION}"

# install apparmor
ENV APPARMOR_VERSION 2.11.1
RUN wget -qO- "https://launchpad.net/apparmor/2.11/${APPARMOR_VERSION}/+download/apparmor-${APPARMOR_VERSION}.tar.gz" | tar zxf -
RUN cd "apparmor-${APPARMOR_VERSION}/libraries/libapparmor" \
    && sh ./autogen.sh \
    && sh ./configure --prefix=/usr \
    && make \
    && make install
RUN cd "apparmor-${APPARMOR_VERSION}/binutils" \
    && make \
    && make install
RUN cd "apparmor-${APPARMOR_VERSION}/utils" \
    && make \
    && make install
RUN cd "apparmor-${APPARMOR_VERSION}/parser" \
    && make \
    && make install
RUN rm -rf "apparmor-${APPARMOR_VERSION}"

# install golang
ENV GO_VERSION 1.11.2
ENV GOROOT /usr/local/go
ENV GOPATH "${HOME}/go"
ENV PATH "${GOROOT}/bin:${GOPATH}/bin:${PATH}"
RUN wget -qO- "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xzf -

# install go packages
RUN go get github.com/onsi/ginkgo/ginkgo
RUN go get github.com/fouralarmfire/grootsay

# add some unprivileged user
RUN groupadd -g 5000 whoever && useradd -u 5000 -g 5000 whoever

# install bosh-cli
RUN curl -L -o /usr/local/bin/bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v5.4.0/bosh-cli-5.4.0-linux-amd64 \
    && chmod +rx /usr/local/bin/bosh

# install the CF CLI
RUN wget -qO - "https://cli.run.pivotal.io/stable?release=linux64-binary&version=6.41.0&source=github-rel" | tar -zx cf \
    && mv cf /usr/local/bin \
    && chmod 755 /usr/local/bin/cf

# install dep
RUN wget https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 -O /usr/local/bin/dep \
    && chmod +x /usr/local/bin/dep

# install terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip -O tf.zip \
    && unzip tf.zip \
    && mv terraform /usr/local/bin/ \
    && chmod +rx /usr/local/bin/terraform \
