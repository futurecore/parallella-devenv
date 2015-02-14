#
# This Dockerfile provides a reproducible development environment for
# developing applications for the Adapteva Parallella development board.
#
# See: http://www.parallella.org
#

# FROM ubuntu:14.04 with a number of improvements. See github README.
FROM phusion/baseimage

MAINTAINER Sarah Mount <s.mount@wlv.ac.uk>

# Install prerequisites.
RUN sudo apt-get update -qq && sudo apt-get -qq install -y build-essential \
    bison \
    flex \
    g++-arm-linux-gnueabihf \
    gcc-arm-linux-gnueabihf \
    git \
    lib32ncurses5 \
    lib32z1 \
    libgmp3-dev \
    libncurses5-dev \
    libmpc-dev \
    libmpfr-dev \
    locate \
    texinfo \
    wget \
    xzip \
    lzip \
    zip

# Setup a new user 'dev' and add to sudoers.
RUN adduser --quiet --shell /bin/bash --gecos "Epiphany Developer,101,," --disabled-password dev && \
    adduser dev sudo && \
    chown -R dev:dev /home/dev/ && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    mkdir -p /opt/adapteva && \
    chown -R dev:dev /opt/adapteva
USER dev
ENV HOME /home/dev

# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
WORKDIR /home/dev
RUN mkdir -p /home/dev/buildroot
ENV EPIPHANY_BUILD_HOME /home/dev/buildroot

# Clone, build and install the Epiphany toolchain and SDK.
WORKDIR /home/dev/buildroot
RUN git clone https://github.com/adapteva/epiphany-sdk sdk --branch 2015.1 && \
    ./sdk/build-epiphany-sdk.sh -C -R -a armv7l -c arm-linux-gnueabihf && \
    cp -a esdk.2015.1/ /opt/adapteva/ && \
    ln -s /opt/adapteva/esdk.2015.1 /opt/adapteva/esdk

# Set environment variables for the new toolchain.
ENV EPIPHANY_HOME /opt/adapteva/esdk
ENV PATH ${EPIPHANY_HOME}/tools/e-gnu/bin:${EPIPHANY_HOME}/tools/host/bin:${PATH}
ENV LD_LIBRARY_PATH ${EPIPHANY_HOME}/tools/host/lib:${LD_LIBRARY_PATH}
ENV EPIPHANY_HDF ${EPIPHANY_HOME}/bsps/current/platform.hdf
ENV MANPATH ${EPIPHANY_HOME}/tools/e-gnu/share/man:${MANPATH}

# Clone the official Epiphany examples repository into $HOME/examples.
WORKDIR /home/dev
RUN git clone https://github.com/adapteva/epiphany-examples.git examples
