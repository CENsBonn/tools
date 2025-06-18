#!/usr/bin/env bash

set -Eeuo pipefail

path="${1:-jobs/latest/slurm.out}"

ssh marvin "tail -f $path"
