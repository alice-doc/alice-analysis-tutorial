# A little test ..

If the analysis code is working, it’s time to launch it on GRID, to see what the results look like when run over a large data set.

*   open the runAnalysis.C macro, and set the flag ’local’ on line 4, to kFALSE

*   keep the flag ’gridTest’ on line 6 set to kTRUE

*   read through the configuration of the `AliAnalysisAlien` class, do all the settings make sense?

If you think everything is OK, initialize a token ( `alien-token-init < username >` ) and launch the analysis.