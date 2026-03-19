# 🛠 Build the packages

ALICE software has several dependencies: aliBuild takes care of downloading them for you. aliBuild
will also automatically download precompiled binaries on [supported versions](./custom.md#operating-systems-we-support) of CentOS/Alma and Ubuntu.

aliBuild will download and compile all the dependencies caching data under `$ALIBUILD_WORK_DIR`. You
will never need to access this directory. The source code for the packages you will actually develop
will be stored elsewhere.

In the following example, we will assume that you need to download AliRoot/AliPhysics for developing
Run 2 software, and O2/O2Physics for Run 3.


## Prepare your source code

We assume your work area is `~/alice`.
So, first off, create the directory and move to it:

```bash
mkdir -p ~/alice
cd ~/alice
```

If you need to develop for Run 3, download O2Physics:

```bash
aliBuild init O2Physics@master
```

Only if you need to develop the Run 3 core software (unlikely), download O2:

```bash
aliBuild init O2@dev
```

{% callout "Obsolete / Deprecated stack" %}
If you absolutely need to develop analysis using the old, deprecated
Run 1 / Run 2 stack, you can still use AliPhysics :

```bash
aliBuild init AliPhysics@master
```

Only if you need to develop the Run 2 core software (unlikely), download AliRoot:

```bash
aliBuild init AliRoot@master
```
{% endcallout %}


### Source code and recipes

If you perform `ls` under your work directory, you will see the packages you have downloaded via
`aliBuild init`, plus an `alidist` directory.

The `alidist` directory contains software recipes, telling aliBuild how the software is built. Your
`alidist` directory and your software source code are Git directories **managed by you**: you need
to keep them up-to-date manually.

{% callout "Check names of your remote repositories" %}
With older versions of aliBuild, the central remote repository (used for pulling updates) would be
called `origin` instead of the usual name `upstream` and the personal (fork) remote repository (used
for pushing changes) would be called `<your-github-username>` instead of the usual name `origin`.
Please check your settings using `git remote -v` and adjust the Git commands mentioned in
the following instructions accordingly, if needed.
{% endcallout %}

Update your software by `cd`ing into its directory and running:

```bash
# use dev instead of master for O2
git checkout master
git pull --rebase upstream master
```

This will work in most cases and will keep your changes. It will also complain if there is some
conflict you need to solve manually. You also have the nuclear option, to be used if you are sure
you do not have any important data:

```bash
# use dev instead of master for O2
git checkout master
git fetch --all
git reset --hard upstream/master
```

Instead of resetting to the current upstream version, you may want to download specific versions of
the software:

```bash
cd ~/alice/O2
git fetch --all --tags
git checkout v5-09-42-01
```

{% callout "Why manual updates?" %}
Software downloaded under your working directory is your responsibility. Our tools will not take any
action to update it: imagine if you lose important data because of an automatic update!

As a developer, and ALICE contributor, you must be capable of using and understanding `git`.
{% endcallout %}


## Check your prerequisites

aliBuild comes with the command `aliDoctor` that will help you identifying if your prerequisites
were installed correctly. In general, aliBuild is capable of building all required software
dependencies, but it has also the ability to take them "from the system" if possible, resulting in
less time spent for building for you.

For Run 3 software:

```bash
cd ~/alice
aliDoctor O2Physics
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

{% callout "Obsolete / Deprecated stack" %}
For Run 2 software based on ROOT 6 (note: this is the only option on macOS):

```bash
cd ~/alice
aliDoctor AliPhysics
```

{% endcallout %}


## Build and rebuild

You can build the whole Run 3 software stack with :

```
cd ~/alice
aliBuild build O2Physics
```

If you want to build O2 and run the tests as well (same way as they are run on the pull request
checkers), with `--debug` to see the full output:

```
cd ~/alice
aliBuild build O2 --debug -e ALIBUILD_O2_TESTS=1
```

_⚠️  It is recommended to run the first O2 build without the tests enabled to let it complete. You
will not have to rerun it from scratch because of test failures like this._

Using the combinations above on CentOS 7 will make aliBuild automatically download the precompiled 
binaries for almost all packages.

{% callout "AliPhysics with ROOT 6 and the Grid" %}
The command above will produce AliPhysics with ROOT 6 as a dependency. When using this version, you
will only be able to submit Grid analysis jobs using ROOT 6-based builds (whose name ends with
`_ROOT6`). If you still need ROOT 5 only for submitting Grid jobs, there is no need to install it:
just [use it from CVMFS](precomp.md) by logging in to `lxplus.cern.ch`.
{% endcallout %}

{% callout "Obsolete / Deprecated stack" %}
```
cd ~/alice
aliBuild build AliPhysics
```
{% endcallout %}


### Rebuild existing installations

As a general rule, your existing installation can be smartly rebuilt by using the exact same
`aliBuild build` command as you did the first time. aliBuild will not rebuild existing software and
it will simply rebuild the changes.

You may find it fast to skip the aliBuild part completely. You can simply move to the build
directory and run `make` (the `alienv` part is [explained
later](#run-a-single-command-in-the-environment)):

```bash
cd $ALIBUILD_WORK_DIR/BUILD/AliPhysics-latest/AliPhysics
alienv setenv GCC-Toolchain/latest -c cmake --build . -- -j <num-parallel-jobs> install
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
alienv enter O2/latest
```

_⚠️  Dependencies are loaded automatically. Do not attempt to load O2 and ROOT as well, you will
find them automatically in the environment! `alienv enter` is verbose and will inform you about the
loaded packages if you have doubts._

The `alienv enter` command drops you to a new shell. Unload the packages by simply exiting it with
the `exit` command.

{% callout "I have several O2 versions. Which one is O2/latest?" %}
aliBuild will tell you exactly what you need to type in order to load the software you have just
built. Just use aliBuild's suggestion in place of `O2/latest` wherever appropriate: for
instance, if you have several O2 versions, `O2/latest` will point to the version you
have built more recently, not the latest.
{% endcallout %}


### Load environment in the current shell or script

If you know what you are doing, you can also load the environment in your _current_ shell, and
subsequently unload it (this is not recommended):

```bash
alienv load O2/latest
alienv unload O2/latest
```

If you want to load the environment inside a script you are developing, just add this line (works
with Bash scripts):

```bash
source $(alienv printenv O2/latest)
```


### Run a single command in the environment

You can also run a single command (for instance, `root`) in the given environment without loading
it in the current shell:

```bash
alienv setenv O2/latest -c root 
```

{% callout "🚫Do not load alienv automatically in your shell" %}
Even if this is technically possible, it is strongly not recommended to load the environment with
`alienv` in your `~/.bashrc`! **You must keep your environment pristine for safely running
aliBuild.** By not loading the environment automatically, you will avoid a huge source of errors.
{% endcallout %}


## Special build needs

Please refer to the aliBuild documentation for special build options like:

- Building multiple branches in the same area
- Remove obsolete / unneeded packages
- Limit resource usage
- Cross platforms builds using docker / Apple Container
