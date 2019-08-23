# Advanced topics
## Installing Rivet locally
Rivet can be installed using aliBuild (analogous to AliPhysics). Assuming you have followed the instructions to install AliPhysics in ali-master, you can run:
```
cd ali-master
aliBuild -z -w ../sw -d build Rivet
```
This will build and install Rivet as well as its dependencies (but not the generators). Subsequently, you can setup the environment to use Rivet by:
```
alienv enter Rivet/latest-ali-master
```
Then, you can use Rivet in the same way as explained above for the installation from cvmfs.
