# Advanced topics
## Installing Rivet locally
Rivet can be installed using aliBuild (analogous to AliPhysics). Assuming you have followed the instructions to install AliPhysics in a repository ~/alice, you can run:
```
cd ~/alice
aliBuild build Rivet
```
This will build and install Rivet as well as its dependencies (2019/10/18):
1. Python-modules
2. boost
3. GMP
4. CMake
5. GSL
6. YODA, histogramming
7. MPFR
8. HepMC, output format for generators, input for Rivet analysis
9. cgal
10. fastjet
11. Rivet
     
Subsequently, you can setup the environment to use Rivet by:
```
alienv enter Rivet/latest-ali-master
```
Then, you can use Rivet in the same way as explained above for the installation from cvmfs.     


## Installing MC generators locally

Note however that the above instructions just provide you with Rivet and Yoda basically but do not include the various generators themselves...

Under CVMFS, you will typically find generators that are centrally installed :
1. AMPT, 
1. CRMC (= EPOS-LHC), 
1. DPMJET, 
1. EPOS-3, 
1. FONLL, 
1. Herwig-7, 
1. JEWEL,
1. POWHEG, 
1. (Rivet),
1. SHERPA, 
1. Therminator2, 
1. (aligenmc),
1. PYTHIA-6, 
1. PYTHIA-8

and several utilities coming along (Sacrifice for Pythia, ThePEG for Herwig, Agile for fortran MC, LHAPDF sets, ...).

The version of the generators as well as their dependencies naturally evolve with time and should normally be managed accordingly in ALICE.

Such MC generators available in ALICE are encompassed into the bundle __AliGenerator__.
One can find its constituents under [http://alimonitor.cern.ch/packages/#VO_ALICE@AliGenerators::v20190924-1 "packages"](https://alimonitor.cern.ch/packages), take for instance AliGenerators::v20190924-1.


Such a bundle can also be built locally with aliBuild and is managed via the recipe`alidist/aligenerators.sh` and `alidist/defaults-pwgmmtest.sh`. Such a meta-recipe relies on the recipes of the individual generators `alidist/[generator.sh]`.
```
cd ~/alice
aliBuild build AliGenerators

```




