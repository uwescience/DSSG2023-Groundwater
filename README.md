# Data Science for Social Good 2023: Groundwater Project

A reproducible and well-documented workflow to analyze groundwater scarcity in the Colorado River Basin. This workflow is written in python and contained in a set of Jupyter notebooks which can be used by researchers, analysts, or anyone interested in applying this workflow to study groundwater. Though we focus on the Colorado River Basin, this workflow is flexible and can be easily modified to study other areas suffering from water crises. 

## Tools and Skills Needed for This Workflow

+ Python 
+ Jupyter Notebooks
+ Familiarity with basic terminal commands

## Overview of Workflow 

This workflow is intended to be used directly on a user's machine. The repository should be cloned or downloaded and the user should follow the instructions outlined in the workflow and run the code and scripts locally. The paths and structure of the repository is so that the DSSG2023-Groundwater folder is the location where the work is being done, so the code is written such that files are being saved or read in relative to this location. 

Dependencies can be installed by running ```pip install -r requirements.txt```.

The repository has three main folders, which are described below: 

#### notebooks-and-markdowns/

The Jupyter notebooks and markdowns containing the code and information to implement our workflow. These files are numbered and should be used in the order that is shown. Note that the workflow assumes that main folder of the git repo is your working directory--paths throughout the workflow are set relative to there. 

#### output/

A folder that contains output from the workflow, including downloaded data from GRACE and GLDAS. 

#### scripts/

Additional scripts that are necessary for the workflow such as shell scripts to download GRACE and GLDAS data or additional analysis files. Currently this folder has two subfolders: /analysis and /data. The /analysis folder contains code to produce visualizations contained in /notebooks-and-markdowns/05-Visualization Your Data.md and the /data folder include scripts to download the data. 



