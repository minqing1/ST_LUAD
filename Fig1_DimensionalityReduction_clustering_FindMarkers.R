library(Seurat)
library(SeuratData)
library(ggplot2)
library(patchwork)
library(dplyr)


# Data preprocessing, skipped
# plot1 <- VlnPlot(stdata, features = "nCount_Spatial", pt.size = 0.1) + NoLegend()
# plot2 <- SpatialFeaturePlot(stdata, features = "nCount_Spatial") + theme(legend.position = "right")
# wrap_plots(plot1, plot2)
# #sctransform 
# stdata <- SCTransform(stdata, assay = "Spatial", verbose = FALSE) 
# #Dimensionality reduction, clustering, and visualization
# stdata <- RunPCA(stdata, assay = "SCT", verbose = FALSE)
# stdata <- FindNeighbors(stdata, reduction = "pca", dims = 1:30)
# stdata <- FindClusters(stdata, verbose = FALSE) 
# stdata <- RunUMAP(stdata, reduction = "pca", dims = 1:30)

load("Fig1_demo.RData")

##tSNE
DimPlot(stdata, reduction = "tsne", label = TRUE)

##UMAP
DimPlot(stdata, reduction = "umap", label = TRUE)

##Clusters
SpatialDimPlot(stdata, label = TRUE, label.size = 3)

##Differentially expressed genes 
#stdata.markers <- FindAllMarkers(stdata, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
stdata.markers %>% group_by(cluster) %>% top_n(n = 20, wt = avg_logFC)
DoHeatmap(stdata, features = top20$gene)

