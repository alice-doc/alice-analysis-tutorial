aliBuild prerequisites for Ubuntu
=================================

<!-- Dockerfile UPLOAD_NAME alisw/o2-ubuntu1804 -->
<!-- Dockerfile FROM ubuntu:18.04 -->
<!-- Dockerfile RUN export DEBIAN_FRONTEND=noninteractive -->
<!-- Dockerfile RUN export DEBIAN_NONINTERACTIVE_SEEN=true -->
<!-- Dockerfile RUN apt update -y -->
<!-- Dockerfile RUN apt install -y sudo -->
<!-- Dockerfile RUN echo -e "13\n33" | apt install -y tzdata -->
<!-- Dockerfile RUN test `cat /etc/timezone` = Etc/UTC -->
At ALICE we do our best to support two versions of Ubuntu: the latest and greatest, and the latest
LTS (Long Term Support) release. What we currently support is:

* Ubuntu 18.04 LTS
* Ubuntu 17.10 _(not a LTS)_
* Ubuntu 16.04 LTS

**We do not support Ubuntu pre-releases** (_i.e._ if something breaks there, you are on your own).

Ubuntu has a [comprehensive page with its support policy](https://www.ubuntu.com/info/release-end-of-life).

**If your release is not mentioned (yet) in the list above, it means we cannot guarantee support for
it.** It does not mean it does not work, however, and [we will be happy to review your
contribution](../README.md) if you have more information!


## Run in an Ubuntu Docker container

Not an Ubuntu user, but you want to build on Ubuntu still? You can use one of the official [Ubuntu
Docker images](https://hub.docker.com/_/ubuntu/). The images corresponding to the supported Ubuntu
versions are:

* `ubuntu:16.04`
* `ubuntu:17.10`
* `ubuntu:18.04`

Just follow [our instructions](README.md#running-in-docker) by using the `ubuntu:XX.XX` image name
corresponding to your choice.


## Install or upgrade required packages

Refresh the list of packages first (you need root, _i.e._ `sudo`, permissions):

<!-- Dockerfile RUN_INLINE -->
```bash
sudo apt update -y
```

**On Ubuntu 16.04 and 17.10**, install packages with the following long line:

```bash
sudo apt install -y curl libcurl4-openssl-dev build-essential gfortran cmake libmysqlclient-dev xorg-dev libglu1-mesa-dev libfftw3-dev libssl-dev libxml2-dev git unzip python-pip autoconf automake autopoint texinfo gettext libtool libtool-bin pkg-config bison flex libperl-dev libbz2-dev libboost-all-dev swig liblzma-dev libnanomsg-dev libyaml-cpp-dev rsync lsb-release unzip environment-modules
```

**On Ubuntu 18.04**, install the following list instead:

<!-- Dockerfile RUN_INLINE -->
```bash
sudo apt install -y curl libcurl4-gnutls-dev build-essential gfortran cmake libmysqlclient-dev xorg-dev libglu1-mesa-dev libfftw3-dev libssl1.0 libssl1.0-dev libxml2-dev git unzip python-pip autoconf automake autopoint texinfo gettext libtool libtool-bin pkg-config bison flex libperl-dev libbz2-dev libboost-all-dev swig liblzma-dev libnanomsg-dev libyaml-cpp-dev rsync lsb-release unzip environment-modules
```

Once this is done, install (as root) the required Python packages:

<!-- Dockerfile RUN_INLINE -->
```bash
sudo pip install matplotlib numpy certifi ipython==5.1.0 ipywidgets ipykernel notebook metakernel pyyaml
```

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)

<!-- Dockerfile RUN apt install -y vim-nox emacs-nox -->
<!-- Dockerfile RUN apt clean -y -->
<!-- Dockerfile RUN pip install alibuild -->
<!-- Dockerfile RUN mkdir /lustre /cvmfs -->
<!-- Dockerfile ENTRYPOINT ["/bin/bash"] -->
