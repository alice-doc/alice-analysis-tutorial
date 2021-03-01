# 🛠 Build the packages

ALICE software has several dependencies: aliBuild takes care of downloading them for you. aliBuild
can also automatically download precompiled binaries if possible.

aliBuild will download and compile all the dependencies caching data under `$ALIBUILD_WORK_DIR`. You
will never need to access this directory. The source code for the packages you will actually develop
will be stored elsewhere.

In the following example, we will assume that you need to download AliRoot/AliPhysics for developing
Run 2 software, and O2 for Run 3.


## Prepare your source code

We assume your work area is `~/alice`. If you are working in an
[alidock](https://github.com/alidock/alidock/wiki) environment, you might as well use the
container's `~` directly (which corresponds to your laptop's `~/alidock`).

So, first off, create the directory and move to it:

```bash
mkdir -p ~/alice
cd ~/alice
```

If you want to develop analysis code, download AliPhysics:

```bash
aliBuild init AliPhysics@master
```

Only if you need to develop the Run 2 core software (unlikely), download AliRoot:

```bash
aliBuild init AliRoot@master
```

If you need to develop for Run 3, download O2 (note the `--defaults o2`):

```bash
aliBuild init O2@dev --defaults o2
```


### Source code and recipes

If you perform `ls` under your work directory, you will see the packages you have downloaded via
`aliBuild init`, plus an `alidist` directory.

The `alidist` directory contains software recipes, telling aliBuild how the software is built. Your
`alidist` directory and your software source code are Git directories **managed by you**: you need
to keep them up-to-date manually.

Update your software by `cd`ing into its directory and running:

```bash
git checkout master  # use dev instead of master for O2
git pull --rebase
```

This will work in most cases and will keep your changes. It will also complain if there is some
conflict you need to solve manually. You also have the nuclear option, to be used if you are sure
you do not have any important data:

```bash
git checkout master             # use dev for O2
git fetch --all
git reset --hard origin/master  # use origin/dev for O2
```

Instead of resetting to the current upstream version, you may want to download specific versions of
the software:

```bash
cd ~/alice/AliPhysics
git fetch --all --tags
git checkout v5-09-42-01
```

{% callout "Why manual updates?" %}
Software downloaded under your working directory is your responsibility. Our tools will not take any
action to update it: imagine if you lose important data because of an automatic update!

As a developer, and ALICE contributor, you must be capable of using and understanding `git`.
{% endcallout %}


## Check your prerequisites (skip if using alidock!)

** 🐳 If you are building with [alidock](https://github.com/alidock/alidock/wiki), skip this part
and [jump to the build](#build-and-rebuild). 🐳 **

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
aliDoctor AliPhysics --defaults next-root6
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
* flatbuffers
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


## Build and rebuild

You can build the whole Run 2 software stack based on ROOT 6 with:

```
cd ~/alice
aliBuild build AliPhysics --defaults user-next-root6
```

If you also need to work with GEANT 3, GEANT 4 and DPMJET, use:

```
cd ~/alice
aliBuild build AliPhysics --defaults next-root6
```

Similarly, for O2:

```
cd ~/alice
aliBuild build O2 --defaults o2
```

If you want to build O2 and run the tests as well (same way as they are run on the pull request
checkers), with `--debug` to see the full output:

```
cd ~/alice
env ALIBUILD_O2_TESTS=1 aliBuild build O2 --defaults o2 --debug
```

_⚠️  It is recommended to run the first O2 build without the tests enabled to let it complete. You
will not have to rerun it from scratch because of test failures like this._

Using the combinations above in an [alidock environment](https://github.com/alidock/alidock/wiki) or
on CentOS 7 will make aliBuild automatically download the precompiled binaries for almost all
packages.

{% callout "AliPhysics with ROOT 6 and the Grid" %}
The command above will produce AliPhysics with ROOT 6 as a dependency. When using this version, you
will only be able to submit Grid analysis jobs using ROOT 6-based builds (whose name ends with
`_ROOT6`). If you still need ROOT 5 only for submitting Grid jobs, there is no need to install it:
just [use it from CVMFS](precomp.md) by logging in to `lxplus.cern.ch`.
{% endcallout %}


### Other build options

The options above are suitable for alidock or a CentOS 7 installation, since precompiled binaries
will be downloaded. You also have other installation options according to your needs: it is not
guaranteed that cached binaries are available for the following options, but they may be faster to
build.

**Build AliPhysics based on ROOT 5 (legacy):**

```bash
aliBuild build AliPhysics --defaults user  # without GEANT 3, GEANT 4, DPMJET
aliBuild build AliPhysics                  # no defaults; full stack
```

_⚠️  ROOT 5 does not work on macOS. Use a ROOT 6 version compatible with ROOT 5 if you really need it
(see below)._

---

### Rebuild existing installations

As a general rule, your existing installation can be smartly rebuilt by using the exact same
`aliBuild build` command as you did the first time. aliBuild will not rebuild existing software and
it will simply rebuild the changes.

You may find it fast to skip the aliBuild part completely. You can simply move to the build
directory and run `make` (the `alienv` part is [explained
later](#run-a-single-command-in-the-environment)):

```bash
cd $ALIBUILD_WORK_DIR/BUILD/AliPhysics-latest/AliPhysics
alienv setenv GCC-Toolchain/latest -c make -j <num-parallel-jobs> install
```

Replace `<num-parallel-jobs>` with a sensible number (_e.g._ slightly more than the actual number of
your cores).

{% callout "You lied. aliBuild is rebuilding everything! 🤬" %}
One or more of the following actions might change the way aliBuild sees and uses the dependencies
and might result in a **full** (or nearly) rebuild. So, if an important conference is approaching
(well: it always does, doesn't it?) **plan the following actions accordingly as they might increase
the build time**:

* Updating recipes in `alidist`
* Removing the cache `$ALIBUILD_WORK_DIR` or forgetting to export the variable
* Adding or removing system dependencies as seen by `aliDoctor`
* Updating your operating system or compilers (including Xcode on macOS)
{% endcallout %}


## Use your local software installations

You will not find the packages you have built immediately available on your shell: we provide a tool
called `alienv` that configures your shell according to the packages you want to load. `alienv` is
capable of switching between different versions of the same package without a hassle.

**List your available packages with:**

```bash
alienv q
```

**Load the latest version you have built of a package (AliPhysics for instance):**

```bash
alienv enter AliPhysics/latest
```

_⚠️  Dependencies are loaded automatically. Do not attempt to load AliRoot and ROOT as well, you will
find them automatically in the environment! `alienv enter` is verbose and will inform you about the
loaded packages if you have doubts._

The `alienv enter` command drops you to a new shell. Unload the packages by simply exiting it with
the `exit` command.

{% callout "I have several AliPhysics versions. Which one is AliPhysics/latest?" %}
aliBuild will tell you exactly what you need to type in order to load the software you have just
built. Just use aliBuild's suggestion in place of `AliPhysics/latest` wherever appropriate: for
instance, if you have several AliPhysics versions, `AliPhysics/latest` will point to the version you
have built more recently, not the latest.
{% endcallout %}


### Load environment in the current shell or script

If you know what you are doing, you can also load the environment in your _current_ shell, and
subsequently unload it (this is not recommended):

```bash
alienv load AliPhysics/latest
alienv unload AliPhysics/latest
```

If you want to load the environment inside a script you are developing, just add this line (works
with Bash scripts):

```bash
source $(alienv printenv AliPhysics/latest)
```


### Run a single command in the environment

You can also run a single command (for instance, `aliroot`) in the given environment without loading
it in the current shell:

```bash
alienv setenv AliPhysics/latest -c aliroot myMacro.C+
```

{% callout "🚫Do not load alienv automatically in your shell" %}
Even if this is technically possible, it is strongly not recommended to load the environment with
`alienv` in your `~/.bashrc`! **You must keep your environment pristine for safely running
aliBuild.** By not loading the environment automatically, you will avoid a huge source of errors.

Do you still find annoying to type `alienv enter AliPhysics/latest` every time you want to use it?
You can add the following line in your `~/.bashrc` to make it more convenient:

```bash
alias ali='alienv enter AliPhysics/latest'
```

You are creating an alias called `ali`, that will load the environment by just typing it at the
prompt. Of course you can name it any way you want.
{% endcallout %}


## Special build needs

Read below if you have some advanced requirements for your local installation.


### Build by using less resources

Building takes by default all the available CPU and most of the memory of your computer,
considerably slowing down your work. In some cases you may want to reduce the number of cores
available to aliBuild by using the `-j <num-cores>` option:

```bash
aliBuild build AliPhysics --defaults user-next-root6 -j 1
```


### Do not use the cache on alidock and CentOS 7

aliBuild will attempt to fetch the precompiled binaries automatically in an alidock environment or
on CentOS 7: no need to specify extra options.

If you want _not_ to use them for some reason, it is important you follow the [CentOS 7
prerequisites](prereq-centos7.md) first: this will allow aliBuild to take as many packages as
possible from the system. You will then need to add the `--always-prefer-system` option to the
`aliBuild build` command. For instance:

```bash
aliBuild build AliPhysics --defaults user --always-prefer-system
```


### Build the same source multiple times with different options

aliBuild and alienv give you the ability to build the same development source with different
defaults without duplicating the source, and without conflicts.

Imagine we are under `~/alice` and we have cloned AliRoot and AliPhysics with the `aliBuild init`
command above. We build AliPhysics _twice_, once with ROOT 5 and a second time against ROOT 6.

**Let's first build AliPhysics with ROOT 5:**

```bash
aliBuild build AliPhysics --defaults user -z aliroot5
```

_⚠️  Note the `-z aliroot5` command; it is assigning a nickname to the build for distinguishing it
more easily when using it._

The command ends with a message saying what to do to use the package:

```bash
alienv enter AliPhysics/latest-aliroot5-user
```

---

**Let's now build the same AliPhysics with ROOT 6:**

```bash
aliBuild build AliPhysics --defaults user-next-root6 -z aliroot6
```

Now, the message tells us to type:

```bash
alienv enter AliPhysics/latest-aliroot6-user-next-root6
```

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
alienv setenv AliPhysics/latest-aliroot6-user-next-root6 -c aliroot
```

The `aliroot` command will be run with the correct environment in both cases.

{% callout "Migrating from ROOT 5 to ROOT 6" %}
While you are at it, if you want to migrate your existing code to ROOT 6 (and make sure it works
there) check out our [migration guide](../analysis/ROOT5-to-6.md).
{% endcallout %}


### Build specific releases (tags) of the software

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
options [as explained here](#build-the-same-source-multiple-times-with-different-options) in order
to have different builds usable in parallel without duplicating your source code.

## 🧹 Delete obsolete builds

With frequent rebuilding of packages, obsolete builds can pile up and occupy a lot of precious
disk space.

### Basic cleanup

The simplest way to get rid of obsolete builds is to let aliBuild do its best by running:
```bash
aliBuild clean
```
which can take the optional argument `--aggressive-cleanup` that deletes also source code of built
dependency packages and downloaded `.tar.gz` archives.

In general, it's good practice to run `aliBuild clean` always after `aliBuild build`.

This might not be enough, as aliBuild will not delete any build directory pointed to by a symlink
that has "latest" in its name, even when that build is not needed by any other package anymore.
Manual intervention is therefore sometimes needed.

### Deep cleanup

If you want to keep only the latest builds of your development packages (and their dependencies),
you can make aliBuild delete the rest with a little trick.

1. Delete symlinks to all builds:
```bash
find $ALIBUILD_WORK_DIR/<architecture>/ -mindepth 2 -maxdepth 2 -type l -delete
find $ALIBUILD_WORK_DIR/BUILD/ -mindepth 1 -maxdepth 1 -type l -delete
```
where `<architecture>` is the name of your system architecture, returned by `aliBuild architecture`
(unless you specified it manually using the `-a` option with `aliBuild build`).
1. Recreate symlinks to the latest builds of development packages (and their dependencies)
by running `aliBuild build` for each development package.
1. Let aliBuild delete all the other builds by running `aliBuild clean`.
