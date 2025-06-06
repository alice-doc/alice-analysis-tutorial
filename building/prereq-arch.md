aliBuild prerequisites for ArchLinux
=================================

ALICE software on ArchLinux is supported on a best effort basis. There is no guarantee that software builds or runs correctly. Support requests might have low priority.

## Install or Upgrade the Required Packages

With root permissions, i.e. `sudo` or as `root` install the prerequisites using:

```bash
pacman -S git python3 python-pip which gcc \
          make gcc-fortran \
          base-devel libxpm libxft glu gsl \
          libuv tbb xerces-c re2 libwebsockets grpc
```

You are now ready to [start building ALICE software](README.md#get-or-upgrade-alibuild)
