# The event loop

Collisions are referred to as ‘events’. In our analysis task, the function 
```
AliAnalysisTaskSE::UserExec
```
is called once for each event in the input data set. **You never have to explicitly call this function yourself** ! Remember the introduction slides about **inheritance** in c++ ? This function is called by a **base** class that you do not have to worry about. We will later see that this function is only called when an event passes your **trigger selection**. 

## Fun !  

It’s time to add some code to our task. First, create additional output histograms in which you’ll store

*   The primary vertex positions along the beam line for all events

*   The centrality of all events

Just like the example histogram `fHistPt`, you have to add these histograms as members of your class. So, create the pointers in the header file, remember to initialize the pointers in your class constructors, and don’t forget to create instances of the histograms in the `UserCreateOutput` method.

One of the trickiest things in programming can be _finding out what methods to use_ out of millions of lines of code. To help you out, here’s two lines of hints to obtain the vertex position along the beam line, and collision centrality, of our AOD events

```cpp
float vertexZ = fAOD->GetPrimaryVertex()->GetZ();
float centrality = fAOD->GetCentrality()->GetCentralityPercentile("V0M");
```

You can of course just copy-paste these lines into your task and hope that it works, but try to think of

*   do you understand the _logic_ of these lines?

*   can you find out in which classes these methods are defined? [<sup>3</sup>](#fn3)

Try to run the code again, after you’ve added these histograms.
