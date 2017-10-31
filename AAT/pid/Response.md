# PID response

To speed things up a bit, the code that you need for excercises 4 and onwards is given here below.

To identify particles, you will add an additional task to your analysis, the ‘PID response’ task. This task makes sure that parametrizations that we use for e.g. specific energy loss in the TPC are loaded. To add this task to your analysis, open your runAnalysis.C macro, and add the following lines. Make sure that these lines are called _before_ your own task is added to that analysis manager, your task will _depend_ on this task:

```cpp
// load the necessary macros
gROOT->LoadMacro("\$ALICE_ROOT/ANALYSIS/macros/AddTaskPIDResponse.C");
AddTaskPIDResponse();
```

As a second step, you’ll have to make some changed to the header of our analysis. First, you’ll add another class member, which is a pointer to the AliPIDresponse object that we’ll use in our class. To do this, remember how you added pointers to histograms earlier in this tutorial, so add

*   a _forward declaration_ of the type, i.e. ‘class AliPIDResponse’

*   the pointer itself, i.e. ‘AliPIDResponse* fPIDResponse; //! pid response object’

Don’t forget to add this new pointer fPIDResponse to the member initialization list in your class constructors (in the .cxx files)!

After making changes to the header, you can add the actual identification routine. This will be done in the implementation of the class. You need to go through a few steps:

*   Retrieve the AliPIDResponse object from the analysis manager;

*   make our poiter ‘fPIDResponse’ point to the AliPIDResponse object;

*   include the header for the AliPIDResponse class, so that the compiler knows how it is defined

The code to do this might be a bit difficult to figure out by yourself, so it’s given here below

```cpp
AliAnalysisManager *man = AliAnalysisManager::GetAnalysisManager();
if (man) {
    AliInputEventHandler* inputHandler = (AliInputEventHandler*)(man->GetInputEventHandler());
    if (inputHandler)   fPIDResponse = inputHandler->GetPIDResponse();
}
```

Do you understand

*   what happens in each line?

*   in which function (UserCreateOutputObjects, UserExcec, Terminate, etc) to put this code?

Now that we’ve retrieved our PID response object, it’s time to use it. To extract information for different particle species, you can use the functions

```cpp
double kaonSignal = fPIDResponse->NumberOfSigmasTPC(track, AliPID::kKaon);
double pionSignal = fPIDResponse->NumberOfSigmasTPC(track, AliPID::kPion);
double protonSignal = fPIDResponse->NumberOfSigmasTPC(track, AliPID::kProton);
```

What these functions return you, is a probability that a particle is of a certain type, expressed in standard deviations ($$\sigma$$) . To identify a particle, we’ll require that its PIDresponse signal lies _withim 3 standard deviations_ of the expected signal. To check this, you can write a few lines such as

```cpp
if (std::abs(fPIDResponse->NumberOfSigmasTPC(track, AliPID::kPion)) < 3 ) {
  // jippy, i'm a pion
};
```

