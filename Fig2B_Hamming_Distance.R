library(e1071)
library(pheatmap)
library(export)

dat_new <- read.table("Fig2B_input_demo.txt",header=T,sep="\t",row.names=1)
dat_new[dat_new > 0] = 1
dat_new[dat_new == 0] = 0
rr <- hamming.distance(as.matrix(dat_new))
pheatmap(rr, color = colorRampPalette(c("red","white", "blue"))(50),cluster_rows = FALSE, cluster_cols = FALSE,angle_col=90,main = "ST_LUAD",fontsize_col=8)

