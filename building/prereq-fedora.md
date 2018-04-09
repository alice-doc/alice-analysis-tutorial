aliBuild prerequisites for Fedora 27
====================================

We support on a best-effort basis recent versions of Fedora as development platform. Currently
supported version is Fedora 27. Other versions (older or newer) are to be considered not supported.

{% callout "Fedora is bleeding-edge" %}
Note that in general it is not so easy to support a distribution like Fedora due to its "bleeding
edge" nature. Every new version tends to adopt new standards and packages very easily, requiring
adjustments in our software chain. Such adjustments are, as per our
[policy](https://indico.cern.ch/event/642232/#3-wp3-common-tools-and-softwar), are performed on a
best-effort basis.

If you are a Fedora user, let us remind you once again that any version different than Fedora 27 is
not supported at the moment. You might want to wait until we update our software chain and
documentation before upgrading to a newer Fedora version. If you are impatient, you might want to
use Docker with a supported OS (such as CentOS 7) as your development environment.
{% endcallout %}


## Run in a Fedora 27 Docker container

You can use Docker to run a Fedora environment even if your OS is different. Check out the official
[Fedora images](https://hub.docker.com/_/fedora/). The image corresponding to a base Fedora 27
installation is `fedora:27`. Just follow [our instructions](README.md#running-in-docker) by using
`fedora:27` as container name.


## Install or upgrade required packages

Install packages (one long line, just copy and paste it), as **root user**:

```bash
dnf install -y git python mysql-devel curl curl-devel python python-devel python-pip bzip2 bzip2-devel autoconf automake texinfo gettext gettext-devel libtool freetype freetype-devel libpng libpng-devel sqlite sqlite-devel ncurses-devel mesa-libGLU-devel libX11-devel libXpm-devel libXext-devel libXft-devel libxml2 libxml2-devel motif motif-devel kernel-devel pciutils-devel kmod-devel bison flex perl-ExtUtils-Embed environment-modules which gcc-gfortran gcc-c++ swig rsync
```

**Note:** at the time of writing (February 2018), our current software does not support OpenSSL 1.1,
therefore it is necessary to install the following two compatibility packages with the
`--allowerasing` option:

```bash
dnf install compat-openssl10-devel compat-openssl10 --allowerasing
```

Now get some Python dependencies (again **as root user**):

```bash
pip install matplotlib numpy certifi ipython==5.1.0 ipywidgets ipykernel notebook metakernel pyyaml
```

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)
