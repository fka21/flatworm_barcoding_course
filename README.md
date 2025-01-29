# Flatworm Barcoding Course 2025

## 1. Aim
In this course, we will classify sampled flatworms based on sequencing results from your genotyping effort.

The workflow consists of the following steps:

1. Processing sequencing files:

    -  Input: `.ab1` files from the sequencing facility.
    -  Trim sequences to remove erroneous base calls using the R package [sangeranalyseR](https://sangeranalyser.readthedocs.io/en/latest/).
    -  Export cleaned sequences as `.fasta` files.
2. Comparing sequences with known species:

    -  Merge the processed sequences with reference sequences from known species.
    -  Perform a multiple sequence alignment using the [MAFFT aligner](https://mafft.cbrc.jp/alignment/server/index.html).
3. Phylogenetic analysis:
    - Construct a Maximum Likelihood tree using [IQTREE](http://www.iqtree.org/).

## 2. How to use the repo:

### Setting Up Your Environment

> **NOTE**
> 
> To use GitPod, you need a GitHub account and the GitPod browser extension.
 
  - You can register on GitHub by following the Part 1 from this [link](https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account).
  - For the extension please follow the [links](https://www.gitpod.io/docs/configure/user-settings/browser-extension) provided on the official GitPod website.

This repository includes a `.gitpod.yml` file, which automatically sets up the required environment for analysis.

### Data and Scripts
- Data is located in the `input/` directory. 
- Scripts used for analyses are located in the `scripts/` directory.
  
  - You can run the scripts via the command line. For example:

  ```
  RScript scripts/sanger_processor.R
  ```
