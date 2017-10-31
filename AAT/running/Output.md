# Take a look at the output

If all goes well, your simple task runs over the input data, and fills one histogram with the distribution of transverse momentum of all charged particle tracks in all events. 

Once the task is done running, take a look at the outputfile 

```
AnalysisResults.root
```
 that has generated. The easiest way to do so is to open a TBrowser (ROOT’s ’graphical user interface’) while you are in (ali)root 

```
new TBrowser
```

and take a look at the distribution in the histogram. No idea how to use a TBrowser, or what a TBrowser even is? Don’t hesitate to ask, and take a look at the [ROOT user’s guide](https://root.cern.ch/root/htmldoc/guides/users-guide/ROOTUsersGuide.html).
