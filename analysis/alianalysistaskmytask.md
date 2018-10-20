# Your analysis task: the header

As written before, 

We’ll use a **fixed format** for writing our class

-   The **header** file (.h) which contains function prototypes

-   The **implementation** file (.cxx), in which the code is implemented

-   An **AddTask.C** macro which creates an **instance** of your class
    and **configures** it

Let’s start by looking at our header, as here all functions are defined


```cpp
#ifndef AliAnalysisTaskMyTask_H
#define AliAnalysisTaskMyTask_H|\pause|
class AliAnalysisTaskMyTask : public AliAnalysisTaskSE  
{|\pause|
public:
   // two class constructors
   AliAnalysisTaskMyTask();
   AliAnalysisTaskMyTask(const char *name);|\pause|
   // class destructor
   virtual                 ~AliAnalysisTaskMyTask();|\pause|
   // called once at beginning of runtime
   virtual void            UserCreateOutputObjects();|\pause|
   // called for each event
   virtual void            UserExec(Option_t* option);|\pause|
   // called at end of analysis
   virtual void            Terminate(Option_t* option);|\pause|
ClassDef(AliAnalysisTaskMyTask, 1);
};

#endif
```

[Adding our histogram]{} Let’s start filling in the blanks, and add a
**histogram**, an **output list** and some more

-   Class members must be **defined** in the header
```cpp
    ...
    class AliAnalysisTaskMyTask : public AliAnalysisTaskSE
    ...
     private:
       AliAODEvent*  fAOD;           //! input event
       TList*        fOutputList;    //! output list
       TH1F*         fHistPt;        //! dummy histogram
    ...
```

-   Pointers to objects that are initialized at **run-time** (the
    **User...** methods) should have at the end - I’ll explain later

-   We use an output **list** to have one **common** output object,
    rather than many

[Implementation: AliAnalysisTaskMyTask.cxx]{}

-   ROOT requires **two** class constructors ... (we’ll get later to why
    this is necessary)

        AliAnalysisTaskMyTask::AliAnalysisTaskMyTask() : AliAnalysisTaskSE(), 
            fAOD(0), fOutputList(0), fHistPt(0)
        {
            // ROOT IO constructor, don't allocate memory here!
        }
        AliAnalysisTaskMyTask::AliAnalysisTaskMyTask(const char* name) : AliAnalysisTaskSE(name),
            fAOD(0), fOutputList(0), fHistPt(0)
        {
            DefineInput(0, TChain::Class()); 
            DefineOutput(1, TList::Class()); 
        }

-   In the constructor, we **initialize** members to their **default**
    values ...

-   ... and tell the task what the in- and output is

[Implementation: AliAnalysisTaskMyTask.cxx]{} Objects that are
**output** are initialized in the function

-   UserCreateOutputObjects()

```cpp
    ...
    #include "TList.h"
    #include "TH1F.h"
    ...
    AliAnalysisTaskMyTask::UserCreateOutputObjects()
    {
        // create a new TList that OWNS its objects
        fOutputList = new TList();
        fOutputList->SetOwner(kTRUE);
        |\pause|
        // create our histo and add it to the list
        fHistPt = new TH1F("fHistPt", "fHistPt", 100, 0, 100);
        fOutputList->Add(fHistPt);
        |\pause|
        // add the list to our output file
        PostData(1,fOutputList); 
    }
```

[The event loop]{} The function **UserExec()** is called for each event

-   This is the ‘heart’ of our analysis

```cpp
    ...
    #include "AliAODEvent.h"
    ...
    AliAnalysisTaskMyTask::UserExec(Option_t*)
    {
      // get an event from the analysis manager
      fAOD = dynamic_cast<AliAODEvent *>InputEvent();

      // check if there actually is an event
      if(!fAOD) return;
```

[The event loop]{} The function **UserExec()** is called for each event

-   This is the ‘heart’ of our analysis

```cpp
           ...
        if(!fAOD) return;
        // let's loop over the trakcs and fill our histogram
    |\pause|
        // first we get the number of tracks
        Int_t iTracks(fAOD->GetNumberOfTracks());
    |\pause|
        // and then loop over them
        for(Int_t i(0); i < iTracks; i++) {
            AliAODTrack* track = static_cast<AliAODTrack*>(fAOD->GetTrack(i));
            if(!track) continue;
            |\pause|
            // here we do some track selection
            if(!track->TestFilterbit(128) continue;
    |\pause|
            // fill our histogram
            fHistPt->Fill(track->Pt());
        }
        // and save the data gathered in this iteration
        PostData(1, fOutputList);
    }
```

In principe, this is all we need in the .cxx and .h

[Almost there: the AddTask macro]{} The **AddMyTask.C** macro
**instantiates** our task (class), define it’s in- and output and
connect it to the **analysis manager**

```cpp
AliAnalysisTaskMyTask* AddMyTask(TString name = "name") {
  AliAnalysisManager *mgr = AliAnalysisManager::GetAnalysisManager();
|\pause|
  TString fileName = AliAnalysisManager::GetCommonFileName();
  fileName += ":MyTask";      // create a subfolder in the file|\pause|
  // now we create an instance of your task
  AliAnalysisTaskMyTask* task = new AliAnalysisTaskMyTask(name.Data());   
  // add your task to the manager
  mgr->AddTask(task);|\pause|
  // connect the manager to your task
  mgr->ConnectInput(task,0,mgr->GetCommonInputContainer());
  // same for the output
  mgr->ConnectOutput(task,1,mgr->CreateContainer("MyOutputContainer", TList::Class(), AliAnalysisManager::kOutputContainer, fileName.Data()));|\pause|
  // important: return a pointer to your task
  return task;
}
```

that’s it\
