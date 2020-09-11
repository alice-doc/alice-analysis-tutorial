aliBuild Prerequisites for CentOS 7
===================================

<!-- Dockerfile UPLOAD_NAME alisw/o2-cc7 -->
<!-- Dockerfile FROM centos:7 -->
<!-- Dockerfile RUN rpmdb --rebuilddb && yum clean all -->
For ALICE O2, CERN CentOS 7 (CC7)is the [officialy supported target platform](https://indico.cern.ch/event/642232/#3-wp3-common-tools-and-softwar). Since CC7 is CentOS 7 with additional CERN packages, instructions apply to vanilla CentOS 7 as well.

## Install or Upgrade the Required Packages

With root permissions, i.e. `sudo` or as `root` install the prerequisites using:

<!-- Dockerfile RUN_INLINE -->
```bash
yum install -y git mysql-devel curl curl-devel bzip2 bzip2-devel unzip autoconf automake texinfo gettext gettext-devel libtool freetype freetype-devel libpng libpng-devel sqlite sqlite-devel ncurses-devel mesa-libGLU-devel libX11-devel libXpm-devel libXext-devel libXft-devel libXi-devel libxml2 libxml2-devel motif motif-devel kernel-devel pciutils-devel kmod-devel bison flex perl-ExtUtils-Embed environment-modules tk-devel glfw-devel
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
yum install -y python3-pip
pip3 install --upgrade pip
```

## Get or Update Developer Toolset 7

We require a more recent set of compilers than shipped by the OS. They can be obtained via [Softawre
Collections](https://www.softwarecollections.org/).

The only supported Developer Toolset for ALICE software is `devtoolset-7`.

With root permissions, i.e. `sudo` or as `root` enable software collections:
<!-- Dockerfile RUN_INLINE -->
```bash
yum install -y centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms
```
Then, still with `root` permissions install compilers and developer tools via:
<!-- Dockerfile RUN_INLINE -->
```bash
yum install -y devtoolset-7
```
By design these tools do not replace the standard tools shipped by the system and have to be enabled explicitly for every new shell session you open:
```bash
source scl_source enable devtoolset-7
```
If desired so, the above line can be added to your `~/.bashrc` or `~/.bash_profile`, so that tools shipped via devtoolset are automatically available in every shell. However beware that in some special cases that this might have undesired side effects.

You can check if you are running the correct version of GCC with:

```bash
gcc --version
```

It should report `GCC v7.3.1`.

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)

<!-- Dockerfile RUN yum install -y vim-enhanced emacs-nox -->
<!-- Dockerfile RUN rpmdb --rebuilddb && yum clean all -->
<!-- Dockerfile RUN echo "source scl_source enable devtoolset-7" >> /etc/profile -->
<!-- Dockerfile RUN echo "source scl_source enable devtoolset-7" >> /etc/bashrc -->
<!-- Dockerfile RUN pip install alibuild -->
<!-- Dockerfile RUN mkdir /lustre /cvmfs -->
<!-- Dockerfile ENTRYPOINT ["/bin/bash"] -->
