# DOCKER-VERSION 17.03.1-ce
# VERSION 0.3.0

# TODO: Use POSTGRES_VERSION in FROM
# ARG POSTGRES_VERSION
# FROM postgres:${POSTGRES_VERSION}

FROM postgres:9.6.2
MAINTAINER Jan Nash <jnash@jnash.de>

ENV DEBIAN_FRONTEND noninteractive

ARG STATUS_VOLUME_PATH

COPY ./content/wait_for_postgres "${STATUS_VOLUME_PATH}"
COPY ./scripts/monitor_postgres_status /usr/local/bin/
RUN chmod +x /usr/local/bin/monitor_postgres_status

ENTRYPOINT ["monitor_postgres_status"]
