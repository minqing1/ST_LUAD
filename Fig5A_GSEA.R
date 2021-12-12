library(GSVA)
library(GSVAdata)
library(GSEABase)
library(limma)

kegg <- getGmt("GSVA/c2.cp.kegg.v7.3.symbols.gmt")
reactome <- getGmt("GSVA/c2.cp.reactome.v7.3.symbols.gmt")
hallmark <- getGmt("GSVA/h.all.v7.3.symbols.gmt")


dat <- read.table("stdata_counts.txt", header=T,row.names=1,sep="\t")
kegg_result <- gsva(expr=as.matrix(dat),kegg, method='ssgsea', kcdf="Gaussian", parallel.sz=50)
write.table(kegg_result, file = "GSVA/GSVA_KEGG.txt", quote = FALSE, sep = "\t")

dat <- read.table("stdata_counts.txt", header=T,row.names=1,sep="\t")
reactome_result <- gsva(expr=as.matrix(dat),reactome, method='ssgsea', kcdf="Gaussian", parallel.sz=50)
write.table(reactome_result, file = "GSVA/GSVA_Reactome.txt", quote = FALSE, sep = "\t")

dat <- read.table("stdata_counts.txt", header=T,row.names=1,sep="\t")
hallmark_result <- gsva(expr=as.matrix(dat),hallmark, method='ssgsea', kcdf="Gaussian", parallel.sz=50)
write.table(hallmark_result, file = "GSVA/GSVA_Hallmark.txt", quote = FALSE, sep = "\t")



