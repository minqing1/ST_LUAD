library(e1071)
library(pheatmap)
library(export)


dat <- read.table("Fig2E_heatmap_TAM_forplot_demo.txt",header=T,sep="\t",row.names=1)

pheatmap(t(dat), color = colorRampPalette(c("white", "red"))(20),cluster_rows = TRUE, cluster_cols = FALSE,angle_col=90,main = "Macrophage",fontsize_col=8,border_color="white")



