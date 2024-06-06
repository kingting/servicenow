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

# Function to update the README.md with the given script content and type
update_readme() {
  local script_filename=$1
  local script_type=$2

  # Determine the start and end markers based on the script filename
  local start_marker="${script_filename}-start"
  local end_marker="${script_filename}-end"

  # Replace placeholders in README.md while keeping the placeholders
  sed -i -e "/${start_marker}/,/${end_marker}/ {//!d; /${start_marker}/r ${script_filename}" -e '}' README.md
  sed -i -e "/${start_marker}/a\\\`\`\`${script_type}" README.md
  sed -i -e "/${end_marker}/i\\\`\`\`" README.md
}

# Update README.md with the specified scripts
update_readme "servicenow.js" "javascript"
update_readme "packer.js" "javascript"

# Check for changes in README.md
if git diff --quiet README.md; then
  echo 'No changes detected in README.md.'
  changes=false
else
  echo 'Changes detected in README.md.'
  changes=true
fi
echo "changes=${changes}" >> $GITHUB_ENV
set +x
