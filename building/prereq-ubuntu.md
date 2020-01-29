aliBuild Prerequisites for Ubuntu
=================================

ALICE software on Ubuntu is supported on a best effort basis. There is no guarantee that software builds or runs correctly. Support requests might have low priority. We were able to successfully build on:

* Ubuntu 18.04 LTS
* Ubuntu 16.04 LTS

## Install or Upgrade Required System Packages

With root permissions, _i.e._ `sudo` update your package sources:

```bash
sudo apt update -y
```
### Ubuntu 16.04:

```bash
sudo apt install -y curl libcurl4-openssl-dev build-essential gfortran cmake libmysqlclient-dev xorg-dev libglu1-mesa-dev libfftw3-dev libxml2-dev git unzip autoconf automake autopoint texinfo gettext libtool libtool-bin pkg-config bison flex libperl-dev libbz2-dev swig liblzma-dev libnanomsg-dev libyaml-cpp-dev rsync lsb-release unzip environment-modules
```

### Ubuntu 18.04: 

```bash
sudo apt install -y curl libcurl4-gnutls-dev build-essential gfortran cmake libmysqlclient-dev xorg-dev libglu1-mesa-dev libfftw3-dev libxml2-dev git unzip autoconf automake autopoint texinfo gettext libtool libtool-bin pkg-config bison flex libperl-dev libbz2-dev swig liblzma-dev libnanomsg-dev libyaml-cpp-dev rsync lsb-release unzip environment-modules
```

## Python and pip
AliBuild, our build tool, is installed via the python Package manager `pip`.
In case  
```bash
pip show pip
``` 
returns `command not found` or similar, install `pip` via: 
```bash
sudo apt -y install python3-pip
sudo pip3 install --upgrade pip
```

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)
