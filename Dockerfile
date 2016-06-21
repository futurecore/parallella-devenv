#
# This Dockerfile provides a reproducible development environment for
# developing applications for the Adapteva Parallella development board.
#
# See: http://www.parallella.org
#

FROM ubuntu:xenial

MAINTAINER Sarah Mount <sarah.mount@kcl.ac.uk>

# Install prerequisites.
# Setup a new user 'dev' and add to sudoers.
RUN apt-get update -qq && \
    apt-get update && \
    apt-get -y install sudo && \
    useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo && \
    sudo apt-get -qq install -y build-essential \
    bison \
    flex \
    g++-arm-linux-gnueabihf \
    gcc-arm-linux-gnueabihf \
    git \
    guile-1.8 \
    libgmp3-dev \
    libncurses5-dev \
    libmpc-dev \
    libmpfr-dev \
    libtool \
    locate \
    texinfo \
    wget \
    xzip \
    lzip \
    zip && \
    adduser --quiet --shell /bin/bash --gecos "Epiphany Developer,101,," --disabled-password dev && \
    adduser dev sudo && \
    chown -R dev:dev /home/dev/ && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    mkdir -p /opt/adapteva && \
    chown -R dev:dev /opt/adapteva && \
    mkdir -p /home/dev/buildroot && \
    chown -R dev:dev /home/dev/buildroot

# Set up new user and home directory in environment.
# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
USER dev
ENV HOME /home/dev
ENV EPIPHANY_BUILD_HOME /home/dev/buildroot

# Download, build and install the Epiphany toolchain and SDK.
# Remove temporary files to save space.
# Download the official Epiphany examples repository into $HOME/examples.
WORKDIR /home/dev/buildroot
RUN wget --no-check-certificate https://github.com/adapteva/epiphany-sdk/archive/2016.3.zip && \
    unzip 2016.3.zip && \
    rm 2016.3.zip && \
    mv epiphany-sdk-2016.3 sdk && \
    sed -i.bak s/--clone/--download/g sdk/build-epiphany-sdk.sh && \
    ./sdk/build-epiphany-sdk.sh && \
    cp -a esdk.2016.3/opt/adapteva/esdk.2016.3 /opt/adapteva/ && \
    ln -s /opt/adapteva/esdk.2016.3 /opt/adapteva/esdk && \
    cd /home/dev/ && \
    rm -Rf /home/dev/buildroot && \
    wget --no-check-certificate https://github.com/adapteva/epiphany-examples/archive/master.zip && \
    unzip master.zip && \
    rm master.zip && \
    mv epiphany-examples-master examples

# Set environment variables for the new toolchain.
ENV EPIPHANY_HOME /opt/adapteva/esdk
ENV PATH ${EPIPHANY_HOME}/tools/e-gnu/bin:${EPIPHANY_HOME}/tools/host/bin:${PATH}
ENV LD_LIBRARY_PATH ${EPIPHANY_HOME}/tools/host/lib:${LD_LIBRARY_PATH}
ENV EPIPHANY_HDF ${EPIPHANY_HOME}/bsps/current/platform.hdf
ENV MANPATH ${EPIPHANY_HOME}/tools/e-gnu/share/man:${MANPATH}

# Start at $HOME.
WORKDIR /home/dev

# Expose a port so that GDB can connect to a Parallella board.
EXPOSE 51000

# Start from a BASH shell.
CMD ["bash"]
