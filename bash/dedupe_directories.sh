#!/bin/bash

# Usage: ./dedupe_dirs.sh /path/to/primary /path/to/secondary
# The primary is the directory that duplicate directories will be removed from.

set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <primary_dir> <secondary_dir>"
  exit 1
fi

primary="$1"
secondary="$2"

if [ ! -d "$primary" ] || [ ! -d "$secondary" ]; then
  echo "Both arguments must be valid directories."
  exit 2
fi

comm -12 \
  <(find "$primary" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort) \
  <(find "$secondary" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort) \
| while read -r name; do
    dup="$primary/$name"
    if [ -d "$dup" ]; then
      echo "Deleting duplicate: $dup"
      rm -rf "$dup"
    fi
  done
