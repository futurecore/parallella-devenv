#
# This Dockerfile provides a reproducible development environment for
# developing applications for the Adapteva Parallella development board.
#

# FROM ubuntu:14.04 with a number of improvements. See github README.
FROM phusion/baseimage

MAINTAINER Sarah Mount <s.mount@wlv.ac.uk>

RUN sudo apt-get update -qq && sudo apt-get -qq install -y build-essential \
    bison \
    flex \
    git \
    libgmp-dev \
    libncurses-dev \
    libmpc-dev \
    libmpfr-dev \
    texinfo \
    xzip \
    lzip

# Setup user 'dev' and add to sudoers.
RUN adduser --quiet --shell /bin/bash --gecos "Epiphany Developer,101,," --disabled-password dev && \
    adduser dev sudo && \
    chown -R dev:dev /home/dev/ && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER dev
ENV HOME /home/dev

# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
WORKDIR /home/dev
RUN mkdir -p /home/dev/buildroot
ENV EPIPHANY_BUILD_HOME /home/dev/buildroot

WORKDIR /home/dev/buildroot
RUN git clone https://github.com/adapteva/epiphany-sdk sdk --branch 2014.11
RUN ./sdk/build-epiphany-sdk.sh -t 2014.11 -C -a x86_64 && echo SDK BUILD OK || cat logs/2014.11/build*.log

ENV EPIPHANY_HOME /home/dev/buildroot/esdk.RevUndefined/
ENV PATH /home/dev/buildroot/esdk.RevUndefined/tools/e-gnu/bin:$PATH
ENV MANPATH /home/dev/buildroot/esdk.RevUndefined/tools/e-gnu/share/man:$MANPATH

# Clone and build the official Parallella examples as a proof of concept.
WORKDIR /home/dev
RUN git clone https://github.com/adapteva/epiphany-examples.git examples
WORKDIR /home/dev/examples/scripts
RUN ./build_all.sh

USER dev
WORKDIR /home/dev
