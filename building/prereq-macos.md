aliBuild prerequisites for macOS
================================

ALICE software on macOS is supported on a best effort basis. Even though we systematically check macOS builds there is no guarantee that software builds or runs correctly. Support requests might have low priority. That said, we were able to successfully build on:

* Big Sur (11.0)
* Monterey (12.0) both x86 and M1

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

## Get Homebrew

[Homebrew](https://brew.sh) is a command-line package manager for macOS used to install software packages similar to `yum` on CentOS or `apt` on Ubuntu.

* Install Homebrew using the [instructions on their webpage](https://brew.sh/).
* Once installed detect any problems regarding Homebrew and your system using
```bash
brew doctor
```

## Install the required packages

Note that Homebrew does not run as root. Do not prepend `sudo` to **any** of the following commands.

* Install the prerequisites and aliBuild via:
```bash
brew install alisw/system-deps/o2-full-deps alisw/system-deps/alibuild
```

* Edit or create `~/.zprofile` and add
```bash
export PATH="/usr/local/opt/gettext/bin:/usr/local/bin:$PATH"
```
* Close Terminal and reopen it to apply changes.

## (Recommended) Exclude your work directory from Spotlight

The mac search engine (Spotlight) will be indexing the build directory which can have severe effects on your system performance. To avoid that, you can exclude your working directory (we are assuming `~/alice` - create if not yet existing).
Go to `(Apple) menu>System preferences>Spotlight`. In the `Privacy` tab, hit the `+` button. Now select the `~/alice` directory and confirm.

You are now ready for [installing aliBuild and start building ALICE software](README.md#get-or-upgrade-alibuild)

## Troubleshooting:

Some users have reported that homebrew commands might terminate with an error. The solution oddly enough seems to be to execute the above command multiple times until brew does not complain anymore.

If you have just upgraded your Xcode or macOS, you should run `brew reinstall` instead, in order to force the reinstallation of already installed packages. You also might want to run `brew cleanup` at the end to free up some space.
