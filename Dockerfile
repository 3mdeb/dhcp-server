FROM debian:jessie

MAINTAINER Piotr Król <piotr.krol@3mdeb.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  git \
  vim \
  tmux \
  python \
  python-dev \
  ntpdate \
  ca-certificates \
  netbase \
  isc-dhcp-server

RUN mkdir -p /data

VOLUME /data

ADD entrypoint.sh /entrypoint.sh

EXPOSE 67/udp 67/tcp
