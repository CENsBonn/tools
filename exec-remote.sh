#!/usr/bin/env bash

set -Eeuo pipefail

SSH_HOST=marvin

local_script_path="$1"
shift
arguments=("$@")

ssh "$SSH_HOST" "bash -s -- ${arguments[*]}" < "$local_script_path"
