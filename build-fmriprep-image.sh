#!/usr/bin/env bash

set -Eeuo pipefail

SSH_HOST=marvin
FMRIPREP_VERSION=25.1.1

remote_home=$(ssh "$SSH_HOST" 'echo $HOME')

ssh "$SSH_HOST" mkdir -p "$remote_home/fmriprep"

img="$remote_home/fmriprep/fmriprep-${FMRIPREP_VERSION}.simg"

if ssh "$SSH_HOST" test -f "$img"; then
	echo "Image already exists: $img. Skipping."
else
	ssh "$SSH_HOST" apptainer build "$img" "docker://nipreps/fmriprep:${FMRIPREP_VERSION}"
fi
