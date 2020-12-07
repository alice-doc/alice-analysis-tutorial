aliBuild prerequisites for macOS
================================

ALICE software on macOS is supported on a best effort basis. Even though we systematically check macOS builds there is no guarantee that software builds or runs correctly. Support requests might have low priority. We were able to successfully build on:

* Mojave (10.14)
* Catalina (10.15)
* Big Sur (11.0)

With very short update cycles of macOS, refrain from updating until we list the latest version of macOS as verified. 

In November 2020, Apple started a transition to theier own ARM based processor archtecture called "Apple Silicon" on the Mac. These differ significantly from the current Macs based on Intel X86 processors. In the forseeable future, these ARM based Macs will not be able to run ALICE code as software packages we depend on are not yet available for this platform. However with a big Mac community at ALICE we expect support to come once this is possible.

## Get Xcode

Xcode bundles the necessary tools to build software in the apple ecosystem including compilers, build systems and version control
* Download it from the [App Store](https://itunes.apple.com/gh/app/xcode/id497799835?mt=12)
* Open once installed. It will ask to install additional components - approve the action.
* Open a terminal (`Applicaions>Utilities>Terminal`) and install the command line tools using:
```bash
sudo xcode-select --install
```
* approve the license conditions by
```bash
sudo xcodebuild -license
```
## Disable System Integrity Protection (SIP)
System Integrity Protection was introduced by Apple to Mac OSX since El Capitan and is meant to harden the system against malicious software. More details are available in [Apple's knowledge base](https://support.apple.com/en-us/HT204899).
Unfortunately, some of the measures taken by SIP (in particular not propagating `LD_LIBRARY_PATH`) will cause ROOT to not find dynamic libraries. We therefore have to switch off SIP.

* Reboot your Mac in _Recovery Mode_. by holding `Command-R` at startup until the Apple logo appears.
* Open a Terminal: (`Utilities>Terminal`).
* Disable SIP by executing
```csrutil disable``` 
* Restart your machine.
* After the reboot, open a terminal (`Applicaions>Utilities>Terminal`) and check if 
```bash
csrutil status
```
returns `System Integrity Protection status: disabled.`

The process can be reverted by following the above steps executing  
```csrutil enable```

The process is also documented in [Apple's developer documentation](https://developer.apple.com/library/archive/documentation/Security/Conceptual/System_Integrity_Protection_Guide/ConfiguringSystemIntegrityProtection/ConfiguringSystemIntegrityProtection.html)

## Get Homebrew

[Homebrew](https://brew.sh) is a command-line package manager for macOS used to install software packages similar to `yum` on CentOS or `apt` on Ubuntu. There are several different package managers for macOS, but Homebrew is by far the most poppular , and the only one we support.

* Install Homebrew using the [instructions on their webpage](https://brew.sh/).
* Once installed detect any problems regarding Homebrew and your system using  
```bash
brew doctor
```

## Install the required packages

Note that Homebrew does not run as root. Do not prepend `sudo` to **any** of the following commands.

* Install the prerequisites via:
```bash
brew install alisw/system-deps/o2-full-deps
```
Various users have reported that this might terminate with an error. The solution oddly enough seems to be to execute the above command multiple times until brew does not complain anymore.
* If you have just upgraded your Xcode or macOS, you should run `brew reinstall` instead, in order to force the reinstallation of already installed packages. You also might want to run `brew cleanup` at the end to free up some space.

* Edit or create `~/.bash_profile` (Mojave) or `~/.zprofile` (Catalina and later) and add
```bash
export PATH="/usr/local/opt/gettext/bin:/usr/local/bin:$PATH"
```
* Close Terminal and reopen it to apply changes. 

## Python
In case you are using [Python from Anaconda](https://www.anaconda.com/) or Python from Homebrew
then you have `pip` already. Check it by typing:
```bash
type pip3
```
If not present install with 
```bash
sudo easy_install3.9 pip
sudo pip3 install --upgrade pip
```

## (Optinal) Exclude your work directory from Spotlight
The mac search engine (Spotlight) will be indexing the build directory which can have severe effects on your system performance. To avoid that, you can exclude your working directory (we are assuming `~/alice` - create if not yet existing).
Go to `(Apple) menu>System preferences>Spotlight`. In the `Privacy` tab, hit the `+` button. Now select the `~/alice` directory and confirm.

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)
