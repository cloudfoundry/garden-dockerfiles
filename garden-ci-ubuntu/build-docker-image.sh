#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

build_ctr=build-garden-ci-ubuntu
trap 'docker rm "$build_ctr"' EXIT

docker run --name $build_ctr -v $PWD:/garden-ci-ubuntu \
  -e GARDEN_DEBUG=${GARDEN_DEBUG:-} \
  -w /garden-ci-ubuntu cfgarden/ansible-able ./build-in-container.sh

tag=${IMAGE_TAG:-cfgarden/garden-ci-ubuntu}

docker commit -c 'ENV GOPATH /root/go' \
  -c 'ENV PATH /root/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
  build-garden-ci-ubuntu "$tag"
