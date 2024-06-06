FROM ubuntu:20.04

# Set non-interactive mode for apt-get to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    bash \
    git \
    sed

# Copy the script into the container
COPY update-readme.sh /update-readme.sh

# Ensure the script has execute permissions
RUN chmod +x /update-readme.sh

# Set the entrypoint to the script
ENTRYPOINT ["/update-readme.sh"]
