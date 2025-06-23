#!/usr/bin/env bash

set -Eeuo pipefail

path="${1:-jobs/latest/slurm.out}"

ssh marvin "while [ ! -f '$path' ]; do sleep 1; done; tail -f $path" -n 1000
