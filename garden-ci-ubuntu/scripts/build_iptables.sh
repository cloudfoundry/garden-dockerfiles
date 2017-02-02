#!/bin/bash

set -e -x

temp_dir_path=$(mktemp -d /tmp/build-iptables-XXXXXX)
old_wd=$(pwd)
cd $temp_dir_path

apt-get update
apt-get install wget build-essential bison flex -y

wget "https://www.netfilter.org/projects/iptables/files/iptables-1.6.1.tar.bz2"
wget "https://www.netfilter.org/projects/libnftnl/files/libnftnl-1.0.7.tar.bz2"
wget "https://www.netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2"

tar jxf iptables-1.6.1.tar.bz2
tar jxf libnftnl-1.0.7.tar.bz2
tar jxf libmnl-1.0.4.tar.bz2

pushd libmnl-1.0.4/
  ./configure
  make
  make install
popd

pushd libnftnl-1.0.7/
  ./configure
  make
  make install
popd

pushd iptables-1.6.1/
  ./configure
  make
  make install
popd

cd $old_wd
rm -rf $temp_dir_path
