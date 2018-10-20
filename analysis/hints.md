# Some hints

To create documentation of analysis code, we use a system called ’Doxygen’. You can find explanation about Doxygen at this webpage: [https://dberzano.github.io/alice/doxygen/](https://dberzano.github.io/alice/doxygen/).

The Doxygen documentation of AliROOT and AliPhysics is available here [http://alidoc.cern.ch/](http://alidoc.cern.ch/) . It is generated daily.


coding conventions\
![image](q.png){width=".78\textwidth"}\

helping others understand your code

[Cleaning up and improving your code]{}

-   One of the most important things you can do is make sure your code
    is **readable**

-   This means using **whitespace** freely, **consistent indentation**,
    etc

-   This is **valid** C++ code:

    ``` {.numberLines .c language="C" numbers="left"}
    for(int i=0;i<10;i++){cout<<"i is "<<i<<endl;}
    ```

    but it looks **bad**

-   This is C++ code **equivalent** to that:

    ``` {.numberLines .c language="C" numbers="left"}
    for(int i=0; i<10; i++)
      {
        cout << "i is " << i << endl;
      }
    ```

    and it looks much **better**

-   There are no wrongs or rights, but be **consistent**

[Cleaning up and improving the code]{} Another very important thing to
do is build in **fault tolerance**

-   Check e.g. the snippet

    ``` {.numberLines .c language="C" numbers="left"}
    for(Int_t i(0); i < iTracks; i++) {
        // loop over all the tracks
        AliAODTrack* track = static_cast<AliAODTrack*>(fAOD->GetTrack(i));
        // fill our histogram
        fHistPt->Fill(track->Pt());
    }
    ```

-   We can build in fault tolerance:

    ``` {.numberLines .c language="C" numbers="left"}
    for(Int_t i(0); i < iTracks; i++) {
        // loop over all the tracks
        AliAODTrack* track = static_cast<AliAODTrack*>(fAOD->GetTrack(i));
        if(!track) continue;
        // fill our histogram
        fHistPt->Fill(track->Pt());
    }
    ```

[Cleaning up and improving the code]{}

-   Finally, it’s a very good idea to comment your code

-   Comments improve readability and maintainability

-   Comments should be useful, though, and comments that are overly
    obvious can be avoided\

    ``` {.numberLines .c language="C" numbers="left"}
    // no comment: bad
    a++;
    |\pause|
    // pointless comment, also not so good

    a++; // adding 1 to a

    |\pause|
    // descriptive comment, very good

    a++; // adding 1 to a to make a point during a tutorial
    ```

-   It’s also a good idea to document your code as you’re writing it -
    you **will** forget how it works and no-one will continue with
    uncommented tasks


