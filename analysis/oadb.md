## OADB and large shared files

The Offline Analysis Database (OADB) is a repository of relatively large configuration/calibration files that are used by the analysis framework, 
containing for example the 'TPC splines' with the parametrised dE/dx response of the TPC and calibration files for event plane calculation.
The data are generally stored in ROOT files, and the primary repository is on the CERN EOS file system, which is accessible from lxplus:

```
/eos/experiment/alice/analysis-data
```

We have preserved the same directory structure found on AliPhysics, and the
same permissions: for instance, `PWGLF` is writable by all members of
`alice-svn-pwglf` (whose members can be edited by the group conveners).

Every day, in concomitance with the AliPhysics daily tag (at 4pm Geneva time),
this folder is snapshotted on CVMFS under the following path:

```
/cvmfs/alice.cern.ch/data/analysis/YYYY/vAN-YYYYMMDD
```

carrying the same name as the corresponding AliPhysics tag. Moreover, at
every AliRoot/AliPhysics production release, we also snapshot at:

```
/cvmfs/alice.cern.ch/data/prod/v5-XX-YY-01
```

where the last component is the AliPhysics tag name.

CVMFS brings the advantage to make data access from Grid jobs reliable and
faster due to caching (files unchanged in two different snapshots are not
downloaded twice).

In order to profit from the separate storage for large files we have created an
interface in AliRoot to allow transparent access to OADB files using a relative
path. For instance, if you want to access the following large OADB data file:

```
PWGLF/FORWARD/CORRECTIONS/data/fmd_corrections.root
```

you can do:

```cpp
TFile::Open(AliDataFile::GetFileNameOADB("PWGLF/FORWARD/CORRECTIONS/data/fmd_corrections.root"))
```

The static function `AliDataFile::GetFileNameOADB` returns the first accessible
full URL of the OADB file by finding the first match from the following ordered
list of paths:

1. `$OADB_PATH/<file>`
2. `$ALICE_DATA/OADB/<file>`
3. `$ALICE_PHYSICS/OADB/<file>`
4. `/cvmfs/alice.cern.ch/data/prod/v5-XX-YY-01/OADB/<file>` (for Grid jobs, or with CVMFS installed)
5. `/cvmfs/alice.cern.ch/data/analysis/YYYY/vAN-YYYYMMDD/OADB/<file>` (for Grid jobs, or with CVMFS installed)
6. `root://eospublic.cern.ch//eos/experiment/alice/analysis-data/OADB/<file>`

This means that for laptop analysis it will always be possible to access data
files, somehow, and in a transparent fashion. If you want to have your OADB
data locally, you can download it from lxplus:

```bash
export OADB_PATH=/path/to/my/local/oadb
rsync -av --delete cern_user@lxplus.cern.ch:/eos/experiment/alice/analysis-data/ $OADB_PATH/
```

> Trailing slashes are important to rsync! Do not forget them!

Note that the variable `$OADB_PATH` must be exported to the environment where
you run your local analysis in order to make it visible to the job.


### Non-OADB data files

The same EOS path has also PWG-specific directories, outside the OADB one, for
other analysis-specific data. The following interface can be used to access
files from there:

```cpp
TFile::Open(AliDataFile::GetFileName("PWGMM/my_large_data.root"))
```

> Note the difference between `GetFileName()` and `GetFileNameOADB()`.

In this case, the file will be searched in the following locations in order:

1. `$ALICE_DATA/<file>`
2. `$ALICE_PHYSICS/<file>`
3. `/cvmfs/alice.cern.ch/data/prod/v5-XX-YY-01/<file>` (for Grid jobs, or with CVMFS installed)
4. `/cvmfs/alice.cern.ch/data/analysis/YYYY/vAN-YYYYMMDD/<file>` (for Grid jobs, or with CVMFS installed)

