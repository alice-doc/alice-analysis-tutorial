# Advanced heavy-ion feratures

This section covers more advanced heavy-ion features introduced in Rivet version 2.7.0+. It explains how event mixing is implemented in Rivet and how to use it, as well as it presents the idea of reentrant finalize for analyses which require more than one beam and/or energy within the same analysis.

Please follow the basic tutorial of implementing a Rivet analysis [here](implementing-rivet-analysis.md) and a section covering basic heavy-ion features [here](hi-features.md) first before going into this section.

## Postprocessing with reentrant finalize

Postprocessing is a method that enables to merge results coming from different Rivet runs. This is useful for analyses which require different beams and/or energies to obtain final results, but also is useful when one wants to simply increase the statistics by merging multiple runs for the same beam/energy. Note, that such an analysis must be implemented in a certain way to allow proper running for all modes, so one should take great care when writing it.

In case of running an analysis for different beams/energies, first step is to declare them in the .info file like this:
```
[...]
Beams: [[p, p], [1000822080, 1000822080]]
# This is _total_ energy of beams, so this becomes 208*2760=574080
Energies: [2760, 574080]
[...]
```
Then, inside the analysis' init function, one should declare objects for each beam/energy separately, e.g.:
```cpp
void init() {
  // Initialize PbPb objects
  _histNch = bookHisto1D(1, 1, 1);
  _counterSOW = bookCounter("counter.pbpb", "Sum of weights counter for PbPb");
  _counterNcoll = bookCounter("counter.ncoll", "Ncoll counter for PbPb");
  // Initialize pp objects
  std::string namePP = _histNch->name() + "-pp";
  _histNchPP = bookHisto1D(namePP, refData(1, 1, 1));
  _counterSOWPP = bookCounter("counter.pp", "Sum of weights counter for pp");
  [...]
}
```
Next, in the analyze method, one needs to check the type of an event the analysis is run with, for example like this:
```cpp
  // Check the type of event
  const HepMC::HeavyIon* hi = event.genEvent()->heavy_ion();
  if (hi && hi->is_valid()) {
    // PbPb event, fill PbPb histograms
  }
  else {
    // pp event, fill pp histograms
  }

```
Note: This is not a perfect solution as this check does not always work in a predictable way. In the future versions of Rivet this will be replaced with a check directly on the beam type.

Finally, the regular finalize method is called, but in case we have entries in the histograms for both beam types, we do an additional step of dividing them one by another to create R_AA plot:
```cpp
void finalize() {
  // Regular finalize, scaling, etc.
  [...]

  // Postprocessing of the histograms in case there are
  // entries in histograms for both beam types
  if (_histNchPP->numEntries() > 0 && _histNch->numEntries() > 0) {
    // Initialize and fill R_AA histograms
    _histRAA = bookScatter2D(16, 1, 1);
    divide(_histNch, _histNchPP, _histRAA);
  }
}
```
In order to run an analysis in the postprocessing mode one should run an analysis for every beam/energy combination and then use the rivet-merge script with the output files from the previous runs provided as parameters (check rivet-merge --help):
```
rivet-merge /path/to/result1.yoda /path/to/result2.yoda ...
```
This will use the RAW histograms from you output files (check that your .yoda files contain them, they contain results from the analysis before the final scaling in the finalize method), merge them, and call finalize part of the analysis again on the merged histograms. Now, as all the histograms will be available, the finalize method will (in our case) create and fill R_AA histograms and save them to the output .yoda file containing final results. Note, that there is no information about beam and energy when running rivet-merge script. Also note, that an analysis with reentrant finalize must be implemented in a cetrain way to allow running in every mode, and so in the .info file it should be marked as:
```
Reentrant: True
```
A full example of an analysis with the reentrant finalize mode enabled is provided below:
```cpp
// -*- C++ -*-
#include "Rivet/Analysis.hh"
#include "Rivet/Projections/ChargedFinalState.hh"
#include "Rivet/Tools/Cuts.hh"
#include "Rivet/Projections/SingleValueProjection.hh"
#include "Rivet/Tools/AliceCommon.hh"
#include "Rivet/Projections/AliceCommon.hh"
#include <fstream>

#define _USE_MATH_DEFINES
#include <math.h>

namespace Rivet {

  /// @brief ALICE PbPb at 2.76 TeV R_AA analysis.
  class ALICE_2012_I1127497 : public Analysis {

  public:

    /// Constructor
    DEFAULT_RIVET_ANALYSIS_CTOR(ALICE_2012_I1127497);

    /// @name Analysis methods
    //@{

    /// Book histograms and initialise projections before the run
    void init() {

      // Declare centrality projection
      declareCentrality(ALICE::V0MMultiplicity(),
        "ALICE_2015_PBPBCentrality", "V0M", "V0M");

      // Charged, primary particles with |eta| < 0.5 and pT > 150 MeV
      declare(ALICE::PrimaryParticles(Cuts::abseta < 0.5 &&
        Cuts::pT > 150*MeV && Cuts::abscharge > 0), "APRIM");

      // Loop over all histograms
      for (size_t ihist = 0; ihist < NHISTOS; ++ihist) {

        // Initialize PbPb objects
        _histNch[PBPB][ihist] = bookHisto1D(ihist+1, 1, 1);

        std::string nameCounterPbPb = "counter.pbpb." + std::to_string(ihist);
        _counterSOW[PBPB][ihist] = bookCounter(nameCounterPbPb,
          "Sum of weights counter for PbPb");

        std::string nameCounterNcoll = "counter.ncoll." + std::to_string(ihist);
        _counterNcoll[ihist] = bookCounter(nameCounterNcoll,
          "Ncoll counter for PbPb");

        // Initialize pp objects. In principle, only one pp histogram would be
        // needed since centrality does not make any difference here. However,
        // in some cases in this analysis the binning differ from each other,
        // so this is easy-to-implement way to account for that.
        std::string namePP = _histNch[PBPB][ihist]->name() + "-pp";
        // The binning is taken from the reference data
        _histNch[PP][ihist] = bookHisto1D(namePP, refData(ihist+1, 1, 1));

        std::string nameCounterpp = "counter.pp." + std::to_string(ihist);
        _counterSOW[PP][ihist] = bookCounter(nameCounterpp,
          "Sum of weights counter for pp");

      }

      // Centrality regions keeping boundaries for a certain region.
      // Note, that some regions overlap with other regions.
      _centrRegions.clear();
      _centrRegions = {{0., 5.},   {5., 10.},  {10., 20.},
                       {20., 30.}, {30., 40.}, {40., 50.},
                       {50., 60.}, {60., 70.}, {70., 80.},
                       {0., 10.},  {0., 20.},  {20., 40.},
                       {40., 60.}, {40., 80.}, {60., 80.}};

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {

      const double weight = event.weight();

      // Charged, primary particles with at least pT = 150 MeV
      // in eta range of |eta| < 0.5
      Particles chargedParticles =
        applyProjection<ALICE::PrimaryParticles>(event,"APRIM").particlesByPt();

      // Check type of event. This may not be a perfect way to check for the
      // type of event as there might be some weird conditions hidden inside.
      // For example some HepMC versions check if number of hard collisions
      // is equal to 0 and assign 'false' in that case, which is usually wrong.
      // This might be changed in the future
      const HepMC::HeavyIon* hi = event.genEvent()->heavy_ion();
      if (hi && hi->is_valid()) {

        // Prepare centrality projection and value
        const CentralityProjection& centrProj =
          apply<CentralityProjection>(event, "V0M");
        double centr = centrProj();
        // Veto event for too large centralities since those are not used
        // in the analysis at all
        if ((centr < 0.) || (centr > 80.))
          vetoEvent;

        // Fill PbPb histograms and add weights based on centrality value
        for (size_t ihist = 0; ihist < NHISTOS; ++ihist) {
          if (inRange(centr, _centrRegions[ihist].first, _centrRegions[ihist].second)) {
            _counterSOW[PBPB][ihist]->fill(weight);
            _counterNcoll[ihist]->fill(event.genEvent()->heavy_ion()->Ncoll(), weight);
            foreach (const Particle& p, chargedParticles) {
              float pT = p.pT()/GeV;
              if (pT < 50.) {
                double pTAtBinCenter = _histNch[PBPB][ihist]->binAt(pT).xMid();
                _histNch[PBPB][ihist]->fill(pT, weight/pTAtBinCenter);
              }
            }
          }
        }

      }
      else {

        // Fill all pp histograms and add weights
        for (size_t ihist = 0; ihist < NHISTOS; ++ihist) {
          _counterSOW[PP][ihist]->fill(weight);
          foreach (const Particle& p, chargedParticles) {
            float pT = p.pT()/GeV;
            if (pT < 50.) {
              double pTAtBinCenter = _histNch[PP][ihist]->binAt(pT).xMid();
              _histNch[PP][ihist]->fill(pT, weight/pTAtBinCenter);
            }
          }
        }

      }

    }


    /// Normalise histograms etc., after the run
    void finalize() {

      // Right scaling of the histograms with their individual weights.
      for (size_t itype = 0; itype < EVENT_TYPES; ++itype ) {
        for (size_t ihist = 0; ihist < NHISTOS; ++ihist) {
          if (_counterSOW[itype][ihist]->sumW() > 0.) {
            scale(_histNch[itype][ihist],
              (1. / _counterSOW[itype][ihist]->sumW() / 2. / M_PI));
          }
        }
      }

      // Postprocessing of the histograms
      for (size_t ihist = 0; ihist < NHISTOS; ++ihist) {
        // If there are entires in histograms for both beam types
        if (_histNch[PP][ihist]->numEntries() > 0 && _histNch[PBPB][ihist]->numEntries() > 0) {
          // Initialize and fill R_AA histograms
          _histRAA[ihist] = bookScatter2D(ihist+16, 1, 1);
          divide(_histNch[PBPB][ihist], _histNch[PP][ihist], _histRAA[ihist]);
          // Scale by Ncoll. Unfortunately some generators does not provide
          // Ncoll value (eg. JEWEL), so the following scaling will be done
          // only if there are entries in the counters
          double ncoll = _counterNcoll[ihist]->sumW();
          double sow = _counterSOW[PBPB][ihist]->sumW();
          if (ncoll > 1e-6 && sow > 1e-6)
            _histRAA[ihist]->scaleY(1. / (ncoll / sow));

        }
      }

    }

    //@}

  private:

    static const int NHISTOS = 15;
    static const int EVENT_TYPES = 2;
    static const int PP = 0;
    static const int PBPB = 1;

    /// @name Histograms
    //@{
    Histo1DPtr _histNch[EVENT_TYPES][NHISTOS];
    CounterPtr _counterSOW[EVENT_TYPES][NHISTOS];
    CounterPtr _counterNcoll[NHISTOS];
    Scatter2DPtr _histRAA[NHISTOS];
    //@}

    std::vector<std::pair<double, double>> _centrRegions;

  };

  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2012_I1127497);

}
```

## Event mixing

WARNING: This feature is still under development and its usage might change in the coming versions of Rivet. Description of this procedure was prepared for Rivet version 2.7.2.

Event mixing is a procedure that enables to project out an event mixed of several events. In Rivet it is implemented in a form of a projection class called EventMixingProjection. It is based on a mixing observable provided as an input to define what should qualify as a mixable event, where the mixing observable can be defined as number of final state particles, centrality, event plane angle, etc. It contains a buffer that is filled with events over the runtime. This buffer can be used within an analysis to perform required operations. A declaration of an event mixing projection looks like this:
```cpp
void init () {
  [...]
  // Charged final state to manage the mixing observable
  ChargedFinalState cfsMult(Cuts::abseta < 0.8);
  addProjection(cfsMult, "CFSMult");
  // Primary particles.
  PrimaryParticles pp({Rivet::PID::PIPLUS, Rivet::PID::KPLUS, 
  Rivet::PID::K0S, Rivet::PID::K0L, Rivet::PID::PROTON, 
  Rivet::PID::NEUTRON, Rivet::PID::LAMBDA, Rivet::PID::SIGMAMINUS,
  Rivet::PID::SIGMAPLUS, Rivet::PID::XIMINUS, Rivet::PID::XI0, 
  Rivet::PID::OMEGAMINUS},Cuts::abseta < etamax && Cuts::pT > pTmin*GeV);
  addProjection(pp,"APRIM");
  // The event mixing projection
  declare(EventMixingFinalState(&cfsMult, pp, 5, 0, 100, 10),"EVM");
  
  [...]
}
```
In this case the first parameter of the event mixing projection defines a mixing observable. The second parameter is used to project out an event that is added to the buffer. The other parameters are: number of events to mix, minimal and maximal value of the mixing observable, and number of bins for that observable (so that for each bin there is a separate buffer). One can use it in the analyze method like this:
```cpp
void analyze(const Event& event) {
  [...]
  const EventMixingFinalState& evm = applyProjection<EventMixingFinalState>(event, "EVM");
  // Test if we have enough mixing events available to continue.
  if (!evm.hasMixingEvents()) return;
  // Loop over the particles in the mixing buffer
  for(const Particle& pMix : evm.particles()){
    [...]
  }
  [...]
}
```
This enables to check if we already have enough events in our buffer (method hasMixingEvents will return false in case the number of events in the buffer is lower than requested) and gives us access to the mixing buffer within the analysis. Note, that in this case first few events will be skipped as we require our buffers to be filled before going further. Full example can be found here:
```cpp
// -*- C++ -*-
#include "Rivet/Analysis.hh"
#include "Rivet/Projections/AliceCommon.hh"
#include "Rivet/Projections/PrimaryParticles.hh"
#include "Rivet/Projections/ChargedFinalState.hh"
#include "Rivet/Projections/EventMixingFinalState.hh"
namespace Rivet {


  /// @brief Correlations of identified particles in pp.
  /// Also showcasing use of EventMixingFinalState.

  class ALICE_2016_I1507157 : public Analysis {
  public:

    /// Constructor
    DEFAULT_RIVET_ANALYSIS_CTOR(ALICE_2016_I1507157);


    /// @name Analysis methods
    //@{
        
    /// @brief Calculate angular distance between particles.
    double phaseDif(double a1, double a2){
      double dif = a1 - a2;
      while (dif < -M_PI/2)
        dif += 2*M_PI;
      while (dif > 3*M_PI/2)
        dif -= 2*M_PI;
      return dif;
    }


    /// Book histograms and initialise projections before the run
    void init() {

      double etamax = 0.8;
      double pTmin = 0.5; // GeV 
	
      // Trigger
      declare(ALICE::V0AndTrigger(), "V0-AND");
      // Charged tracks used to manage the mixing observable.
      ChargedFinalState cfsMult(Cuts::abseta < etamax);
      addProjection(cfsMult, "CFSMult");
      
      // Primary particles.
      PrimaryParticles pp({Rivet::PID::PIPLUS, Rivet::PID::KPLUS, 
	Rivet::PID::K0S, Rivet::PID::K0L, Rivet::PID::PROTON, 
	Rivet::PID::NEUTRON, Rivet::PID::LAMBDA, Rivet::PID::SIGMAMINUS,
       	Rivet::PID::SIGMAPLUS, Rivet::PID::XIMINUS, Rivet::PID::XI0, 
	Rivet::PID::OMEGAMINUS},Cuts::abseta < etamax && Cuts::pT > pTmin*GeV);
      addProjection(pp,"APRIM");

      // The event mixing projection
      declare(EventMixingFinalState(&cfsMult, pp, 5, 0, 100, 10),"EVM");
      // The particle pairs.
      pid = {{211, -211}, {321, -321}, {2212, -2212}, {3122, -3122}, {211, 211},
             {321, 321}, {2212, 2212}, {3122, 3122}, {2212, 3122}, {2212, -3122}};
      // The associated histograms in the data file.
      vector<string> refdata = {"d04-x01-y01","d04-x01-y02","d04-x01-y03",
        "d06-x01-y02","d05-x01-y01","d05-x01-y02","d05-x01-y03","d06-x01-y01",
        "d01-x01-y02","d02-x01-y02"};
      for (int i = 0, N = refdata.size(); i < N; ++i) {
        // The ratio plots.
	ratio.push_back(bookScatter2D(refdata[i], true));
	// Signal and mixed background.
        signal.push_back(bookHisto1D("/TMP/" + refdata[i] +
			"-s", *ratio[i], refdata[i] + "-s"));	
        background.push_back(bookHisto1D("/TMP/" + refdata[i] + 
			"-b", *ratio[i], refdata[i] + "-b"));	
        // Number of signal and mixed pairs.
	nsp.push_back(0.);
        nmp.push_back(0.);
      } 
    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {
      const double weight = event.weight();
     
      // Triggering
      if (!apply<ALICE::V0AndTrigger>(event, "V0-AND")()) return;
      // The projections
      const PrimaryParticles& pp = 
        applyProjection<PrimaryParticles>(event,"APRIM");
      const EventMixingFinalState& evm = 
        applyProjection<EventMixingFinalState>(event, "EVM");

      // Test if we have enough mixing events available to continue.
      if (!evm.hasMixingEvents()) return;

      for(const Particle& p1 : pp.particles()) {
        // Start by doing the signal distributions
	for(const Particle& p2 : pp.particles()) {
	  if(isSame(p1,p2))
	    continue;
	  double dEta = abs(p1.eta() - p2.eta());
	  double dPhi = phaseDif(p1.phi(), p2.phi());
	  if(dEta < 1.3) {
	    for (int i = 0, N = pid.size(); i < N; ++i) {
	      int pid1 = pid[i].first;
	      int pid2 = pid[i].second;
	      bool samesign = (pid1 * pid2 > 0);
	      if (samesign && ((pid1 == p1.pid() && pid2 == p2.pid()) || 
		 (pid1 == -p1.pid() && pid2 == -p2.pid()))) {
	        signal[i]->fill(dPhi, weight);
		nsp[i] += 1.0;
	      }
	      if (!samesign && abs(pid1) == abs(pid2) &&
		  pid1 == p1.pid() && pid2 == p2.pid()) {
	            signal[i]->fill(dPhi, weight);
		    nsp[i] += 1.0;
	      }
	      if (!samesign && abs(pid1) != abs(pid2) && 
		  ( (pid1 == p1.pid() && pid2 == p2.pid()) ||
		  (pid2 == p1.pid() && pid1 == p2.pid()) ) ) {
	            signal[i]->fill(dPhi, weight);
		    nsp[i] += 1.0;
	      }
	    }
	  }
	}
	// Then do the background distribution
	for(const Particle& pMix : evm.particles()){
	  double dEta = abs(p1.eta() - pMix.eta());
	  double dPhi = phaseDif(p1.phi(), pMix.phi());
	  if(dEta < 1.3) {
	    for (int i = 0, N = pid.size(); i < N; ++i) {
	      int pid1 = pid[i].first;
	      int pid2 = pid[i].second;
	      bool samesign = (pid1 * pid2 > 0);
	      if (samesign && ((pid1 == p1.pid() && pid2 == pMix.pid()) || 
		 (pid1 == -p1.pid() && pid2 == -pMix.pid()))) {
	            background[i]->fill(dPhi, weight);
		    nmp[i] += 1.0;
	      }
	      if (!samesign && abs(pid1) == abs(pid2) &&
		  pid1 == p1.pid() && pid2 == pMix.pid()) {
	            background[i]->fill(dPhi, weight);
		    nmp[i] += 1.0;
	      }
	      if (!samesign && abs(pid1) != abs(pid2) && 
		  ( (pid1 == p1.pid() && pid2 == pMix.pid()) ||
		  (pid2 == p1.pid() && pid1 == pMix.pid()) ) ) {
	            background[i]->fill(dPhi, weight);
		    nmp[i] += 1.0;
	      }
	    }
	  }
	}
      }
    }


    /// Normalise histograms etc., after the run
    void finalize() {
      for (int i = 0, N = pid.size(); i < N; ++i) {
        double sc = nmp[i] / nsp[i];
	signal[i]->scaleW(sc);
	divide(signal[i],background[i],ratio[i]);
      }
    }

    //@}


    /// @name Histograms
    //@{
    vector<pair<int, int> > pid;
    vector<Histo1DPtr> signal;
    vector<Histo1DPtr> background;
    vector<Scatter2DPtr> ratio;
    vector<double> nsp;
    vector<double> nmp;

    //@}

  };

  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2016_I1507157);

}

```
