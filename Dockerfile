# Stage base
FROM ubuntu:latest as base

RUN apt-get update && apt-get install -y iproute2 procps coreutils bash && rm -rf /var/lib/apt/lists/*
COPY linux_cli.sh .
RUN chmod +x linux_cli.sh

# Stage Tests (můžete přidat testovací nástroje, pokud chcete)
FROM base as tests

RUN apt-get update && apt-get install -y bats shellcheck

# Stage Production (finální image)
FROM base as production
ENTRYPOINT ["/bin/bash", "./linux_cli.sh"]