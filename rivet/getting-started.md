# Getting started with Rivet

## Overview
Rivet (Robust Independent Validation of Experiment and Theory) is a **generator-agnostic framework** to **replicate analyses** performed on experimental data on the output of **Monte Carlo event generators**. The latter are interfaced through event records written in the **HepMC** format. Rivet reads these input data and reproduces the selected analysis as well as produces **comparison plots** to the published data.

Analyses for Rivet are implemented as **plugins**, the official ones being distributed together with Rivet. This design allows for the easy implementation and usage of new analysis even before they become official. Each plugin needs to contain the required information to reproduce the analysis, to produce the comparison plots, and the required references for documentation. The detailed content of a plugin is explained below.

## Analysis plugin
An analysis plugin can be distributed with Rivet or added on-top of a Rivet installation (e.g. for local development). It always comprises the following elements:

* **identifier:** `<experiment>_<year of publication>_I<inspire ID>` (for older analyses the SPIRES ID was used)
* **title**
* **description:**
  * short summary of the analysis content collision system and energies 
  * reference to paper 
  * status: preliminary, unvalidated, validated, obsolete, \dots
* **code:**
  * code to reproduce the analysis on Monte Carlo output
* **data:**
  *  measured data points and uncertainties

