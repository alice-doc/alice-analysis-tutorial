# Develop a **single** package reusing a CVMFS / RPM installation **EXPERIMENTAL**

For those cases where you want to develop a single O2Suite package, for example ALICE O2, it's now possible to reuse a preexisting installation in CVMFS or
installed via the RPM packages.

In order to do so you must make sure you point `WORK_DIR` to your base installation folder. E.g. for lxplus:

```bash
export WORK_DIR=/cvmfs/alice.cern.ch
```

and that you properly set your `ALIBUILD_ARCH_PREFIX`. E.g. for lxplus:

```bash
export ALIBUILD_ARCH_PREFIX=el7-x86_64/Packages
```

assuming you want to use `nightly-20200810-1` as baseline, you can then do:

```bash
. $WORK_DIR/$ALIBUILD_ARCH_PREFIX/O2/nightly-20210120-1/etc/profile.d/init.sh
```

This will fill your environment with all the requirements needed to properly build O2.

You can checkout and build most of the AliceO2Group packages with:

```bash
git clone --origin upstream https://github.com/AliceO2Group/AliceO2 O2
mkdir -p O2/objs
cd O2/objs
cmake ..
cmake --build . --target all -j8
```

This is not a replacement for the full alibuild environment, which allows you to build multiple packages at once or to keep track of
changes in alidist, however it should work already fairly well to develop a single package.

## Caveats:

* Runtime environment is currently not handled fully and you need to either use `-DCMAKE_INSTALL_PREFIX` or run executables from `stage/bin`.
