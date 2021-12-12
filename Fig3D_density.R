library(ggplot2)
library(ggsignif)
library("RColorBrewer")
library(gridExtra)
library(ggpubr)
library(patchwork)
library(export)

dat <- read.table("Fig3A_3B_CytoTRACE_for_plot.txt", header=T,sep="\t")
dat_MP <- dat[dat$Sample %in% c('ST_P1','ST_P5','ST_P6') & dat$Subtype %in% c('MP'),]

ggplot(dat_MP, aes(x = Score, group=Sample, fill=Sample)) + geom_density(adjust=1.5, alpha=.7)+ scale_fill_manual(values=c("green4","brown3","seashell4")) + theme_classic() + theme(panel.background = element_blank(), axis.text.x = element_text(angle = 0, hjust = 1, vjust = 1))+ xlab("Differentiation score") + ylab("Density")+ theme(axis.text.x = element_text(color = "black"),axis.text.y = element_text(color = "black"))

