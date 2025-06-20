#!/usr/bin/env bash

set -Eeuo pipefail

if [[ $# -ne 2 ]]; then
  >&2 echo "Download or upload a file or directory using rsync."
  >&2 echo "Usage:   $0 <source> <destination>"
  >&2 echo "Example (download): $0 marvin:~/my_remote_file ."
  >&2 echo "Example (upload):   $0 my_local_file.txt marvin:~/"
  exit 1
fi

source="$1"
destination="$2"

rsync -av --info=progress2 "$source" "$destination"
