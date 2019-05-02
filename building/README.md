Build ALICE software
====================

The ALICE experiment currently comprises two frameworks:

* [AliRoot](https://github.com/alisw/AliRoot)/[AliPhysics](https://github.com/alisw/AliPhysics) for
  LHC Run 1 and Run 2
* [O2](https://github.com/AliceO2Group/AliceO2) for Run 3 software on

**The preferred way to get ALICE software built on your computer is by means of
[alidock](https://github.com/alidock/alidock).** We provide users with a consistent environment
based on containers. By using alidock, you will benefit from precompiled binaries which will make
you save plenty of time. This method works on any modern Linux distribution and macOS.

* [🐳 Install ALICE software with alidock](alidock.md)

We also have instructions for installing your software without using our controlled environment. We
do not recommend you to follow this path, though, since alidock has better support.

* [🐌 Install ALICE software manually](custom.md)
