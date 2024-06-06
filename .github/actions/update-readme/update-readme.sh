#!/bin/bash

set -x
echo "Updating README.md with script content..."

# Ensure we're in the correct Git repository
if [ ! -d ".git" ]; then
  echo "Error: Not a git repository. Exiting."
  exit 1
fi

# Replace placeholders in README.md while keeping the placeholders
sed -i -e '/servicenow.js-start/,/servicenow.js-end/ {//!d; /servicenow.js-start/r servicenow.js' -e '}' README.md

# Check if there are changes
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  if git diff --exit-code; then
    echo "No changes detected, skipping commit."
    echo "no_changes=true" >> $GITHUB_ENV
  else
    echo "Changes detected, committing."
    echo "no_changes=false" >> $GITHUB_ENV
  fi
else
  echo "Not a git repository, skipping commit check."
  echo "no_changes=true" >> $GITHUB_ENV
fi
set +x
