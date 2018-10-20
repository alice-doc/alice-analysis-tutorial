[Scaling up]{} By now, your class is running well on GRID .... but do
you really want to

-   .... stay up all night to resubmit jobs?

-   .... lose your code when your laptop dies ?


So what we’ll do

-   Make your code available in AliPhysics

-   Use automatic GRID job submission via our LEGO train system

[Adding a class to AliPhysics]{} Two files to change

-   CMakeLists.txt

-   \*LinkDef.h

If you do this for the first time, ask your PWG or PAG coordinators for
help!

Once you’ve made the relevant changes to AliPysics, open a PR as Dario
explained about yesterday

[LEGO trains in a nutshell]{} Launching your job on GRID is (each
analysis task requires one instance of AliROOT running)

-   More efficient: add **many jobs** (wagons) of different users that
    require the same data to a single analysis manager (engine)

-   Run these in an **automated way** (train)

This is done in the **LEGO trains**
(https://alimonitor.cern.ch/trains/)\

![image](d2.png){width="\textwidth"}

![image](train1.png){width="\textwidth"}\

![image](train2.png){width="\textwidth"}\

![image](train3.png){width="\textwidth"}\
