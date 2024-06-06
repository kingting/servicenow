#!/bin/bash

set -x
echo "Updating README.md with script content..."

# Print current directory for debugging
echo "Current directory: $(pwd)"

# List files in the current directory for debugging
ls -la

# Ensure we're in the correct Git repository
if [ ! -d ".git" ]; then
  echo "Error: Not a git repository. Exiting."
  exit 1
fi

# Replace placeholders in README.md while keeping the placeholders
sed -i -e '/servicenow.js-start/,/servicenow.js-end/ {//!d; /servicenow.js-start/r servicenow.js' -e '}' README.md

# Check for changes in README.md
if git diff --quiet README.md; then
  echo 'No changes detected in README.md.'
  no_changes=true
else
  echo 'Changes detected in README.md.'
  no_changes=false
fi
echo "no_changes=${no_changes}" >> $GITHUB_ENV
set +x
