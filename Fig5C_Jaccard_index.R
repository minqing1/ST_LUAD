library(GSVA)
library(GSVAdata)
library(GSEABase)
library(limma)

kegg <- getGmt("c2.cp.kegg.v7.3.symbols.gmt")  ##186 gene sets
reactome <- getGmt("c2.cp.reactome.v7.3.symbols.gmt")  ##1569 gene sets 
hallmark <- getGmt("h.all.v7.3.symbols.gmt") ##50 gene sets 


sig_kegg     <- read.table("GSVA_subtype_selected_kegg",header=F,sep="\t")
sig_hallmark <- read.table("GSVA_subtype_selected_hallmark",header=F,sep="\t")
sig_reactome <- read.table("GSVA_subtype_selected_reactome",header=F,sep="\t")

dat <- read.table("GSVA_cluster_combine.txt", header=T,row.names=1,sep="\t")
dat2 <- dat[,-length(colnames(dat))]


## kegg&reactome Jaccard index; as well as other pairs
for(var in sig_kegg$V1) {
for(var2 in sig_reactome$V1) {

aa = geneIds(kegg[[var]])[geneIds(kegg[[var]]) %in% rownames(dat2)]
bb = geneIds(reactome[[var2]])[geneIds(reactome[[var2]]) %in% rownames(dat2)]

ints = length(intersect(aa, bb))
uno = length(union(aa, bb))
jac=ints/uno

rr = paste("Jaccard",var,var2,jac,sep = "\t")
#cat(rr,"\n")
#cat("Jaccard","\t",var,"\t",var2,"\t",jac,"\n")

write.table(rr, file = "Jaccard_result", append = TRUE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)

}
}

