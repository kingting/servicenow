FROM ubuntu:20.04

# Set non-interactive mode for apt-get to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    bash \
    git \
    gsed

# Copy the script into the container
COPY update-readme-script.sh /update-readme-script.sh

# Ensure the script has execute permissions
RUN chmod +x /update-readme-script.sh

# Set the entrypoint to the script
ENTRYPOINT ["/update-readme-script.sh"]
