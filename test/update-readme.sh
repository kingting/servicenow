#!/bin/bash

echo "Reading the script content..."

# Read the script content
SERVICENOW_JS=$(cat servicenow.js)

# Display the content to ensure it has been read correctly
echo "Content of servicenow.js:"
echo "$SERVICENOW_JS"

# Check the version of sed to ensure we're using the right one
sed --version

# Create a sample README.md file for ing
cat <<EOL > README.md
# Sample README

## Scripts

### ServiceNow JS
<!-- servicenow.js-start -->
Original ServiceNow JS content.
<!-- servicenow.js-end -->
EOL

echo "Original README.md:"
cat README.md

# Replace placeholders in README.md while keeping the placeholders

sed -i -e '/servicenow.js-start/,/servicenow.js-end/ {//!d; /servicenow.js-start/r servicenow.js' -e '}' README.md
sed -i -e '/servicenow.js-start/a```' README.md
sed -i -e '/servicenow.js-end/i```' README.md
cat README.md

echo "Updated README.md:"

