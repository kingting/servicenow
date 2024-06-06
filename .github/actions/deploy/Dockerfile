FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    bash \
    git

COPY deploy.sh /deploy.sh

RUN chmod +x /deploy.sh

ENTRYPOINT ["/deploy.sh"]

