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

### Prerequisites

According to your operating system, please follow the prerequisites below. You will find a list of
packages to install and configurations to perform.

**Primary supported platform:**

* [CentOS 7](prereq-centos7.md)
* [CentOS/AlmaLinux 8](prereq-centos8.md)
* [AlmaLinux 9](prereq-alma9.md)

**Platforms supported on a best-effort basis:**

* [macOS Ventura and Sonoma (13.0, 14.0)](prereq-macos.md)
* [Ubuntu (20.04 LTS, 22.04 LTS)](prereq-ubuntu.md)
* [Fedora](prereq-fedora.md)
* Linux Mint
    * Follow the instructions for the Ubuntu version your Linux Mint version is based on.
    * Specify the corresponding Ubuntu architecture when running the `aliBuild` command
      using the `-a` option (e.g. `-a ubuntu2004_x86-64` for Ubuntu 20.04).
      Use the `-a` option also with the `alienv` command.

If your operating system is _not_ in any list, it does not mean our software won't work on it;
it will be just more difficult for you to get support for it.

Only in case you cannot install aliBuild in the way described above, you can [install aliBuild manually](manual-install.md).
This procedure should only be used as a fall-back, in case you cannot follow the instructions for your operating system linked above.

## Configure aliBuild

After you are done installing alibuild you need to configure it by adding the two
following lines to your `~/.bashrc`, `~/.bash_profile`, `~/.zshrc` or `~/.zprofile`
(depending on your operating system and configuration):

```bash
export ALIBUILD_WORK_DIR="$HOME/alice/sw"
eval "$(alienv shell-helper)"
```

The first line tells what directory is used as "build cache", the second line installs a "shell
helper" that makes easier to run certain aliBuild-related commands.

You need to close and reopen your terminal for the change to be effective. The directory
`~/alice/sw` will be created the first time you run aliBuild.

> Note that this directory tends to grow in size over time, and it is the one you need to remove in
> case of cleanups.


## Build the packages

When aliBuild is installed on your computer and your prerequisites are satisfied, you can move to
the next step.

* [🛠 Build the packages](build.md)
