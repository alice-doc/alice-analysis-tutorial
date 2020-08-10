# Develop a **single** package reusing a CVMFS / RPM installation

For those cases where you want to develop a single O2Suite package, for example ALICE O2, it's now possible to reuse a preexisting installation in CVMFS or
installed via the RPM packages. You can get the build environment by doing:

```bash
WORK_DIR=/cvmfs/alice.cern.ch ALIBUILD_ARCH_PREFIX=el7-x86_64/Packages . /cvmfs/alice.cern.ch/el7-x86_64/Packages/O2/nightly-20200728-1/etc/profile.d/init.sh
```

and then you can checkout and build most of the AliceO2Group packages with:

```bash
git clone https://github.com/AliceO2Group/AliceO2 O2
mkdir O2/objs
cd O2/objs
cmake ..
make -j 20
```
