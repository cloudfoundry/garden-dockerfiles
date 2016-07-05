#!/bin/bash

set -ex

docker pull busybox
docker tag busybox localhost:5000/busybox
docker push localhost:5000/busybox

