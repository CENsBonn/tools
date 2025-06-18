#!/usr/bin/env bash

set -Eeuo pipefail

ssh marvin sacct --allocations --starttime "$(date -d '7 days ago' '+%Y-%m-%dT%H:%M:%S')" --endtime now --format=JobName%25,Start,Elapsed,State
