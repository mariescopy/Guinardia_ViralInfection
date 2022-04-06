
library(readxl)
library(ggplot2)
library(data.table)
library(RColorBrewer)

setwd("S:/Quantification//")

# Opening the data
# infected samples
chl_sph <- read_excel("3D_Morphometry.xlsx", sheet="Chl_Sphericity", na="")
chl_vol <- read_excel("3D_Morphometry.xlsx", sheet="Chl_Volume", na="")
nuc_vol <- read_excel("3D_Morphometry.xlsx", sheet="Nuc_Volume", na="")

# control samples
chl_sph_con <- read_excel("3D_Morphometry.xlsx", sheet="Chl_Sphericity_con", na="")
chl_vol_con <- read_excel("3D_Morphometry.xlsx", sheet="Chl_Volume_con", na="")
nuc_vol_con <- read_excel("3D_Morphometry.xlsx", sheet="Nuc_Vol_con", na="")


# removing first (empty) row from 'Chl_Volume', although row 55 from all datasets is empty
chl_vol <- chl_vol[-1,]

# Adding the name of the file as a variable
chl_sph$file <- "Chloroplast sphericity [0,1]"
chl_vol$file <- "Chloroplast volume [µm^3]"
nuc_vol$file <- "Nuclei volume [µm^3]"
chl_sph_con$file <- "Chloroplast sphericity [0,1]"
chl_vol_con$file <- "Chloroplast volume [µm^3]"
nuc_vol_con$file <- "Nuclei volume [µm^3]"

# Melting the datasets into one column
chl_sph <- melt(as.data.table(chl_sph))
chl_vol <- melt(as.data.table(chl_vol))
nuc_vol <- melt(as.data.table(nuc_vol))
chl_sph_con <- melt(as.data.table(chl_sph_con))
chl_vol_con <- melt(as.data.table(chl_vol_con))
nuc_vol_con <- melt(as.data.table(nuc_vol_con))

# Merging all files
#data <- rbind(chl_sph, chl_vol, nuc_vol)
#head(data)


# PLOTTING
# infected
ggplot(chl_sph, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.3, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "A | Chloroplast Sphericity",x = "Time post infection", y = "Sphericity [0;1]")+
    theme_bw()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ylim(0,0.6)+
    scale_fill_brewer(palette = "RdPu", direction=-1)

ggplot(chl_vol, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.3, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "B | Chloroplast Volume",x = "Time post infection", y = "Volume [µm^3]")+
    theme_bw()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ ylim(0,1800)+
    scale_fill_brewer(palette = "RdPu", direction=-1)

ggplot(nuc_vol, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.3, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "C | Nucleus Volume",x = "Time post infection", y = "Volume [µm^3]")+
    theme_bw()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ylim(0,170)+
    scale_fill_brewer(palette = "Blues", direction=-1)

# control
ggplot(chl_sph_con, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.3, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "A | Chloroplast Sphericity",x = "Time post infection", y = "Sphericity [0;1]")+
    theme_bw()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ylim(0,0.6)+
    scale_fill_brewer(palette = "RdPu", direction=-1)

ggplot(chl_vol_con, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.3, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "B | Chloroplast Volume",x = "Time post infection", y = "Volume [µm^3]")+
    theme_bw()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ ylim(0,1800)+
    scale_fill_brewer(palette = "RdPu", direction=-1)

ggplot(nuc_vol_con, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.3, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "C | Nucleus Volume",x = "Time post infection", y = "Volume [µm^3]")+
    theme_bw()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ylim(0,170)+
    scale_fill_brewer(palette = "Blues", direction=-1)
