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

WORKDIR $HOME
RUN mkdir buildroot && sudo mkdir -p /opt/adapteva

WORKDIR $HOME/buildroot
RUN git clone https://github.com/adapteva/epiphany-sdk sdk --branch 2014.11

WORKDIR $HOME/buildroot/sdk
RUN ./build-epiphany-sdk.sh -c arm-linux-gnueabihf -C

WORKDIR $HOME/buildroot
RUN git clone https://github.com/adapteva/epiphany-examples.git examples

WORKDIR $HOME/buildroot/examples/scripts
RUN ./build_all.sh
