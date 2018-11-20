# 📦 Use the precompiled binaries

You can run our precompiled binaries from CVMFS by simply logging to `lxplus` or `lxplus7`:

```bash
ssh <youruser>@lxplus.cern.ch
ssh <youruser>@lxplus7.cern.ch  # required for O2
```

If you are an ALICE user, you are welcomed with a message telling you exactly what to do. To load
a specific analysis tag of AliPhysics you can do:

```bash
/cvmfs/alice.cern.ch/bin/alienv enter AliPhysics/vAN-20181121_ROOT6-1
```

You can list all the available versions with (very slow 🐌):

```bash
/cvmfs/alice.cern.ch/bin/alienv q
```

or you can simply consult [the list of Grid packages here](https://alimonitor.cern.ch/packages).

---

O2 is available on the "nightlies" repository of ALICE. You can use it only from `lxplus7.cern.ch`:
it will not work on SLC6. List the packages:

```bash
/cvmfs/alice-nightlies.cern.ch/bin/alienv q
```

Load a specific version:

```bash
/cvmfs/alice-nightlies.cern.ch/bin/alienv enter O2/nightly-20181121-1
```
