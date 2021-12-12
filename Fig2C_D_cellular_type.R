library(ggplot2)
library(ggsignif)
library("RColorBrewer")
library(gridExtra)
library(ggpubr)
library(patchwork)


dat <- read.table("Fig2C_D_subtype_for_plot_demo.txt", header=T,sep="\t")

## Club cells
dat3_club <- dat[dat$Cell  %in% c('Club'),]
ggplot(dat3_club,aes(x=reorder(Subtype, Score, median),y=Score,color=factor(Subtype)))+scale_y_continuous(name = "Proportion")+ scale_x_discrete(name = "Subtype")+scale_color_manual(values=c("dodgerblue3","purple4","green4","seashell4","sienna4","brown3"))+theme_classic()+geom_boxplot(fatten = 4,alpha=0.8,show.legend = FALSE,outlier.alpha=0)+ scale_fill_manual(values=c("dodgerblue3","purple4","green4","seashell4","sienna4","brown3")) + theme(axis.text.x = element_text(color = "black"),axis.text.y = element_text(color = "black")) + geom_jitter(mapping=aes(x=Subtype,y=Score,color=factor(Subtype), alpha = 0.3,size=0.5),show.legend = FALSE) + labs(title="Club")


## S pattern
dat4_s <- dat[dat$Subtype %in% c('S'),] 
ggplot(dat4_s,aes(x=reorder(Cell, Score, median),y=Score,color=factor(Celltype)))+scale_y_continuous(name = "Proportion")+scale_x_discrete(name = "Cell")+theme_classic()+geom_boxplot(alpha=0.8,aes(fill=Celltype),show.legend = TRUE)+theme(panel.background = element_blank(),axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))+scale_fill_manual(values=c("brown3","purple4","green4","sienna4"))+scale_color_manual(values=c("brown3","purple4","green4","sienna4")) + theme(axis.text.x = element_text(color = "black"),axis.text.y = element_text(color = "black"))+theme(axis.text.x=element_text(size=8)) + labs(title="S")




