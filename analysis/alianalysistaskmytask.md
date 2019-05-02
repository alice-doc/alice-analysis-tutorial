# Your analysis task

In the previous section we discussed some of the basics of writing an analysis task from a 'theoretical viewpoint'. In this section, we will go through a working analysis class line-by-line. 

As you now know, your own analysis task will be derived from the base class `AliAnalysisTaskSE`. We will use a *fixed format* to write our tasks, which means that we need to create three files:

-   The **header** file (.h) which contains function *prototypes* and in which your class members are defined

-   The **implementation** file (.cxx), in which the methods of your analysis are implemented

-   An **AddTask.C** macro which creates an **instance** of your class
    and **configures** it.

## The class header (.h)
Let’s start by looking at our header (the .h file), where we define the prototypes of all the methods that we want to implement in our class

```cpp
#ifndef AliAnalysisTaskMyTask_H
#define AliAnalysisTaskMyTask_H

class AliAnalysisTaskMyTask : public AliAnalysisTaskSE  
{
public:
   // two class constructors
   AliAnalysisTaskMyTask();
   AliAnalysisTaskMyTask(const char *name);
   // class destructor
   virtual                 ~AliAnalysisTaskMyTask();
   // called once at beginning of runtime
   virtual void            UserCreateOutputObjects();
   // called for each event
   virtual void            UserExec(Option_t\* option);
   // called at end of analysis
   virtual void            Terminate(Option_t\* option);
  /// \cond CLASSDEF
  ClassDef(AliAnalysisTaskMyTask, 1);
  /// \endcond};

#endif
```
Let's go through the snippet of code line-by-line. First of all, we see
```cpp
#ifndef AliAnalysisTaskMyTask_H
#define AliAnalysisTaskMyTask_H
.
.
.
#endif
```
These three lines form an **include guard** (sometimes called macro guard, or header guard). This construct is used to avoid the problem of **double inclusion**: should the header of your class be included more than once, the include guard will protect your code from double definitions which result in invalid code. 

{% challenge " Include guards" %}
What is the risk of *not* using include guards?
{% solution " drum roll " %}

Say that you have a header file, called `grandparent.h`, in which you define a struct
```cpp
struct foo {
    int member;
};
```
and you create a second file `parent.h` where you write
```cpp
#include "grandparent.h"
```
and even a third one, `child.h` in which you do
```cpp
#include "grandparent.h"
#include "parent.h"
```
After preprocessing, the content of the file `child.h` will be
```cpp
struct foo {
    int member;
};
struct foo {
    int member;
};
```
since `child.h` has indirectly included two copies of the text in the header file `grandparent.h`. This will cause a compilation error, since the struct `foo` will be defined twice. Using include guards, this problem would not have arisen. 
{% endchallenge %}


## Class definition and constructors
If we continue looking at the code, we see the class definition and two class constructors
```cpp
class AliAnalysisTaskMyTask : public AliAnalysisTaskSE  
{
public:
   // two class constructors
   AliAnalysisTaskMyTask();
   AliAnalysisTaskMyTask(const char *name);
   // class destructor
   virtual                 ~AliAnalysisTaskMyTask();
```
The first line means that we define a class `AliAnalysisTaskMyTask`, which is derived from `AliAnalysisTaskSE`. 

### Class constructors and destructor

The two functions `AliAnalysisTaskMyTask()` and `AliAnalysisTaskMyTask(const char *name)` are **class constructors**. A class constructor is a special function in a class that is called when a new object of the class is created. 

We always need to define *two* class constructors for our analysis task, why this is, will be explained later. The third function is the class *destructor*. A destructor is also a special function which is called when the created object is deleted. We will later see, that a class that has pointer data members should include, in addition to a destructor, a copy constructor and an assignment operator - but for now we can just forget about those. 

## AliAnalysisTaskSE inherited functions

After the constructors and destructors, we define the prototypes of the functions that we have already seen in the `AliAnalysisTaskSE` section
```cpp
   // called once at beginning of runtime
   virtual void            UserCreateOutputObjects();
   // called for each event
   virtual void            UserExec(Option_t* option);
   // called at end of analysis
   virtual void            Terminate(Option_t* option);
```
These functions will be the heart of our analysis. In the `UserCreateOutputObjects`, we will define whatever output we want to write to our `root` files. The `UserExec` function will be called for all events in the data sample that we are looking at. Finally, `Terminate` is called at the very end of the analysis. 

{% challenge " Virtual functions " %}
In the code snippet above, we see the `virtual` keyword. Do you know what this means ? 

{% solution " Click to show answer " %}
Consider the following simple program which is an example of runtime polymorphism.
The main thing to note about the program is, derived class function is called using a base class pointer. The idea is, virtual functions are called according to the type of object pointed or referred, not according to the type of pointer or reference. In other words, virtual functions are resolved late, at runtime (which makes them powerful, but costly):
```cpp
class Employee 
{ 
public: 
    virtual void raiseSalary() 
    {  /* common raise salary code */  } 
  
    virtual void promote() 
    { /* common promote code */ } 
}; 
  
class Manager: public Employee { 
    virtual void raiseSalary() 
    {  /* Manager specific raise salary code, may contain 
          increment of manager specific incentives*/  } 
  
    virtual void promote() 
    { /* Manager specific promote */ } 
}; 
  
// Similarly, there may be other types of employees 
  
// We need a very simple function to increment salary of all employees 
// Note that emp[] is an array of pointers and actual pointed objects can 
// be any type of employees. This function should ideally be in a class  
// like Organization, we have made it global to keep things simple 
void globalRaiseSalary(Employee *emp[], int n) 
{ 
    for (int i = 0; i < n; i++) 
        emp[i]->raiseSalary(); // Polymorphic Call: Calls raiseSalary()  
                               // according to the actual object, not  
                               // according to the type of pointer                                  
} 
```
Outputs  **???**
```cpp
In Derived
```
So, virtual functions allow us to create a list of base class pointers and call methods of any of the derived classes without even knowing the type of the derived class object. 

{% endchallenge %}


## Histograms, lists, and more
Now that we have defined the methods of our analysis class, it is time to add some members. What we are going to add, are three pointer data members

* `fAOD` which is a pointer to an event
* `fOutputList` which is a (pointer to a) list that holds all our output objects
* `fHistPt` which is a (pointer to a) histogram that will hold our pt spectrum

Since these members are part of our class definition, we have to add them to our header file
```cpp
    class AliAnalysisTaskMyTask : public AliAnalysisTaskSE
    .
    .
    .
     private:
       AliAODEvent*  fAOD;           //!<! input event
       TList*        fOutputList;    //!<! output list
       TH1F*         fHistPt;        //!<! dummy histogram
```

In the code snippet above, you might see something interesting: when we write comments that describe what our class members are doing, we append the expression `!<!` to the double slashes `//` that start our comment giving us `//!<!`. Contrary to what you might think, this expression mark is seen by ROOT (even though it's written as a comment) and it is essential for the correct documentation generation. We will get later to the logic of this locution, but for now a rule of thumb suffices: pointers to objects that are initialized at **run-time** (in the `User*` methods) should be marked with a `//!<!`.

## The ClassDef definition
At the very end of our header file, we add the following line
```cpp
/// \cond CLASSDEF
ClassDef(AliAnalysisTaskMyTask, 1);
/// \endcond
};
```
There is a lot going on behind this one single line: `ClassDef` is a C preprocessor macro that must be used if your class derives from `TObject`. `ClassDef` contains member declarations, i.e. it inserts a few new members into your class; the `ClassDef` macro family is defined in the file `Rtypes.h`, should you be interested.
The two comments surrounding the `ClassDef` statement are required to properly produce the documentation.

How all this works exactly is not very relevant at this point. We will later see that you will need to increase the version number whenever you change the definition of your class, or ROOT will not be able to handle objects written before and after this change in one process. The version number 0 (zero) disables I/O for the class completely, so we start counting at 1. 

# The implementation of your analysis task (.cxx)

We are for now done with our class header, it's time to move to the implementation of the class: the `AliAnalysisTaskMyTask.cxx` file, in which we will actually *implement* our methods. Let's start by defining our class constructors. As stated before, ROOT requires **two** class constructors (we’ll get later to why this is necessary), one of which is the I/O constructor, which is not allowed to allocate any memory. So we start our implementation with
```cpp
        AliAnalysisTaskMyTask::AliAnalysisTaskMyTask() : AliAnalysisTaskSE(), 
            fAOD{0}, fOutputList{0}, fHistPt{0}
        {
            // ROOT IO constructor, don't allocate memory here!
        }
        AliAnalysisTaskMyTask::AliAnalysisTaskMyTask(const char* name) : AliAnalysisTaskSE(name),
            fAOD{0}, fOutputList{0}, fHistPt{0}
        {
            DefineInput(0, TChain::Class()); 
            DefineOutput(1, TList::Class()); 
        }
```
As you see, in the constructor, we **initialize** members to their **default** values. **Always** initialize members to default values (and pointers to `nullptr`). If you fail to do so, values contained by the members will be random, which can lead to unexpected behavior of your code. 

{% challenge " Undefined behavior " %}
You have written a small function
```cpp
int f(int x)
{
    int a;
    if(x>0) a = 42;
    return a; 
}
```
What happens when you call
```cpp
f(10)
```
and what happens when you call
```cpp
f(-10)
```
?
{% solution " drum roll" %}
f(10) will return 42. The output of f(-10) is *undefined*, since variable a was not initialized. 
{% endchallenge %}

In the second constructor of this task, we define what the *input* and *output* does the analysis class handle. In our case, the input is of type `TChain`, and as we will see later, the output is a `TList`. 


## UserCreateOutputObjects()
In our `UserCreateOutputObjects` function, we will define the output objects of our task. These are commonly histograms, profiles, etc. In our specific example, we will add one histogram, and define a list to which we will attach the histogram. 
{% callout "Output lists" %}
Adding all your output histograms to a list makes your life easier: the list will allow you to manipulate many output objects simultaneously. By calling `TList::SetOwner(true)`, we transfer ownership of all memory allocated by the list items to the `TList` itself, this means that in our destructor, we can simply call `delete list` to delete all our list items, rather than calling `delete` for all items individually. 
{% endcallout %}

The implementation of the `UserCreateOutputObjects` method looks like this 

```cpp
    ...
    #include "TList.h"
    #include "TH1F.h"
    ...
    AliAnalysisTaskMyTask::UserCreateOutputObjects()
    {
        // create a new TList that OWNS its objects
        fOutputList = new TList();
        fOutputList->SetOwner(true);
        
        // create our histo and add it to the list
        fHistPt = new TH1F("fHistPt", "fHistPt", 100, 0, 100);
        fOutputList->Add(fHistPt);
        
        // add the list to our output file
        PostData(1,fOutputList); 
    }
```
Note that we create a `TList` and make it the owner of the memory of all its elements. After we create the histogram, we add it to the output list. Finally, in the last line, we call `PostData`, which will notify the client tasks of the data container that that the data pointer has changed compared to the previous post. 

## UserExec

The `UserExec` is the heart of our analysis: it is called for each event in our input data set. First, we need to access our event, which we can do via a call to the method `InputEvent` 
```cpp
    ...
    #include "AliAODEvent.h"
    ...
    AliAnalysisTaskMyTask::UserExec(Option_t*)
    {
      // get an event from the analysis manager
      fAOD = dynamic_cast<AliAODEvent*>(InputEvent());

      // check if there actually is an event
      if(!fAOD)
        ::Fatal("AliAnalysisTaskMyTask::UserExec", "No AOD event found, check the event handler.");
```

Once we have access to our input event, we can e.g. loop over all the tracks that it contains, and store the pt of the tracks in our histogram:

```cpp
        ...
        // let's loop over the tracks and fill our histogram
    
        // first we get the number of tracks
        int iTracks{fAOD->GetNumberOfTracks()};
    
        // and then loop over them
        for(int i{0}; i < iTracks; i++) {
            AliAODTrack* track = static_cast<AliAODTrack*>(fAOD->GetTrack(i));
            if(!track) continue;
            
            // here we do some track selection
            if(!track->TestFilterbit(128) continue;
    
            // fill our histogram
            fHistPt->Fill(track->Pt());
        }
        // and save the data gathered in this iteration
        PostData(1, fOutputList);
    }
```

Take a look at the code and make sure that you understand the logic of all the lines. In principle, this is all you need in an analysis task to run a small analysis. 

## Almost there: the AddTask macro

The last thing that we need to fully define our analysis task, is a small file, that we will call the `AddTask` macro, that *instantiates* our task (class), defines its in- and output, and connects it to the *analysis manager*. We will put this piece of code in an independent, third file, called `AddMyTask.C`. It is important, that this macro defines a function, in our case called `AddMyTask`, that returns a pointer to our analysis task. We need to follow this exact convention if we later on want to run our analysis in the automated LEGO train system. 

Our `AddTask` macro looks as follows:


```cpp
AliAnalysisTaskMyTask* AddMyTask(TString name = "name") {
  AliAnalysisManager *mgr = AliAnalysisManager::GetAnalysisManager();

  // resolve the name of the output file
  TString fileName = AliAnalysisManager::GetCommonFileName();
  fileName += ":MyTask";      // create a subfolder in the file

  // now we create an instance of your task
  AliAnalysisTaskMyTask* task = new AliAnalysisTaskMyTask(name.Data());   

  // add your task to the manager
  mgr->AddTask(task);

  // connect the manager to your task
  mgr->ConnectInput(task,0,mgr->GetCommonInputContainer());
  // same for the output
  mgr->ConnectOutput(task,1,mgr->CreateContainer("MyOutputContainer", TList::Class(), AliAnalysisManager::kOutputContainer, fileName.Data()));

  // important: return a pointer to your task
  return task;
}
```

And that's it - we now have our three files that contain a minimal analysis!
