gene_universe = bkground # Size of gene universe (in this example: number of genes in the expression matrix)
gene_set1 = a_num       # Number of cancer region specific genes (Spatial Transcriptomics)
gene_set2 = b_num       # Number of fibroblast specific genes (scRNA-seq)
gene_intersect = num   # Number of genes in common between these two gene sets

-log10(phyper(gene_intersect, gene_set1, gene_universe-gene_set1, gene_set2, lower.tail = FALSE))


