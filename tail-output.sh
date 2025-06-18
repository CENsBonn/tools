#!/usr/bin/env bash

set -Eeuo pipefail

ssh marvin "tail -f jobs/latest/slurm.out"
