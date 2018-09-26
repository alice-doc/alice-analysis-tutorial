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

In case you do not have particular needs, or you don't know what you are doing, please follow the
procedure **very carefully and without diverging from it at all**.

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

* [macOS High Sierra (10.13) and Mojave (10.14)](prereq-macos.md)
* [Ubuntu 18.04 LTS, 17.10 and 16.04 LTS](prereq-ubuntu.md)
* [CentOS 7](prereq-centos7.md)
* [Fedora 27](prereq-fedora.md)

In case your operating system is not supported, you can [run the whole build process under
Docker](#running-in-docker).


## Get or upgrade aliBuild

Install or upgrade [aliBuild](https://pypi.python.org/pypi/alibuild/) with `pip`:

```bash
sudo pip install alibuild --upgrade
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

If you want to checkout a specific version of the software, you have again to bear in mind that
AliRoot, AliPhysics and O2 are normal Git repositories. Do something like:

```bash
( cd AliRoot && git checkout v5-09-11 )
( cd AliPhysics && git checkout v5-09-11-01 )
```

instead of using `master` and pulling from there.
{% endcallout %}


### Check your prerequisites

aliBuild comes with the command `aliDoctor` that will help you identifying if your prerequisites
were installed correctly. In general, aliBuild is capable of building all required software
dependencies, but it has also the ability to take them "from the system" if possible, resulting in
less time spent for building for you.

Run the `aliDoctor` command to check dependencies for Run 2 software:

```bash
cd ~/alice
aliDoctor AliPhysics
```

For Run 2 software based on ROOT 6 (note: this is the only option on macOS):

```bash
cd ~/alice
aliDoctor AliPhysics --defaults root6
```

For Run 3 software:

```bash
cd ~/alice
aliDoctor O2 --defaults o2
```

aliDoctor will warn you that some packages have to be built as they could not be found from the
system. If you have followed the instructions, this list should contain **nothing more than**:

* boost
* CMake
* GSL
* nanomsg
* protobuf
* Vc
* yaml-cpp
* ZeroMQ
* SWIG

In particular, you should never have `Python` or `Python-modules`. If the output is longer than this
list, please go through the prerequisites once again and run `aliDoctor` again. If the output
contains those packages, or less packages, then you are fine and you may continue.

> If you think a package is shown but should not be in the list because you are sure you have
> installed it, it might just be that its version it's incompatible (this frequently happens with
> `CMake`) or you are missing the "development" package for that component.


### Build and rebuild

If you have followed the prerequisites part thoroughly, and if you have double-checked it with
`aliDoctor`, it's time to run your build.

Remember that you have checked out _manually_ the sources for AliRoot, AliPhysics and O2, so before
building make sure your sources are up to date by following the instructions above.

There are different ways of building Run 2 software depending on your configuration and your
desired features. The build command is:

```bash
cd ~/alice
aliBuild build AliPhysics [--defaults DEFAULTS]
```

Choose your `--defaults` accordingly:

| Defaults     | ROOT 6 | GEANT3, 4, DPMJET | Works on macOS |
| ------------ | ------ | ----------------- | -------------- |
| `<none>`     | no     | yes               | no             |
| `user`       | no     | no _(faster)_     | no             |
| `root6`      | yes    | yes               | yes            |
| `user-root6` | yes    | no _(faster)_     | yes            |

Note that **it is mandatory to use ROOT 6 on macOS**. ROOT 5 builds do not work there. In most cases
the `user` (and `user-root6`) installation is sufficient and takes less time and disk space.

You will need to run the **exact same command** when rebuilding, with the same `--defaults` option.

{% callout "Build with ROOT 5 and 6 at the same time" %}
If you want to build, using the same source, against ROOT 5 and ROOT 6 at the same time, you can do
that, it's explained [later on](#build-and-use-the-same-source-with-different-options).
{% endcallout %}

The same command is used both for building the first time, and rebuilding: aliBuild is smart and
**it will rebuild only what changed**.

{% callout "Why is aliBuild rebuilding everything?!?!? 😠🤬" %}
One or more of the following actions might change the way aliBuild sees and uses the dependencies
and might result in a **full** (or nearly full) rebuild. So, if an important conference is
approaching, **plan the following actions accordingly as they might increase the build time**:

* Updating recipes in `alidist`
* Removing the cache `$ALIBUILD_WORK_DIR` or forgetting to export the variable
* Adding or removing system dependencies as seen by `aliDoctor`
* Updating your operating system or compilers (including Xcode on macOS)
{% endcallout %}

If you need to build Run 3 software, simply do:

```bash
aliBuild build O2 --defaults o2
```

on every platform.

aliBuild installation will finish with a clear indication of what to do to use the software you
have just built. This part is covered in the next section.

{% callout "Build takes up too many laptop resources!" %}
Building ALICE software is a resource-expensive operation. By default, aliBuild uses as many laptop
resources as possible for building. If you need to work while building, you can use the `-j` flag to
tell aliBuild to use fewer CPUs (just one in the example below):

```bash
aliBuild build O2 -j 1 --defaults o2
```
{% endcallout %}


## Use the software you have built

aliBuild comes with a tool called `alienv`: this tool is used to load the correct environment for
the software you have built. Notably, `alienv` can manage multiple versions of the same software
without conflicts.

Just open a terminal and type:

```bash
alienv q
```

to display the list of available packages. To load the latest version you have built of AliPhysics,
do:

```bash
alienv enter AliPhysics/latest
```

> Note that this command will load AliPhysics **and all its dependencies** automatically, so there
> is absolutely no need to also load, _e.g._, AliRoot or ROOT!

The `enter` command drops you to a new shell, meaning that you can "clean up" your environment by
simply exiting it.

> Please also note that aliBuild will tell you exactly what you need to type in order to load the
> software you have just built. Just use aliBuild's suggestion in place of `AliPhysics/latest`
> wherever appropriate.

If you know what you are doing, you can also load the environment in your _current_ shell:

```bash
alienv load AliPhysics/latest
```

In this case, you will clear the environment by doing:

```bash
alienv unload AliPhysics/latest
```

If you want to load the environment inside a script you are developing, just add this line:

```bash
source $(alienv printenv AliPhysics/latest)
```

{% callout "Do not load alienv automatically!" %}
Even if this is technically possible, it is strongly not recommended to load the environment with
`alienv` in your `~/.bashrc`! **You must keep your environment pristine for safely running
aliBuild.** By not loading the environment automatically, you will avoid a huge source of errors.

Do you still find annoying to type `alienv enter AliPhysics/latest` every time you want to use it?
You can add the following line in your `~/.bashrc` to make it more convenient:

```bash
alias ali='alienv enter AliPhysics/latest'
```

You are creating an alias called `ali`, that will load the environment by just typing it at the
prompt. Of course you can use any name you want.
{% endcallout %}


# Build and use the same source with different options

aliBuild and alienv give you the ability to build the same development source with different
defaults without duplicating the source, and without conflicts.

Imagine we are under `~/alice` and we have cloned AliRoot and AliPhysics with the `aliBuild init`
command above. We build AliPhysics _twice_, once with ROOT 5 and a second time against ROOT 6.

{% callout "ROOT package in development mode" %}
Bear in mind that in this example we are assuming you don't have ROOT in development mode, _i.e._
you have _only_ cloned AliRoot and AliPhysics in your current directory (with `aliBuild init`), not
ROOT!

If you did that, then you need to manually enter the ROOT directory and checkout the proper ROOT
version by yourself.
{% endcallout %}

Here's the ROOT 5 build command (note the `-z aliroot5` suffix, giving our build a special name
that allows to distinguish it from the ROOT 6 one):

```bash
aliBuild build AliPhysics --defaults user -z aliroot5
```

The command ends with a message saying what to do to use the package:

```bash
alienv enter AliPhysics/latest-aliroot5-user
```

Notice that aliBuild tells you **what is the exact alienv command to run to use this build**. Let's
do the same with ROOT 6 (note that we use a distinct name, `-z aliroot6`):

```bash
aliBuild build AliPhysics --defaults user-root6 -z aliroot6
```

Now, the message tells us to type:

```bash
alienv enter AliPhysics/latest-aliroot6-user-root6
```

to use the package. As you can see, `aliroot6` is part of the package name.

Keep in mind that:

* aliBuild always tells you what is the package name to load at the end of the build
* you can load the two environments separately, in two different shells, with no chance of a mixup
* you have used the same set of sources for generating two distinct builds
* `alienv enter AliPhysics/latest` will load the _latest you have built_, which can either be the
  ROOT 5 or ROOT 6-based version: given its ambiguity, do use explicit names instead

It is also possible to directly run `aliroot` (or any command you want) without "entering" the
environment:

```bash
alienv setenv AliPhysics/latest-aliroot5-user -c aliroot
alienv setenv AliPhysics/latest-aliroot6-user-root6 -c aliroot
```

The `aliroot` command will be run with the correct environment in both cases.

{% callout "Migrating from ROOT 5 to ROOT 6" %}
While you are at it, if you want to migrate your existing code to ROOT 6 (and make sure it works
there) check out our [migration guide](../analysis/ROOT5-to-6.md).
{% endcallout %}


## Build specific releases (tags) of the software

It might come useful to build a certain tag of AliRoot and AliPhysics instead of simply pulling the
master.

> Note that **we only guarantee that the current AliPhysics master works against the latest AliRoot
> tag!** It is therefore possible (though a rare occurrence) that the current AliRoot master breaks
> the current AliPhysics master.

If you have your source code in "development mode" (_i.e._ downloaded locally by means of `aliBuild
init`), since your AliRoot/AliPhysics/O2 directories [are mere Git
repositories](#software-and-recipes-must-be-updated-manually), you simply need to `cd` into them and
checkout the Git version you want.

For instance, if you want to build AliPhysics against AliRoot v5-09-33, you would need to first
move to the AliRoot directory and check the version out:

```bash
cd ~/alice/AliRoot
git fetch origin --tags
git checkout v5-09-33
```

Then update your AliPhysics master:

```bash
cd ~/alice/AliPhysics
git fetch origin master
git checkout master
git reset --hard origin/master
```

and then build normally using the `aliBuild` command. You might want to build using different `-z`
options [as explained here](#build-and-use-the-same-source-with-different-options) in order to have
different builds usable in parallel without duplicating your source code.


## Running in Docker

[Docker](https://www.docker.com/) is a popular way to run Linux containers. As a consequence you
will get the runtime environment of a different operating system without the overhead of a virtual
machine.

This may be useful if your OS is unsupported, or if you want to have a fully isolated environment
for your ALICE builds: you simply create a container corresponding to one of the supported Linux
OSes and follow the corresponding prerequisites. **The examples below focus on the CentOS 7
container as this is the reference environment for ALICE.**

This is how to install Docker on:

* [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/)
* [macOS](https://docs.docker.com/docker-for-mac/install/)
* [Windows](https://docs.docker.com/docker-for-windows/install/)

If you are a macOS user, you should tune your memory settings once for all by clicking on the Docker
whale icon in the taskbar, then **Preferences... → Advanced**. Set the CPUs to the maximum
available, and the memory to at least 4 GB (the more the merrier). Click **Apply & Restart**.

Create a persistent container by giving it a friendly name (we have chosen `aliceBuildEnvironment`):

```bash
docker run -it --name aliceBuildEnvironment -v $HOME/alice:$HOME/alice:rw centos:7
```

The `-v ...` switch tells Docker to make your system's directory `~/alice` visible under the exact
same path in your container. This allows Docker to save your work environment on your system, not
inside the container: your container is therefore _disposable_, even if you lose it you won't lose
your ALICE builds.

{% callout "Use the same directory path" %}
It is quite important that you use the **exact same directory name** inside the container: this is
the only way to make aliBuild work on the same directory both inside the container and outside. This
allows you to share, for instance, the Git clones across installations on different platforms, and
save you gigabytes of space!

Please also note that the value of the variable `$HOME` inside the container will be different, so
before entering the container just display its value:

```bash
echo $HOME
```

and then inside the container `cd` into that path.
{% endcallout %}

A root shell will open inside the container. It will be the same as using a CentOS 7 operating
system (in case you've used the [centos:7](https://hub.docker.com/r/library/centos/) container)
until you type `exit`: this means you will have to follow the [proper installation
prerequisites](#your-operating-system) as usual.

When you are done with the prerequisites you can [continue your installation as
usual](#get-or-upgrade-alibuild) inside the container.


### Start your saved container

Since your container is persistently saved, you can always restart it if you exit it or reboot your
computer with:

```bash
docker start aliceBuildEnvironment
```

The command will return immediately (and will do nothing if the container is already running). Once
started (check with `docker ps`) you can connect to it as many times as you want with:

```bash
docker exec -it aliceBuildEnvironment bash
```


### Remove your container

In case your container environment gets messed up for some reason, you can erase it completely with:

```bash
docker rm -f aliceBuildEnvironment
```

This will terminate any active session if running. Since your `~/alice` directory contains all the
aliBuild installation artifacts, if you intend to perform an aliBuild cleanup you should remove that
directory too.
