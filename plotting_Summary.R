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

###############################################
# Figure 2: Abundance, Photosynthetic efficiency, viral titer
p2a_abundances  <-  ggplot(guinardia_data, aes(x=hours)) + 
    geom_line(aes(y = abun_inf), size=1) + 
    geom_line(aes(y = abun_con), size=1,linetype="dashed") +
    theme_minimal() + theme(plot.title = element_text(face="bold"))+
    labs(title = "A  Cell abundances",y = "Cells per mL",x="")

p2b_FvFm <- ggplot(guinardia_data, aes(x=hours)) + 
  #geom_line(aes(y = Fv_Fm_inf), color="magenta4",size=1) + 
  #geom_line(aes(y = Fv_Fm_con), color="magenta4",size=1,linetype="dashed") +
  geom_line(aes(y = Fv_Fm_inf), size=1) + 
  geom_line(aes(y = Fv_Fm_con), size=1,linetype="dashed") +
  geom_hline(yintercept=0.6,color="grey25",size=0.3)+
  theme_minimal()+ theme(plot.title = element_text(face="bold"))+
  labs(title = "B  Photosynthetic effciency",y = "Fv/Fm",x="")

p2c_viral_titer <- ggplot(guinardia_data, aes(hours, Viral_titer)) + 
    geom_point(size=3, alpha=0.3)+
    geom_line(size=1) +
    #geom_point(color = "springgreen4", size=3, alpha=0.3)+
    #geom_line(color = "springgreen4", size=1) +
    theme_minimal() + theme(plot.title = element_text(face="bold"))+
    labs(title = "C  Extracellular infectious viruses",x="Time post infection (hours)",y="Viral titer [1/mL]")

grid.newpage()
grid.draw(rbind(ggplotGrob(p2a_abundances), ggplotGrob(p2b_FvFm), ggplotGrob(p2c_viral_titer),size = "last"))

###############################################
# Figure 3: Mortality, RNA spots
inf_data <- melt(as.data.table(guinardia_data), id.vars=c("time", "hours"))
inf_data <- inf_data[variable=="inf_healthy" | variable=="inf_dead" | variable=="inf_spots"]

con_data <- melt(as.data.table(guinardia_data), id.vars=c("time", "hours"))
con_data <- con_data[variable=="con_healthy" | variable=="con_dead" | variable=="con_spots"]

# Bar plots
p3_counts_inf <- ggplot(inf_data, aes(x=time, y=value, fill=variable))+
    geom_bar(stat="identity", position='dodge')+
    scale_fill_manual(values=c("magenta4", "grey75", "springgreen4"))+
    scale_x_discrete(labels=unique(guinardia_data$hours))+
    theme_minimal()+ theme(legend.position="none", plot.title = element_text(face="bold"))+
    labs(y="Percentage of cells (%)",x="",title = "A  Infected culture")

p3_counts_con <- ggplot(con_data, aes(x=time, y=value, fill=variable))+
    geom_bar(stat="identity", position='dodge')+
    scale_fill_manual(values=c("magenta4", "grey75", "springgreen4"),name="",labels=c("healthy", "dead", "RNA spots visible"))+
    scale_x_discrete(labels=unique(guinardia_data$hours))+
    theme_minimal() + theme(legend.position="bottom", plot.title = element_text(face="bold"))+
    labs(x="Time post infection (hours)", y="Percentage of cells (%)",title = "B  Control culture")

grid.newpage()
grid.draw(rbind(ggplotGrob(p3_counts_inf), ggplotGrob(p3_counts_con),size = "last"))

#Area plots?
ggplot(guinardia_tidy,aes(x=hours))+
  geom_area(aes(y=healthy), alpha=0.2, position='dodge', fill="magenta4")+
  geom_area(aes(y=dead), alpha=0.4, position='dodge', fill="grey75")+
  geom_area(aes(y=spots), alpha=0.5, position='dodge', fill="springgreen4")+
  facet_grid(Culture~.)+
  theme_minimal()
