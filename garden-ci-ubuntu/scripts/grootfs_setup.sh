#!/bin/bash

# Inspired by: https://github.com/cloudfoundry/grootfs/blob/659f5fd061b3176e310887d9ae874af6d2368b75/Dockerfile

set -e -x

apt-get update
apt-get install -y uidmap btrfs-tools sudo jq

useradd -d /home/groot -m -U groot
echo "groot ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

go get github.com/Masterminds/glide
go get github.com/fouralarmfire/grootsay

