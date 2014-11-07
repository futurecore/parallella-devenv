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
    lzip \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf

# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
WORKDIR /root
RUN mkdir -p /opt/buildroot && mkdir -p /opt/examples
ENV EPIPHANY_BUILD_HOME /opt/buildroot

WORKDIR /opt/buildroot
RUN git clone https://github.com/adapteva/epiphany-sdk sdk --branch 2014.11
RUN ./sdk/build-epiphany-sdk.sh -t 2014.11 -C -a x86_64 && echo SDK BUILD OK || cat logs/2014.11/build*.log

ENV EPIPHANY_HOME /opt/buildroot/esdk.RevUndefined/
ENV PATH /opt/buildroot/esdk.RevUndefined/tools/e-gnu/bin:$PATH
ENV MANPATH /opt/buildroot/esdk.RevUndefined/tools/e-gnu/share/man:$MANPATH

# Clone and build the official Parallella examples as a proof of concept.
WORKDIR /opt
RUN git clone https://github.com/adapteva/epiphany-examples.git examples
WORKDIR /opt/examples/scripts
RUN ./build_all.sh
