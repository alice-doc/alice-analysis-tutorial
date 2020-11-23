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

* Ubuntu 20.04 LTS
* Ubuntu 18.04 LTS

## Install required system packages

With root permissions, _i.e._ `sudo`, update your package sources:


<!-- Dockerfile RUN_INLINE -->
```bash
sudo apt update -y
```

With root permissions, _i.e._ `sudo`, install the following packages:

<!-- Dockerfile RUN_INLINE -->
```bash
sudo apt install -y curl libcurl4-gnutls-dev build-essential gfortran libmysqlclient-dev xorg-dev libglu1-mesa-dev libfftw3-dev libxml2-dev git unzip autoconf automake autopoint texinfo gettext libtool libtool-bin pkg-config bison flex libperl-dev libbz2-dev swig liblzma-dev libnanomsg-dev rsync lsb-release environment-modules libglfw3-dev libtbb-dev python3-venv libncurses-dev
```

## Python and pip
AliBuild, our build tool, is installed via the python Package manager `pip`.
In case
```bash
pip show pip
```
returns `command not found` or similar, install `pip` with `root` permissions, i.e. `sudo` or as `root`:

<!-- Dockerfile RUN_INLINE -->
```bash
sudo apt install -y python3-pip
sudo pip3 install --upgrade pip
```

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)

<!-- Dockerfile RUN apt install -y vim-nox emacs-nox -->
<!-- Dockerfile RUN apt clean -y -->
<!-- Dockerfile RUN pip install alibuild -->
<!-- Dockerfile RUN mkdir /lustre /cvmfs -->
<!-- Dockerfile ENTRYPOINT ["/bin/bash"] -->
