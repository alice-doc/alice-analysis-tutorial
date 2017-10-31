# Step 2 - Running the task

It is now time to run this simple analysis. To run the task, make sure that the aliroot environment is (still) loaded, and type
```
$ aliroot runAnalysis.C
```
in the folder where you have stored the analysis code. This launches aliroot, and executes the macro ’runAnalysis.C’. The macro will

*   compile your analysis code

*   Add your analysis task to the analysis manager

*   run the analysis


As the code starts running, the analysis manager prints some information to your screen, e.g.
```
______________________________________________________________________________
   task: name  ACTIVE=0 POST_LOOP=0
      INPUT #0: TChain <-  [cAUTO_INPUT]
      OUTPUT #0: TTree ->  [NO CONTAINER]
      OUTPUT #1: TList ->  [MyOutputContainer]
      Container: MyOutputContainer     DATA TYPE: TList
       = Filename: AnalysisResults.root  folder: MyTask
I-AliAnalysisManager::SetUseProgressBar: Progress bar enabled, updated every 25 events.
  ### NOTE: Debug level reset to 0 ###
(class TClass*)0x37637e0
===== RUNNING LOCAL ANALYSIS AnalysisTaskExample ON TREE aodTree
(class TClass*)0x37637e0
Initialization time: 2.69299 [sec]
E-AliAnalysisManager::GetRunFromAlienPath: Invalid AliEn path string
I-AliAODInputHandler::Notify: Moving to file AliAOD.root
Proocessing event     [=====|    ]  525 [ 50.92 %]   TIME 00:00:08  ETA 00:00:08
```

This information is useful: you can see what kind of input and output your job is digesting. 

## Caveats

Make sure though, that the macro ’knows’ where you stored the AliAOD.root file on your laptop (if the AliAOD.root file is in a different folder than the analysis source code, open the runAnalysis.C file, and change the lines where the input file is accessed).

By default, the macro will run the task just on your laptop. Later on, we’ll see how you can run your analysis on GRID.

`BEWARE` are you using ROOT6 , or running MacOS High Sierra? We try to make the tutorial as compatible as possible with the latest standards, but there might be some surprises - ping us if something doesn’t work.
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
