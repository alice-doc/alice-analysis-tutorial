aliBuild prerequisites for Ubuntu
=================================

At ALICE we do our best to support two versions of Ubuntu: the latest and greatest, and the latest
LTS (Long Term Support) release. What we currently support is:

* Ubuntu 17.10 _(not a LTS)_
* Ubuntu 16.04 LTS

**We do not support Ubuntu pre-releases** (i.e. if something breaks there, you are on your own)
however these instructions have been successfully tested on:

* Ubuntu 18.04 LTS _(prerelease)_

Ubuntu has a [comprehensive page with its support policy](https://www.ubuntu.com/info/release-end-of-life).

**If your release is not mentioned (yet) in the list above, it means we cannot guarantee support for
it.** It does not mean it does not work, however, and [we will be happy to review your
contribution](../README.md) if you have more information!


## Ubuntu Docker image

Not an Ubuntu user, but you want to build on Ubuntu still? You can use one of the official [Ubuntu
Docker images](https://hub.docker.com/_/ubuntu/). The images corresponding to the supported Ubuntu
versions are:

* `ubuntu:16.04`
* `ubuntu:17.10`
* `ubuntu:18.04`


## Install or upgrade required packages

Refresh the list of packages first (you need root, _i.e._ `sudo`, permissions):

```bash
sudo apt update
```

Install packages (one long line, just copy and paste it):

```bash
sudo apt install curl libcurl4-openssl-dev build-essential gfortran cmake libmysqlclient-dev xorg-dev libglu1-mesa-dev libfftw3-dev libssl-dev libxml2-dev git unzip python-pip autoconf automake autopoint texinfo gettext libtool libtool-bin pkg-config bison flex libperl-dev libbz2-dev libboost-all-dev swig liblzma-dev libnanomsg-dev libyaml-cpp-dev rsync lsb-release environment-modules
```

Once this is done, install (as root) the required Python packages:

```bash
sudo pip install matplotlib numpy certifi ipython==5.1.0 ipywidgets ipykernel notebook metakernel pyyaml
```

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)
