#
# This Dockerfile provides a repeatable development environment for
# developing applications for the Adapteva Parallella development board.
#

# FROM ubuntu:14.04 with a number of improvements. See github README.
FROM phusion/baseimage
MAINTAINER Sarah Mount <s.mount@wlv.ac.uk>

RUN sudo apt-get update -qq
RUN sudo apt-get -qq install -y build-essential \
    bison \
    flex \
    libgmp-dev \
    libncurses-dev \
    libmpc-dev \
    libmpfr-dev \
    texinfo \
    xzip \
    lzip \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf
