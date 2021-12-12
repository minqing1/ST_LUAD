library(Seurat)
library(ggplot2)
library(patchwork)
library(dplyr)
library(SCENIC)
library(foreach)
library(doSNOW)
library(doParallel) 
library(doMPI)
library(png)

options(bitmapType='cairo')

load("demo.RData")

##cell meta
cellInfo0 <- data.frame(stdata@meta.data)
colnames(cellInfo0)[which(colnames(cellInfo0)=="seurat_clusters")] <- "cluster"
cellInfo <- data.frame(cellInfo0[,c("cluster")])
rownames(cellInfo) <- rownames(cellInfo0)
colnames(cellInfo) <- "cluster"
saveRDS(cellInfo, file="cellInfo.Rds")

##expression matrix
exprMat <- as.matrix(GetAssayData(stdata, slot='counts'))

##set environments
mydbDIR <- "./cisTarget/"
mydbs <- c("hg38__refseq-r80__500bp_up_and_100bp_down_tss.mc9nr.feather", "hg38__refseq-r80__10kb_up_and_down_tss.mc9nr.feather")
names(mydbs) <- c("500bp", "10kb")

scenicOptions <- initializeScenic(org="hgnc", nCores=20, dbDir=mydbDIR, dbs = mydbs, datasetTitle = "sampledemo")

##filter
genesKept <- geneFiltering(exprMat, scenicOptions, minCountsPerGene = 3 * 0.01 * ncol(exprMat), minSamples = ncol(exprMat) * 0.01)
exprMat_filtered <- exprMat[genesKept, ]


##correlation
runCorrelation(exprMat_filtered, scenicOptions)

##TF-Targets
exprMat_filtered_log <- log2(exprMat_filtered+1)
runGenie3(exprMat_filtered_log, scenicOptions, nParts = 10)

runSCENIC_1_coexNetwork2modules(scenicOptions)

runSCENIC_2_createRegulons(scenicOptions, coexMethod=c("top5perTarget"))

scenicOptions@settings$nCores <- 1
runSCENIC_3_scoreCells(scenicOptions, exprMat=exprMat_filtered_log)

runSCENIC_4_aucell_binarize(scenicOptions)


regulonAUC <- loadInt(scenicOptions, "aucell_regulonAUC") 
regulonAUC <- regulonAUC[onlyNonDuplicatedExtended(rownames(regulonAUC)),]
regulonActivity_byCellType <- sapply(split(rownames(cellInfo), cellInfo\$cluster),function(cells) rowMeans(getAUC(regulonAUC)[,cells]))
write.table(regulonActivity_byCellType, file = "int/3.4_regulonAUC.txt", sep = "\t",quote=F)

