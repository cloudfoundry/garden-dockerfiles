#!/usr/bin/env bash

set -e

function install_libmnl() {
  local libmnl_version=1.0.4

  curl "https://www.netfilter.org/projects/libmnl/files/libmnl-${libmnl_version}.tar.bz2" | tar jxf -

  pushd "libmnl-${libmnl_version}"
    ./configure
    make
    make install
  popd

  rm -rf "libmnl-${libmnl_version}"
}

function install_libnftnl() {
  local libnftnl_version=1.0.8

  curl "https://www.netfilter.org/projects/libnftnl/files/libnftnl-${libnftnl_version}.tar.bz2" | tar jxf -

  pushd "libnftnl-${libnftnl_version}"
    ./configure
    make
    make install
  popd

  rm -rf "libnftnl-${libnftnl_version}"
}

function install_iptables() {
  local iptables_version=1.6.1

  install_libmnl
  install_libnftnl

  curl "http://www.netfilter.org/projects/iptables/files/iptables-${iptables_version}.tar.bz2" | tar jxf -

  pushd "iptables-${iptables_version}"
    mkdir /opt/static-assets/iptables
    ./configure --prefix=/opt/static-assets/iptables --enable-static --disable-shared
    make
    make install
  popd

  rm -rf "iptables-${iptables_version}"
}

function install_tar() {
  local tar_version=1.29

  curl "https://ftp.gnu.org/gnu/tar/tar-${tar_version}.tar.gz" | tar zxf -

  pushd "tar-${tar_version}"
    FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/opt/static-assets/tar
    make LDFLAGS=-static
    make install
  popd

  rm -rf "tar-${tar_version}"
}

function install_seccomp() {
  local seccomp_version=2.3.2

  curl -L "https://github.com/seccomp/libseccomp/releases/download/v${seccomp_version}/libseccomp-${seccomp_version}.tar.gz" | tar zxf -

  pushd "libseccomp-${seccomp_version}"
    ./configure --prefix=/opt/static-assets/libseccomp
    make
    make install
  popd

  rm -rf "libseccomp-${seccomp_version}"
}

apt-get update
apt-get -y install pkg-config bzip2 wget build-essential bison flex

mkdir -p /opt/static-assets

install_tar
install_iptables
install_seccomp
