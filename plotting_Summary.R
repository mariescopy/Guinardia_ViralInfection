
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
p1_viral_titer <- ggplot(guinardia_data, aes(hours, Viral_titer)) + 
    geom_point(color = "springgreen3", size=3, alpha=0.3)+
    geom_line(color = "springgreen3", size=1) + theme_bw() +
    labs(title = "Extracellular infectious viruses",x="", y = "Viral titer 1/mL]")

#p2_FvFm <- 
ggplot(guinardia_data, aes(x=hours)) + 
    geom_line(aes(y = Fv_Fm_inf), color="purple1",size=1) + 
    geom_line(aes(y = Fv_Fm_con), color="purple1",size=1,linetype="dashed") +
    theme_bw() +
    labs(title = "Photosynthetic effciency",y = "Fv/Fm",x="Time post infection (hours)")

inf_data <- melt(as.data.table(guinardia_data), id.vars=c("time", "hours"))
inf_data <- inf_data[variable=="inf_healthy" | variable=="inf_dead" | variable=="inf_spots"]

con_data <- melt(as.data.table(guinardia_data), id.vars=c("time", "hours"))
con_data <- con_data[variable=="con_healthy" | variable=="con_dead" | variable=="con_spots"]

p3_counts_inf <- ggplot(inf_data, aes(x=time, y=value, fill=variable))+
    geom_bar(stat="identity", position='dodge')+
    scale_fill_manual(values=c("purple1", "grey75", "springgreen3"))+
    scale_x_discrete(breaks=unique(data$time), labels=unique(data$hours))+
    theme_bw()+
    labs(y="Percentage of cells (%)",x="",title = "Infected culture")

p4_counts_con <- ggplot(con_data, aes(x=time, y=value, fill=variable))+
    geom_bar(stat="identity", position='dodge')+
    scale_fill_manual(values=c("purple1", "grey75", "springgreen3"))+
    scale_x_discrete(breaks=unique(data$time), labels=unique(data$hours))+
    theme_bw()+
    labs(x="Time post infection (hours)", y="Percentage of cells (%)",title = "Control culture")

# Merging plots
grid.newpage()
grid.draw(rbind(ggplotGrob(p1_viral_titer), ggplotGrob(p2_FvFm), size = "last"))

grid.newpage()
grid.draw(rbind(ggplotGrob(p3_counts_inf), ggplotGrob(p4_counts_con),size = "last"))


# NOTES
# stat='identity', 
#scale_fill_manual(values=c("red2", "yellow2", "slateblue4", "green3", "orange", "olivedrab2"))
#ggplot(dat,aes(date, volume)) + geom_bar(stat="identity") + theme_minimal() + 
#    theme(axis.title.x = element_blank(),axis.text.x = element_text(angle=90))