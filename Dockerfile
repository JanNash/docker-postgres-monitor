# DOCKER-VERSION 17.06.0-ce
# VERSION 0.5.0

FROM debian:stretch-slim
MAINTAINER Jan Nash <jnash@jnash.de>

ARG DEBIAN_FRONTEND=noninteractive
ARG STATUS_VOLUME_PATH
ARG POSTGRES_VERSION

RUN \
# Check for mandatory build-arguments
    MISSING_ARG_MSG="Build argument needs to be set and non-empty." \
&&  : "${STATUS_VOLUME_PATH:?${MISSING_ARG_MSG}}" \
&&  : "${POSTGRES_VERSION:?${MISSING_ARG_MSG}}" \

# This hack is necessary, so "postgresql-client-${POSTGRES_VERSION}"
# can add the symlink to its man page and doesn't fail installing.
&&  mkdir -p \
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
&& mkdir -p "${STATUS_VOLUME_PATH}"

COPY ./content/wait_for_postgres "${STATUS_VOLUME_PATH}"
COPY ./scripts/monitor_postgres_status /usr/local/bin/
RUN chmod +x \
        "${STATUS_VOLUME_PATH}"/wait_for_postgres \
        /usr/local/bin/monitor_postgres_status

ENTRYPOINT ["monitor_postgres_status"]
