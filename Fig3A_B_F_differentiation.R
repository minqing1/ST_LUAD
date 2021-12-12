library(Seurat)
library(SeuratData)
library(ggplot2)
library(patchwork)
library(dplyr)
library(CytoTRACE)
library(reticulate)
library(monocle)
library(RColorBrewer)


load("Fig1_demo.RData")

#marker
stdata.markers_tmp  <- stdata.markers[stdata.markers$p_val<0.01,]
stdata.markers_tmp2 <- stdata.markers_tmp[stdata.markers_tmp$avg_logFC>0.25,]

#Extract data, phenotype data, and feature data from the SeuratObject
data_counts <- as(as.matrix(GetAssayData(stdata, slot='counts')), 'sparseMatrix')

pd <- new('AnnotatedDataFrame', data = stdata@meta.data)

fData <- data.frame(gene_short_name = row.names(data_counts), row.names = row.names(data_counts))
fd <- new('AnnotatedDataFrame', data = fData)

#Construct monocle cds
monocle_cds <- newCellDataSet(data_counts, phenoData = pd, featureData = fd, lowerDetectionLimit = 0.1, expressionFamily = negbinomial.size())
print(head(pData(monocle_cds)))
print(head(fData(monocle_cds)))

#Estimate size factors and dispersions Required
monocle_cds <- estimateSizeFactors(monocle_cds) #SizeFactor
monocle_cds <- estimateDispersions(monocle_cds) #Dispersions

#Filtering low-quality cells Recommended
monocle_cds <- detectGenes(monocle_cds, min_expr = 0.1)
print(head(pData(monocle_cds)))
print(head(fData(monocle_cds)))
expressed_genes <- row.names(subset(fData(monocle_cds), num_cells_expressed >= 10))
expressed_genes2 <- expressed_genes[expressed_genes %in% stdata.markers_tmp2$gene]


##Trajectory step 1: choose genes that define a cell's progress
monocle_cds <- setOrderingFilter(monocle_cds, expressed_genes2)
plot_ordering_genes(monocle_cds)

#Trajectory step 2: reduce data dimensionality
monocle_cds <- reduceDimension(monocle_cds, max_components = 2,  method = 'DDRTree')

#Trajectory step 3: order cells along the trajectory
monocle_cds <- orderCells(monocle_cds)
save(monocle_cds,expressed_genes2,file = "demo_monocle_cds.Rdata")



### CytoTrace
py_available()

Sys.setenv(RETICULATE_PYTHON="/usr/local/bin/python3")
py_discover_config()

import("os")
py_available()

load("Fig1_demo.RData")
load("demo_monocle_cds.Rdata")

sample_mat <- stdata@assays$SCT@counts
sample_phe <- stdata@meta.data$seurat_clusters
names(sample_phe) <- rownames(stdata@meta.data)


emb = t(monocle_cds@reducedDimS)
mat = as.matrix(sample_mat)
phe3 = as.numeric(sample_phe)
names(phe3) = names(sample_phe)


results <- CytoTRACE(mat,ncores =60,enableFast=FALSE)
plotCytoTRACE(results, phenotype = phe3, emb=emb, outputDir="./ST_P1/") 
plotCytoGenes(results, numOfGenes = 10,outputDir="./ST_P1/")

cluster <- as.matrix(sample_phe)
cytoscore <- as.matrix(results$CytoTRACE)
cytoscore2 <- cbind(cytoscore,cluster[rownames(cytoscore),])
colnames(cytoscore2) <- c("Score","Cluster")

write.table(cytoscore2, file ="./ST_P1/ST_P1.CytoTRACE_score", sep ="\t", row.names =TRUE, col.names =TRUE, quote =FALSE)


cytogene <- as.matrix(results$cytoGenes)
colnames(cytogene) <- c('Correlation')
write.table(cytogene, file ="./ST_P1/ST_P1.cytogene", sep ="\t", row.names =TRUE, col.names =TRUE, quote =FALSE)


#projection
stdata[['Pseudotime']] <- 0
stdata[['Pseudotime']][rownames(as.matrix(results$CytoTRACE)),] <- as.matrix(results$CytoTRACE)[,1]

pdf("ST_P1_CytoTRACE_Pseudotime.pdf",width=8 ,height=8)
SpatialFeaturePlot(stdata, features = c("Pseudotime"))
dev.off()







