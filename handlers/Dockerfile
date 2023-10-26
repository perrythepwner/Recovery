FROM python:3.11-slim-bookworm as base

RUN true \
    && mkdir -p /var/log/chall /startup \
    && apt update \
    && apt install -y xinetd tini curl jq electrum \
    && rm -rf /var/cache/apt/archives \
    && useradd -m chall \
    && true

COPY ./requirements.txt .
RUN pip install -r requirements.txt 