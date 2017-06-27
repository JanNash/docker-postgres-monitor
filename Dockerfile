# DOCKER-VERSION 17.03.1-ce
# VERSION 0.3.0

FROM debian:stretch-slim
MAINTAINER Jan Nash <jnash@jnash.de>

ENV DEBIAN_FRONTEND noninteractive

ARG WAIT_FOR_VOLUME_PATH
ARG POSTGRES_VERSION

RUN \
# This hack is necessary, so "postgresql-client-${POSTGRES_VERSION}"
# can add the symlink to its man page and doesn't fail installing.
    mkdir -p \
        /usr/share/man/man1 \
        /usr/share/man/man7 \

# Package installations
&&  apt-get update \
&&  apt-get install -y --no-install-recommends \
        "postgresql-client-${POSTGRES_VERSION}" \

# Cleanup
&&  apt-get clean \
&&  rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/* \

# Create wait_for-volume directory
&& mkdir -p "${WAIT_FOR_VOLUME_PATH}"

COPY ./content/postgres "${WAIT_FOR_VOLUME_PATH}"
COPY ./scripts/monitor_postgres_status /usr/local/bin/
RUN chmod +x \
        "${WAIT_FOR_VOLUME_PATH}"/postgres \
        /usr/local/bin/monitor_postgres_status

ENTRYPOINT ["monitor_postgres_status"]
