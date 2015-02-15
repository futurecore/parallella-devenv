parallella-devenv  [![Docker repo](http://img.shields.io/badge/docker-repo-blue.svg)](https://registry.hub.docker.com/u/snim2/parallella-devenv/)
=================

Development environment for the [Adapteva Parallella board](http://www.parallella.org/).


Installing and running
----------------------

Start by [installing docker](https://docs.docker.com/installation/#installation) for your platform.

The rest of this guide is based on a Ubuntu environment, but any other environment should be similar.

This container is based on a Ubuntu 14.04 image. You can start the container from the command line:

```bash
$ docker run  -t -i snim2/parallella-devenv /bin/bash
```

This will create a BASH shell in the `$HOME` directory which is located at `/home/dev/`.

There are two directories inside the home directory:

  * `buildroot` - which contains the SDK, toolchain and modified Linux kernel for the Parallella board. The SDK is installed in the directory `/opt/adapteva` and relevant environment variables (such as `$PATH`, `$LD_LIBRARY_PATH` and `$MANPATH`) have been set. The path `/opt/adapteva/` is readable and writeable by the default user `dev`.
  * `examples` - a clone of the official [Epiphany examples](https://github.com/adapteva/epiphany-examples) repository.

![demo](https://raw.githubusercontent.com/futurecore/parallella-devenv/master/screenshots/demo-start.gif)

Compiling code for the Parallella board
------------------------------------------------------

To compile and simulate the `hello-world` example from the [Epiphany examples](https://github.com/adapteva/epiphany-examples) repository, first change directory:

```bash
$ cd ~/examples/apps/hello-world
```

then run the build script to with:

```bash
$ ./build.sh
```

This will build all the relevant binary files and place them in the `Debug` directory.

![demo](https://raw.githubusercontent.com/futurecore/parallella-devenv/master/screenshots/demo-compile.gif)

Contributing
------------

Contributions to this repository are very welcome.

To contribute, please fork this repository on GitHub and send a pull request with a clear description of your changes. If appropriate, please ensure that the user documentation in this README is updated.

If you have submitted a PR and not received any feedback for a while, feel free to [ping me on Twitter](http://twitter.com/snim2)


TODO
----

Add documentation on how to connect to `e-server`.


---------------------------------------

© Sarah Mount, University of Wolverhampton, 2015.
