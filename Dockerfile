FROM openfaas/classic-watchdog:0.18.1 as watchdog

FROM python:3.8

## Copy watchdog:
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

## Perform installations and further configuration:
RUN apt-get update && apt-get install -y jq libxml2-utils && \
    pip install --upgrade yq pip                          && \
    groupadd -r app && useradd -r -g app app              && \
    apt-get clean autoclean                               && \
    apt-get autoremove -y                                 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Switch thw user:
USER app

## Define the process to be run by watchdog:
ENV fprocess="xq . -"

## Expose the port:
EXPOSE 8080

## Set healtcheck command:
HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

## Define the command to run:
CMD ["fwatchdog"]
