#!/usr/bin/env bash
set -ex

export GOPATH=/root/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

# install build dependencies
# - graphviz is for rendering heap w/ pprof
apt-get update && \
apt-get -y --force-yes install \
  apparmor-utils \
  aufs-tools \
  build-essential \
  curl \
  git \
  graphviz \
  htop \
  iptables \
  jq \
  libapparmor-dev \
  libpython-dev \
  lsof \
  netcat \
  pkg-config \
  psmisc \
  python \
  quota \
  strace \
  uidmap \
  ulogd \
  wget \
  unzip \
  net-tools \
  iputils-ping

# seccomp profiles require a recent (>= 2.2.1) version of seccomp
echo 'deb http://httpredir.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list
apt-get update && \
apt-get -y --force-yes install \
  libseccomp2/jessie-backports \
  libseccomp-dev/jessie-backports
rm /etc/apt/sources.list.d/backports.list

wget -qO- https://storage.googleapis.com/golang/go1.11.2.linux-amd64.tar.gz | tar -C /usr/local -xzf -

go get github.com/onsi/ginkgo/ginkgo
go install github.com/onsi/ginkgo/ginkgo

wget -qO - "https://cli.run.pivotal.io/stable?release=linux64-binary&version=6.29.2&source=github-rel" | tar -zx cf
mv cf /usr/local/bin
chmod 755 /usr/local/bin/cf

# create dir for rootfses to upload to
mkdir -p /opt/warden
chmod 0777 /opt/warden

# add a user to run rootless tests as
groupadd -g 5000 rootless
useradd -u 5000 -g 5000 rootless

curl -o /usr/local/bin/bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-5.3.1-linux-amd64
chmod +rx /usr/local/bin/bosh

wget https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip -O tf.zip
unzip tf.zip
mv terraform /usr/local/bin/
chmod +rx /usr/local/bin/terraform
