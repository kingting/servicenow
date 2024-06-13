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

# Function to determine the script type based on file suffix
get_script_type() {
  local filename=$1
  case "${filename##*.}" in
    js) echo "javascript" ;;
    py) echo "python" ;;
    sh) echo "shell" ;;
    rb) echo "ruby" ;;
    php) echo "php" ;;
    go) echo "go" ;;
    java) echo "java" ;;
    tf) echo "hcl" ;;
    hcl) echo "hcl" ;;
    json) echo "json" ;;
    yaml) echo "yaml" ;;
    yml) echo "yaml" ;;
    *) echo "" ;;
  esac
}

# Function to update the README.md with the given script content
update_readme() {
  local script_filename=$1
  local script_type=$(get_script_type "${script_filename}")

  if [ -z "$script_type" ]; then
    echo "Unsupported script type for file: ${script_filename}. Skipping."
    return
  fi

  # Determine the start and end markers based on the script filename
  local start_marker="${script_filename}-start"
  local end_marker="${script_filename}-end"

  # Replace placeholders in README.md while keeping the placeholders
  sed -i -e "/${start_marker}/,/${end_marker}/ {//!d; /${start_marker}/r ${script_filename}" -e '}' README.md
  sed -i -e "/${start_marker}/a\\\`\`\`${script_type}" README.md
  sed -i -e "/${end_marker}/i\\\`\`\`" README.md
}

# Extract all filenames from lines containing '-start -->' 
FILENAMES=$(grep -e '-start -->' README.md | awk '{gsub(/-start/, "", $2); print $2}')
echo $FILENAMES

# Update README.md with the specified scripts
for FILENAME in $FILENAMES; do
  update_readme $FILENAME 
done
set +x
