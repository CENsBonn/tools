#!/usr/bin/env bash

set -Eeuo pipefail

SSH_HOST=marvin

fs_license_src="$1"

remote_home=$(ssh "$SSH_HOST" 'echo $HOME')

ssh "$SSH_HOST" mkdir -p "$remote_home/fmriprep"

fs_license_dst="$remote_home/fmriprep/license.txt"

rsync -av --info=progress2 "$fs_license_src" "${SSH_HOST}:${fs_license_dst}"
