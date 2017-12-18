#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"
vagrant up --provider virtualbox --provision
vagrant reload
