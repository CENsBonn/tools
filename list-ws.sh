#!/usr/bin/env bash

set -Eeuo pipefail

script_dir="$(dirname "$(readlink -f "$0")")"

ssh marvin ws_list -C | "${script_dir}/ws_list_to_json.py" | jq -r 'keys[]'
