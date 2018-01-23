How to build ALICE software
===========================

The ALICE experiment currently has two frameworks:

* [AliRoot](https://github.com/alisw/AliRoot)/[AliPhysics](https://github.com/alisw/AliPhysics) for
  LHC Run 1 and Run 2
* [O2](https://github.com/AliceO2Group/AliceO2), currently under development, for Run 3 software

Building software has become an increasingly complicated operation, as our software has many
dependencies and we expect it to work both on your laptop and on the Grid. In addition, we support
many Linux distributions and recent macOS versions.

{% callout "Please follow the instructions closely!" %}
Most of the paths and procedures presented here can be adapted to your system and your taste. You
can for instance decide to use different path names, or a different directory structure, it's up to
you, however we **do not recommend you use different ways of installing the required
dependencies.**

In case you do not have particular needs, or you don't know what you are doing, please follow the procedure **very carefully and without diverging from it at all**.

This will make support easier in case something does not work as expected.
{% endcallout %}


## aliBuild

ALICE uses aliBuild to build software. aliBuild:

* knows how to build software via [per-package recipes](https://github.com/alisw/alidist),
* manages the dependencies consistently,
* rebuilds only what's necessary,
* allows several versions of the same software to be installed at the same time.


## Your operating system

There are different prerequisites depending on your operating system. The following list represents
what we support. If your operating system is in the list below, click on it to know what to do
_before_ proceeding with the ALICE software installation.

If you are in doubt about what operating system to install on your new laptop, the list below might
be helpful.

If your operating system is _not_ in the list below, it does not mean our software won't work on it;
it will be just more difficult for you to get support for it. We will be happy to add proper
documentation for additional operating systems!

* [macOS Sierra (10.12) and High Sierra (10.13)](prereq-macos.md)


## Get or upgrade aliBuild

Install or upgrade [aliBuild](https://pypi.python.org/pypi/alibuild/) with `pip`:

```bash
sudo pip install alibuild --upgrade
```

Now add the two following lines to your `~/.bashrc` or `~/.bash_profile` (depending on your
configuration):

```bash
export ALIBUILD_WORK_DIR="$HOME/.alicesw"
eval "`alienv shell-helper`"
```

The first line tells what directory is used as "build cache", the second line installs a "shell
helper" that makes easier to run certain aliBuild-related commands.

You need to close and reopen your terminal for the change to be effective. The directory
`~/.alicesw` will be created the first time you run aliBuild.

> Note that this directory tends to grow in size over time, and it is the one you need to remove in
> case of cleanups.


### I don't have root permissions

In case you don't have root permissions, the most general way of installing aliBuild is to specify
a user directory where to install it. Start with opening your `~/.bashrc` or `~/.bash_profile` (this
depends on your system), and add the following lines:

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


### I want a special version of aliBuild

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


## Build ALICE software

ALICE software is made of several dependencies, and aliBuild takes care of downloading them for you.
If you have exported the `$ALIBUILD_WORK_DIR` variable as described above, source code for all
dependencies will be "hidden" there. You want, however, to be able to see and control the source
code for the components you are developing: in our example we will show how to do that for AliRoot,
AliPhysics and (if you also develop Run 3 software) O2.


### Initialize or update your work area

We will assume our work area is `~/alice`. Let's create it and download the source of the packages
we need to develop.

```bash
mkdir ~/alice
cd ~/alice
```

For Run 2 software:

```bash
aliBuild init AliRoot,AliPhysics
```

For Run 3 software (you can have both Run 2 and Run 3 source code under the same directory):

```bash
aliBuild init O2 --defaults o2
```

> Do not forget the `--defaults o2`, aliBuild will complain if you don't specify it.

The commands above will finish with a message like:

```
==> Development directory . created for aliroot, aliphysics
```

If you do `ls`, you will see the AliRoot, AliPhysics and O2 directories, plus an additional alidist
directory: this is the place containing the software recipes, telling aliBuild how to construct our
software, and you can ignore it.

{% callout "Software and recipes must be updated manually!" %}
`aliBuild init` downloads software, and the recipes directory, for you the first time, but then they
will behave like any other Git directory and aliBuild will never update them any longer. You will
need to take care of the update yourself.

This means, in most cases, moving into the software directory and doing something like:

```bash
git checkout master
git reset --hard origin/master
git pull
```

Note that the operation above differs for O2 (where the default branch is `dev`, not `master`), and
the `git reset --hard` command is destructive: it will align your repository to the upstream one by
making you lose all your local changes.
{% endcallout %}