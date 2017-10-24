#!/bin/bash

set -e -x

temp_dir_path=$(mktemp -d /tmp/build-apparmor-XXXXXX)
old_wd=$(pwd)
cd $temp_dir_path

apt-get update
apt-get install wget build-essential autoconf libtool gettext -y

wget "https://launchpad.net/apparmor/2.11/2.11.1/+download/apparmor-2.11.1.tar.gz"

tar zxf apparmor-2.11.1.tar.gz

pushd apparmor-2.11.1/libraries/libapparmor
  sh ./autogen.sh
  sh ./configure --prefix=/usr
  make
  make install
popd

pushd apparmor-2.11.1/binutils
  make
  make install
popd

pushd apparmor-2.11.1/utils
  make
  make install
popd

pushd apparmor-2.11.1/parser
  make
  make install
popd

cd $old_wd
rm -rf $temp_dir_path
