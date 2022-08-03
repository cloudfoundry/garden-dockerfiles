FROM ubuntu:jammy

ENV GO_VERSION=1.18.4

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
      libtool \
      lsof \
      netcat-openbsd \
      net-tools \
      pkg-config \
      python2 \
      strace \
      sudo \
      uuid-dev \
      wget \
      iputils-ping \
      uidmap \
      curl \
      jq \
      unzip \
      sysstat \
      ca-certificates \
      libssl-dev \
      libinih-dev \
      zlib1g-dev \
      psmisc


# container rootfs
RUN mkdir -p /opt/warden && chmod 0755 /opt/warden
RUN mkdir -p /tmp/busybox
COPY assets/busybox.tar /tmp
RUN tar xf /tmp/busybox.tar -C /tmp/busybox
COPY usemem/usemem /tmp/busybox/bin
RUN tar cf /opt/warden/rootfs.tar -C /tmp/busybox .
RUN rm -rf /tmp/busybox
COPY assets/docker_registry_v2.tar /opt/warden/docker-registry-v2-rootfs.tar
COPY assets/fuse.tar /opt/warden/fuse-rootfs.tar
RUN chmod 0644 /opt/warden/rootfs.tar /opt/warden/docker-registry-v2-rootfs.tar /opt/warden/fuse-rootfs.tar

# create static assets dir
RUN mkdir -p /opt/static-assets && chmod 0755 /opt/static-assets

# install xfsprogs
RUN version=5.13.0 \
    && wget -qO- "http://ftp.ntu.edu.tw/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz" | tar zxf - \
    && cd "xfsprogs-${version}" \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf "xfsprogs-${version}"

# install libmnl (required by iptables)
RUN version=1.0.4 \
    && wget -qO- "https://www.netfilter.org/projects/libmnl/files/libmnl-${version}.tar.bz2" | tar jxf - \
    && cd "libmnl-${version}" \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf "libmnl-${version}"

# install libnftnl (requried by iptables)
RUN version=1.0.9 \
    && wget -qO- "https://www.netfilter.org/projects/libnftnl/files/libnftnl-${version}.tar.bz2" | tar jxf - \
    && cd "libnftnl-${version}" \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf "libnftnl-${version}"

# install iptables
RUN version=1.6.2 \
    && wget -qO- "https://netfilter.org/projects/iptables/files/iptables-${version}.tar.bz2" | tar jxf - \
    && cd "iptables-${version}" \
    && mkdir /opt/static-assets/iptables \
    && ./configure --prefix=/opt/static-assets/iptables --enable-static --disable-shared \
    && make \
    && make install \
    && cd .. \
    && rm -rf "iptables-${version}"

# install tar
RUN version="1.30" \
    && wget -qO- "https://ftp.gnu.org/gnu/tar/tar-${version}.tar.xz" | tar xJf - \
    && cd "tar-${version}" \
    && FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/opt/static-assets/tar \
    && make LDFLAGS=-static \
    && make install \
    && cd .. \
    && rm -rf "tar-${version}"

# install seccomp
RUN version=2.4.1 \
    && wget -qO- "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz" | tar zxf - \
    && cd "libseccomp-${version}" \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf "libseccomp-${version}"

# install apparmor
RUN version=2.13.2 \
    && wget -qO- "https://launchpad.net/apparmor/2.13/${version}/+download/apparmor-${version}.tar.gz" | tar zxf - \
    && cd "apparmor-${version}/libraries/libapparmor" \
    && sh ./autogen.sh \
    && sh ./configure --prefix=/usr \
    && make \
    && make install \
    && cd "../../utils" \
    && make \
    && make install \
    && cd "../parser" \
    && make \
    && make install \
    && cd ../.. \
    && mkdir -p /etc/apparmor.d/ \
    && cp -R "apparmor-${version}/profiles/apparmor.d/tunables" "/etc/apparmor.d/tunables" \
    && cp -R "apparmor-${version}/profiles/apparmor.d/abstractions" "/etc/apparmor.d/abstractions" \
    && rm -rf "apparmor-${version}"

# copy apparmor profile
COPY apparmor/garden-default /opt/static-assets/

# install golang
ENV GOROOT=/usr/local/go GOPATH="${HOME}/go" PATH="/usr/local/go/bin:${HOME}/go/bin:${PATH}"
RUN rm -rf /usr/local/go && wget -qO- "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xzf -

# install go packages
RUN go install github.com/onsi/ginkgo/ginkgo@latest

# add some unprivileged user
RUN groupadd -g 5000 whoever && useradd -u 5000 -g 5000 whoever

# install bosh-cli
RUN curl -L -o /usr/local/bin/bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v5.4.0/bosh-cli-5.4.0-linux-amd64 \
    && chmod +rx /usr/local/bin/bosh

# install the CF CLI
RUN wget -qO - "https://cli.run.pivotal.io/stable?release=linux64-binary&version=6.41.0&source=github-rel" | tar -zx cf \
    && mv cf /usr/local/bin \
    && chmod 755 /usr/local/bin/cf

# install terraform
RUN wget https://releases.hashicorp.com/terraform/1.1.8/terraform_1.1.8_linux_amd64.zip -O tf.zip \
    && unzip tf.zip \
    && mv terraform /usr/local/bin/ \
    && chmod +rx /usr/local/bin/terraform

RUN git clone https://github.com/rbenv/rbenv.git /rbenv
ENV PATH "/rbenv/bin:$PATH"
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
ENV PATH "$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

# install bundler for template-tests
RUN rbenv install 3.1.1 && rbenv global 3.1.1 && rbenv rehash && eval "$(rbenv init -)" && gem install bundler
