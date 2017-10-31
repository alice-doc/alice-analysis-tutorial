# All set?

It’s _almost_ time to do some physics. Not all collisions in the detector are actually usable for physics analysis. Events which happen very far from the center of the detector, for example, are usually not used for analysis (any idea why?). To make sure that we only look at high quality data, we do ’event selection’. Let’s add some event selection criteria to your task.

*   modify the code such that only primary vertices are accepted within 10 cm of detector center;
Selections in the event sample or track sample are often referred to as ‘cuts’. Usually, we want to see how much data we ‘throw away’ when applying a cut. How would you go about doing that?

Besides rejecting data via cuts, we also make data selection while data taking, by _‘triggering’_: selecting collisions in which we expect certain processes to have occurred. You can check which triggers are selected in line 27 of the `AddMyTask.C` macro - we won’t have time to cover triggers in detail, but if you have questions, ask!
