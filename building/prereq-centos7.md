aliBuild prerequisites for CentOS 7
===================================

<!-- Dockerfile UPLOAD_NAME alisw/o2-cc7 -->
<!-- Dockerfile FROM centos:7 -->
<!-- Dockerfile RUN rpmdb --rebuilddb && yum clean all -->
For ALICE O2, our policy is [to support CERN CentOS 7 as our official deployment
platform](https://indico.cern.ch/event/642232/#3-wp3-common-tools-and-softwar). CERN CentOS 7 is
essentially a CentOS 7 with some more CERN-specific packages, so these instructions apply to the
pristine CentOS 7 as well.

As the primary supported platform, our [alidock](https://github.com/alidock/alidock/wiki)
installation method is based on it. If you use alidock, you don't need to follow those
prerequisites. The environment we provide is ready to use.


## Install or upgrade the required packages

Install packages (one long line, just copy and paste it), as **root user**:

<!-- Dockerfile RUN_INLINE -->
```bash
yum install -y python git mysql-devel curl curl-devel python python-devel python-pip bzip2 bzip2-devel unzip autoconf automake texinfo gettext gettext-devel libtool freetype freetype-devel libpng libpng-devel sqlite sqlite-devel ncurses-devel mesa-libGLU-devel libX11-devel libXpm-devel libXext-devel libXft-devel libxml2 libxml2-devel motif motif-devel kernel-devel pciutils-devel kmod-devel bison flex perl-ExtUtils-Embed environment-modules tk-devel
```

Now get a recent version of `pip` (the Python package manager): this is required for installing aliBuild and other Python dependencies. Do, always as **root user**:

<!-- Dockerfile RUN_INLINE -->
```
curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
python /tmp/get-pip.py
```

Now get some Python dependencies (again **as root user**):

<!-- Dockerfile RUN_INLINE -->
```bash
pip install matplotlib==2.0.2 numpy certifi ipython==5.1.0 ipywidgets ipykernel notebook metakernel pyyaml
```


## Get or update the compiler from Devtoolset

The default compiler on CentOS 7 is quite old. Luckily, [Softawre
Collections](https://www.softwarecollections.org/) has RPMs for recent versions of GCC.

{% callout "Developer Toolset version" %}
CC7 with the Developer Toolset is the default OS for ALICE O2 operations, therefore we take
particular care about compatibility and upgrading our recommendations. Our policy is to never
upgrade O2 to a newer compiler unless the corresponding Developer Toolset package is out and tested.

Every recommendation change concerning the Develpoer Toolset versions is reviewed, discussed and
voted. The **current situation (July 2018)** is:

* [devtoolset-7](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-7/) (GCC v7.3.1) is
  the currently **approved and working** version for O2.

**Please make sure your `devtoolset-7` is up-to-date!** Due to
[a bug](https://bugzilla.redhat.com/show_bug.cgi?id=1519073), versions of `devtoolset-7` with GCC
v7.2.1 do not work.

All versions other than the very latest `devtoolset-7` are to be considered unsupported.
{% endcallout %}

First off, enable Software Collections:

<!-- Dockerfile RUN_INLINE -->
```bash
yum install -y centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms
```

Get the compiler with:

<!-- Dockerfile RUN_INLINE -->
```bash
yum install -y devtoolset-7
```

Note that by default if you type now `gcc` at the prompt you will not see the new GCC! You need to
enable it explicitly:

<!-- Dockerfile RUN yum install -y vim-enhanced emacs-nox -->
<!-- Dockerfile RUN rpmdb --rebuilddb && yum clean all -->
<!-- Dockerfile RUN echo "source scl_source enable devtoolset-7" >> /etc/profile -->
<!-- Dockerfile RUN echo "source scl_source enable devtoolset-7" >> /etc/bashrc -->
<!-- Dockerfile RUN pip install alibuild -->
<!-- Dockerfile RUN mkdir /lustre /cvmfs -->
<!-- Dockerfile ENTRYPOINT ["/bin/bash"] -->
```bash
source scl_source enable devtoolset-7
```

You can either do it in every shell manually, or add it to your `~/.bashrc` or `~/.bash_profile`. If
you do so, the new GCC will always be enabled in every shell. This might not be desirable in some
cases, so beware. Also, if you add this line to the shell configuration, this will be enabled in all
new terminals (not the current one).

You can check if you are running the correct version of GCC with:

```bash
gcc --version
```

It should report **GCC v7.3.1**.

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)
