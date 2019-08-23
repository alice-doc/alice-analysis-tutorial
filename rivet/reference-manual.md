# Reference manual for Rivet in ALICE

## Booking histograms/profiles
There are several ways to book a histogram:
* corresponding to HepData
```cpp
_hist = bookHisto1D("d01-x01-y01");
```
* re-using properties from HepData
```cpp
_hist = bookHisto1D("TMP/test", refData(1, 1, 1));
```
* manual
```cpp
_hist = bookHisto1D("pt_h", 10, 0., 20., "final state particles", "$p_\\perp$", "counts");
_prof = bookProfile1D("cos2phi_pt_h", 10, 0., 20.);
```

## Booking projections
### particle level
In order to select all final state particles in a given rapidity range:
```cpp
      const FinalState fs(-_etamax, _etamax);
      addProjection(fs, "FS");
```
or if you want to constrain to charged particles:
```cpp
      const ChargedFinalState cfs(-_etamax, _etamax);
      addProjection(cfs, "CFS");
```
You can further add a minimum transverse momentum and particle identification:
```cpp
      IdentifiedFinalState pionfs(-_etamax, _etamax, 0.*GeV);
      pionfs.acceptId(111);
      addProjection(pionfs, "PIONFS");
```
### derived projections
You can also add projections which are derived from a final state, e.g. for multiplicity:
```cpp
    addProjection(Multiplicity(fs), "Mult");
```
or for thrust:
```cpp
    addProjection(Thrust(fs), "Thrust");
```
### jets
In order to add a projection for jets, you first have to add (or re-use) a particle-level projection which serves as input to a jet finder. You can use the jet finders provided with the FastJet package.
```cpp
      const FinalState fs_jet(-_etamax - _jet_r, _etamax + _jet_r);
      addProjection(fs_jet, "FS_JET");
      FastJets fj02(fs_jet, FastJets::ANTIKT, _jet_r);
      fj02.useInvisibles();
      addProjection(fj02, "Jets02");
```
### and more ...
The list of basic projections can be found under the Hepforge page for Rivet : Rivet code - projection dir￼.

## Normalisation
You can normalize a given histogram to unity:
```cpp
    normalize(_h_sin2phi);
```
You can normalize to the number of events:
```cpp
      scale(_h_stat, 1. / sumOfWeights());
```
or to cross section:
```cpp
      scale(_h_stat, crossSection() / sumOfWeights());
```
You might have to account for the considered phase space:
```cpp
      const double fac = crossSection() / (millibarn * sumOfWeights() * 2 * pi * 2 * _etamax);
      scale(_h_pt_jet02, fac);
```
