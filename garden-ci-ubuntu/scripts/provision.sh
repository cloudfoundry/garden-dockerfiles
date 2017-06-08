set -e -x

# install build dependencies
# - graphviz is for rendering heap w/ pprof
apt-get update && \
apt-get -y --force-yes install \
  build-essential \
  curl \
  git \
  graphviz \
  htop \
  libpython-dev \
  lsof \
  psmisc \
  python \
  strace \
  wget \
  iptables \
  aufs-tools \
  quota \
  ulogd \
  pkg-config \
  libapparmor-dev \
  apparmor-utils \
  netcat \
  uidmap

# seccomp profiles require a recent (>= 2.2.1) version of seccomp
echo 'deb http://httpredir.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list
apt-get update && \
apt-get -y --force-yes install \
  libseccomp2/jessie-backports \
  libseccomp-dev/jessie-backports
rm /etc/apt/sources.list.d/backports.list

wget -qO- https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz | tar -C /usr/local -xzf -

go get github.com/onsi/ginkgo/ginkgo
go install github.com/onsi/ginkgo/ginkgo

# create dir for rootfses to upload to
mkdir -p /opt/warden
chmod 0777 /opt/warden

# add a user to run rootless tests as
groupadd -g 5000 rootless
useradd -u 5000 -g 5000 rootless
