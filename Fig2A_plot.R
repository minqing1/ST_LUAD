library(devtools)
library(ggplot2)
library(export)
library(patchwork)
library(dplyr)


dat <- read.table("Fig2A_heatmap_for_plot_demo.txt",header=T,sep="\t")
dat3 <- dat[order(dat$CellName,decreasing = FALSE),]
Score2 <- dat3$Score *100
dat4 <- cbind(dat3,Score2)

rr <- ggplot(dat4, aes(Cluster, CellName, size = Score, color = Sample)) + 
geom_point() + scale_colour_manual(values = c("dodgerblue3","purple4","green4","brown3","sienna4")) + 
theme(panel.background = element_blank()  ,axis.text.x = element_text(angle = 90, hjust = 1, vjust = 1)) +
theme(legend.key = element_blank()) +
theme(axis.text.x=element_text(size=10))


##### celltype proportion
header=paste("Result","\t","CellType","\t","Score")
write.table (header, file ="CellType_percent", sep ="\t", row.names =FALSE, col.names =FALSE, quote =FALSE,append = TRUE)

for (i in rev(unique(dat4$CellName))){
  tt = sum(dat4[dat4$CellName==i,'Score'])*100/51
  tt1 =paste("Result","\t",i,"\t",round(tt,2))
  cat(tt1,"\n")
  write.table (tt1, file ="Fig2A_CellType_percent", sep ="\t", row.names =FALSE, col.names =FALSE, quote =FALSE,append = TRUE)
}

dat_cell <- read.table("Fig2A_CellType_percent",header=T,sep="\t")

ggplot(dat_cell, aes(CellType, Score)) + geom_bar(stat = "identity", width = 0.5) + theme_classic() +theme(panel.background = element_blank(), axis.text.x = element_text(angle = 90, hjust = 1, vjust = 1))


