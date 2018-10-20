### For our class

Out class dynamically allocates memory (use of the **new**)

        // create our histo and add it to the list
        fHistPt = new TH1F("fHistPt", "fHistPt", 100, 0, 100);
        

This has 3 implications:

-   After usage, **we** are resonsible for freeing the allocated memory
    (else it’s **lost**!)

-   A bit more advanced: you have to think about the copy constructor
    and assignment operator (maybe you recognize this warning):

         warning: 'class AliAnalysisTaskMyTask' has pointer 
         data members but does not override 'AliAnalysisTaskMyTask(const
         AliAnalysisTaskMyTask&)' or 'operator=(const AliAnalysisTaskMyTask&)' 
         [-Weffc++]"
                    

[Implementing the destructor]{} We didn’t implement a destructor for our
class

-   Memory allocatd with **new** cannot be used again, unless it is
    realased by **delete**

-   Never deleting memory is called a **memory leak**

-   Leaks are **bad**: they waste resources and can crash your system

For that reason, we should implement a destructor

[Implementing the destructor]{}

-   Suppose we have a **constructor** that looks like this

    ``` {.numberLines .c language="C" numbers="left"}
    MyClass::MyClass()
    {
      n = new int;
      p = new float;
      x = new float[5];
    }
    ```

-   The **destructor** should be

    ``` {.numberLines .c language="C" numbers="left"}
    MyClass::~MyClass()
    {
      delete n;
      delete p;
      delete[] x;
    }
    ```

[Implementing the destructor]{} Our life is not so easy

-   We didn’t allocate memory in the class constructor but in
    `UserCreateOutputObjects`

-   We **might** want to free that memory, but what if
    `UserCreateOutputObjects` was **not** called? —if it hasn’t, freeing
    the memory will cause serious problems (the infamous ‘glibc double
    free or corruption’)

-   To avoid this, initialize our pointers to NULL in the member
    initialization list

         ...
        AliAnalysisTaskMyTask::AliAnalysisTaskMyTask() : AliAnalysisTaskSE(), 
            fAOD(0), fOutputList(0), fHistPt(0)
        {
            // ROOT IO constructor, don't allocate memory here!
        }
         ...

[Implementing the destructor]{}

-   With our pointers initialized to NULL, we can go ahead and write our
    destructor

    ``` {.numberLines .c language="C" numbers="left"}
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

Rule of thumb: all calls to **new** should be accompanied by a call to
**delete** somewhere in your code

c++ 11 has introduced ’smart pointers’\
![image](ptr.png){height=".5\textwidth"}\
very powerful and convenient, explained tomorrow

time to try for yourself\
.\
.\
https://github.com/rbertens/ALICE\_analysis\_tutorial\
.\
..\
try step 6 - the others are ’bonus’

So now there’s nothing between you and ....\
![image](np.png){width="\textwidth"}\

Absolute Backup

[Destructors and PROOF]{}

-   Like I said, I unfortunately don’t know anything about PROOF

-   But here’s an implementation of the destructor, courtesy of Dario

    ``` {.numberLines .c language="C" numbers="left"}
    AliAnalysisMyTask::~AliAnalysisMyTask()
    {
      if(AliAnalysisManager::GetAnalysisManager()->GetAnalysisType()
        != AliAnalysisManager::kProofAnalysis) delete fOutputList;
    }
    ```

-   This only deletes the output list if you’re not running PROOF

-   If you are running PROOF, then you *must not* delete the output list

-   Of course, you could always just leave the destructor empty
    (recommended)

-   If you have more questions about this... ask Dario

[Copy constructor and assignment operator]{}

-   Sometimes in AliRoot code you see copy constructors and assignment
    operators (these two always go together)

-   We don’t need them because our analysis class is never copied (apart
    from the streamer actions, which do not rely on these constructors)

-   In a nutshell:

        MyObject A;      // initialization by default constructor
        MyObject B(A);   // initialization by copy constructor
        MyObject C = A;  // Also initialization by copy constructor
        B = C;           // assignment by copy assignment operator

    The copy constructor and assignment operator are **automatically
    generated**, but if your class has **pointer members**, they need to
    be customized (this is **not** a ROOT feature, just c++!)

[Shallow and deep copies]{} ‘In making a deep copy, fields are
dereferenced: rather than references to objects being copied, new copy
objects are created for any referenced objects, and references to these
placed in the target object.’

    private:
      // not implemented
      AliAnalysisTaskMyTask(const AliAnalysisTaskMyTask&); 
      AliAnalysisTaskMyTask& operator=(const AliAnalysisTaskMyTask&);

Generally, this suffices for end-user tasks, as these operators are
never called

-   But be aware when writing classes which **do** require copying

-   Examples are in the backup

[Copy constructor and assignment operator]{}

-   If we wanted to implement our own, we would add the following in the
    class header file:

    ``` {.numberLines .c language="C" numbers="left"}
    ...
    class AliAnalysisMyTask : public AliAnalysisTaskSE
    ...
     private:
      AliAnalysisMyTask(const AliAnalysisMyTask&);
      AliAnalysisMyTask& operator=(const AliAnalysisMyTask&);
    ...
    ```

-   If we have them as private, we don’t have to write an implementation
    even if we leave these lines in the header file

-   If we have them as public, then we must write an implementation

[Copy constructor and assignment operator]{}

-   Here’s what the copy constructor looks like

    ``` {.numberLines .c language="C" numbers="left"}
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

-   The TProfile and most ROOT histogram classes have public copy
    constructors, so we can use them

-   The TList copy constructor is private, so we need to make a Clone of
    it instead

[Copy constructor and assignment operator]{}

-   The assignment operator is very similar to the copy constructor

-   But it has the additional requirements for checking for
    self-assignment and returning a value

    ``` {.numberLines .c language="C" numbers="left"}
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
