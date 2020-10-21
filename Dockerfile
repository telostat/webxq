FROM python:3.8

RUN apt-get update && apt-get install -y jq libxml2-utils && pip install --upgrade yq pip

ENTRYPOINT ["xq", ".", "-"]
