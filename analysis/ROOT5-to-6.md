# Transition from ROOT5 to ROOT6

*ROOT6* is similar to *ROOT5*: It comes with the same library of classes (base
classes, histogram classes like TH1, ...) which share the same interface as under
*ROOT5*. It provides a command line interface as *ROOT5*, and runs macros just
like under *ROOT5*. Therefore it is possible to build and run the ALICE
simulation, reconstruction and analysis framework under ROOT6. AliPhysics can be
built against *ROOT6* in the following way:

```bash
aliBuild -z --defaults root6 build AliPhysics
```

For classes in AliRoot or AliPhysics this transition is transparent. For code in
macros there are however a few difference. This page tries to summarize the
differences in behaviour observed so far and gives some suggestions how to solve
these issues so work can go on smoothly under *ROOT6*.

## What is a just-in-time compiler?

For the command line interface and running macros *ROOT5* uses *CINT*, which is an
interpreter for C/C++. An interpreter processes a macro line-by-line. It depends
on the implementation of the interpreter how C++ code will be handled and how
close the interpretation comes to the language standard. *ROOT5* allows for some
deviations from the language standards, which means that some coding errors
which would thrown by a compiler leading in a break of the compilation are still
tolerated by *ROOT5*. Furthermore the standard library is not fully supported as
its handling has to be implemented into the compiler. Macro can however also be
run in the compiled mode by ROOT5 (adding a "+" to the macro name). In this case
ROOT calls an external compiler to compile the macro to a library which is loaded
into ROOT. Once the macro runs in compiled mode it is expected to be fully
compatible with the C++ standard and coding error free as the compiler will not
tolerate compiler errors.

In contrast to this *ROOT6* uses a just-in-time compiler called *cling*. A
just-in-time compiler translates each statement, no matter whether it is a single
command or a complicated macro, into machine code as it would be a program and
only afterwards runs this piece of code. In order to translate code into machine
code the compiler must know how to translate every single line. Based on powerful
compiler library this means for *ROOT6* that all macro must comply to 100% with
the C++ language standard, and exceptions will not be tolerated. Furthermore this
also means that all symbols and objects must be known at compile time. This has
three side effects:

- Loading Functions with `gROOT->LoadMacro(...);`: This function loads all
  functions it finds within the macro into ROOT during run time. For an interpreter
  this is sufficient as the functions are used after they are loaded. However the
  compiler must know all symbols used in a macro at compile time.
- Loading libraries with `gSystem->Load(...);`: Here we have the same problem:
  The symbols in the libraries must be known before they are used.
- Compiling ALICE analysis tasks on the fly with `gROOT->LoadMacro("...+");`:
  As the analysis task compiled like this will be converted in a library it must be
  know to the just-in-time compiler before.

For all three cases exist workarounds which will be discussed in the next
sections. In general macros which were running under *ROOT5* in the compiled mode
will also run under *ROOT6*. Macros which were running only in the interpreted
mode might contain coding errors which were not handled by *ROOT5* and might
therefore need fixes. However the just-in-time compiler will give precise error
messages leading exactly to the lines which need fixes.

## How can I call macros inside macros?

Calling macros inside macros is a bit tricky as the result of a macro will be
available only at runtime. There are however several workarounds which cover the 
most common use cases:

- Using ROOT's TMacro:

  TMacro is a wrapper class around the macro processing. It is constructed with
  the macro path. The macro is run using TMacro::Exec. The result of
  TMacro::Exec() is a number representing an address in memory where to
  find the resulting object. This has to be cast into a pointer to an object of
  the expected type. Example:

  ```C++
  TMacro physseladd(gSystem->ExpandPathName("$ALICE_PHYSICS/OADB/macros/AddTaskPhysicsSelection.C"));
  AliPhysicsSelectionTask *physseltask = reinterpret_cast<AliPhysicsSelectionTask *>(physseladd.Exec());
  ```

  The macro is still evaluated at runtime, however with the reinterpret_cast to
  AliPhysicsSelectionTask \* we tell ROOT that the result of the macro
  interpretation must be of type AliPhysicsSelectionTask \*, so the type is known
  at compile time. TMacro::Exec optionally gets a string representation of the
  function arguments. This might be a bit complicated to handle, particularly if
  the arguments are dynamic and change at run time. The method works both for
  *ROOT5* and *ROOT6*.

- Using gROOT/gInterpreter->ProcessLine: 

  Macro execution can be launched as well via gROOT->ProcessLine() /
  gInterpreter->ProcessLine(). As with TMacro this method is focused on running
  a macro and not loading content from it. The ProcessLine method returns a
  long number representing an address in memory where to find the output objects.
  This number has to be cast to the expected output type using a
  reinterpret_cast in order to access the content of the output objects. The
  following example runs the add macro for the physics selection task:

  ```C++
  AliPhysicsSelectionTask *physseltask = reinterpret_cast<AliPhysicsSelectionTask *>(gInterpreter->ProcessLine(Form(".x %s", gSystem->ExpandPathName("$ALICE_PHYSICS/OADB/macros/AddTaskPhysicsSelection.C"))))
  ```

  Adding function arguments is possible here as well as a simple string
  representation after the macro path, surrounded with (). This method also works
  both under *ROOT5* and *ROOT6*.
  
  An example of adding function arguments using a TString literal (this method) is shown here. Suppose you
  have a dummy AddTask file that takes a boolean and and a string as arguments. The way
  to call this function would then be
  
  ```C++ 
    TString arguments = R"((kTRUE, "test.root"))";
    AliAnalysisTaskDummy *task = reinterpret_cast<AliAnalysisTaskDummy*>(gInterpreter->ProcessLine(".x AddTaskDummy.C" +  arguments));
  ```

  Note the syntax! The outer R"( and )" are part of the TString literal while the innner ( and ) 
  are there for the function call of AddTaskDummmy.
  
- Including macros:

  As *ROOT6* compiles the macro it is possible to include macros and treat them
  as if they were header files. In order for this to work it is essential to tell
  ROOT before where to find the macro. This can be done using the preprocessor
  macro `R_ADD_INCLUDE_PATH(...)`. For the just-in-time compiler macros
  included will look as if they were part of the code itself. The following macro
  runs under *ROOT6*:

  ```C++
  #ifdef __CLING__
  // Tell  ROOT where to find AliRoot headers
  R__ADD_INCLUDE_PATH($ALICE_ROOT)
  #include <ANALYSIS/macros/train/AddESDHandler.C>

  // Tell ROOT where to find AliPhysics headers
  R__ADD_INCLUDE_PATH($ALICE_PHYSICS)
  #include <OADB/macros/AddTaskPhysicsSelection.C>
  #endif

  void simpleaddtest(){
    AliAnalysisManager *mgr = new AliAnalysisManager;

    // Take function from macro AddESDHandler
    // no gROOT->LoadMacro for ROOT6
    AddESDHandler();

    AliPhysicsSelectionTask *test = AddTaskPhysicsSelection(kTRUE);

    mgr->InitAnalysis();
    mgr->PrintStatus();
  }
  ```

  In particular when passing arguments to the macro (in the example above passing
  kTRUE to AddTaskPhysicsSelection) this method is very convenient. This method
  is specific to *ROOT6*. The part including macros has to be protected (see
  below).
  
  To include a macro that is not part of AliROOT or AliPhysics is a bit trickier but 
  definitely possible. Such could be the case for a locally modified AddTask macro.
  In this case you need to compile the macro first in an interactive session
  
  ```C++
    aliroot
    .L AddTaskDummy.C
    exit
  ```
  This will generate a library file for ROOT to load. Now, in your run macro, you can add
  the following to the preamble:
  
  ```C++
    R__LOAD_LIBRARY(AliAnalysisTaskDummy_cxx.so)
    #include "AddTaskDummy.C"
  ```
  
  This will allow you to call the function directly in the body of your run macro, 
  the same way you would as in ROOT5.
  
  ```C++
    AliAnalysisTaskDummy *task = AddTaskDummy(kTRUE, "test.root");
  ```
  
## Do I need to include header files in my macros?

*ROOT6* comes with a technique called pre-compiled header files. Header files
from a certain library are compiled to a binary format by `rootcling`, the
successor of `rootcint`, and loaded into *ROOT6* by an auto-loading mechanism
similar to the rootmap mechanism. Once `rootcling` is invoked with the
argument `-rml name` a **.pcm**-file is created containing the pre-compiled
headers. *ROOT6* will search for .pcm-files in the **LD_LIBRARY_PATH**.

The following packages in ALICE provide .pcm support:

- AliRoot
- AliPhysics
- RooUnfold
- FairRoot
- o2

For libraries providing .pcm-support **NO** headers should be included in macros.

For libraries handled by the user make sure to
- run `rootcling` with the arguments `-rmf` for the .rootmap file
  and `-rml` for the .pcm file
- Install both the .rootmap and the .pcm file of your library path in the 
  library location (usually PROJECT_PATH/lib)

## I get a huge amount of errors, and my macro doesn't run. What can I do?

Here are few examples that commonly appear in user macros and which are tolerated by ROOT5 but not anymore by ROOT6:

- Undefined symbols:

  Maybe you have something like this in your code:
  ```C++
  taskname = "mytask";
  ```
  The variable `taskname` was not defined before. It was implicitly defined in *ROOT5* as `const char *`. In *ROOT6* this leads to the error
  ```
  error: use of undeclared identifier 'taskname'
  ```
  The variable `taskname` must be defined with a type before a value can be assigned. In this case the proper code would be
  ```C++
  const char *taskname = "mytask";
  ```
  Thanks to C++11 *ROOT6* can also detect the type implicitly using the keyword
  `auto`. In this case the code looks the following:
  ```C++
  auto taskname = "mytask";
  ```
  This will however not be transparent to *ROOT5* as *ROOT5* doesn't understand
  C++11.

  **Note**: On the command line *ROOT6* automatically adds the auto keyword. The 
  statement above will be possible in the interpreted mode of *ROOT6*.

- Missing forward declarations

  Consider this macro:
  ```C++
  void fail_forward() {
    int result = test(2,4);
    printf("2 + 4 = %d\n", result);
  }

  int test(int a, int b) {
    return a + b;
  }
  ```
  Under *ROOT5* this macro will run, but under *ROOT6* it will raise the following compiler error:
  ```
  error: use of undeclared identifier 'test'
  ```
  The function test is defined, but after it is used. In *ROOT5* this is
  no problem: During interpretation the interpreter loads all functions. But
  under *ROOT6* the macro is compiled, and now the order matters: Functions need
  to be declared before they are used. Adding a forward declaration is 
  sufficient in order to make the macro working. The following version of
  the macro will run also under *ROOT6*:
  ```C++
  int test(int a, int b);

  void run_forward() {
    int result = test(2,4);
    printf("2 + 4 = %d\n", result);
  }

  int test(int a, int b) {
    return a + b;
  }
  ```

- Handling of pointer and objects:

  *ROOT5* does not enforce using the proper access operator for objects, pointers and
  references, but will allow the usage of the `operator ->` for
  references and the `operator .` for pointers. *ROOT6* distinguishes
  between them, and consequently the proper access operator needs to be used.

  Consider the following macro:
  ```C++
  void fail_access(){
    TH1F *ptr = new TH1F("ptr", "ptr", 1, 0., 1.);
    ptr.SetTitle("test1");
    printf("Title 1: %s\n", ptr.GetTitle());

    TH1F obj("obj", "obj", 1, 0., 1.);
    obj->SetTitle("test2");
    printf("Title 2: %s\n", obj.GetTitle());
  }
  ```
  Consequently the wrong access operator is used. *ROOT5* will warn about the
  incorrect access operator, but it will run the macro. Trying this under *ROOT6*
  ends in the following errors:
  ```
  ...: error: member reference type 'TH1F *' is a pointer; did you mean to use '->'?
  ptr.SetTitle("test1");
    ~~~^
       ->
  ...: error: member reference type 'TH1F *' is a pointer; did you mean to use '->'?
    printf("Title 1: %s\n", ptr.GetTitle());
                            ~~~^
                               ->
  ...: error: member reference type 'TH1F' is not a pointer; did you mean to use '.'?
    obj->SetTitle("test2");
    ~~~^~
       .
  ...: error: member reference type 'TH1F' is not a pointer; did you mean to use '.'?
    printf("Title 2: %s\n", obj->GetTitle());
                            ~~~^~
                               .
  ```

## I get a huge amount of unknown symbols from classes in AliRoot or AliPhysics? Do I still need to include header files?

In case the compilation of a macro under *ROOT6* fails libraries and pre-compiled
headers from external packages are not loaded. The consequence is that *ROOT6*
does not know about these classes and will raise errors about unknown symbols.
Once **all** the initial compiler errors are fixed (usually at the very top of
the error log), the next time the macros are compiled *ROOT6* will also load the
libraries and .pch files from external libraries and the errors disappear. Header
from ALICE libraries should **NOT** be included.

## How do I distinguish between *ROOT5* and *ROOT6* in my macros?

Sometimes macros require different treatment for *ROOT5* and *ROOT6*. It is then
necessary to know which ROOT version is used while the macro is running.

*ROOT5* defines the preprocessor macro `__CINT__`, which can be used to check
whether one is in an interpreter session. In current (up to at least v6-12-04)
however also *ROOT6* exports `__CINT__`, so this macro cannot be used to
distinguish between ROOT versions.

*ROOT6* in addition `__CLING__` which is not present in *ROOT5*. The following lines 
indicate how to run *ROOT5*/*ROOT6* specific code:

```C++
#if defined(__CLING__)
  // ROOT6-specific code here ...
#elif defined(__CINT__)
  // ROOT5-specific code here ...
#endif
```

## I heard TF1 has changed fundamentally. Is there something to be aware of?

TF1 is based on TFormula for the formula representation. TFormula got a heavy
change: In *ROOT5* formulas were always interpreted on-the-fly. With *ROOT6* they
are compiled by the just-in-time compiler. While this leads to a significant
speedup in particular when the formula is evaluated multiple times (in fit
procedures for example) it comes on cost of breaking backward compatibility, for
which reading TFormula/TF1 object created with *ROOT6* with *ROOT5* will lead to
errors. For what concerns TFormala a *ROOT5*-compatible version has been added to
*ROOT6* as `ROOT::v5::TFormula`, however something similar does not exist for
TF1. In order to read a TF1 object from a ROOT file under *ROOT5* it has to be
created under *ROOT5*.

## Now my macro finally works under *ROOT6*. Will it still work under *ROOT5*?

It depends whether the macro now contains something which *ROOT5* does **NOT**
understand.

- *ROOT6* is fully compatible with C++11. In *ROOT5* C++11 support is not
  implemented, but the standard C++98 is used. C++11-specific code will not
  be understood.
- All **NEW** features provided by *ROOT6* are of course not ported to *ROOT5*.
  This in particular affects:
    - TTreeReader
    - TProcPool
    - TDataFrame
    - ...
- Standard library support in *ROOT5*, while it comes out-if-the-box in *ROOT6*.
  If the macro should run under both ROOT versions consider ROOT containers
  instead.
  - If your classes write stl-containers containing ROOT-objects to a ROOT-file 
    they must be declared to *ROOT5* in your LinkDef.h file. Example:
    ```C++
    #pragma link C++ class std::vector<AliAnalysisTaskEmcalJetTreeBase::AliEmcalJetInfoSummaryPP>+;
    ```
    For *ROOT6* this is not necessary.
