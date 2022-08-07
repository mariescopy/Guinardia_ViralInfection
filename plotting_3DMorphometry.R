library(readxl)
library(ggplot2)
library(data.table)
library(RColorBrewer)
library(cowplot)
library(gridExtra)

stwd("S:/Quantification//")

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
chl_vol$file <- "Chloroplast volume [?m^3]"
nuc_vol$file <- "Nuclei volume [?m^3]"
chl_sph_con$file <- "Chloroplast sphericity [0,1]"
chl_vol_con$file <- "Chloroplast volume [?m^3]"
nuc_vol_con$file <- "Nuclei volume [?m^3]"

# Melting the datasets into one column
chl_sph <- melt(as.data.table(chl_sph))
chl_vol <- melt(as.data.table(chl_vol))
nuc_vol <- melt(as.data.table(nuc_vol))
chl_sph_con <- melt(as.data.table(chl_sph_con))
chl_vol_con <- melt(as.data.table(chl_vol_con))
nuc_vol_con <- melt(as.data.table(nuc_vol_con))

########################################################
# BIOSTATISTICS
chl_sph_tidy <- read_excel("3D_Morphometry_noNA.xlsx", sheet="Chl_Sphericity_tidy")
chl_vol_tidy <- read_excel("3D_Morphometry_noNA.xlsx", sheet="Chl_Volume_tidy")
nuc_vol_tidy <- read_excel("3D_Morphometry_noNA.xlsx", sheet="Nuc_Volume_tidy")

#pairwise tests for each time point
timpoints<-list("t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7")

for (t in timpoints)
{ 
  print(t)
  chl_sph_tidy_sub<-subset(chl_sph_tidy, Time==t)
  #pairwise t-tests
  print(t.test(Chl_Sphericity ~ Culture, data = chl_sph_tidy_sub))
  #fit to linear model
  print(summary(lm(Chl_Sphericity ~ Culture, data = chl_sph_tidy_sub)))
}

for (t in timpoints)
{ 
  print(t)
  chl_vol_tidy_sub<-subset(chl_vol_tidy, Time==t)
  #pairwise t-tests
  print(t.test(Chl_Volume ~ Culture, data = chl_vol_tidy_sub))
  #fit to linear model
  #print(summary(lm(Chl_Volume ~ Culture, data = chl_vol_tidy_sub)))
}

for (t in timpoints)
{ 
  print(t)
  nuc_vol_tidy_sub<-subset(nuc_vol_tidy, Time==t)
  #pairwise t-tests
  print(t.test(Nuc_Volume ~ Culture, data = nuc_vol_tidy_sub))
  #fit to linear model
  #print(summary(lm(Nuc_Volume ~ Culture, data = nuc_vol_tidy_sub)))
}


########################################################
# PLOTTING
# Figure 4: Morphological changes
# infected
p_chl_sph_inf<-ggplot(chl_sph, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.2, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "Chloroplast Sphericity",x = "", y = "Sphericity [0;1]")+
    #theme_bw()+
    theme_minimal()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ylim(0,0.6)+
    scale_fill_brewer(palette = "RdPu", direction=-1)

p_chl_vol_inf<-ggplot(chl_vol, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.2, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "Chloroplast Volume",x = "", y = "Volume [µm³]")+
    #theme_bw()+
    theme_minimal()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ ylim(0,1800)+
    scale_fill_brewer(palette = "RdPu", direction=-1)

p_nuc_vol_inf<-ggplot(nuc_vol, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.2, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(title = "Nucleus Volume",x = "", y = "Volume [µm³]")+
     #theme_bw()+
    theme_minimal()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ylim(0,170)+
    scale_fill_brewer(palette = "Blues", direction=-1)


# control
p_chl_sph_con<-ggplot(chl_sph_con, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.2, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(x = "Time post infection", y = "Sphericity [0;1]")+
    #theme_bw()+
    theme_minimal()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ylim(0,0.6)+
    scale_fill_brewer(palette = "RdPu", direction=-1)

p_chl_vol_con<-ggplot(chl_vol_con, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.2, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(x = "Time post infection", y = "Volume [µm³]")+
    #theme_bw()+
    theme_minimal()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ ylim(0,1800)+
    scale_fill_brewer(palette = "RdPu", direction=-1)

p_nuc_vol_con<-ggplot(nuc_vol_con, aes(x=variable, y=value, fill=variable))+
    geom_jitter(alpha=0.2, width = 0.1)+
    geom_boxplot(alpha=0.7, outlier.shape = NA)+
    labs(x = "Time post infection", y = "Volume [µm³]")+
    #theme_bw()+
    theme_minimal()+
    theme(legend.position = "none", plot.title = element_text(face="bold"))+ylim(0,170)+
    scale_fill_brewer(palette = "Blues", direction=-1)

grid.arrange(p_chl_sph_inf,p_chl_vol_inf,p_nuc_vol_inf, p_chl_sph_con,p_chl_vol_con,p_nuc_vol_con, nrow = 2)