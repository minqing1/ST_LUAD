library(Seurat)
library(SeuratData)
library(ggplot2)
library(patchwork)
library(dplyr)

##Integration with a scRNA-seq reference
##A reference scRNA-seq dataset of a molecular cell atlas of human lung was obtained from:
##Travaglini KJ, et al. A molecular cell atlas of the human lung from single-cell RNA sequencing. Nature 587, 619-625 (2020).

load("Reference.Rdata")
load("demo.RData")

anchors <- FindTransferAnchors(reference = hlca , query = stdata, normalization.method = "SCT")

predictions.assay <- TransferData(anchorset = anchors, refdata = hlca$free_annotation, prediction.assay = TRUE, weight.reduction = stdata[["pca"]])

write.table (predictions.assay@data, file ="Annotation.txt", sep ="\t", row.names =TRUE, col.names =TRUE, quote =FALSE)

stdata[["predictions"]] <- predictions.assay

DefaultAssay(stdata) <- "predictions"


