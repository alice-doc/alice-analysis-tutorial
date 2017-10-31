# The track loop

In this exercise we are going to study the particles that are produced in each event. Out end goal is to identify charged pions, but first we’ll familiarize ourselves with the analysis code some more.

* plot the pseudorapidity and azimuthal distributions of the particles for all accepted events in a two-dimensional histogram

* make sure that the axis have proper ranges (how large is the detector?) and a reasonable amount of bins

If you’ve added this histogram, run the analysis, and look at the two dimensional histogram. Does the distribution make sense?

`TIP`

If you have no idea how to extract information on tracks (like azimuthal angle, pseudorapidity, etc) from tracks, it can be useful to look in the source file of the track class to see if you find what you need. You can see that the track class if of type AliAODTrack. You can open the header file of that class **AliAODTrack.h** to see which methods are defined in this class, to give you a flavor

```

  // kinematics
  virtual Double_t OneOverPt() const { return (fMomentum[0] != 0.) ? 1./fMomentum[0] : -999.; }
  virtual Double_t Phi()       const { return fMomentum[1]; }
  virtual Double_t Theta()     const { return fMomentum[2]; }
  
  virtual Double_t Px() const { return fMomentum[0] * TMath::Cos(fMomentum[1]); }
  virtual Double_t Py() const { return fMomentum[0] * TMath::Sin(fMomentum[1]); }
  virtual Double_t Pz() const { return fMomentum[0] / TMath::Tan(fMomentum[2]); }
  virtual Double_t Pt() const { return fMomentum[0]; }
  virtual Double_t P()  const { return TMath::Sqrt(Pt()*Pt()+Pz()*Pz()); }
  virtual Bool_t   PxPyPz(Double_t p[3]) const { p[0] = Px(); p[1] = Py(); p[2] = Pz(); return kTRUE; }

  virtual Double_t Xv() const { return GetProdVertex() ? GetProdVertex()->GetX() : -999.; }
  virtual Double_t Yv() const { return GetProdVertex() ? GetProdVertex()->GetY() : -999.; }
  virtual Double_t Zv() const { return GetProdVertex() ? GetProdVertex()->GetZ() : -999.; }
  virtual Bool_t   XvYvZv(Double_t x[3]) const { x[0] = Xv(); x[1] = Yv(); x[2] = Zv(); return kTRUE; }

```

It can be hard at first to find where members and methods are defined, and what the design of a software package is. An **IDE** might help you with that. 



# Track selection

Just as some events are not of fit to do analysis with, some tracks are also not good for looking at certain observables. In addition to ’event cuts’, we therefore have to apply ’track cuts’ as well. In ALICE, we usually use a system of predefined track selection criteria, that are checked by reading the `filterbit` of a track - see the DPG talk !

* Check in the code where the filterbit selection is done

* Change the filterbit selection from value 1 to 128 to 512

How does your eta, phi distribution change, if you run your task again with filterbit 512? What do you think is the cause of the difference? Please ask one of us to explain this in a bit more detail.

`TIP`

* If you ran your task again, you have - most likely - overwritten the output of the previous run, which makes it hard to compare the distributions obtained with the different filterbits - it can be useful to keep all output files you generate on a safe place on your hard drive

* ... _if you keep the files_ make sure that you will remember which event and track selections you used. In a few weeks, you have probably forgotten which filterbit was set for a certain output file. You can create readme files, or add a histogram as bookkeeping device.
