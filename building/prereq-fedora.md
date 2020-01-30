aliBuild prerequisites for Fedora
=================================

<!-- Dockerfile UPLOAD_NAME alisw/o2-fedora31 -->
<!-- Dockerfile FROM fedora:31 -->
ALICE software on Fedora is supported on a best effort basis. There is no guarantee that software builds or runs correctly. Support requests might have low priority.

## Install required system packages

With root permissions, i.e. `sudo` or as `root` install the prerequisites using:

<!-- Dockerfile RUN_INLINE -->
```bash
dnf install -y git python mysql-devel curl curl-devel bzip2 bzip2-devel unzip autoconf automake texinfo gettext gettext-devel libtool freetype freetype-devel libpng libpng-devel sqlite sqlite-devel ncurses-devel mesa-libGLU-devel libX11-devel libXpm-devel libXext-devel libXft-devel libxml2 libxml2-devel motif motif-devel kernel-devel pciutils-devel kmod-devel bison flex perl-ExtUtils-Embed environment-modules which gcc-gfortran gcc-c++ swig rsync make
```

## Python and pip
AliBuild, our build tool, is installed via the python Package manager `pip`.
In case  
```bash
pip3 show pip
``` 
returns `command not found` or similar, install `pip` with root permissions, i.e. `sudo` or as `root`:
<!-- Dockerfile RUN_INLINE -->
```bash
dnf install -y python3-pip
pip3 install --upgrade pip
```

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)

<!-- Dockerfile RUN dnf install -y vim-enhanced emacs-nox -->
<!-- Dockerfile RUN dnf clean all -->
<!-- Dockerfile RUN pip install alibuild -->
<!-- Dockerfile RUN mkdir /lustre /cvmfs -->
<!-- Dockerfile ENTRYPOINT ["/bin/bash"] -->
