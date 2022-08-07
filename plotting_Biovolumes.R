library(readxl)
library(here)
library(tidyverse)
library(ggplot2)
library(data.table)
library(RColorBrewer)
library(grid)

setwd("/shared/projects/symbioscope/Quantification/")
#setwd("S:/Quantification/")

# Opening the data
biovolume_data <- read_excel(here("Biovolumes_biomass.xlsx"), sheet=2, na="")
colnames(biovolume_data) 
#biovolume_data$hpi <- as.factor(biovolume_data$hpi)

biovolume_tidy<- read_excel(here("Biovolumes_biomass.xlsx"), sheet=3, na="")
colnames(biovolume_tidy) 
biovolume_tidy$hpi <- as.factor(biovolume_tidy$hpi)

# PLOTTING
#Cell Biovolumes & Biomass
ggplot(biovolume_tidy) + aes(hpi,volume_um3,color=Culture,fill=Culture,alpha=Culture) +
  geom_jitter(width = 0.15)+
  geom_boxplot(outlier.shape = NA)+
  scale_y_continuous("Biovolume [µm³]\n", sec.axis = sec_axis(~10^(0.76*log10(.))-0.352, name = "Biomass [pg C]\n"))+
  labs(title = "Measured biovolumes & estimated C biomass per cell",x = "Time post infection (hours)")+
  scale_fill_manual(values = c("black","red2"))+
  scale_alpha_manual(values = c(0.15, 0.3))+
  scale_colour_manual(values=c("black","red2"))+
  theme_bw()+
  coord_cartesian(ylim = c(0, 3000))+
  theme(legend.position = "bottom", plot.title = element_text(face="bold"))

# only cell biovolumes
p4_biovolumes <- ggplot(biovolume_tidy) + aes(hpi,volume_um3,color=Culture,fill=Culture,alpha=Culture) +
  geom_jitter(width = 0.15)+
  geom_boxplot(outlier.shape = NA)+
  scale_y_continuous("Biovolume [µm³]\n")+
  labs(title = "Measured biovolumes & estimated C biomass per cell",x = "Time post infection (hours)")+
  scale_fill_manual(values = c("gray50","black"))+
  scale_alpha_manual(values = c(0.15, 0.3))+
  scale_colour_manual(values=c("gray50","black"))+
  theme_minimal()+
  coord_cartesian(ylim = c(0, 3000))+
  theme(legend.position = "bottom", plot.title = element_text(face="bold"))

# Measured abundances
p1a_abundance_counts <- ggplot(biovolume_data) + aes(hpi,Abundance_count,color=Culture,linetype=Culture) +
  geom_point() +
  geom_line(size=1)+
  labs(title = "Cell abundances",x = "",y="Cells / mL\n")+
  scale_colour_manual(values=c("gray50","red2"))+
  scale_linetype_manual(values=c("longdash", "solid"))+
  theme_bw()+   theme(legend.position = "none", plot.title = element_text(face="bold"))

# Growth rates
p1b_abundance_rates <- ggplot(biovolume_data) + aes(hpi,Abundance_rate,color=Culture,linetype=Culture) +
  geom_point() +
  geom_line(size=1)+
  geom_hline(aes(yintercept=0))+
  labs(title = "Growth rate",x = "Time post infection (hours)",y="Cells / (mL h)\n")+
  scale_colour_manual(values=c("gray50","red2"))+
  scale_linetype_manual(values=c("longdash", "solid"))+
  theme_bw()+   theme(legend.position = "bottom", plot.title = element_text(face="bold"))
grid.newpage()
grid.draw(rbind(ggplotGrob(p1a_abundance_counts), ggplotGrob(p1b_abundance_rates), size = "last"))

#Biomass median
#p2a_biomassmedian <- 
  ggplot(biovolume_data) + aes(hpi,Biomass_ngLiter,color=Culture,linetype=Culture) +
  geom_point() +
  geom_line(size=1)+
  labs(title = "Estimated Biomass",x = "",y="Biomass [ng C / L]\n")+
  #scale_colour_manual(values=c("gray50","red2"))+
  scale_linetype_manual(values=c("longdash", "solid"))+
  theme_bw()+   theme(legend.position = "none", plot.title = element_text(face="bold"))

#Biomass rate
p2b_biomassmedian <- ggplot(biovolume_data) + aes(hpi,BiomassRate,color=Culture,linetype=Culture) +
  geom_point() +
  geom_line(size=1)+
  geom_hline(aes(yintercept=0))+
  labs(x = "Time post infection (hours)",y="Biomass rate [pg C / L h]\n")+
  scale_colour_manual(values=c("gray50","red2"))+
  scale_linetype_manual(values=c("longdash", "solid"))+
  theme_bw()+   theme(legend.position = "bottom", plot.title = element_text(face="bold"))
grid.newpage()
grid.draw(rbind(ggplotGrob(p2a_biomassmedian), ggplotGrob(p2b_biomassmedian), size = "last"))


#Biomass & Organelles
#Biovolume
p3a_biovolume <- ggplot(biovolume_data) + 
  aes(x=hpi,y=VolumeMedian,color=Culture,fill=Culture) +
  geom_point() +
  geom_line(aes(linetype=Culture),size=1)+
  geom_ribbon(aes(ymin=VolumeMedian-VolumeStdDev,ymax=VolumeMedian+VolumeStdDev),linetype=0,alpha=0.15)+ 
  labs(title = "Measured Cell Biovolumes",x = "",y="Volume\n[µm³]\n")+
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  scale_colour_manual(values=c("gray75","black"))+
  scale_fill_manual(values=c("gray50","gray50"))+
  scale_linetype_manual(values=c("longdash", "solid"))+
  coord_cartesian(ylim = c(0, 2500))+
  theme_minimal()+ theme(legend.position = "none", plot.title = element_text(face="bold"))
#Biomass
p3a_biomassmedian <- ggplot(biovolume_data) + 
  aes(x=hpi,y=Biomass_ngLiter,color=Culture,fill=Culture) +
  geom_point() +
  geom_line(aes(linetype=Culture),size=1)+
  geom_ribbon(aes(ymin=Biomass_ngLiter-Biomass_ngLiter_StDv,ymax=Biomass_ngLiter+Biomass_ngLiter_StDv),linetype=0,alpha=0.15)+ 
  labs(title = "Estimated Total Biomass",x = "",y="Biomass\n[ng C / L]\n")+
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  scale_colour_manual(values=c("gray50","black"))+
  scale_fill_manual(values=c("gray50","gray75"))+
  scale_linetype_manual(values=c("longdash", "solid"))+
  theme_bw()+theme(legend.position = "bottom")

#Chloroplasts median
p3b_chlmedian <- ggplot(biovolume_data) + 
  aes(x=hpi,y=ChloroplastsMedian,color=Culture,fill=Culture) +
  geom_point() +
  geom_line(aes(linetype=Culture),size=1)+
  geom_ribbon(aes(ymax=ChloroplastsMedian+ChloroplastStDv,ymin=ChloroplastsMedian-ChloroplastStDv),linetype=0,alpha=0.15)+
  labs(title = "Chloroplast size",x = "",y="Volume\n[µm³]\n")+
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  scale_colour_manual(values=c("gray50","purple4"))+
  scale_fill_manual(values=c("gray50","purple4"))+
  scale_linetype_manual(values=c("longdash", "solid"))+
  theme_bw()+   theme(legend.position = "none", plot.title = element_text(face="bold"))

#Nuclei median
p3c_nucmedian <- ggplot(biovolume_data) + 
  aes(x=hpi,y=NucleiMedian,color=Culture,fill=Culture) +
  geom_point() +
  geom_line(aes(linetype=Culture),size=1)+
  geom_ribbon(aes(ymax=NucleiMedian+NucleiStDev,ymin=NucleiMedian-NucleiStDev),linetype=0,alpha=0.15) + 
  labs(title = "Nuclei size",x = "",y="Volume\n[µm³]\n")+
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  scale_colour_manual(values=c("gray50","blue2"))+
  scale_fill_manual(values=c("gray50","blue2"))+
  scale_linetype_manual(values=c("longdash", "solid"))+
  coord_cartesian(ylim = c(0, 150))+  
  theme_bw()+   theme(legend.position = "none", plot.title = element_text(face="bold"))

#Chloroplasts proportion
p3d_chlpercent <- ggplot(biovolume_data) + 
  aes(hpi,ChloroplastsPercent,color=Culture) +
  geom_point() +
  geom_line(aes(linetype=Culture),size=1)+
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  scale_colour_manual(values=c("purple4","purple4"))+
  scale_linetype_manual(values=c("dashed", "solid"))+
  labs(title = "Chloroplast proportion",x = "\nTime post infection (hours)",y="Median %\nof biovolume\n")+
  theme_minimal()+   theme(legend.position = "bottom", plot.title = element_text(face="bold"))+ylim(0,100)

###########################################
# Figure 5: Cell Biovolumes & Biomass
grid.newpage()
grid.draw(rbind(ggplotGrob(p3a_biovolume), ggplotGrob(p3a_biomassmedian),
                ggplotGrob(p3c_nucmedian),
                ggplotGrob(p3b_chlmedian), ggplotGrob(p3d_chlpercent), 
                size = "last"))


grid.newpage()
grid.draw(rbind(ggplotGrob(p4_biovolumes), ggplotGrob(p2b_FvFm),ggplotGrob(p3d_chlpercent),
                size = "last"))
