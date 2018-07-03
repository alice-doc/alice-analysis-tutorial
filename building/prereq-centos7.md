aliBuild prerequisites for CentOS 7
===================================

<!-- Dockerfile UPLOAD_NAME alisw/o2-cc7 -->
<!-- Dockerfile FROM centos:7 -->
<!-- Dockerfile RUN rpmdb --rebuilddb && yum clean all -->
For ALICE O2, our policy is [to support CERN CentOS 7 as our official deployment
platform](https://indico.cern.ch/event/642232/#3-wp3-common-tools-and-softwar). CERN CentOS 7 is
essentially a CentOS 7 with some more CERN-specific packages, so these instructions apply to the
pristine CentOS 7 as well.


## Run in a CentOS 7 Docker container

You can use Docker to run a CentOS 7 environment even if your OS is different. Check the official
[CentOS images](https://hub.docker.com/_/centos/). The image corresponding to a base CentOS 7
installation is `centos:7`. Just follow [our instructions](README.md#running-in-docker) by using
`centos:7` as container name.


## Install or upgrade required packages

Install packages (one long line, just copy and paste it), as **root user**:

<!-- Dockerfile RUN_INLINE -->
```bash
yum install -y git python mysql-devel curl curl-devel python python-devel python-pip bzip2 bzip2-devel unzip autoconf automake texinfo gettext gettext-devel libtool freetype freetype-devel libpng libpng-devel sqlite sqlite-devel ncurses-devel mesa-libGLU-devel libX11-devel libXpm-devel libXext-devel libXft-devel libxml2 libxml2-devel motif motif-devel kernel-devel pciutils-devel kmod-devel bison flex perl-ExtUtils-Embed environment-modules
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
voted. The **current situation (February 2018)** is:

* [devtoolset-6](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-6/) (GCC v6.3.1) is
  the currently **approved and working** version for O2;
* [devtoolset-7](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-7/) (GCC v7.2.1) is
  under evaluation but **it currently does not work [due to a bug](  https://bugzilla.redhat.com/show_bug.cgi?id=1519073)**.

In short, **please use `devtoolset-6` at the moment**. All versions other than `devtoolset-6` are to
be considered unsupported or experimental (therefore, again, _unsupported_).
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
yum install -y devtoolset-6
```

Note that by default if you type now `gcc` at the prompt you will not see the new GCC! You need to
enable it explicitly:

<!-- Dockerfile RUN yum install -y vim-enhanced emacs-nox -->
<!-- Dockerfile RUN rpmdb --rebuilddb && yum clean all -->
<!-- Dockerfile RUN echo "source scl_source enable devtoolset-6" >> /etc/profile -->
<!-- Dockerfile RUN echo "source scl_source enable devtoolset-6" >> /etc/bashrc -->
<!-- Dockerfile RUN pip install alibuild -->
<!-- Dockerfile RUN mkdir /lustre /cvmfs -->
<!-- Dockerfile ENTRYPOINT ["/bin/bash"] -->
```bash
source scl_source enable devtoolset-6
```

You can either do it in every shell manually, or add it to your `~/.bashrc` or `~/.bash_profile`. If
you do so, the new GCC will always be enabled in every shell. This might not be desirable in some
cases, so beware. Also, if you add this line to the shell configuration, this will be enabled in all
new terminals (not the current one).

You can check if you are running the correct version of GCC with:

```bash
gcc --version
```

It should report **GCC v6.3.1**.

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)
