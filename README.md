# Guinardia Viral Infection study
This repository contains all analysis and plotting scripts for the manuscript:  
*Viral infection impacts the 3D subcellular structure of the abundant marine diatom Guinardia delicatula* by  
**Marie Walde, Cyprien Camplong, Colomban de Vargas, Anne-Claire Baudoux, Nathalie Simon**
https://doi.org/10.1101/2022.09.06.505714 

## Physiological Measurements & Counts
All data is summarized in **SummaryQuantifications.xlsx** and was plotted in RStudio with the **plotting_Summary.R** script

## Image analysis
### Maximum projection and rotation of single cell stacks (FIJI)
For 2D visualisation of multi-colour 3D datasets from confocal microscopy, datasets were batch-processed in FIJI (Schindelin et al., 2012). 
For each z-stack recorded, a 2D maximum projection was calculated for each fluorescence channel and a minimum projection for the transmission channel. The dominant cell orientation in each image was detected by Fourier component analysis (Tinevez et al., 2018), and cells were aligned along the vertical axis and cropped to their bounding box. 

### 3D Organelle Morphometry (FIJI & R)
Raw confocal image data in Leica LIF format was analysed with a Fiji macro and the 3D Image Suite macro.
3D analysis results were written into Excel files with the Write-to-Excel Plugin. A summary of these results can be found in the file **3D_Morphometry.xlsx**. This served as the input for plotting in RStudio with the R script **plotting_3DMorphometry.R**
