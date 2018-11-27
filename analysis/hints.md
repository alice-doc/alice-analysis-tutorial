# Some hints

To create documentation of analysis code, we use a system called ’Doxygen’. You can find explanation about Doxygen at this webpage: [https://dberzano.github.io/alice/doxygen/](https://dberzano.github.io/alice/doxygen/).

The Doxygen documentation of AliROOT and AliPhysics is available here [http://alidoc.cern.ch/](http://alidoc.cern.ch/) . It is generated daily.



## Cleaning up and improving your code

-   One of the most important things you can do is make sure your code
    is **readable**

-   This means using **whitespace** freely, **consistent indentation**,
    etc

-   This is **valid** C++ code:

```cpp
    for(int i=0;i<10;i++){cout<<"i is "<<i<<endl;}
```

but it looks **bad**

-   This is C++ code **equivalent** to that:

```cpp
    for(int i=0; i<10; i++)
      {
        cout << "i is " << i << endl;
      }
```

    and it looks much **better**

-   There are no wrongs or rights, but be **consistent**

## Fault tolerance

-   Check e.g. the snippet

```cpp
    for(Int_t i(0); i < iTracks; i++) {
        // loop over all the tracks
        AliAODTrack* track = static_cast<AliAODTrack*>(fAOD->GetTrack(i));
        // fill our histogram
        fHistPt->Fill(track->Pt());
    }
```

-   We can build in fault tolerance:

```cpp
    for(Int_t i(0); i < iTracks; i++) {
        // loop over all the tracks
        AliAODTrack* track = static_cast<AliAODTrack*>(fAOD->GetTrack(i));
        if(!track) continue;
        // fill our histogram
        fHistPt->Fill(track->Pt());
    }
```

-   Finally, it’s a very good idea to comment your code

-   Comments improve readability and maintainability

-   Comments should be useful, though, and comments that are overly
    obvious can be avoided

```cpp
    // no comment: bad
    a++;
    
    // pointless comment, also not so good

    a++; // adding 1 to a

    
    // descriptive comment, very good

    a++; // adding 1 to a to make a point during a tutorial
```

-   It’s also a good idea to document your code as you’re writing it -
    you **will** forget how it works and no-one will continue with
    uncommented tasks


