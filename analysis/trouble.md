troubleshooting\
when GRID does not do\
what you want it to do

### First off all: be informed!

The GRID and its software are **complex**

-   and communicating problems with it is even complexer !

Subscribe yourself to the **analysis** mailings lists on
**e-groups.cern.ch**

-   alice-analysis-operations

-   alice-project-analysis-task-force

-   your PAG’s mailing list

We also have more professinal bug/feature tracking: **JIRA**

-   https://alice.its.cern.ch/jira/projects/ALPHY

-   **assigning** issues, **following** issues, making requests, etc

[Troubleshooting 101]{}

                `Dear experts,
            All my jobs are going into error. 
                Could you check? Thanks!'
            

The experts **can** (and probably will) check, but you yourself should
be the **first** to take a look

-   Go to ‘**my jobs**’ on MonaLISA

-   Take a look at the job **trace** and, if available, the **stderr**
    and **stdout**

If you cannot solve the issue: be complete in your message and **don’t
kill** your jobs!

Heads-up: excellent **actual debugging** documentation is available at

-   https://dberzano.github.io/alice/debug/

### Validation Error example

![image](a3.png){width="\textwidth"}

### Validation Error example

![image](b3.png){width="\textwidth"}

### Validation Error example

![image](c3.png){width="\textwidth"}

### Validation Error example

![image](d3.png){width="\textwidth"}

[and the patient suffers from ...]{} Segmentation violation means
**illegal memory** access

-   Either GRID is really broken (not so likely)

-   or I’m doing something wrong ... better check my pointers

    ``` {.numberLines .c language="C" numbers="left"}
    AliAnalysisTaskMyTask::UserCreateOutputObjects()
    {
        // create a new TList that OWNS its objects
        fOutputList = new TList();
        fOutputList->SetOwner(kTRUE);
        // add the list to our output file
        PostData(1,fOutputList);
    }
       ...
       fHistPt->Fill(track->Pt()); // segfault!
    ```

Turns out **fHistPt** is not initialized in my UserCreateOutputObjects()

-   Oops .. some more rigorous was apparantly required ...

### Execution Error example

![image](e3.png){width="\textwidth"}

### Execution Error example

![image](f3.png){width="\textwidth"}

### Execution Error example

![image](g3.png){width="\textwidth"}\
... better search for **memory leaks** ... (see backup)

[What is the perfect workflow?]{} There is **no** perfect workflow - my
personal preference

-   Download some AliAOD.root files to your computer

-   Develop your task

-   Test locally (fast, no internet connection needed)

When this goes well

-   Check in ‘test’ grid mode. There are a few subtle differences
    between running LOCALLY and on GRID (which I’ll get to later)

If the code is robust:

-   Don’t spend long nights (re)submitting jobs to GRID ...

-   ... rather get your code checked into AliPhysics

-   **And use the LEGO trains**
