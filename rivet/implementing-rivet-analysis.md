# Implementing a Rivet analysis

In order to implement a new analysis, you can start from a template created by the Rivet tools. Best start in a new directory for the implementation and create the template therein:
```
mkdir myRivet
cd myRivet
rivet-mkanalysis <ID>
```
where ID specifies the identifier of the analysis. If you are aiming for an official analysis, you should use the proper identifier; if you are just testing, you can use essentially what you want. If you use an identifier referring to a published analysis, e.g. ALICE_2011_I1080735, you automatically get the reference data (taken from HepData) and the metadata (taken from spires/inspire) for this analysis.

In the next step, you "just" have to add the missing bits and pieces to the template. In more detail, the rivet-mkanalysis command will give you a bunch of files, amongst others a cc-file for the implementation of the analysis. This cc-file contains already the required class and the mandatory methods:

* init
* analyze
* finalize

which you still have to fill with useful content, of course. We will explain the required implementations in more details below, the template (for an assumed analysis ALICE_2016_test) contains:
```cpp
// -*- C++ -*-
#include "Rivet/Analysis.hh"
#include "Rivet/Projections/FinalState.hh"
/// @todo Include more projections as required, e.g. ChargedFinalState, FastJets, ZFinder...

namespace Rivet {
  class ALICE_2016_test : public Analysis {

  public:

    /// Constructor
    ALICE_2016_test()
      : Analysis("ALICE_2016_test")
    {    }


    /// @name Analysis methods
    //@{

    /// Book histograms and initialise projections before the run
    void init() {

      /// @todo Initialise and register projections here

      /// @todo Book histograms here, e.g.:
      // _h_XXXX = bookProfile1D(1, 1, 1);
      // _h_YYYY = bookHisto1D(2, 1, 1);

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {
      const double weight = event.weight();

      /// @todo Do the event by event analysis here

    }


    /// Normalise histograms etc., after the run
    void finalize() {

      /// @todo Normalise, scale and otherwise manipulate histograms here

      // scale(_h_YYYY, crossSection()/sumOfWeights()); // norm to cross section
      // normalize(_h_YYYY); // normalize to unity

    }

    //@}

  private:
    // Data members like post-cuts event weight counters go here

    /// @name Histograms
    //@{
    Profile1DPtr _h_XXXX;
    Histo1DPtr _h_YYYY;
    //@}
  };

  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2016_test);
}
```
Rivet usually does not use a separate header file for the implementation of the main class of the analysis (you can add further classes and headers if the analysis gets more complex). When extending the code for the Rivet plugin, be careful to follow Rivet coding conventions (which are different from the ALICE ones) such that the analysis can eventually be submitted to the Rivet team for integration into the official distribution.

You can already try and compile the plugin at this stage to make sure that the setup and preparations are correct:
```
rivet-buildplugin RivetALICE_2016_test.so ALICE_2016_test.cc
```
which builds the shared library RivetALICE_2016_test.so to be used by Rivet.

## Required member variables and methods

For the plugin to do something useful, you need to add code in a few places. The basic steps are usually very straight-forward.

### member variables

You can add member variables in the private section (below the comment introducing Data members). They should follow the naming conventions of Rivet. This is the place where you add the pointers for histograms, profiles, etc. There are special Rivet structures for such pointers which should be used:
```cpp
Histo1DPtr   _h_0000; // for a histogram
Profile1DPtr _h_0001; // for a profile
```
Of course, you can also add variables of your own, e.g. to define pt/rapidity ranges, jet radii, ...

### init
The code in this method is run once at the beginning of the run. It is used to set up the analysis.

Here, you have to book the histograms (using the previously added pointers). When implementing a published analysis, the preferred way to book the histograms is to let Rivet take the histogram details from the reference data:
```cpp
_h_0000 = bookHisto1D("d01-x01-y01");
_h_0001 = bookHisto1D("TMP/test", refData(1, 1, 1));
```
where d01-x01-y01 refers to the reference data (following HepData naming conventions for the histograms). If you don't have a reference histogram or you need to use a different binning, you can book a histogram as follows:
```cpp
_hist = bookHisto1D("pt_h", 10, 0., 20., "final state particles", "$p_\\perp$", "counts");
```
In addition to the histogram bookings, you need to add all the projections required for the analysis. Rivet uses projections to extract (and re-use) observables from the final state, e.g. particles (after cuts), jets, .... E.g. for an analysis based on charged particles in the rapidity interval etamax, you would use:
```cpp
  const ChargedFinalState cfs(-_etamax, _etamax);
  addProjection(cfs, "CFS");
```
For an analysis based on jets you would use:
```cpp
  const FinalState fs_jet(-_etamax - _jet_r, _etamax + _jet_r);
  addProjection(fs_jet, "FS_JET");
  FastJets fj02(fs_jet, FastJets::ANTIKT, _jet_r);
  fj02.useInvisibles();
  addProjection(fj02, "Jets02");
```
For more details on possible projections, see the [reference page](reference-manual.md)

### analyze
The code in this method is run for every event and is used for the actual (event-wise) analysis. The event for analysis is passed as parameter to the function. Commonly, you extract the event weight, apply the projections, and fill some histograms:
```cpp
const double weight = event.weight();

const ChargedFinalState & cfs = applyProjection<ChargedFinalState>(event, "CFS");

foreach (const Particle &p, cfs.particles()) {
  _h_0000->fill(p.pT() / GeV, weight);
}
```
N.B.: Here, the iterations use boost constructs. In the future, this will probably be replaced by C++11 constructs. The ALICE build of Rivet already is C++11-enabled but so far Rivet allows to be built without C++11 support (i.e. contributed analyses must work without).

### finalize
The code in this method is run once after the run. It is typically used for scaling and/or normalization of histograms. In order to normalize a histogram to the number of events, you can make use of Rivet helpers:
```cpp
scale(_h_0000, 1./sumOfWeights());
```
where sumOfWeights() is provided by Rivet.

## example analysis
In order to explain the required steps in a real life situation, we will go through the implementation for the analysis published as :

* Measurement of pion, kaon and proton production in proton-proton collisions at sqrt(s) = 7 TeV
  * ALICE internal draft : ID-183￼
  * journal reference : Eur.Phys.J C75 (2015) no. 5, 226￼,
  * Inspire : ID-1357424￼,
  * arXiv : arXiv:1504.00024￼.
The content we now want to reproduce in Rivet is the following:
* transverse momentum spectra of identified pions, kaons, protons
* particle ratios: kaons / pions, protons / pions
For the implementation, you can to the ALICE Rivet reference page to look up the individual ingredients you might need for your analysis.

Now, we go step by step.

### identifier and template
First, we need to find the identifier for the analysis we want to implement. The analysis was published in 2015 and has the inspire ID 1357424. Thus, the identifier is ALICE_2015_I1357424.

Now, we can create the template structure (don't forget to load the environment for Rivet and to change to an appropriate directory):
```
rivet-mkanalysis ALICE_2015_I1357424
```
As mentioned before, the analysis can already be compiled and run (even though it does nothing useful at this stage):
```
rivet-buildplugin RivetALICE_2015_I1357424.so ALICE_2015_I1357424.cc
rivet --pwd -a ALICE_2015_I1357424 /eos/project/a/alipwgmm/rivet/hepmc/epos_PbPb2760.hepmc
```

### initialisation (histograms and projections)
First, we book the required histograms. We need one histogram for each of the pt spectra of pions, kaons, and protons. Eventually, we also want to plot the ratios of the spectra for which a different binning was used. Therefore, we need additional temporary histograms.

So, we add the required member variables (in the private section):
```cpp
  // histograms for spectra
  Histo1DPtr _histPtPions;
  Histo1DPtr _histPtProtons;
  Histo1DPtr _histPtKaons;

  // temporary histograms for ratios
  Histo1DPtr _histPtPionsR1;
  Histo1DPtr _histPtPionsR2;
  Histo1DPtr _histPtProtonsR;
  Histo1DPtr _histPtKaonsR;

  // scatter plots for ratios
  Scatter2DPtr _histPtKtoPi;
  Scatter2DPtr _histPtPtoPi;
```
Then, we add the booking of the histograms (in the init method):
```cpp
  // plots from the paper
  _histPtPions          = bookHisto1D("d01-x01-y01");    // pions
  _histPtKaons          = bookHisto1D("d01-x01-y02");    // kaons
  _histPtProtons        = bookHisto1D("d01-x01-y03");    // protons
  _histPtKtoPi          = bookScatter2D("d02-x01-y01");  // K to pi ratio 
  _histPtPtoPi          = bookScatter2D("d03-x01-y01");  // p to pi ratio

  // temp histos for ratios
  _histPtPionsR1        = bookHisto1D("TMP/pT_pi1", refData(2, 1, 1)); // pi histo compatible with more restricted kaon binning
  _histPtPionsR2        = bookHisto1D("TMP/pT_pi2", refData(3, 1, 1)); // pi histo compatible with more restricted proton binning
  _histPtKaonsR         = bookHisto1D("TMP/pT_K",   refData(2, 1, 1)); // K histo with more restricted binning
  _histPtProtonsR       = bookHisto1D("TMP/pT_p",   refData(3, 1, 1)); // p histo with more restricted binning
```
Next, we book the projections for the identified particles (also in the init method):
```cpp
  const ChargedFinalState cfs(Cuts::absrap < 0.5);
  addProjection(cfs, "CFS");
```
Here, we use the charged final state (with a rapidity cut) and will deal with the particle identification directly in the analysis code.

### analysis
Here, we just use the previously declared projection to loop over all the charged particles in the selected rapidity range and to fill the histograms. 
Note: We exclude feed-down from particles decaying weakly into π, K, p:
```cpp
  const double weight = event.weight();
  const ChargedFinalState& cfs = applyProjection<ChargedFinalState>(event, "CFS");
  foreach (const Particle& p, cfs.particles()) {
    // protections against mc generators decaying long-lived particles
    if ( !(p.hasAncestor(310)  || p.hasAncestor(-310)  ||     // K0s
           p.hasAncestor(130)  || p.hasAncestor(-130)  ||     // K0l
           p.hasAncestor(3322) || p.hasAncestor(-3322) ||     // Xi0
           p.hasAncestor(3122) || p.hasAncestor(-3122) ||     // Lambda
           p.hasAncestor(3222) || p.hasAncestor(-3222) ||     // Sigma+/-
           p.hasAncestor(3312) || p.hasAncestor(-3312) ||     // Xi-/+ 
           p.hasAncestor(3334) || p.hasAncestor(-3334) ))     // Omega-/+     
      {  
        switch (abs(p.pid())) {
        case 211: // pi+
          _histPtPions->fill(p.pT()/GeV, weight);
          _histPtPionsR1->fill(p.pT()/GeV, weight);
          _histPtPionsR2->fill(p.pT()/GeV, weight);
          break;
        case 2212: // proton
          _histPtProtons->fill(p.pT()/GeV, weight);
          _histPtProtonsR->fill(p.pT()/GeV, weight);
          break;
        case 321: // K+
          _histPtKaons->fill(p.pT()/GeV, weight);
          _histPtKaonsR->fill(p.pT()/GeV, weight);
          break;
      } // particle switch
    } // primary pi, K, p only
  } // particle loop
```

### finalise
In the end, we build the particle ratios to pions (K/π and P/π) and normalize the histograms in order to show 1/Nev d²N/dpt dy event-normalised spectra :
```cpp
  divide(_histPtKaonsR,   _histPtPionsR1, _histPtKtoPi);
  divide(_histPtProtonsR, _histPtPionsR2, _histPtPtoPi);

  scale(_histPtPions,       1./sumOfWeights());
  scale(_histPtProtons,     1./sumOfWeights());
  scale(_histPtKaons,       1./sumOfWeights());
```

### try your new analysis
Now, try and run the analysis on the test file:
```
rivet-buildplugin Rivet_test.so ALICE_2015_I1357424.cc
rivet --pwd -a ALICE_2015_I1357424 /eos/project/a/alipwgmm/rivet/hepmc/epos_PbPb2760.hepmc
```
N.B.: Note the option --pwd which instructs Rivet to look for the specified analyses (also) in the current working directory.

Next, create the plots and compare:
```
rivet-mkhtml --pwd Rivet.yoda
```
(if needed copy plots/ directory locally).

In case of problems, you can look at the [reference implementation](https://twiki.cern.ch/twiki/bin/view/ALICE/PWGMMRivetExampleReference) - but first try to sort it out yourself.

