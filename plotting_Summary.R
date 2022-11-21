library(readxl)
library(ggplot2)
library(data.table)
library(RColorBrewer)
library(grid)

# Opening the data
setwd("S:/Quantification/")
guinardia_data <- read_excel("SummaryQuantifications.xlsx", sheet="Summary", na="")
colnames(guinardia_data) 
guinardia_tidy <- read_excel("SummaryQuantifications.xlsx", sheet="Summary_tidy", na="NA")
colnames(guinardia_tidy)

bac_medians <- read_excel(here("BacteriaCounts.xlsx"), sheet=2)
colnames(bac_medians) 

###############################################
# Figure 1: Abundance, viral titer, mortality, RNA spots
inf_data <- melt(as.data.table(guinardia_data), id.vars=c("time", "hours"))
inf_data <- inf_data[variable=="inf_healthy" | variable=="inf_dead" | variable=="inf_spots"]
infspots <- inf_data[variable=="inf_spots"]

con_data <- melt(as.data.table(guinardia_data), id.vars=c("time", "hours"))
con_data <- con_data[variable=="con_healthy" | variable=="con_dead" | variable=="con_spots"]

# Line Plots
p1a_abundances  <- ggplot(guinardia_data, aes(x=hours)) + 
  geom_line(aes(y = abun_inf), size=1) + 
  geom_line(aes(y = abun_con), size=1,linetype="dashed") +
  geom_point(aes(y = abun_inf), color = "black", size=3, alpha=0.3)+
  geom_point(aes(y = abun_con), color = "grey50",  size=3, alpha=0.3)+
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  theme_minimal() + theme(legend.position = "none", plot.title = element_text(face="bold"))+
  labs(title = "A Cell abundances",x="",y = "Diatoms / mL",x="")

p1b_lines<- ggplot(guinardia_tidy, aes(x=hours, linetype=Culture)) + 
  geom_point(aes(y=healthy),size=3, alpha=0.3,color="magenta4")+
  geom_line(aes(y=healthy),size=1,color="magenta4") +
  geom_point(aes(y=dead),size=3, alpha=0.3,color="grey75")+
  geom_line(aes(y=dead),size=1,color="grey75") +
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  scale_y_continuous(limits = c(0, 100))+
  scale_linetype_manual(values=c("dashed", "solid"))+
  theme_minimal() + theme(legend.position = "none", plot.title = element_text(face="bold"))+
  labs(title = "B Subcellular morphologies: Healthy/dead", x="",y="% of cells")

p1c_lines_RNA<- ggplot(guinardia_tidy, aes(x=hours, linetype=Culture)) + 
  geom_point(aes(y=spots),size=3, alpha=0.3,color="springgreen4")+
  geom_line(aes(y=spots),size=1,color="springgreen4") +
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  scale_y_continuous(limits = c(0, 50))+
  scale_linetype_manual(values=c("dashed", "solid"))+
  theme_minimal() + theme(legend.position = "none",  plot.title = element_text(face="bold"))+
  labs(title = "C Cytosolic RNA spots",x="",y="% of cells")

p1d_viral_titer <- ggplot(guinardia_data, aes(hours, Viral_titer)) + 
  geom_point(color = "springgreen4", size=3, alpha=0.3)+
  geom_line(color = "springgreen4", size=1) +
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  theme_minimal() + theme(legend.position = "none", plot.title = element_text(face="bold"))+
  labs(title = "D Extracellular infectious RNA viruses",x="",y="Viral titer / mL")

p1e_bact_counts <- ggplot(bac_medians, aes(x=Hours))+
  geom_point(aes(y=Mean),size=3, alpha=0.3,color="blue4")+
  geom_line(aes(y=Mean,group=Culture,linetype=Culture),size=1,color="blue4") + 
  scale_linetype_manual(values=c("dashed", "solid"))+
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  theme_minimal() + theme(legend.position = "bottom", plot.title = element_text(face="bold"))+
  labs(title = "E Bacterial concentration",x="Time post infection (hours)",y="Bacteria / mL")

grid.newpage()
grid.draw(rbind(ggplotGrob(p1a_abundances), 
                ggplotGrob(p1b_lines), 
                ggplotGrob(p1c_lines_RNA),
                ggplotGrob(p1d_viral_titer),
                ggplotGrob(p1e_bact_counts),
                size = "last"))

################################################################
# Figure 3: Photosynthetic efficiency
p2b_FvFm <- ggplot(guinardia_data, aes(x=hours)) + 
  #geom_line(aes(y = Fv_Fm_inf), color="magenta4",size=1) + 
  #geom_line(aes(y = Fv_Fm_con), color="magenta4",size=1,linetype="dashed") +
  geom_line(aes(y = Fv_Fm_inf), size=1) + 
  geom_line(aes(y = Fv_Fm_con), size=1,linetype="dashed") +
  geom_hline(yintercept=0.6,color="grey25",size=0.3)+
  scale_x_continuous(breaks=c(seq(0,92,10)))+
  theme_minimal()+
  labs(title = "Photosynthetic efficiency",y = "Fv/Fm",x="")

################################################################
# Bar plots
p1_counts_inf <- ggplot(inf_data, aes(x=time, y=value, fill=variable))+
  geom_bar(stat="identity", position='dodge')+
  scale_fill_manual(values=c("magenta4", "grey75", "springgreen4"))+
  scale_x_discrete(labels=unique(guinardia_data$hours))+
  theme_minimal()+ theme(legend.position="none")+
  labs(y="Percentage of cells (%)",x="",title = "A  Infected culture")

p1_counts_con <- ggplot(con_data, aes(x=time, y=value, fill=variable))+
  geom_bar(stat="identity", position='dodge')+
  scale_fill_manual(values=c("magenta4", "grey75", "springgreen4"),name="",labels=c("healthy", "dead", "RNA spots visible"))+
  scale_x_discrete(labels=unique(guinardia_data$hours))+
  theme_minimal() + theme(legend.position="bottom")+
  labs(x="Time post infection (hours)", y="Percentage of cells (%)",title = "B  Control culture")

grid.newpage()
grid.draw(rbind(ggplotGrob(p3_counts_inf), ggplotGrob(p3_counts_con),size = "last"))
