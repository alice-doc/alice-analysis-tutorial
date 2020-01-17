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
ALICE software on Ubuntu is supported on a best effort basis. There is no guarantee that software builds or runs correctly. Support requests might have low priority. We were able to successfully build on:

* Ubuntu 18.04 LTS
* Ubuntu 17.10 _(not a LTS)_
* Ubuntu 16.04 LTS

## Install or upgrade required packages

With root permissions, _i.e._ `sudo` update your package sources:

<!-- Dockerfile RUN_INLINE -->
```bash
sudo apt update -y
```

Install prerequisites for **Ubuntu 16.04 and 17.10**:

```bash
sudo apt install -y curl libcurl4-openssl-dev build-essential gfortran cmake libmysqlclient-dev xorg-dev libglu1-mesa-dev libfftw3-dev libssl-dev libxml2-dev git unzip python-pip autoconf automake autopoint texinfo gettext libtool libtool-bin pkg-config bison flex libperl-dev libbz2-dev libboost-all-dev swig liblzma-dev libnanomsg-dev libyaml-cpp-dev rsync lsb-release unzip environment-modules
```

Install prerequisites for **Ubuntu 18.04**: 

<!-- Dockerfile RUN_INLINE -->
```bash
sudo apt install -y curl libcurl4-gnutls-dev build-essential gfortran cmake libmysqlclient-dev xorg-dev libglu1-mesa-dev libfftw3-dev libssl1.0 libssl1.0-dev libxml2-dev git unzip python-pip autoconf automake autopoint texinfo gettext libtool libtool-bin pkg-config bison flex libperl-dev libbz2-dev libboost-all-dev swig liblzma-dev libnanomsg-dev libyaml-cpp-dev rsync lsb-release unzip environment-modules
```
Furthermore you will need the following Python packages:

<!-- Dockerfile RUN_INLINE -->
```bash
sudo pip3 install matplotlib numpy certifi ipython==5.1.0 ipywidgets ipykernel notebook metakernel pyyaml
```

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)

<!-- Dockerfile RUN apt install -y vim-nox emacs-nox -->
<!-- Dockerfile RUN apt clean -y -->
<!-- Dockerfile RUN pip install alibuild -->
<!-- Dockerfile RUN mkdir /lustre /cvmfs -->
<!-- Dockerfile ENTRYPOINT ["/bin/bash"] -->
