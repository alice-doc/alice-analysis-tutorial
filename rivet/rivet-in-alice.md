# Using Rivet in ALICE

Rivet has been integrated into the ALICE build system and is maintained there. Thus, it is also deployed to cvmfs, from where it can be used by Grid workernodes, interactive lxplus sessions, or other machines using software from cvmfs (e.g. CERN Linux desktops). It can also be installed locally using aliBuild. However, if you just get started and want to gain experience with Rivet, we recommend to use the cvmfs installation on lxplus, as this is maintained centrally and known to work (if it is not, please report!).

## Using Rivet on lxplus

In order to use Rivet on lxplus, you just have to logon and use alienv to enter a shell with the proper environment loaded (same procedure as for AliPhysics):
```
ssh lxplus.cern.ch
alienv enter Rivet
```
You can then check which packages and versions are loaded using:
```
alienv list
```
Now you have all the rivet tools (rivet, rivet-buildplugin, ...) available. To list the available analyses (those distributed with the used version of Rivet), you can use:
```
rivet --list-analyses
rivet --list-analyses ALICE_
```
where the second command only lists analyses for ALICE publications. You can display the details of one of these analyses (here ALICE_2010_S8625980) using:
```
rivet --show-analysis ALICE_2010_S8625980
```
Assuming you have some output from a Monte Carlo generator in a HepMC file (e.g. /afs/cern.ch/work/a/alipwgmm/public/hepmc/pythia6_pp7000.hepmc or see here for instructions on running MC generators), you can run an analysis (e.g. ALICE_2010_S8625980) on this input using:
```
rivet -a ALICE_2010_S8625980 /afs/cern.ch/work/a/alipwgmm/public/hepmc/pythia6_pp7000.hepmc
```
where -a is used to specify the analysis you want to run (you can use any analysis that was distributed with Rivet). You can also list more than one analysis. The command line above runs the analysis on the given input (~1000 generated events, here) and stores the produced output, typically histograms, in the file Rivet.yoda. Based on this yoda file, you can produce plots by running:
```
rivet-mkhtml Rivet.yoda
```
This command puts the plots in the subdirectory plots/. The directory also contains an index.html, which you can open in a browser to look and navigate through the plots. If you have run Rivet on an lxplus node you probably must copy this directory to your local PC and then point your browser to the directory, i.e.
```
scp -r lxplus.cern.ch:<myRivetDir>/plots /tmp/myRivetPlots
open /tmp/myRivetPlots/index.html (on Mac OS X, otherwise point browser to file:///tmp/myRivetPlots/index.html)
```
(N.B.: If on lxplus you use a directory under /tmp you have to copy from the exact host you are working on instead of lxplus.cern.ch, e.g. lxplus012.cern.ch.)

# Running Rivet together with a generator

You can use Rivet to run on the output of an arbitrary generator for which an interface to HepMC exists - e.g. those which have been integrated into the ALICE build system and are, thus, available on cvmfs or for local installation. There are two common options to run the generator and Rivet:
* intermediate file:
  * run generator writing to hepmc file
  * run Rivet reading from hepmc file (see example above)
* FIFO (first-in-first-out pipe, on Linux)
  * create FIFO (NB: not possible on afs, need to use /tmp on lxplus)
  * run generator writing to FIFO (process won't finish)
  * run Rivet reading from FIFO
The latter option avoids writing a file to disk and is beneficial if the generator is fast. You can run a generator directly or use `aligenmc` after you have set it up with:
```
source ~alipwgmm/public/aligenmc/setup.sh # for bash
source ~alipwgmm/public/aligenmc/setup.csh # for (t)csh
```
Then, you would have to do something like:
```
mkfifo /tmp/fifo_$UID.hepmc
aligenmc -o /tmp/fifo_$UID.hepmc &
rivet -a ALICE_2010_S8625980 /tmp/fifo_$UID.hepmc
rm /tmp/fifo_$UID.hepmc
```
NOTE :
* aligenmc is the script developed within ALICE that does the running of a chosen generator, with a dedicated configuration file, and writing the output to the specified file/FIFO.
* beware the absence (!) of extension of your analysis name specified at the rivet command, i.e. no "rivet -a ALICE_2010_S8625980.cc ...". This would make your analysis not recognisable by Rivet, and it will complain so.

For further instructions on how to run different generators, see further :
```
* aligenmc -h  
```
* [MC generator documentation](https://twiki.cern.ch/twiki/bin/view/ALICE/PWGMMgeneratorsALICE)

