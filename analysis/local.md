now let’s **run** our class

[Running your task]{} Basically, there’s 3 options for running

-   Run on **local** data

-   Run on **GRID** (either in test or full mode) yourself

-   Run on GRID using the **LEGO** train system

There’s also **proof**, not covered in these slides, but your supervisor
might suggest it

Let’s take a look at running our task **on our own laptop**

-   So we have to **compile our code**

-   and launch our analysis

[Local testing: runAnalysis.C]{}

    void runAnalysis() {
        // header location
        gROOT->ProcessLine(".include $ROOTSYS/include");
        gROOT->ProcessLine(".include $ALICE_ROOT/include");|\pause|
        // create the analysis manager
        AliAnalysisManager *mgr = new AliAnalysisManager("AnalysisMyTask");
        AliAODInputHandler *aodH = new AliAODInputHandler();
        mgr->SetInputEventHandler(aodH);|\pause|
        // compile the class (locally)
        gROOT->LoadMacro("AliAnalysisTaskMyTask.cxx++g");
        // load the addtask macro
        gROOT->LoadMacro("AddMyTask.C");|\pause|
        // create an instance of your analysis task
        AliAnalysisTaskMyTask *task = AddMyTask();|\pause|
        // if you want to run locally, we need to define some input
        TChain* chain = new TChain("aodTree");
        chain->Add("/scratch/.../AliAOD.root");|\pause|
        // start the analysis locally
        mgr->StartAnalysis("local", chain);
    }

[Example: running it locally]{}

    [rbertens@degobah test]$ aliroot runAnalysis.C 

![image](browser.png){width="\textwidth"}

time to try for yourself\
.\
.\
https://github.com/rbertens/ALICE\_analysis\_tutorial\
.\
..\
try steps 1, 2, and 3
