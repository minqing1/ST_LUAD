library(psych)
library(pheatmap)
library(corrplot)

sample <- read.table('mIHC_subtype_density_all_positive_selected_format.txt', header = TRUE, sep = "\t")
dim(sample)
sample <- sample[,-c(124)]
sample_tumor = sample[sample$class =="Tumor",c(4:123)]

tt <- corr.test(sample_tumor,method="spearman",adjust="holm") 
#For symmetric matrices, p values adjusted for multiple tests are reported above the diagonal
write.table(tt$r, file ='co-localization.spearman.matrix', sep ="\t", row.names =TRUE, col.names =TRUE, quote =FALSE)
write.table(tt$p, file ='co-localization.spearman.matrix.pvalue', sep ="\t", row.names =TRUE, col.names =TRUE, quote =FALSE)


sample_tumor = sample[sample$class =="Tumor",c('d_PANCK_P','d_CD68_P','d_CD206.CD68_PP','d_CD163.CD206.CD68_NPP','d_CD163.CD68_PP','d_CD163.CD206.CD68_PNP','d_CD163.CD206.CD68_PPP','d_ICSBP_P','d_CD68.ICSBP_PP')]
tt <- corr.test(sample_tumor,method="spearman",adjust="holm") 
corrplot(as.matrix(tt$r), order = "alphabet",col = colorRampPalette(c("darkblue","white","darkred"))(100),method = "color",tl.col="black",tl.cex = 0.7,cl.pos = "r",cl.lim=c(-1,1),cl.ratio = 0.1,cl.cex=0.8,cl.length=5,p.mat = as.matrix(tt$p), type="full",insig = "label_sig", sig.level = c(.001, .01, .05),pch.cex = .9,diag=FALSE,pch.col = "white")



sample_tumor_5MP <- sample[sample$class =="Tumor" & sample$Subtype =="5MP",c('d_PANCK_P','d_CD68_P','d_CD206.CD68_PP','d_CD163.CD206.CD68_NPP','d_CD163.CD68_PP','d_CD163.CD206.CD68_PNP','d_CD163.CD206.CD68_PPP','d_ICSBP_P','d_CD68.ICSBP_PP')]
tt_sample_tumor_5MP <- corr.test(sample_tumor_5MP,method="spearman",adjust="holm")
tt_sample_tumor_5MP$r

corrplot(as.matrix(tt_sample_tumor_5MP$r), order = "alphabet",col = colorRampPalette(c("darkblue","white","darkred"))(100),method = "color",tl.col="black",tl.cex = 0.7,cl.pos = "r",cl.lim=c(-1,1),cl.ratio = 0.1,cl.cex=0.8,cl.length=5,p.mat = as.matrix(tt_sample_tumor_5MP$p), type="full",insig = "label_sig", sig.level = c(.001, .01, .05),pch.cex = .9,diag=FALSE,pch.col = "white")


