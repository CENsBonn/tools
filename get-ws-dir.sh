#!/usr/bin/env bash

set -Eeuo pipefail

SSH_HOST=marvin

ws_list_output="$(ssh "$SSH_HOST" ws_list -C | ./ws_list_to_json.py)"

selected_ws="${1:-}"

if [ -z "$selected_ws" ]; then
  selected_ws="$(echo "$ws_list_output" | jq -r 'keys[]' | fzf --no-sort --tac)"
fi

ws_dir="$(echo "$ws_list_output" | jq -r --arg ws "$selected_ws" '.[$ws].workspace_directory')"

echo "$ws_dir"
