cellphonedb method statistical_analysis --counts-data hgnc_symbol  --project-name  stdata --threshold 0.4 --output-path  ST_P1/  --threads  60  ST_P1/stdata_meta.txt ST_P1/stdata_counts.txt  

cellphonedb plot dot_plot --means-path ST_P1/stdata/means_filter.txt   --pvalues-path ST_P1/stdata/pvalues.txt   --output-path ST_P1/stdata   --output-name ST_P1/stdata/dot_plot.pdf
