aliBuild prerequisites for macOS
================================

ALICE software on macOS is supported on a best effort basis. Even though we systematically check macOS builds there is no guarantee that software builds or runs correctly. Support requests might have low priority. We were able to successfully build on:

* Mojave (10.14)
* Catalina (10.15)

With very short update cycles of macOS, refrain from updating until we list the latest version of macOS as verified for your own good.

## Get Xcode

Xcode provides the necessary tools to build software in the apple ecosystem
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

## Get or upgrade Homebrew

[Homebrew](https://brew.sh) is the most poppular command-line package manager for macOS, and the only one we support.

* Install Homebrew using the [instructions on their webpage](https://brew.sh/).
* Once installed detect any problems regarding Homebrew and your system using  
```bash
brew doctor
```

## Install the required Packages

Note that Homebrew does not run as root. Do not prepend `sudo` to **any** of the following commands.

* Install the prerequisites via:
```bash
brew install alisw/system-deps/o2-full-deps
```
* If you have just upgraded your Xcode or macOS, you should run `brew reinstall` instead, in order to force the reinstallation of already installed packages. You also might want to run `brew cleanup` at the end to free up some space.

* Edit or create `~/.bash_profile` (Mojave) or `~/.zprofile` (Catalina) and add
```bash
export PATH="/usr/local/opt/gettext/bin:/usr/local/bin:$PATH"
```
* Close the terminal and reopen it to apply changes. 

## GFortran

* Download a Fortran compiler [downloads page for macOS](https://github.com/fxcoudert/gfortran-for-macOS/releases).
* Get the `.dmg` archive of the version that corresponds to your operating system the most, i.e. if `gfortran` for your operating system version is not out yet, you can safely download the one for the previous version.

## Python
In case you are using [Python from Anaconda](https://www.anaconda.com/) or Python from Homebrew
then you have `pip` already. Check it by typing:
```bash
type pip3
```
If not present install with 
```bash
sudo easy_install3.7 pip
sudo pip3 install --upgrade pip
```

## (Optional) Python modules
Optinally you can install the required python modules. If we cannot find them, our build system will do it for you.

With the **system python**:
```bash
sudo pip3 install --upgrade --force-reinstall matplotlib numpy certifi ipython==5.1.0 ipywidgets ipykernel notebook metakernel pyyaml
```
For **Homebrew python**, leave out the `sudo`.

## (Optinal) Exclude your work directory from Spotlight
The mac search engine (Spotlight) will be indexing the build directory which can have severe effects on your system performance. To avoid that, you can exclude your working directory (we are assuming `~/alice` - create if not yet existing).
Go to `(Apple) menu>System preferences>Spotlight`. In the `Privacy` tab, hit the `+` button. Now select the `~/alice` directory and confirm.

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)
