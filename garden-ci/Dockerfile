FROM c2cnetworking/tas-runtime-build

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update -y && apt-get install --assume-yes --no-install-recommends \
      autoconf \
      bison \
      libblkid-dev \
      build-essential \
      flex \
      gettext \
      git \
      apparmor \
      iptables \
      iproute2 \
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
      libseccomp-dev \
      zlib1g-dev \
      xfsprogs \
      psmisc \
      && rm -rf /var/lib/apt/lists/*


# container rootfs
RUN mkdir -p /opt/warden && chmod 0755 /opt/warden
COPY rootfs.tar /opt/warden/rootfs.tar
COPY docker_registry_v2.tar /opt/warden/docker-registry-v2-rootfs.tar
COPY fuse-rootfs.tar /opt/warden/fuse-rootfs.tar
RUN chmod 0644 /opt/warden/*.tar

# create static assets dir
RUN mkdir -p /opt/static-assets && chmod 0755 /opt/static-assets

# install tar
RUN version="1.30" \
    && wget -qO- "https://ftp.gnu.org/gnu/tar/tar-${version}.tar.xz" | tar xJf - \
    && cd "tar-${version}" \
    && FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/opt/static-assets/tar \
    && make LDFLAGS=-static \
    && make install \
    && cd .. \
    && rm -rf "tar-${version}"

# copy apparmor profile
COPY apparmor-garden-default /opt/static-assets/garden-default

# add some unprivileged user
RUN groupadd -g 5000 whoever && useradd -u 5000 -g 5000 whoever
