How to build ALICE software
===========================

The ALICE experiment currently has two frameworks:

* [AliRoot](https://github.com/alisw/AliRoot)/[AliPhysics](https://github.com/alisw/AliPhysics) for
  LHC Run 1 and Run 2
* [O2](https://github.com/AliceO2Group/AliceO2), currently under development, for Run 3 software

Building software has become an increasingly complicated operation, as our software has many
dependencies and we expect it to work both on your laptop and on the Grid. In addition, we support
many Linux distributions and recent macOS versions.


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
