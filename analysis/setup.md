# Obtain your source code

The starting point for these exercises is the analysis template called _AliAnalysisTaskMyTask_. To obtain the source code of this analysis, choose one of the following two options: 

1. Clone the Git repository. Programmers use version control systems when developing their code. You will also use version control (in our case through Git) when you are contributing to the ALICE code base. So why not start with Git right now? You can _clone_ the example task repository, which you can find it on [here](https://github.com/rbertens/ALICE_analysis_tutorial), by typing, in a terminal

```bash
git clone https://github.com/rbertens/ALICE_analysis_tutorial.git
```

This will _clone_ the remote repository, so that you have access to a carbon copy of the full repository on your local computer. 

2. A more robust approach to working with Git, is creating a remote _fork_ of a certain repository, and working on this fork. For this, you will need to open a GitHub [https://github.com/] account (which you will need in any case if you want to contribute to ALICE software). If you have a GitHub account, you create a _fork_ of the example task repository by surfing [here](https://github.com/rbertens/ALICE_analysis_tutorial) and clicking on _fork_ at the top right of the screen. If you have forked the repository, you can proceed to cloning it on your laptop in the way as explained in option 1; this then allows you to develop the code, and push commits to your own fork

Whichever approach you chose, the end result should be that you have stored these files on your laptop. One word of caution: ** the path in which you store these files cannot contain spaces! E.g. /home/my  task/ will not work, use /home/my_task/ ** .


# A first look at your task

As a start, just take a look at code that makes up the task:

*   AliAnalysisTaskMyTask.cxx

*   AliAnalysisTaskMyTask.h

*   AddMyTask.C

*   runAnalysis.C

You will see that the code is extensively documented. Can you tell

*   which function is called for each event?

*   where are the output histogram defined?

*   where are the output histogram filled?

Remember, that for now, the name ‘AliAnalysisTaskMyTask’ doesn’t sound so bad, but when you develop a task ‘in real life’, make sure to give it a meaningful name, that explains what the task is aimed at.



# Obtain input data

To run your own analysis task, you will also need to download a file that contains reconstructed collisions. This input file is called **AliAOD.root**, short for Analysis Object Data. In the following steps, will assume that we are looking at Pb-Pb data that was taken in 2015. You can also choose to run on data from a different period or collision system.  

## Source your environment
We will get the data form the ALICE file catalogue. To access the file catalogue, you will need to use xjalienfs or xalienfs packages and have a valid Grid certificate. This means that, at this point, we will assume that you have built all the ALICE software (see [our build manual for that](https://alice-doc.github.io/alice-analysis-tutorial/building/) ).


Load your ALICE environment as [explained here](https://alice-doc.github.io/alice-analysis-tutorial/building/#use-the-software-you-have-built), e.g. by doing

```
alienv enter AliPhysics::latest
```

You should see which module files are currently loaded, e.g.

```
 1) BASE/1.0
 2) AliEn-Runtime/v2-19-le-49
 3) OpenSSL/v1.0.2o-9
 4) Python-modules/1.0-11
 5) XRootD/v4.11.1-14
 6) ROOT/v6-18-04-alice2-1
 7) boost/v1.70.0-6
 8) cgal/4.6.3-5
 9) fastjet/v3.2.1_1.024-alice3-21
10) Vc/1.4.1-5
11) xjalienfs/1.0.6-2
12) JAliEn-ROOT/0.6.0-2
13) AliRoot/master-1
14) RooUnfold/V02-00-01-alice4-25
15) treelite/a7a0839-2
16) KFParticle/alice-v1.1-1-9
17) AliPhysics/latest
12) AliPhysics/latest
Use alienv list to list loaded modules. Use exit to exit this environment.
```

The module xjalienfs is now available, which is what we will use to get our data. 

## Get a valid token (optional)

{% callout "JAliEn tokens" %}
You can skip this step if you are using JAliEn. JAliEn clients create the token automatically, but you can still run _alien-token-init_ to refresh it manually.
{% endcallout %}

The ALICE file catalogue is only accessible if you are an ALICE member. 

If you are using AliEn-ROOT-Legacy or ROOT5, then you first need to authenticate yourself and obtain a _token_

```
alien-token-init <username>
``` 

where _username_ is your CERN username. You should be prompted to provide your PEM pass phrase, which is ** not the same as your CERN password ** unless you set them to be the same yourself. 


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

For comparison, here is the output from the JAlien _alien-token-init_

```
[AliPhysics/latest] ~ > alien-token-init
INFO: JAliEn client automatically creates tokens, alien-token-init is deprecated
DN >>> /C=ch/O=AliEn2/CN=Users/CN=nhardi/OU=nhardi
ISSUER >>> /C=ch/O=AliEn/CN=AliEn CA
BEGIN >>> 2020-03-26 10:06:05
EXPIRE >>> 2020-04-26 08:16:48
```

## Open the AliEn shell

You can now enter the alice environment shell by typing


```
alien.py
```

Once you type this command, a the alice environment shell is loaded, and you should see

```
[AliPhysics/latest] ~ > alien.py
Welcome to the ALICE GRID
support mail: adrian.sevcenco@cern.ch

AliEn[nhardi]:/alice/cern.ch/user/n/nhardi/ >

```


The AliEn legacy shell _aliensh_ and JAliEn shell _alien.py_ are very similar. The command prompt for aliensh shell looks like this:

```
[AliPhysics/latest] ~/sw $> aliensh
 [ aliensh 1.0.140x (C) ARDA/Alice: Andreas.Joachim.Peters@cern.ch/Derek.Feichtinger@cern.ch]
aliensh:[alice] [1] /alice/cern.ch/user/r/rbertens/ >
```

This shell works a lot like a normal unix shell, but it is not - not all commands that you expect to find are defined. 


Move to the directory where the data we are looking for is stored

```
cd /alice/data/2015/LHC15o/000246757/pass1/AOD/002/
```
NOTE: this example needs to be updated
and copy the AliAOD.root file that is inside this folder to your ** local ** hard drive by doing
```
cp AliAOD.root file:.
```

Note the syntax of the copy command, here we tell to copy the _remote_ file AliAOD.root to our own laptop by specifying _file:._ . 

## Trouble ?
If for some reason this does not work for you - no fear. You can ask a colleague to provide a file for you, or send a mail to our mailing lists  if you are having trouble with access.
