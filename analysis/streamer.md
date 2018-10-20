
    `Dear experts,
            my task worked fine <enter_date> but now 
            on grid it does not. can you take a look ? '
            

Many weird errors are caused by misuse of the **ROOT’s Streamer** So
what is the ‘**streamer** to begin with?

-   The ROOT streamer **decomposes** an object into its data members
    (**serialization**) and writes it to disk

``` {.numberLines .c language="C" numbers="left"}
class Polygon
{
 private:
  int width, height;
}
```

Streamer’s job:

-   save value of height, width

[The automatically generated streamer]{} ROOT automaticaly generates a
steamer for us

-   In our task, we defined

          // tell ROOT the class version
          ClassDef(AliAnalysisMyTask,1);
        };
        #endif

-   which constructs a streamer using the `ClassDef` macro (it does much
    more, if you’re interested, see `$ROOTSYS/include/Rtypes.h`)

What we have to do: **customize** it

-   Customization means defining what data members **should** and
    **should not** be touched by the streamer

-   Customization is done in the **.h** of a class ...

-   ... in the **comments after** data members (i.e. ‘//’)

which (I personally) find easy to miss ...

### Customizing: ‘member persistence’

-   Persistent Members (//) are ‘streamed’ (copied/stored)

            class SomeClass : public TObject {
                private:
                   Int_t   fMinEta;     // min eta value
                   Int_t   fMaxEta;     // max eta value
                      ...
            

-   Transient Members (//!) are **not** streamed

            class SomeClass : public TObject {
                      ...
                   AliAODEvent*    fAOD;        //! current event
                   TH1F*           fHistPt;     //! our histogram
            

For these classes

-   fMinEta and fMaxEta will be stored (//)

-   fAOD and fHistPt will be ignored (//!)

### There is (always) more

-   The Pointer to Objects (//-$>$) calls streamer of the object
    directly

            class SomeClass : public TObject {
                private:
                   TClonesArray  *fTracks;            //->
                      ...
            

-   Variable Length Array, (so that not just the pointer is copied)

            class SomeClass : public TObject {
                      Int_t          fNvertex;
                      ...
                      Float_t       *fClosestDistance;   //[fNvertex]
            

All this is explained in **detail** in 11.3 of the ROOT documentation

-   https://root.cern.ch/root/htmldoc/guides/users-guide/ROOTUsersGuide.html\#streamers

[How can this go wrong?]{} If you run **locally**, your task is
(probably) never copied, ergo

-   The streamer information is never used

-   // and //! are equivalent

If you run on GRID/LEGO, the situation is different:

-   Your task is initialized **locally** and added to the **manager**

-   The manager is **stored** locally in a .root file

-   This file is **copied** to grid nodes, invoking the streamer

-   At the grid node, a ‘**fresh**’ instance of your task is created

-   Non-persistent members are initialized to their default values found
    in the **empty I/O constructor** (remember slides 9 and 10)

-   **Persistent** members are read from the .root file

Special care should **always** be taken with **pointer members**

[Example 1 - ‘unexpected’ behavior]{}

    class SomeClass : public TObject 
        Int_t   fAbsEta; //!
        // setter
        SetAbsEta(Float_t eta) {fAbsEta = eta;}
    |\pause|
        // ROOT IO constructor
    SomeClass::SomeClass() : 
    fAbsEta(0) {;}
    |\pause|
    // and you configure your task
    SomeClass->SetAbsEta(3);
       

after copying (e.g. to grid) fAbsEta = 0 !

    class SomeClass : public TObject 
        Int_t   fAbsEta; //
        // setter
        SetAbsEta(Float_t eta) {fAbsEta = eta;}
    |\pause|
        // ROOT IO constructor
    SomeClass::SomeClass() : 
    fAbsEta(0) {;}
    |\pause|
    // and you configure your task
    SomeClass->SetAbsEta(3);
            

after copying (e.g. to grid) fAbsEta = 3 !

[Example 2 - Common segfaults]{} Look at the functions of AnalysisTaskSE
and **when** they’re called

      // constructor: called locally
      AliAnalysisMyTask(const char*);
      // function called once at RUNTIME
      virtual void UserCreateOutputObjects();
      // functions for each event at RUNTIME
      virtual void UserExec(Option_t*);
        

**RUNTIME** is on GRID. Copying uninitialized objects will go wrong, so
generally, **pointers initialized at RUNTIME should be non-persistent**
(//!)

-   streaming un-initialized pointers leads to **segfaults**

-   Rule-of-thumb: for all your **output** histograms, use

                    TH1F*       fHistPt;        //! pt histo

-   and **initialize** your pointers to 0x0 in your constructors

### ‘Automatic Schema Evolution’

[‘Automatic Schema Evolution’]{}

       `The StreamerInfo of class AliAnalysisTaskMyTask
       has the same version (=1) as the active class but a 
       different checksum.  Do not try to write, ..., 
       the files will not be readable.'

If you **develop** your code, the layout of persistent members probably
changes

``` {.numberLines .c language="C" numbers="left"}
class Polygon
{
 private:
  int width;
}
```

size = 4 bytes

``` {.numberLines .c language="C" numbers="left"}
class Polygon
{
 private:
  int width, height;
}
```

size = 8 bytes

-   The **ClassDef value** bookkeeps this evolution for ROOT and avoids
    compatibility problems

### Upgrading the ClassDef() value

-   **Changing** the list of **persistent** members

            class SomeClass : public TObject {
                private:
                   Int_t   fAbsEta;     // min eta value
                      ...
            ClassDef(SomeClass, 1);
            

-   should lead to an **increase**

             class SomeClass : public TObject {
                private:
                   Int_t   fMinEta;     // min eta value
                   Int_t   fMaxEta;     // max eta value
                ...
            ClassDef(SomeClass, 2);
            

Memory layout changes: ClassDef should reflect this

### Upgrading the ClassDef() value

-   Changing the list of **non-persistent** members

            class SomeClass : public TObject {
                private:
                   Int_t   fAbsEta;     //! min eta value
                      ...
            ClassDef(SomeClass, 1);
            

-   does **not** change this

             class SomeClass : public TObject {
                private:
                   Int_t   fMinEta;     //! min eta value
                   Int_t   fMaxEta;     //! max eta value
                ...
            ClassDef(SomeClass, 1);
            

Memory layout does not change
