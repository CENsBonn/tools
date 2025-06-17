#!/usr/bin/env bash

set -Eeuo pipefail

SSH_HOST=marvin
FMRIPREP_VERSION=25.1.1

fs_license_src="$1"

remote_home=$(ssh "$SSH_HOST" 'echo $HOME')

ssh "$SSH_HOST" mkdir -p "$remote_home/fmriprep"

fs_license_dst="$remote_home/fmriprep/license.txt"

rsync -av --info=progress2 "$fs_license_src" "${SSH_HOST}:${fs_license_dst}"

img="$remote_home/fmriprep/fmriprep-${FMRIPREP_VERSION}.simg"

if ssh "$SSH_HOST" test -f "$img"; then
	echo "Image already exists: $img. Skipping."
else
	ssh "$SSH_HOST" singularity build "$img" "docker://nipreps/fmriprep:${FMRIPREP_VERSION}"
fi
