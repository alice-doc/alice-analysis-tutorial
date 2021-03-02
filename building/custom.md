# 🧪 Installation via alibuild

Building software has become an increasingly complicated operation, as our software has many
dependencies and we expect it to work both on your laptop and on the Grid. In addition, we support
many Linux distributions and recent macOS versions.

{% callout "Please follow the instructions closely!" %}
Most of the paths and procedures presented here can be adapted to your system and your taste. You
can for instance decide to use different path names, or a different directory structure, it's up to
you, however we **do not recommend you use different ways of installing the required
dependencies.**

In case you do not have particular needs, or you don't know what you are doing, please follow the
procedure **very carefully and without diverging from it at all**.

This will make support easier in case something does not work as expected.
{% endcallout %}


## aliBuild

ALICE uses [aliBuild](https://alisw.github.io/alibuild) to build software. aliBuild:

* knows how to build software via [per-package recipes](https://github.com/alisw/alidist),
* manages the dependencies consistently,
* rebuilds only what's necessary,
* allows several versions of the same software to be installed at the same time.


## Operating systems we support

As per policy, the [primary supported platform is CERN
CentOS 7](https://indico.cern.ch/event/642232/#3-wp3-common-tools-and-softwar):
this is also our official deployment platform for Run 3 software.
Other operating systems, such as macOS, are supported _as development platforms_ and _on a
best-effort basis_.

Given the popularity of other operating systems on laptops (including macOS), we provide a
containerized installation method, always supported _on a best-effort basis_,
that allows you to keep using your favorite operating system by still having a consistent environment:

* [🐳 Install using alidock](https://github.com/alidock/alidock/wiki)


### Prerequisites

According to your operating system, please follow the prerequisites below. You will find a list of
packages to install and configurations to perform.

**Primary supported platform:**

* [CentOS 7](prereq-centos7.md) (no need to follow it if using alidock)

**Platforms supported on a best-effort basis:**

* [macOS Catalina (10.15), Big Sur (11.0)](prereq-macos.md)
* [Ubuntu (18.04 LTS, 20.04 LTS)](prereq-ubuntu.md)
* [Fedora](prereq-fedora.md)
* Linux Mint
    * Follow the instructions for the Ubuntu version your Linux Mint version is based on.
    * Specify the corresponding Ubuntu architecture when running the `aliBuild` command
      using the `-a` option (e.g. `-a ubuntu2004_x86-64` for Ubuntu 20.04).
      Use the `-a` option also with the `alienv` command.

If your operating system is _not_ in any list, it does not mean our software won't work on it;
it will be just more difficult for you to get support for it.

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


### I don't have root permissions

In case you don't have root permissions, one of the possibilities is installing aliBuild under a
user-owned directory. Start with opening your `~/.bashrc` or `~/.bash_profile` (this depends on your
system), and add the following lines:

```bash
export PYTHONUSERBASE="$HOME/user_python"
export PATH="$PYTHONUSERBASE/bin:$PATH"
```

Now close all your terminals and reopen them to load the new configuration. Check if it works by
printing the variable:

```bash
echo $PYTHONUSERBASE
```

The operations above need to be performed only once. Now, to install or upgrade aliBuild, just do:

```bash
pip install alibuild --upgrade --user
```

> This time we did not specify `sudo` and we have added the `--user` option. The Python variable
> `PYTHONUSERBASE` tells `pip` where to install the package.

Verify you have `aliBuild` in your path:

```bash
type aliBuild
```


### I need a special version of aliBuild

In some cases you might want to install a "release candidate" version, or you want to get the code
directly from GitHub. By default, the last stable version is installed. **Do not install a special
version of aliBuild if you were not instructed to do so or if you don't know what you are doing, we
provide no support for unstable releases!**

To install a release candidate (for instance, `v1.5.1rc3`):

```bash
sudo pip install alibuild=v1.5.1rc3 --upgrade
```

To install from GitHub (you can specify a tag or a hash, or another branch, instead of `master`):

```bash
sudo pip install git+https://github.com/alisw/alibuild@master --upgrade
```

> Do not forget to drop `sudo` and add `--user` in case you do not have root permissions!


## Build the packages

When aliBuild is installed on your computer and your prerequisites are satisfied, you can move to
the next step.

* [🛠 Build the packages](build.md)
