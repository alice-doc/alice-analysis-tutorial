# Monte Carlo events

A large fraction of our recorded data is accompanied by simulated events that we call Monte Carlo (MC) productions. Different MC generators, like PYTHIA, DPMJET, and HIJING are used to simulate collisions, after which a detector response is simulated using GEANT. 

The main reason for analyzing MC events is that it enables the analyzer to calculate efficiency and acceptance corrections specific for their analysis, and study the difference between the true and reconstructed observables. So, in MC, we have by construction more information available. In MC, we can for example just ask the PDG code of the particles in the event, and then verify how well our data analysis performs. 

## Accessing MC productions

First, we have to download the MC data. Since we downloaded Pb-Pb data from the period LHC15o with run number 246757, we will download an AOD file from the same run of a MC that is anchored to this period; namely LHC16g1.

```cpp
aliensh
cd /alice/sim/2016/LHC16g1/246757/AOD198/0002/
cp AliAOD.root file:.
```
It might be useful to rename the file to AliAOD_MC.root to avoid confusion later on. If you do so, of course you have to change the name of the input data file that you specify in runAnalysis.C.

Now if we don't do anything else and run the analysis, the MC data will be processed as if it was data, and should produce a similar output when compared to real data. But of course we want to and can do more!

## Accessing the MC information

We will add a few things to our code to be able to obtain information that is provided directly by the Monte Carlo generator itself (often referred to as 'true level' or 'generator level'). First, we add our new global variable to the header in the list of private objects:

```cpp
AliMCEvent*             fMCEvent;       //! corresponding MC event
```

Then we add fMCEvent to the constructors

```cpp
...
AliAnalysisTaskMyTask::AliAnalysisTaskMyTask() : AliAnalysisTaskSE(), 
    fAOD(0), fMCEvent(0), fOutputList(0), fHistPt(0)
{
...
```

and

```cpp
...
AliAnalysisTaskMyTask::AliAnalysisTaskMyTask(const char* name) : AliAnalysisTaskSE(name),
    fAOD(0), fMCEvent(0), fOutputList(0), fHistPt(0)
{
...
```

In `UserExec` we can now use our new global variable to obtain the MC event through the `MCEvent` method

```cpp
fMCEvent = MCEvent();
```

Now let's use the information by creating a new function that loops over the MC particles:

in the header file we declare our new function ProcessMCParticles

```cpp
void ProcessMCParticles();
```

Then we put the implementation in the .cxx file:

```cpp
void AliAnalysisTaskMyTask::ProcessMCParticles()
{
    // process MC particles
    TClonesArray* AODMCTrackArray = dynamic_cast<TClonesArray*>(fInputEvent->FindListObject(AliAODMCParticle::StdBranchName()));
    if (AODMCTrackArray == NULL) return;

    // Loop over all primary MC particle
    for(Long_t i = 0; i < AODMCTrackArray->GetEntriesFast(); i++) {

      AliAODMCParticle* particle = static_cast<AliAODMCParticle*>(AODMCTrackArray->At(i));
      if (!particle) continue;
      cout << "PDG CODE = " << particle->GetPdgCode() << endl;
    }
}
```

Finally we call our newly created function in UserExec:
```cpp
if(fMCEvent) ProcessMCParticles();
```
You can run the code and enjoy the list of PDG code values of each particle in the MC event... although it might be more useful to fill a histogram with the values instead of printing them to the terminal.

