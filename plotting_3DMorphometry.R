
library(readxl)
library(ggplot2)
library(data.table)
library(RColorBrewer)

setwd("/home/mmsandin/Desktop/Collaborations/Marie/")

# Opening the data
chl_sph <- read_excel("S:/Quantification/3D_Morphometry.xlsx", sheet="Chl_Sphericity", na="")
chl_vol <- read_excel("S:/Quantification/3D_Morphometry.xlsx", sheet="Chl_Volume", na="")
nuc_vol <- read_excel("S:/Quantification/3D_Morphometry.xlsx", sheet="Nuc_Volume", na="")

# removing first (empty) row from 'Chl_Volume', although row 55 from all datasets is empty
chl_vol <- chl_vol[-1,]

# Adding the name of the file as a variable
chl_sph$file <- "Chloroplast sphericity [0,1]"
chl_vol$file <- "Chloroplast volume [µm^3]"
nuc_vol$file <- "Nuclei volume [µm^3]"

# Melting the datasets into one column
chl_sph <- melt(as.data.table(chl_sph))
chl_vol <- melt(as.data.table(chl_vol))
nuc_vol <- melt(as.data.table(nuc_vol))

# Merging all files
#data <- rbind(chl_sph, chl_vol, nuc_vol)
#head(data)


# Plotting
ggplot(chl_sph, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.3, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "Chloroplast Sphericity",x = "Time post infection", y = "Sphericity [0;1]")+
    theme_bw()+
    theme(legend.position = "none")+
    scale_fill_brewer(palette = "RdPu", direction=-1)

ggplot(chl_vol, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.3, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "Chloroplast Volume",x = "Time post infection", y = "Volume [µm^3]")+
    theme_bw()+
    theme(legend.position = "none")+ ylim(0,1800)+
    scale_fill_brewer(palette = "RdPu", direction=-1)

ggplot(nuc_vol, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.3, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "Nucleus Volume",x = "Time post infection", y = "Volume [µm^3]")+
    theme_bw()+
    theme(legend.position = "none")+ylim(0,170)+
    scale_fill_brewer(palette = "Blues", direction=-1)
