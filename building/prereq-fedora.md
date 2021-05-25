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

## Get or upgrade aliBuild

Install or upgrade [aliBuild](https://pypi.python.org/pypi/alibuild/) with `pip`:

```bash
sudo pip3 install alibuild --upgrade
```

Now add the two following lines to your `~/.bashrc` or `~/.bash_profile` (depending on your
configuration):

```bash
export ALIBUILD_WORK_DIR="$HOME/alice/sw"
eval "`alienv shell-helper`"
```

The first line tells what directory is used as "build cache", the second line installs a "shell
helper" that makes easier to run certain aliBuild-related commands.

You need to close and reopen your terminal for the change to be effective. The directory
`~/alice/sw` will be created the first time you run aliBuild.

> Note that this directory tends to grow in size over time, and it is the one you need to remove in
> case of cleanups.

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)

<!-- Dockerfile RUN dnf install -y vim-enhanced emacs-nox -->
<!-- Dockerfile RUN dnf clean all -->
<!-- Dockerfile RUN pip install alibuild -->
<!-- Dockerfile RUN mkdir /lustre /cvmfs -->
<!-- Dockerfile ENTRYPOINT ["/bin/bash"] -->
