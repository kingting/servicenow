FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    bash \
    git \
    gnupg \
    software-properties-common \
    && add-apt-repository universe \
    && apt-get update \
    && apt-get install -y gsed

COPY update-readme.sh /update-readme.sh

RUN chmod +x /update-readme.sh

ENTRYPOINT ["/update-readme.sh"]

