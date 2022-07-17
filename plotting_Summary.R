library(readxl)
library(ggplot2)
library(data.table)
library(RColorBrewer)
library(grid)

setwd("S:/Quantification/")

# Opening the data
guinardia_data <- read_excel("SummaryQuantifications.xlsx", 1, na="")
names(guinardia_data)

#data <- rbind(chl_sph, chl_vol, nuc_vol)
#head(data)

# Plotting
p1a_abundances  <-  ggplot(guinardia_data, aes(x=hours)) + 
    geom_line(aes(y = abun_inf), size=1) + 
    geom_line(aes(y = abun_con), size=1,linetype="dashed") +
    theme_bw() + theme(plot.title = element_text(face="bold"))+
    labs(title = "A  Cell abundances",y = "Cells per mL",x="")

p1_viral_titer <- ggplot(guinardia_data, aes(hours, Viral_titer)) + 
    geom_point(color = "springgreen3", size=3, alpha=0.3)+
    geom_line(color = "springgreen3", size=1) + theme_bw() +
    theme(plot.title = element_text(face="bold"))+
    labs(title = "C  Extracellular infectious viruses",x="", y = "Viral titer [1/mL]")

p2_FvFm <- ggplot(guinardia_data, aes(x=hours)) + 
    geom_line(aes(y = Fv_Fm_inf), color="magenta3",size=1) + 
    geom_line(aes(y = Fv_Fm_con), color="magenta3",size=1,linetype="dashed") +
    geom_hline(yintercept=0.6,color="grey25",size=0.3)+
    theme_bw() + theme(plot.title = element_text(face="bold"))+
    labs(title = "B  Photosynthetic effciency",y = "Fv/Fm",x="Time post infection (hours)")

# Merging plots
grid.newpage()
grid.draw(rbind(ggplotGrob(p1a_abundances), ggplotGrob(p2_FvFm), ggplotGrob(p1_viral_titer),size = "last"))


inf_data <- melt(as.data.table(guinardia_data), id.vars=c("time", "hours"))
inf_data <- inf_data[variable=="inf_healthy" | variable=="inf_dead" | variable=="inf_spots"]

con_data <- melt(as.data.table(guinardia_data), id.vars=c("time", "hours"))
con_data <- con_data[variable=="con_healthy" | variable=="con_dead" | variable=="con_spots"]

p3_counts_inf <- ggplot(inf_data, aes(x=time, y=value, fill=variable))+
    geom_bar(stat="identity", position='dodge')+
    scale_fill_manual(values=c("magenta3", "grey75", "springgreen3"))+
    scale_x_discrete(breaks=unique(data$time), labels=unique(data$hours))+
    theme_bw()+ theme(legend.position="none", plot.title = element_text(face="bold"))+
    labs(y="Percentage of cells (%)",x="",title = "A | Infected culture")

p4_counts_con <- ggplot(con_data, aes(x=time, y=value, fill=variable))+
    geom_bar(stat="identity", position='dodge')+
    scale_fill_manual(values=c("magenta3", "grey75", "springgreen3"),name="",labels=c("healthy", "dead", "RNA spots visible"))+
    scale_x_discrete(breaks=unique(data$time), labels=unique(data$hours))+
    theme_bw() + theme(legend.position="bottom", plot.title = element_text(face="bold"))+
    labs(x="Time post infection (hours)", y="Percentage of cells (%)",title = "B | Control culture")

# Merging plots
grid.newpage()
grid.draw(rbind(ggplotGrob(p3_counts_inf), ggplotGrob(p4_counts_con),size = "last"))