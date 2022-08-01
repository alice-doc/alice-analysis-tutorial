aliBuild prerequisites for ArchLinux
=================================

ALICE software on ArchLinux is supported on a best effort basis. There is no guarantee that software builds or runs correctly. Support requests might have low priority. We were able to successfully build on:

* 5.18.14-arch1-1, with some minor modifications in the sources

## Install required system packages

With root permissions, _i.e._ `sudo`, update your package sources:

```bash
sudo pacman -Syu
```

With root permissions, _i.e._ `sudo`, install the following packages [TODO remove unneeded packages]:

```bash
sudo pacman -Syu git angular-cli base-devel base binutils bison boost llvm cmake double-conversion doxygen evtest flatbuffers flex gcc-fortran gdm gettext glfw-x11 graphviz grpc gsl gtest gzip libtool m4 meld mlocate openssh parallel pythia8 python-attrs python-bleach python-matplotlib python-pip python-psutil python-wheel python-yaml rapidjson rsync swig xorg-server xorg-xinit xorg-xinput xorg-xrandr xorg-xwininfo xrootd xterm yaml-cpp xsimd
``` 

Additionally, we need packages from aur.

```bash
yay -S autotrace env-modules-tcl
```

## Installing aliBuild
AliBuild, our build tool, is installed as a standard python package. 
This is done with: 

```bash 
cd ~/alice # or wherever you want to install it, I recommend keep it all in one directory
git clone https://github.com/f3sch/alibuild.git # my personal fork until I make a PR upstream cd alibuild
sudo python setup.py install 
```

 Now you should be able to use `aliBuild` as a command.
 ## Installing alidist
To actually build O2 and its dependencies we need the recipes to do so. Normally, `aliBuild init ...` would download those and take care of everything.
However, there are some _minor_ modifications we need to make to those recipes [FUN]. 

```bash 
cd ~/alice
git clone https://github.com/f3sch/alidist.git # my personal fork until I make a PR upstream, but I think the mods are unreconcilable.
git checkout arch
```

Now you have the correct build recipes.

## Building O2
At the end of this section you will be guided to document, which tells you how to build O2. Let me take a few sentences on what to do.

### First
Do not run `aliBuild init ...`! From my understanding this pulls the build recipes itself from upstream, which is not what we want.
This botched some builds for me. 

### Second
Your first build will probably fail to GEANT4 not compiling.
From my understanding there is a naming difference between one math library provided by ArchLinux and all other distributions [WHY?]. If the build fails, look into `~/alice/sw/SOURCES/GEANT4` and make the same changes as in this diff:

```{verbatim} 
diff --git a/source/persistency/ascii/src/G4tgrEvaluator.cc b/source/persistency/ascii/src/G4tgrEvaluator.cc
index 3e0e7de7a..626d4aa62 100644 --- a/source/persistency/ascii/src/G4tgrEvaluator.cc
+++ b/source/persistency/ascii/src/G4tgrEvaluator.cc @@ -70,7 +70,7 @@ G4double ftanh(G4double arg) { return std::tanh(arg); }
 // G4double fasinh( G4double arg ){  return std::asinh(arg); }  // G4double facosh( G4double arg ){  return std::acosh(arg); }
 // G4double fatanh( G4double arg ){  return std::atanh(arg); } -G4double fsqrt(G4double arg) { return std::sqrt(arg); }
+G4double dsqrt(G4double arg) { return std::sqrt(arg); }  G4double fexp(G4double arg) { return std::exp(arg); }
 G4double flog(G4double arg) { return std::log(arg); }  G4double flog10(G4double arg) { return std::log10(arg); }
@@ -92,7 +92,7 @@ void G4tgrEvaluator::AddCommonFunctions()    //  setFunction("asinh", (*fasinh));
   //  setFunction("acosh", (*facosh));    //  setFunction("atanh", (*fatanh));
-  setFunction("sqrt", (*fsqrt)); +  setFunction("sqrt", (*dsqrt));
   setFunction("exp", (*fexp));    setFunction("log", (*flog));
   setFunction("log10", (*flog10));
 ```


You are now ready to [start building ALICE software](README.md#get-or-upgrade-alibuild), but keep the points above in mind.
If all else fails, drop me a mail at felix.schlepper@cern.ch.
