#!/usr/bin/env bash

set -Eeuo pipefail

HOST_NAME="marvin"
HOST_DOMAIN="marvin.hpc.uni-bonn.de"

if [ $# != 2 ]; then
  >&2 echo "Usage:   $0 <hpc_username> <private_key_path>"
  >&2 echo "Example: $0 sebelin2_hpc   ~/.ssh/marvin"
  exit 1
fi

hpc_username="$1"
private_key_path="$2"

if [ ! -f "$HOME/.ssh/config" ]; then
  mkdir -p "$HOME/.ssh"
  touch "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
fi

if ! grep -q "^Host ${HOST_NAME}$" "$HOME/.ssh/config"; then
	cat <<EOF >> "$HOME/.ssh/config"
Host marvin
  HostName ${HOST_DOMAIN}
  User ${hpc_username}
  IdentityFile ${private_key_path}
  ControlMaster auto
  ControlPath ~/.ssh/cm-%r@%h:%p
  ControlPersist 10m
EOF
else
  echo -e "Host marvin is already present in $HOME/.ssh/config. Skipping.\n"
  cat "$HOME/.ssh/config"
fi

