# Destructors

We are at the end of the manual for writing a task, but we forgot to implement one important aspect of our analysis task: the destructor, copy constructor and assignment operator. Out class dynamically allocates memory (use of the **new**), for example when we create our histograms
```cpp

        // create our histo and add it to the list
        fHistPt = new TH1F("fHistPt", "fHistPt", 100, 0, 100);
```        

This has two implications:

-   After usage, **we** are responsible for freeing the allocated memory
    (else it’s **lost**!)

-   A bit more advanced: you might have to think about the copy constructor
    and assignment operator 
                   

## Implementing the destructor

Memory allocated with **new** cannot be used again, unless it is realased by **delete**. Never deleting memory is called a **memory leak**. Leaks are **bad**: they waste resources and can crash your system, and for that reason, we should implement a destructor

Suppose we have a **constructor** that looks like this

```cpp
    MyClass::MyClass()
    {
      n = new int;
      p = new float;
      x = new float[5];
    }
```

The **destructor** should be

```cpp
    MyClass::~MyClass()
    {
      delete n;
      delete p;
      delete[] x;
    }
```

Our life is not so easy however: 

-   We did not allocate memory in the class constructor but in
    `UserCreateOutputObjects`

-   We **might** want to free that memory, but what if
    `UserCreateOutputObjects` was **not** called? —if it hasn’t, freeing
    the memory will cause serious problems (the infamous ‘glibc double
    free or corruption’)

-   To avoid this, initialize our pointers to NULL in the member
    initialization list
```cpp
         ...
        AliAnalysisTaskMyTask::AliAnalysisTaskMyTask() : AliAnalysisTaskSE(), 
            fAOD(0), fOutputList(0), fHistPt(0)
        {
            // ROOT IO constructor, don't allocate memory here!
        }
         ...
```
-   With our pointers initialized to NULL, we can go ahead and write our
    destructor

```cpp
    AliAnalysisMyTask::~AliAnalysisMyTask()
    {
      if(fOutputList) delete fOutputList;
    }
```

-   A little trick we applied is

        fOutputList->SetOwner(kTRUE);

    which tells the destructor of TList\* to delete all objects added to
    it

-   Note that fAOD is not deleted - this pointer points to memory that
    was **not** allocated by our task

{% callout "new - delete" %}
Rule of thumb: all calls to **new** should be accompanied by a call to
**delete** somewhere in your code
{% endcallout %}

## Destructors and PROOF
If you run on `PROOF`, your analysis class is not the owner of its output list. A little trick to avoid segmentation violations when running on PROOF is to write
```cpp
    AliAnalysisMyTask::~AliAnalysisMyTask()
    {
      if(AliAnalysisManager::GetAnalysisManager()->GetAnalysisType()
        != AliAnalysisManager::kProofAnalysis) delete fOutputList;
    }
```
This only deletes the output list if you’re not running PROOF. 

## Copy constructor and assignment operator

Sometimes in AliRoot code you see copy constructors and assignment operators (these two always go together). In principle, we don’t need them because our analysis class is never copied (apart from the streamer actions, which do not rely on these constructors). However, you might occasionally see compiler warnings such as

         warning: 'class AliAnalysisTaskMyTask' has pointer 
         data members but does not override 'AliAnalysisTaskMyTask(const
         AliAnalysisTaskMyTask&)' or 'operator=(const AliAnalysisTaskMyTask&)' 
         [-Weffc++]"

Generally, these can be squashed by defining prototypes 
```cpp
    private:
      // not implemented
      AliAnalysisTaskMyTask(const AliAnalysisTaskMyTask&); 
      AliAnalysisTaskMyTask& operator=(const AliAnalysisTaskMyTask&);
```
Defining these functions as `private` implicates that we do not have provide an implementation. 

So what does this mean, what are copy constructors and assignment operators, why do I need them, and how can I get them? If you are interested in this, keep reading. 

In a nutshell:

```cpp
        MyObject A;      // initialization by default constructor
        MyObject B(A);   // initialization by copy constructor
        MyObject C = A;  // Also initialization by copy constructor
        B = C;           // assignment by copy assignment operator
```
The copy constructor and assignment operator are **automatically generated**, but if your class has **pointer members**, they need to be customized (this is **not** a ROOT feature, just c++!). 

If we wanted to implement our own copy constructor for our class, here is what it would look like
```cpp
    AliAnalysisMyTask::AliAnalysisMyTask
      (const AliAnalysisMyTask& other) : AliAnalysisTaskSE(other),
      fOutputList(NULL), fHistPt(NULL)
    {
      if(other.fOutputList) fOutputList = (TList*)other.fOutputList->Clone();
      if(other.fHistPt) fHistPt = new TH1F(*other.fHistPt);
    }
```

-   Operating on NULL pointers is not allowed and the code will crash if
    you attempt to do that

-   Operating on uninitialized pointers is *undefined* and much more
    dangerous

-   The TH1F and most ROOT histogram classes have public copy
    constructors, so we can use them

-   The TList copy constructor is private, so we need to make a Clone of
    it instead


The assignment operator is very similar to the copy constructor, but it has the additional requirements for checking for self-assignment and returning a value. In our case, it could look like

```cpp
    AliAnalysisMyTask& AliAnalysisMyTask::operator=
      (const AliAnalysisMyTask& other)
    {
      if(&other == this) return *this;
      outputlist = NULL;
      fHistPt = NULL;
      AliAnalysisTaskSE::operator=(other);
      if(other.fOutputList) fOutputList = (TList*)other.fOutputList->Clone();
      if(other.fHistPt) fHistPt = new TProfile(*other.fHistPt);
      return *this;
    }
```
