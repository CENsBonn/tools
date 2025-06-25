#!/usr/bin/env bash

set -Eeuo pipefail

script_dir="$(dirname "$(readlink -f "$0")")"

ssh marvin ws_list -C \
    | "${script_dir}/ws_list_to_json.py" \
    | LC_TIME=C jq -r 'to_entries[] | .key as $key | .value.creation_time as $ct | $ct | strptime("%a %b %e %H:%M:%S %Y") | mktime as $ts | "\($ts) \($key)"'
