aliBuild prerequisites for macOS
================================

ALICE software compiles just fine on macOS using Apple-provided build tools. We support exclusively
the following two versions of macOS:

* High Sierra (10.13)
* Mojave (10.14)

**Any other version of macOS has to be considered not supported.** If you are in doubt about
upgrading your operating system and you still don't see the new version here, then please refrain
from upgrading.

**Please follow these instructions every time you install a new macOS version and every time you get
a newer Xcode! This is non-optional!**

{% callout "Upgrade your macOS/Xcode with care" %}
The instructions you see on this page have been validated **on October 1, 2018** using:

* macOS 10.14
* Xcode 10.0 (10A255)

Even minor version updates on macOS/Xcode may break our build chain, and it might take us days
before fixing it. Keep an eye on this page to see if we have tested the latest versions first.
{% endcallout %}


## Get or upgrade Xcode

Xcode is the Apple-provided toolkit for developing software on Apple devices. Xcode is required as
it contains the necessary compilers and build tools used by ALICE.

Get it from the App Store [by clicking here](https://itunes.apple.com/gh/app/xcode/id497799835?mt=12):
if the link does not work, just open the App Store and search for Xcode. The installation is free of
charge, but it takes quite some space on your Mac.

When installed, open it: if it asks you to install additional required components, please approve
the action.

Installation's not over yet. Additional components (the "command-line tools") are required. Open a
terminal and run:

```bash
xcode-select --install
```

In case they are already installed, you'll see the following message:

```
xcode-select: error: command line tools are already installed, use "Software Update" to install updates
```

**This is important:** once Xcode and the command-line tools are installed, every update will occur
graphically via the App Store.

Now, at your first installation, you need to accept the Xcode license. If the above command did not
ask you anything, just open a terminal and write:

```bash
git
```

without any further option. You will be prompted in case there is a license to accept. In case the
license has been accepted already, you'll just see the list of options for the `git` command.


## Get or upgrade Homebrew

[Homebrew](https://brew.sh) is a command-line package manager for macOS. It is the most popular now,
and it is the only one we support.

> If you have other package managers installed, such as MacPorts or Fink, you must get rid of them
> before proceeding. They will conflict with Homebrew and ALICE software in a bad way.

Note that Homebrew does not run as root. Do not prepend `sudo` to **any** of the following commands!

Installation instructions are [ridiculously simple on the website](https://brew.sh/). Once Homebrew
is installed, run (as suggested):

```bash
brew doctor
```

and fix any potential error highlighted by the tool. **Errors and warnings should not be
overlooked!** Pay close attention to warnings concerning outdated Xcode/compiler versions: you must upgrade Xcode to the latest available version before proceeding any further!

{% callout "Clean up your Homebrew installation" %}
Due to a [problem with the automake 1.16 package](http://gnu-automake.7480.n7.nabble.com/automake-1-16-aclocal-is-unable-to-process-AM-PATH-PYTHON-with-variable-as-value-td22860.html),
subsequently fixed in version 1.16.1, a Homebrew workaround has been suggested on this page.

If you have applied the suggested workaround, the `brew doctor` command from above complains with
the following message:

```
Warning: Homebrew/homebrew-core is not on the master branch

Check out the master branch by running:
  git -C "$(brew --repo homebrew/core)" checkout master
```

To clean it up, it is better if you run the following commands (and not just the one suggested by
`brew doctor`):

```bash
cd "$(brew --repo homebrew/core)"
git checkout master
git fetch origin master
git reset --hard origin/master
```
{% endcallout %}

When you are done fixing the warnings, upgrade all the currently installed Homebrew packages:

```bash
brew upgrade
```

It is now time to install a bunch of required packages:

```bash
brew install alisw/system-deps/o2-full-deps
```

If you have just upgraded your Xcode or macOS, you should run `brew reinstall` instead, in order to
force the reinstallation of already installed packages. You also might want to run `brew cleanup` at
the end to free up some space.

Now, open your `~/.bash_profile` (you should have a default one; create one if it does not exist,
and bear in mind that `~` represents your home directory) and add the following content:

```bash
export PATH="/usr/local/opt/gettext/bin:/usr/local/bin:$PATH"
```

The line above tells your shell (assuming it's Bash) where to find Homebrew programs. To check if it
works, close the terminal, open a new one, and type:

```bash
type autopoint
```

You should get as an answer:

```
autopoint is /usr/local/opt/gettext/bin/autopoint
```


## Get or upgrade gfortran

Your Xcode installation is missing a Fortran compiler, unfortunately. We need it for some parts of
our code, therefore you must install it.

The GCC project has a [downloads page for macOS](https://gcc.gnu.org/wiki/GFortranBinaries#MacOS): get the version that corresponds to your operating
system the most. This means that if gfortran for your operating system version is not out yet, you
can safely download the one for the previous version.

Downloads are dmg files: just double-click on them with Finder and follow the graphical installation
procedure.

When done, open a terminal and check if you can find it:

```bash
type gfortran
```

You should obtain:

```
gfortran is /usr/local/bin/gfortran
```

## Disable System Integrity Protection

Starting from El Capitan (10.11), Apple has introduced a security feature called [System Integrity
Protection](https://www.macworld.com/article/2986118/security/how-to-modify-system-integrity-protection-in-el-capitan.html), or SIP.

At the moment, unfortunately, ALICE software requires this feature to be turned off.

To turn SIP off:

* Reboot your Mac in _Recovery Mode_. That is, before macOS starts up, hold down `Command-R` and
  keep both keys pressed until the Apple logo appears.
* From the **Utilities** menu open a **Terminal**.
* Type: `csrutil disable`: a message will notify the success of your operation.
* Select **Restart** from the  menu.

**Note:** you can always re-enable it using `csrutil enable` instead.


## Get or upgrade pip

`pip` is the Python package manager. Our build tool
[aliBuild](https://pypi.python.org/pypi/alibuild/) and other Python dependencies are installed
through it.

In case you are using [Python from Anaconda](https://www.anaconda.com/) or Python from Homebrew
then you have `pip` already. Check it by typing:

```bash
type pip
```

at your shell prompt. In case you don't use Anaconda, please install `pip` with this command:

```bash
sudo easy_install pip
```

Note that you need admin permissions for running the above command. Once done, check that `pip` got
installed under `/usr/local/bin`:

```bash
type pip
```

It should yield:

```
pip is /usr/local/bin/pip
```

Note that the Python version installed by means of `easy_install` might be too old. Check it with:

```bash
pip --version
```

You must have at least pip 9.0.1. If this is not the case, please run:

```bash
pip install --upgrade pip==9.0.1
```


## Get or upgrade required Python packages

Some Python packages are required for building our software. They are mostly related to ROOT 6. Just
run:

```bash
sudo pip install --upgrade --force-reinstall matplotlib numpy certifi ipython==5.1.0 ipywidgets ipykernel notebook metakernel pyyaml
```

> It is important to specify `ipython`'s version explicitly.


## Exclude your work directory from Spotlight

Mac users have two nice features, Time Machine for backups and Spotlight for searches, that might
have a detrimental effect on your Mac's performances.

Spotlight, in particular, indexes _every_ created file, and since during our build and installation
processes we create _a lot_ of files we don't really want to index, it's better to tell Spotlight
not to index our working directory.

We are assuming our working directory is `~/alice`. Before telling Spotlight to exclude it, we need
to create an empty one, so in a Terminal do:

```bash
mkdir ~/alice
```

(you can also use the Finder for that.) Then, go to the ** (Apple) menu → System preferences →
Spotlight**. Click on the **Privacy** tab, then hit the **+** sign at the bottom of the window. Now
select the `~/alice` directory and confirm.

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)
