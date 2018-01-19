aliBuild prerequisites on macOS
===============================

ALICE software compiles just fine on macOS using Apple-provided build tools. We exclusively support
the following two versions of macOS:

* Sierra (10.12)
* High Sierra (10.13)

**Any other version of macOS has to be considered not supported.** If you are in doubt about
upgrading your operating system and you still don't see the new version here, then please refrain
from upgrading.

**Please follow these instructions every time you install a new macOS version and every time you get
a newer Xcode! This is non-optional!**


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

When you are done fixing the warnings, upgrade all the currently installed Homebrew packages:

```bash
brew upgrade
```

It is now time to install a bunch of required packages. Copy and paste this to your terminal
(warning: long line):

```bash
brew install autoconf automake boost coreutils gettext gmp hub isl libmpc libtool m4 modules mpfr openssl pkg-config readline
```

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

The GCC project has a [downloads page for macOS]: get the version that corresponds to your operating
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

Since El Capitan (10.11), Apple has introduced a security feature called [System Integrity
Protection](https://www.macworld.com/article/2986118/security/how-to-modify-system-integrity-protection-in-el-capitan.html), or SIP.

At the moment, unfortunately, ALICE software requires this feature to be turned off.

To turn SIP off:

* Reboot your Mac in _Recovery Mode_. That is, before macOS starts up, hold down `Command-R` and
  keep both keys pressed until the Apple logo appears.
* From the **Utilities** menu open a **Terminal**.
* Type: `csrutil disable`: a message will notify the success of your operation.
* Select **Restart** from the  menu.

**Note:** you can always re-enable it using `csrutil enable` instead.
