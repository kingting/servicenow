#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

# Input file
input_file="$1"

# Extract all lines containing '-start -->' and process to remove the '-start' suffix
grep -e '-start -->' "$input_file" | awk '{gsub(/-start/, "", $2); print $2}'

