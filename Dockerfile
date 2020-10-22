## Pull in OpenFaaS classic watchdog:
FROM openfaas/classic-watchdog:0.18.1 as watchdog

## Use Python 3.8 as the base image for production:
FROM python:3.8

## Define the version (updated on each release):
ENV VERSION=0.0.1

## Copy watchdog:
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

## Perform installations and further configuration:
# hadolint ignore=DL3008,DL3013,DL3015
RUN apt-get update                                && \
    apt-get install -y jq libxml2-utils           && \
    pip install --upgrade yq pip                  && \
    groupadd -r app && useradd -r -g app app      && \
    apt-get clean autoclean                       && \
    apt-get autoremove -y                         && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Switch thw user:
USER app

## Define the process to be run by watchdog:
ENV fprocess="xq . -"
ENV content_type="application/json"

## Expose the port:
EXPOSE 8080

## Set healtcheck command:
HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

## Define the command to run:
CMD ["fwatchdog"]
