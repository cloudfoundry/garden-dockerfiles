#!/bin/bash
set -euo pipefail

version=${1:-ubuntu}
image_tag="cfgarden/garden-ci-$version"
build_ctr=build-garden-ci-$version
image_name="ansible-able-$version"

cd "$(dirname "$0")"

trap 'docker rm "$build_ctr"' EXIT

docker run --name "$build_ctr" -v "$PWD:/garden-ci-ubuntu" \
  -e GARDEN_DEBUG="${GARDEN_DEBUG:-}" \
  -w /garden-ci-ubuntu cfgarden/$image_name ./build-in-container.sh

docker commit -c 'ENV GOPATH /root/go' \
  -c 'ENV PATH /root/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
  "$build_ctr" "$image_tag"

