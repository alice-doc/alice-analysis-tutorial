# Obtain the code

Our starting point for these exercises is the example analysis ‘AliAnalysisTaskMyTask.cxx’ that was covered during the lesson. Of course it wouldn’t be very efficient to copy and paste the code for your ‘empty’ analysis task from the slides of the lecture. You can use different methods to obtain it, suggested here in order of adventerousness

1. As we have learned in the previous days, programmers use version control systems for developing their code. Use what you have learned during our GIT lectures, and _clone_ the example task repository. You can find it on [https://github.com/rbertens/ALICE_analysis_tutorial](https://github.com/rbertens/ALICE_analysis_tutorial)

2. The third approach is the most robust: if you have a github account, you can make a _fork_ of the example task repository, by surfing to [https://github.com/rbertens/ALICE_analysis_tutorial](https://github.com/rbertens/ALICE_analysis_tutorial) and clicking on _fork_. If you’ve forked the repository, you can proceed to clone it on your laptop, this allows you to develop the code, and push commits to your own fork

3. The quickest way: download the .tar file that you can find attached to today’s session’s agenda and extract the files to your local hard drive

Whichever approach you chose, the end result should be that you have stored these files on your laptop. One word of caution: _the path in which you store these files cannot contain spaces! E.g. /home/my awesome task/ will not work, use /home/my_awesome_task/ 
.


# A first look at your task

As a start, just take a look at code that makes up the task. You should see the files that were also covered in the first part of the talk:

*   AliAnalysisTaskMyTask.cxx

*   AliAnalysisTaskMyTask.h

*   AddMyTask.C

*   runAnalysis.C

Try to find where all the code snippets that were shown during the presentation fit in, and wonder if you can answer the following questions

*   which function is called for each event?

*   where are the output histogram defined?

*   where are the output histogram filled?

Remember, that for now, the name ‘AliAnalysisTaskMyTask’ doesn’t sound so bad, but when you develop a task ‘in real life’, make sure to give it a meaningful name, that explains what the task is aimed at.



# Get the data

To run this task, you will also need to download an input file **AliAOD.root**, which contains some actual reconstructed collisions. We will be looking at Pb-Pb data that was taken in 2015. 

## Source your environment
We will get the data form the ALICE file catalogue, so first, we need to make sure that we can access that. Load your ALICE environment like Dario has showed you yesterday, e.g. by doing

```
alienv enter AliPhysics::latest
```

You should see which module files are currently loaded, e.g.

```
  1) BASE/1.0
  2) GCC-Toolchain/v6.2.0-alice1-1
  3) AliEn-Runtime/v2-19-le-1
  4) GSL/v1.16-1
  5) Python-modules/1.0-1
  6) ROOT/v6-10-06+git_c54db1c10b-1
  7) boost/v1.59.0-1
  8) cgal/v4.6.3-1
  9) fastjet/v3.2.1_1.024-alice1-1
 10) Vc/1.3.2-1
 11) AliRoot/0742e9dc6e12c74634a1e353ab00ceba45335401_ROOT6-1
 12) AliPhysics/latest
Use alienv list to list loaded modules. Use exit to exit this environment.
```

The module Alien-Runtime is now available, which is what we will use to get our data. 

## Get a valid token

To authenticate yourself, obtain a token
```
alien-token-init <username>
``` 

where #username# is your CERN username. You should be prompted to provide your PEM pass phrase, which is ** not the same as your CERN password ** unless you set them to be the same yourself. 


If all goes well, you will see something like
```
[AliPhysics/latest] ~/sw $> alien-token-init rbertens
---------------------------------------------------------------
Setting central config:
===============================================================
export alien_API_SERVER_LIST="pcapiserv03.cern.ch:10000|pcapiserv08.cern.ch:10000|"
export TERMINFO=/usr/share/terminfo
===============================================================
---------------------------------------------------------------
Setting closest site to: CERN
===============================================================
Using X509_CERT_DIR=/home/rbertens/sw/slc7_x86-64/AliEn-Runtime/v2-19-le-1/globus/share/certificates
*********************************************************************************
Attention: You don't have a valid grid proxy ( or less than 1 hour left ) - doing xrdgsiproxy init for you ...
*********************************************************************************
Enter PEM pass phrase:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
file        : /tmp/x509up_u1000
issuer      : /DC=ch/DC=cern/OU=Organic Units/OU=Users/CN=rbertens/CN=718303/CN=Redmer Alexander Bertens
subject     : /DC=ch/DC=cern/OU=Organic Units/OU=Users/CN=rbertens/CN=718303/CN=Redmer Alexander Bertens/CN=708532894
path length : 0
bits        : 512
time left   : 12h:0m:0s
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=> Trying to connect to Server [1] root://pcapiserv08.cern.ch:10000 as User rbertens 
/alice/cern.ch/user/a/alidaq/
/alice/cern.ch/user/r/rbertens/
Your identity: rbertens
Creating token ..................................... Done
Your token is valid until: Wed Nov  1 13:21:18 2017
```

Once you have obtained a valid token, enter the alice environment shell by typing
```
aliensh
```
you should see
```
[AliPhysics/latest] ~/sw $> aliensh
 [ aliensh 1.0.140x (C) ARDA/Alice: Andreas.Joachim.Peters@cern.ch/Derek.Feichtinger@cern.ch]
aliensh:[alice] [1] /alice/cern.ch/user/r/rbertens/ >
```
This shell works a lot like a normal unix shell, but it is not! Most of the commands that you have seen earlier this week are available, but not all. 


Move to the directory where the data we are looking for is stored

```
cd /alice/data/2015/LHC15o/000246757/pass1/AOD/002/
```
and copy the AliAOD.root file that is inside this folder to your ** local ** hard drive by doing
```
cp AliAOD.root file:.
```

Note the syntax of the copy command. 

## Trouble ?
If for some reason this does not work for you - no fear. You can also download one a file  [here](ttps://cernbox.cern.ch/index.php/s/ZP2gJBE265FiSAX) , but first ask one of the helpers to see if we cannot fix it. 

