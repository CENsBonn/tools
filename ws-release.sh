#!/usr/bin/env bash

set -Eeuo pipefail

SSH_HOST=marvin

script_dir="$(dirname "$0")"

workspaces="$(ssh "$SSH_HOST" ws_list | "${script_dir}/ws_list_to_json.py" | jq -r "keys.[]")"

selected_workspaces="$(echo "$workspaces" | fzf --multi)"

if [[ -z "$selected_workspaces" ]]; then
	echo "No workspaces selected. Exiting."
	exit 0
fi

echo "Selected workspaces:"
echo "$selected_workspaces"
read -r -p "Release these workspaces? [y/n]" confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
	for workspace in $selected_workspaces; do
		echo "Releasing workspace '$workspace'..."
		ssh "$SSH_HOST" "ws_release '$workspace'"
	done
else
	echo "Aborted."
fi
