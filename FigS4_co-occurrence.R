library(psych)
library(pheatmap)
library(corrplot)
library(export)

st_p5 <- read.table('FigS4_ST_P5.transfer', header = TRUE, sep = "\t",row.names=1)
which(rownames(st_p5)=="max")
st_p5 <- st_p5[-which(rownames(st_p5)=="max"),]

tt <- corr.test(t(st_p5),method="pearson",adjust="holm") 

tt$r[is.na(tt$r)] <- 0
tt$p[is.na(tt$p)] <- 1


corrplot(as.matrix(tt$r), order = "hclust",col = colorRampPalette(c("darkblue","white","darkred"))(100),method = "color",tl.col="black",tl.cex = 0.7,cl.pos = "r",cl.lim=c(-1,1),cl.ratio = 0.1,cl.cex=0.8,cl.length=5,p.mat = as.matrix(tt$p), sig.level = 0.05,outline="white",insig = "blank",type="full")


