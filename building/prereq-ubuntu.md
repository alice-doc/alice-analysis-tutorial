aliBuild prerequisites for Ubuntu
=================================

ALICE software on Ubuntu is supported on a best effort basis. There is no guarantee that software builds or runs correctly. Support requests might have low priority. We were able to successfully build on:

* Ubuntu 18.04 LTS
* Ubuntu 20.04 LTS
* Ubuntu 22.04 LTS

## Install required system packages

With root permissions, _i.e._ `sudo`, update your package sources:


```bash
sudo apt update -y
```

With root permissions, _i.e._ `sudo`, install the following packages:

```bash
sudo apt install -y curl libcurl4-gnutls-dev build-essential gfortran libmysqlclient-dev xorg-dev libglu1-mesa-dev libfftw3-dev libxml2-dev git unzip autoconf automake autopoint texinfo gettext libtool libtool-bin pkg-config bison flex libperl-dev libbz2-dev swig liblzma-dev libnanomsg-dev rsync lsb-release environment-modules libglfw3-dev libtbb-dev python3-dev python3-venv python3-pip graphviz libncurses-dev software-properties-common
```

## Installing aliBuild
AliBuild, our build tool, is installed as a standard ubuntu package, provided you enable the `alisw` [PPA](https://launchpad.net/ubuntu/+ppas) repository.
This is done with:

```bash
sudo add-apt-repository ppa:alisw/ppa  
sudo apt update
sudo apt install python3-alibuild
```

You are now ready to [start building ALICE software](README.md#get-or-upgrade-alibuild)
