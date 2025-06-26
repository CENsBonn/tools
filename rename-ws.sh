#!/usr/bin/env bash

set -Eeuo pipefail

script_dir="$(dirname "$(readlink -f "$0")")"

"${script_dir}/exec-remote.sh" "${script_dir}/remote-ws-rename.sh" "$@"
