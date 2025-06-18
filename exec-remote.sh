#!/usr/bin/env bash

set -Eeuo pipefail

SSH_HOST=marvin

local_script_path="$1"

ssh "$SSH_HOST" "bash -s" < "$local_script_path"
