# Introduction to heavy-ion features

Several heavy-ion features were added to the recent version of Rivet (2.7.x). The ones that will be used in this tutorial are described below. In order to get to know other heavy-ion features go to section ...

A lot of heavy-ion analyses require calibrating on some global event observable e.g. centrality, thrust, etc. There might be multiple approaches on how to deal with this: using the calibration provided by the experiment together with the analysis, generating your own calibration files, or even using values provided by the generator. All mentioned solutions are already supported by Rivet. On top of that, the first two methods are supported in a form of a new kind of analyses, so called calibration analyses. They are 'dummy' analyses used to produce calibration plots that are afterwards used by our main analysis.

## Calibration analysis

A calibration analysis is essential in case our generator does not provide some global event observable(s) required by the main analysis. Such calibration analysis is similar to the regular one but instead of producing comparisons to the existing experimental data it produces distributions of different observables, such as impact parameter distribution. It should be pointed out that there might be multiple analyses using the same calibration analysis. An example of a calibration analysis producing a V0M multiplicity distribution and an impact parameter distribution is provided below:
```cpp
#include <Rivet/Analysis.hh>
#include <Rivet/Projections/AliceCommon.hh>

namespace Rivet {

  class ALICE_2015_PBPBCentrality : public Analysis {
  public:
    ALICE_2015_PBPBCentrality()
      : Analysis("ALICE_2015_PBPBCentrality") { }

    void init() {
      ALICE::V0AndTrigger v0and;
      declare<ALICE::V0AndTrigger>(v0and, "V0-AND");

      ALICE::V0MMultiplicity v0m;
      declare<ALICE::V0MMultiplicity>(v0m, "V0M");

      _v0m = bookHisto1D("V0M", "Forward multiplicity", "V0M", "Events");
      _imp = bookHisto1D("V0M_IMP", 100, 0, 20, "Impact parameter", "b (fm)", "Events");
    }

    void analyze(const Event& event) {
      // Get and fill in the impact parameter value if the information is valid
      const HepMC::GenEvent* ge = event.genEvent();
      const HepMC::HeavyIon* hi = ge->heavy_ion();
      if (hi && hi->is_valid())
        _imp->fill(hi->impact_parameter(), event.weight());
      
      // Check if we have any hit in either V0-A or -C.  If not, the
      // event is not selected and we get out
      if (!apply<ALICE::V0AndTrigger>(event,"V0-AND")()) return;

      // Fill in the V0 multiplicity for this event 
      _v0m->fill(apply<ALICE::V0MMultiplicity>(event,"V0M")(), event.weight());
    }

    void finalize() {
      _v0m->normalize();
      _imp->normalize();
    }

    // The distribution of V0M multiplicity
    Histo1DPtr _v0m;
    // The distribution of impact parameters
    Histo1DPtr _imp;
  };
  DECLARE_RIVET_PLUGIN(ALICE_2015_PBPBCentrality);
}
```

This calibration analysis can be run in the same way as any other analysis:
```
rivet -a ALICE_2015_PBPBCentrality -o calibration.yoda /path/to/generator.hepmc
```
This will produce the calibration plots and save them to calibration.yoda to use in the future. Once this is done we can proceed to the next step.

## Selecting calibration method

Any analysis can load yoda files from calibration analysis assuming it contains the necessary information about the calibration methods. Possible options that allow the selection of the calibratino method are the following:
* REF (default): get calibration histogram from reference data
* GEN: get generated calibration histogram
* IMP: get impact parameter calibration histogram
* USR: get user-defined calibration histogram
* RAW: get generated centrality (available only with HepMC3)

The information about possible methods for a particular analysis is stored in the .info file of this analysis. An example of how an .info file may look like is provided below:
```
[...]
Options:
 - cent=REF,GEN,IMP,USR
Beams: [1000822080, 1000822080] # PDG of lead ion
Energies: [574080] # This is _total_ energy of beams, so this becomes 208*2760=574080
[...]
```
## Preloading calibration files

In order to run an analysis with preloading calbration file one needs to use '-p' flag (see rivet --help) to provide the path to the calibration .yoda file and choose a method of calibration by adding ':var=METHOD' after the name of the analysis. This will look something like that:
```
rivet -a ALICE_<year>_I<inspireID>:cent=GEN -p /path/to/calibration.yoda /path/to/generator.hepmc
```
This means that Rivet will run our selected analysis with an option GEN (generated calibration histogram) for the centrality calibration using the plots stored in calibration.yoda file. In case of not specifying the calibration method, Rivet will try to access the reference calibration file - if it was not provided with the calibration analysis the run will fail. Next section will cover how to access and use the centrality value inside the main analysis.

## Extracting centrality

Preloading and selecting method of calibration of centrality gives us access to the centrality value inside our main analysis. This is done in a form of a special projection class CentralityProjection. It allows an analysis to cut on percentiles of single event quantities preloaded (or supplied by the experiment) from a histogram. In order to use it one needs to declare it in the init function:
```cpp
void init () {
  [...]
  // Declare centrality projection for centrality estimation
  const CentralityProjection cp = declareCentrality(ALICE::V0MMultiplicity(),
  "ALICE_2015_PBPBCentrality", "V0M", "V0M );
  [...]
}
```
Then, one can use it to extract centrality value in the analyze function like this:
```cpp
const CentralityProjection& centrProj = apply<CentralityProjection>(event, "V0M");
double centr = centrProj();
```
This gives us a value of centrality as a percentage and it can be used to do whatever one wants to do with it: fill the histogram as a function of centrality, fill the histograms for different centrality ranges, remove events with particular centrality, etc. A full example of an analysis using centrality is provided below:
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
#include <cmath>

namespace Rivet {

  /// @brief ALICE PbPb at 2.76 TeV multiplicity at mid-rapidity
  class ALICE_2010_I880049 : public Analysis {

  public:

    /// Constructor
    DEFAULT_RIVET_ANALYSIS_CTOR(ALICE_2010_I880049);

    /// @name Analysis methods
    //@{

    /// Book histograms and initialise projections before the run
    void init() {

      // Declare centrality projection
      declareCentrality(ALICE::V0MMultiplicity(),
        "ALICE_2015_PBPBCentrality", "V0M", "V0M");

      // Trigger projections
      declare(ChargedFinalState((Cuts::eta > 2.8 && Cuts::eta < 5.1) &&
        Cuts::pT > 0.1*GeV), "VZERO1");
      declare(ChargedFinalState((Cuts::eta > -3.7 && Cuts::eta < -1.7) &&
        Cuts::pT > 0.1*GeV), "VZERO2");
      declare(ChargedFinalState(Cuts::abseta < 1. && Cuts::pT > 0.15*GeV),
        "SPD");

      // Charged, primary particles with |eta| < 0.5 and pT > 50 MeV
      declare(ALICE::PrimaryParticles(Cuts::abseta < 0.5 &&
        Cuts::pT > 50*MeV && Cuts::abscharge > 0), "APRIM");

      // Histograms and variables initialization
      _histNchVsCentr = bookProfile1D(1, 1, 1);
      _histNpartVsCentr = bookProfile1D(1, 1, 2);

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {

      const double weight = event.weight();

      // Charged, primary particles with at least pT = 50 MeV
      // in eta range of |eta| < 0.5
      Particles chargedParticles =
        applyProjection<ALICE::PrimaryParticles>(event,"APRIM").particles();

      // Trigger projections
      const ChargedFinalState& vz1 =
        applyProjection<ChargedFinalState>(event,"VZERO1");
      const ChargedFinalState& vz2 =
        applyProjection<ChargedFinalState>(event,"VZERO2");
      const ChargedFinalState& spd =
        applyProjection<ChargedFinalState>(event,"SPD");
      int fwdTrig = (vz1.particles().size() > 0 ? 1 : 0);
      int bwdTrig = (vz2.particles().size() > 0 ? 1 : 0);
      int cTrig = (spd.particles().size() > 0 ? 1 : 0);

      if (fwdTrig + bwdTrig + cTrig < 2) vetoEvent;

      const CentralityProjection& centrProj =
        apply<CentralityProjection>(event, "V0M");
      double centr = centrProj();
      if (centr > 80.)
        vetoEvent;

      // Calculate number of charged particles and fill histogram
      double nch = chargedParticles.size();
      _histNchVsCentr->fill(centr, nch, weight);

      // Attempt to extract Npart form GenEvent.
      // TODO: Unclear how to handle this in HepMC3
      const HepMC::HeavyIon* hi = event.genEvent()->heavy_ion();
      if (hi && hi->is_valid()) {
        _histNpartVsCentr->fill(centr, hi->Npart_proj() + hi->Npart_targ(),
          weight);
      }
    }


    /// Normalise histograms etc., after the run
    void finalize() {

    }

    //@}

  private:

    /// @name Histograms
    //@{
    Profile1DPtr _histNchVsCentr;
    Profile1DPtr _histNpartVsCentr;
    //@}

  };

  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2010_I880049);

}
```

# Run an example

We can now try to run an aleady installed Rivet software with an already existing example analysis with an already existing .hepmc file and (optionally) .yoda calibration file. In order to do that follow the steps described below.

Log in to your lxplus account (check that you have an access to lxplus [here](https://resources.web.cern.ch/resources/Manage/ListServices.aspx)):
```
ssh <username>@lxplus.cern.ch
```
After logging in you can enter the environment as follows:
```
alienv enter Rivet
```
This will load all the environment required for Rivet. You can try out that it is working by typing for example:
```
rivet --help
```
Also, the following command should prompt us that we are going to use Rivet version 2.7.2:
```
rivet --version
```
You can also list available ALICE analyses by typing:
```
rivet --list-analyses | grep ALICE_
```
Now, as an example we are going to use the analysis ALICE_2010_I880049 together with the calibration analysis ALICE_2015_PBPBCentrality. We will use a .hepmc file that contains some events generated with EPOS-LHC for PbPb beam at 2.76 TeV, which corresponds to our analysis and is located here: /eos/project/a/alipwgmm/epos_PbPb_276TeV_1k.hepmc

First, we need to run our calibration analysis
```
rivet -a ALICE_2015_PBPBCentrality -o calibration.yoda /eos/project/a/alipwgmm/epos_PbPb_276TeV_1k.hepmc
```
This will produce our calibration plots (beware that this might take some time). In case of any problems with generating these plots you can use already generated ones here: /eos/project/a/alipwgmm/calibration.yoda

Next step is to run the main analysis. Let's choose for example generated V0M multiplicity distribution as calibration method. We will use the same .hepmc file as we used for calibration (it doesn't have to be the same) and run Rivet again:
```
rivet -a ALICE_2010_I880049 -p /path/to/calibration.yoda /eos/project/a/alipwgmm/epos_PbPb_276TeV_1k.hepmc
```
Again, this might take some time. After it's done, you can create the plots like that:
```
rivet-mkhtml Rivet.yoda
```
