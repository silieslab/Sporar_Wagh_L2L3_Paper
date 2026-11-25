# Sporar_Wagh_Paper

This repository contains the analysis scripts and plotting code used to generate the figure panels in:

## Overview & Software Requirements

### Physiological Recordings
Physiological recordings were analyzed using a combination of **MATLAB** and **Python**. The analysis scripts are labeled accordingly to indicate which environment is required for each method:

* **MATLAB:** Scripts can be run directly within a standard MATLAB environment (tested on MATLAB `9.3.0.713579 (R2017b)`).
* **Python:** Requires **Python 2.7**. Set up a Python 2.7 environment containing the packages imported at the top of each script and function before running.

### RNA-seq Analysis
* **Differential Gene Expression & GO Annotation:** Initial analysis was performed in **R** (tested on R "R version 4.6.1 (2026-06-24 ucrt)").
* **Visualization:** Plots were generated using **Python** (`Python 2.7`).

---

## Repository Structure
* `physiology/` — MATLAB (`.m`) or Python (`.py`) scripts for analyzing physiological recordings.
* `RNAseq/` — R scripts for differential gene expression and GO annotation, along with Python scripts for figure plotting.

