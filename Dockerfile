FROM ubuntu:18.04

RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    ca-certificates \
    libreoffice-calc \
    libreoffice-dev \
    libreoffice-java-common \
    openjdk-8-jre-headless \
    wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN wget --quiet \
    https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.2.14.0/jruby-dist-9.2.14.0-bin.tar.gz \
  && tar xf jruby-dist-9.2.14.0-bin.tar.gz \
  && rm jruby-dist-9.2.14.0-bin.tar.gz

WORKDIR /root/work
