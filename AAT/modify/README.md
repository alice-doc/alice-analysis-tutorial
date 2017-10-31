# Modify the task

If you managed to run the task, congratulations! This is step one towards becoming a professional physicist (no turning back from here ... ) If it didn’t work, ask for help. Also this is a very significant part of becoming a physicist ...

At this point, it’s time to expand our task a bit. What we will do is

*   Add some event selection criteria

*   Add some track selection criteria

But let’s not go too fast.

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

*   can you find out in which classes these methods are defined?

Try to run the code again, after you’ve added these histograms.
# All set?

It’s _almost_ time to do some physics. Not all collisions in the detector are actually usable for physics analysis. Events which happen very far from the center of the detector, for example, are usually not used for analysis (any idea why?). To make sure that we only look at high quality data, we do ’event selection’. Let’s add some event selection criteria to your task.

*   modify the code such that only primary vertices are accepted within 10 cm of detector center;
Selections in the event sample or track sample are often referred to as ‘cuts’. 
*   Usually, we want to see how much data we ‘throw away’ when applying a cut. How would you go about doing that?

Besides rejecting data via cuts, we also make data selection while data taking, by _‘triggering’_: selecting collisions in which we expect certain processes to have occurred. You can check which triggers are selected in the `AddMyTask.C` macro , where we call

```
    task->SelectCollisionCandidates(AliVEvent::kAnyINT);
```

As you can see, trigger classes are defined in the class AliVEvent. A quick look into the source code of that classt tells us which triggers are available

```
  enum EOfflineTriggerTypes { 
    kMB                = BIT( 0), // Minimum bias trigger in PbPb 2010-11
    kINT1              = BIT( 0), // V0A | V0C | SPD minimum bias trigger
    kINT7              = BIT( 1), // V0AND minimum bias trigger
    kMUON              = BIT( 2), // Single muon trigger in pp2010-11, INT1 suite
    kHighMult          = BIT( 3), // High-multiplicity SPD trigger
    kHighMultSPD       = BIT( 3), // High-multiplicity SPD trigger
    kEMC1              = BIT( 4), // EMCAL trigger in pp2011, INT1 suite
    kCINT5             = BIT( 5), // V0OR minimum bias trigger
    kINT5              = BIT( 5), // V0OR minimum bias trigger
    kCMUS5             = BIT( 6), // Single muon trigger, INT5 suite
    kMUSPB             = BIT( 6), // Single muon trigger in PbPb 2011
    kINT7inMUON        = BIT( 6), // INT7 in MUON or MUFAST cluster
    kMuonSingleHighPt7 = BIT( 7), // Single muon high-pt, INT7 suite
    kMUSH7             = BIT( 7), // Single muon high-pt, INT7 suite
    kMUSHPB            = BIT( 7), // Single muon high-pt in PbPb 2011
    kMuonLikeLowPt7    = BIT( 8), // Like-sign dimuon low-pt, INT7 suite
    kMUL7              = BIT( 8), // Like-sign dimuon low-pt, INT7 suite
    kMuonLikePB        = BIT( 8), // Like-sign dimuon low-pt in PbPb 2011
    kMuonUnlikeLowPt7  = BIT( 9), // Unlike-sign dimuon low-pt, INT7 suite
    kMUU7              = BIT( 9), // Unlike-sign dimuon low-pt, INT7 suite
    kMuonUnlikePB      = BIT( 9), // Unlike-sign dimuon low-pt in PbPb 2011
    kEMC7              = BIT(10), // EMCAL/DCAL L0 trigger, INT7 suite
    kEMC8              = BIT(10), // EMCAL/DCAL L0 trigger, INT8 suite
    kMUS7              = BIT(11), // Single muon low-pt, INT7 suite
    kMuonSingleLowPt7  = BIT(11), // Single muon low-pt, INT7 suite
    kPHI1              = BIT(12), // PHOS L0 trigger in pp2011, INT1 suite
    kPHI7              = BIT(13), // PHOS trigger, INT7 suite
    kPHI8              = BIT(13), // PHOS trigger, INT8 suite
    kPHOSPb            = BIT(13), // PHOS trigger in PbPb 2011
    kEMCEJE            = BIT(14), // EMCAL/DCAL L1 jet trigger
    kEMCEGA            = BIT(15), // EMCAL/DCAL L1 gamma trigger
    kHighMultV0        = BIT(16), // High-multiplicity V0 trigger
    kCentral           = BIT(16), // Central trigger in PbPb 2011
    kSemiCentral       = BIT(17), // Semicentral trigger in PbPb 2011
    kDG                = BIT(18), // Double gap diffractive
    kDG5               = BIT(18), // Double gap diffractive
    kZED               = BIT(19), // ZDC electromagnetic dissociation
    kSPI7              = BIT(20), // Power interaction trigger
    kSPI               = BIT(20), // Power interaction trigger
    kINT8              = BIT(21), // 0TVX trigger
    kMuonSingleLowPt8  = BIT(22), // Single muon low-pt, INT8 suite
    kMuonSingleHighPt8 = BIT(23), // Single muon high-pt, INT8 suite
    kMuonLikeLowPt8    = BIT(24), // Like-sign dimuon low-pt, INT8 suite
    kMuonUnlikeLowPt8  = BIT(25), // Unlike-sign dimuon low-pt, INT8 suite
    kMuonUnlikeLowPt0  = BIT(26), // Unlike-sign dimuon low-pt, no additional L0 requirement
    kUserDefined       = BIT(27), // Set when custom trigger classes are set in AliPhysicsSelection
    kTRD               = BIT(28), // TRD trigger
    // Bits 29 and above are reserved for FLAGS
    kFastOnly          = BIT(30), // The fast cluster fired. This bit is set in to addition another trigger bit, e.g. kMB
    kAny               = 0xffffffff, // to accept any defined trigger
    kAnyINT            = kMB | kINT7 | kINT5 | kINT8 | kSPI7 // to accept any interaction (aka minimum bias) trigger
  };
```

but that may be a bit cryptic .. We won’t have time to cover triggers in detail, but if you have questions, ask - and if you do analysis - make sure that you are using the correct trigger configuration. 
