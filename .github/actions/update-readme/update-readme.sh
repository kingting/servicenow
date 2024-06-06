#!/bin/bash

echo "Updating README.md with script content..."

# Read the script content
SERVICENOW_JS=$(cat servicenow.js)
#DEPLOY_SCRIPT_CONTENT=$(cat deploy.sh)
#CLEANUP_SCRIPT_CONTENT=$(cat cleanup.sh)

# Replace placeholders in README.md while keeping the placeholders
sed -i "/<!-- servicenow.js-start -->/,/<!-- servicenow.js-end -->/c\<!-- servicenow.js-start -->\n\```bash\n$SERVICENOW_JS\n\```\n<!-- servicenow.js-end -->" README.md
#sed -i "/<!-- deploy.sh-start -->/,/<!-- deploy.sh-end -->/c\<!-- deploy.sh-start -->\n\```bash\n$DEPLOY_SCRIPT_CONTENT\n\```\n<!-- deploy.sh-end -->" README.md
#sed -i "/<!-- cleanup.sh-start -->/,/<!-- cleanup.sh-end -->/c\<!-- cleanup.sh-start -->\n\```bash\n$CLEANUP_SCRIPT_CONTENT\n\```\n<!-- cleanup.sh-end -->" README.md

# Check if there are changes
if git diff --exit-code; then
  echo "No changes detected, skipping commit."
  echo "no_changes=true" >> $GITHUB_ENV
else
  echo "Changes detected, committing."
  echo "no_changes=false" >> $GITHUB_ENV
fi

