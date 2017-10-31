# Modify the task

If you managed to run the task, congratulations! This is step one towards becoming a professional physicist (no turning back from here ... ) If it didn’t work, ask for help. Also this is a very significant part of becoming a physicist ...

At this point, it’s time to expand our task a bit. What we will do is

*   Add some event selection criteria

*   Add some track selection criteria

But let’s not go too fast.# The event loop

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
# All set?

It’s _almost_ time to do some physics. Not all collisions in the detector are actually usable for physics analysis. Events which happen very far from the center of the detector, for example, are usually not used for analysis (any idea why?). To make sure that we only look at high quality data, we do ’event selection’. Let’s add some event selection criteria to your task.

*   modify the code such that only primary vertices are accepted within 10 cm of detector center;
Selections in the event sample or track sample are often referred to as ‘cuts’. Usually, we want to see how much data we ‘throw away’ when applying a cut. How would you go about doing that?

Besides rejecting data via cuts, we also make data selection while data taking, by _‘triggering’_: selecting collisions in which we expect certain processes to have occurred. You can check which triggers are selected in line 27 of the `AddMyTask.C` macro - we won’t have time to cover triggers in detail, but if you have questions, ask!
