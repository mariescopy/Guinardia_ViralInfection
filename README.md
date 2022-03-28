# Guinardia_ViralInfection
This repository contains all analysis and plotting scripts for the manuscript:


*Monitoring viral infections of the abundant marine diatom Guinardia delicatula by automated fluorescence microscopy* 

**Marie Walde, Cyprien Camplong, Colomban de Vargas, Anne-Claire Baudoux, Nathalie Simon**

## Physiological Measurements & Counts
All data is summarized in **SummaryQuantifications.xlsx** and was plotted in RStudio with the **plotting_Summary.R** script

## Image analysis
### Maximum projection and rotation of single cell stacks

### 3D Organelle Morphometry
Raw confocal image data in Leica LIF format was analysed with a Fiji macro and the 3D Image Suite macro.
3D analysis results were written into Excel files with the Write-to-Excel Plugin. A summary of these results can be found in the file **3D_Morphometry.xlsx**. This served as the input for plotting in RStudio with the R script **plotting_3DMorphometry.R**
