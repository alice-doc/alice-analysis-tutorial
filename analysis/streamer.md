# The ROOT Streamer

Sometimes, mails like

    `Dear experts,
            my task worked fine <enter_date> but now 
            on grid it does not. can you take a look ? '
            
are sent on the mailing list. Some unexpected errors are caused by misuse of the **ROOT streamer**. The streamer has been mentioned a couple of times before now in other sections. So what is the ‘**streamer** to begin with?

-   The ROOT streamer **decomposes** an object into its data members
    (**serialization**) and writes it to disk

This sounds more confusing than it is. Take a look at our class example from section 1

```cpp
class Polygon
{
 private:
  int width, height;
}
```

The job of the streamer here would be, to save values of height and width, so that they can be written to disk. 

## The automatically generated streamer
ROOT automatically generates a steamer for us, if we instruct it to do so. Remember from the earlier sections, that we put the following lines in our task:

```cpp
          // tell ROOT the class version
          ClassDef(AliAnalysisMyTask,1);
        };
```
By doing this, a streamer is constructed for us by invoking the `ClassDef` macro. 

## Customization
ROOT generates a streamer for us, but we have the task of customizing it. Customization means defining what data members **should** and **should not** be touched by the streamer. Customization is done in the **header \*.h)** of a class, by giving specific instructions in the comments written after the declaration of data members (i.e. ‘//’). Let's take a look at this in practice. 

## Customizing: ‘member persistence’

-   Persistent Members (//) are ‘streamed’ (copied/stored)
```cpp
            class SomeClass : public TObject {
                private:
                   Int_t   fMinEta;     // min eta value
                   Int_t   fMaxEta;     // max eta value
                      ...
```            

-   Transient Members (//!) are **not** streamed
```cpp
            class SomeClass : public TObject {
                      ...
                   AliAODEvent*    fAOD;        //! current event
                   TH1F*           fHistPt;     //! our histogram
```            

So if we would write the object defined by the code snippets above to disk, the value of `fMinEta` and `fMaxEta` will be saved (//), but the values of  `fAOD` and `fHistPt` will be ignored (//!).

{% callout " There is more " %}
We can customize the streamer in more sophisticated ways

-   The Pointer to Objects (//-$>$) calls streamer of the object
    directly
```cpp
            class SomeClass : public TObject {
                private:
                   TClonesArray  *fTracks;            //->
                      ...
```            

-   Variable Length Array, (so that not just the pointer is copied)
```cpp
            class SomeClass : public TObject {
                      Int_t          fNvertex;
                      ...
                      Float_t       *fClosestDistance;   //[fNvertex]
```           
All this is explained in **detail** in 11.3 of the ROOT documentation https://root.cern.ch/root/htmldoc/guides/users-guide/ROOTUsersGuide.html
{% endcallout %}

# Pitfalls 
We started this section out, by saying that the streamer definition can be a source of confusion. Why is this so? 

Let's start by realizing when the streamer definition is actually relevant: this is when objects are written to disk or copied. If you run your analysis **locally**, your analysis task is (probably) never copied or stored to disk, ergo the streamer information is never used and specifying // or //! are equivalent

If you run on Grid, or on the LEGO train system, the situation is different, and the following happens

-   Your task is initialized **locally** and added to the analysis **manager**
-   The manager is **stored** locally in a .root file
-   This file is **copied** to grid nodes, invoking the streamer
-   At the grid node, a **fresh** instance of your task is created
-   Non-persistent members are initialized to their default values found
    in the **empty I/O constructor** (remember that we said in Section 3: you always need to specify an empty I/O constructor for your classes!)
-   **Persistent** members are read from the .root file


{% challenge "Example 1 - 'unexpected' behavior" %}

Take a look at the class below
```cpp
    class SomeClass : public TObject 
        Int_t   fAbsEta; //!
        // setter
        SetAbsEta(Float_t eta) {fAbsEta = eta;}
    
        // ROOT IO constructor
    SomeClass::SomeClass() : 
    fAbsEta(0) {;}
    
```
In your steering macro, you call
```
    SomeClass->SetAbsEta(3);
```
You now launch your analysis to run on the Grid. What is the value of `fAbsEta` when the analysis starts to run at a Grid node?
{% solution "Drum roll" %}
After copying (e.g. to grid) the value of `fAbsEta` = 0. The member is *not persistent* (//!), so after copying, the value of `fAbsEta` will be equal to its default value as specified in the I/O constructor of your class.
{% endchallenge %}

{% challenge "Example 2 - expected behavior?" %}
Now take a look at a second, very similar class:
```cpp
    class SomeClass : public TObject 
        Int_t   fAbsEta; //
        // setter
        SetAbsEta(Float_t eta) {fAbsEta = eta;}
    
        // ROOT IO constructor
    SomeClass::SomeClass() : 
    fAbsEta(0) {;}
```
Again, we call
```cpp
    SomeClass->SetAbsEta(3);
```          
And launch our analysis task on the Grid. What is the value of `fAbsEta` when your task starts to run on a Grid node? 
{% solution "Drum roll" %}
After copying (e.g. to grid) `fAbsEta` = 3. The member is declared as *persistent*, so the value it has is retained. 
{% endchallenge %}

So you see, that the streamer can have quite an important effect on your analysis!

## Runtime 

When you launch your analysis to Grid, it's important to realize that *some* methods of your analysis task are called on your laptop when you execute your steering macro, whereas other methods are only called on the Grid nodes. The execution on Grid is what we call `runtime`. 

Looking at the functions of our analysis task, we can e.g. say that 
```cpp
      // constructor: called locally
      AliAnalysisMyTask(const char*);

      // function called once at RUNTIME
      virtual void UserCreateOutputObjects();

      // functions for each event at RUNTIME
      virtual void UserExec(Option_t*);
```  

It makes no sense to make data members that are **initialized at runtime** persistent. Therefore, as a rule-of-thumb, for all your **output** histograms, use the flag for non-persistence, i.e.
```cpp
      TH1F*       fHistPt;        //! pt histo
```

## Automatic Schema Evolution
If you **develop** your code, the layout of persistent members of your class probably changes, i.e.

```cpp
class Polygon
{
 private:
  int width;
}
```
which would take up 4 bytes, could change to 

```cpp
class Polygon
{
 private:
  int width, height;
}
```
which would take up 8 bytes when written to disk. The **ClassDef value** of your class bookkeeps this evolution for ROOT and avoids compatibility problems such as

       `The StreamerInfo of class AliAnalysisTaskMyTask
       has the same version (=1) as the active class but a 
       different checksum.  Do not try to write, ..., 
       the files will not be readable.'

If you commit your code to AliPhysics (or AliROOT), you should make sure to increment the ClassDef value when you change the list of **persistent** members, i.e. if we have a class

```cpp
            class SomeClass : public TObject {
                private:
                   Int_t   fAbsEta;     // min eta value
                      ...
            ClassDef(SomeClass, 1);
```            
and we add a persistent member, we have to increment to ClassDef value
```cpp
             class SomeClass : public TObject {
                private:
                   Int_t   fMinEta;     // min eta value
                   Int_t   fMaxEta;     // max eta value
                ...
            ClassDef(SomeClass, 2);
```            
If the list of **non-persistent** members changes, e.g. when we change
```cpp
            class SomeClass : public TObject {
                private:
                   Int_t   fAbsEta;     //! min eta value
                      ...
            ClassDef(SomeClass, 1);
```
into   
```cpp
             class SomeClass : public TObject {
                private:
                   Int_t   fMinEta;     //! min eta value
                   Int_t   fMaxEta;     //! max eta value
                ...
            ClassDef(SomeClass, 1);
``` 
we **do not** have to increment the ClassDef value, because the streamer definition of the class does not change.             
