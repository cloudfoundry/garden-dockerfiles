#!/bin/bash
set -euo pipefail

export GOPATH=/root/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

tags() {
  tags="docker"
  if [ -n "${GARDEN_DEBUG:-}" ]; then
    tags="$tags debug"
  fi
  echo "$tags"
}

cmd="ansible-playbook -i localhost, --con local --tags $(tags) --extra-vars garden_ci_ubuntu=$PWD"
$cmd "$(dirname "$0")"/playbook.yml
