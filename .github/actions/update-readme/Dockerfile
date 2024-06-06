FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    bash \
    git \
    sed

COPY update-readme.sh /update-readme.sh

RUN chmod +x /update-readme.sh

ENTRYPOINT ["/update-readme.sh"]

