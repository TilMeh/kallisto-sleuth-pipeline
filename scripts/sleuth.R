suppressMessages({
	library("sleuth")
	library(biomaRt)
})
sample_id <- t(read.delim(file.path(snakemake@params["sample_tsv"]), header = TRUE, sep="\t")["sample"])
kal_dirs <- file.path(snakemake@params["kal_dirs"], sample_id)
print("Directories containing kallisto results: \n")
print(kal_dirs)
s2c <- read.table(file.path(snakemake@config["samples"]), header = TRUE, sep = "\t", stringsAsFactors = FALSE)
print(s2c)
print("Appending kallisto result file paths")
s2c <- dplyr::mutate(s2c, path = kal_dirs)
print(s2c)
print("Generating sleuth object")
so <- sleuth_prep(s2c, extra_bootstrap_summary = TRUE)
print("Fitting full model")
so <- sleuth_fit(so, ~condition, 'full')
print("Fitting reduced model")
so <- sleuth_fit(so, ~1, 'reduced')
print("Likelihood ratio test for the models")
so <- sleuth_lrt(so, 'reduced', 'full')
sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)
print("Creating plot")
head(sleuth_significant, 20)
sleuth_plot <- plot_bootstrap(so, sleuth_significant[1, 1], units = "est_counts", color_by = "condition")
print("Saving plot")
ggplot2::ggsave(filename="data/output/plot.pdf", plot=sleuth_plot)
print("Writing results to output")
write(t(sleuth_significant), file = file.path(snakemake@params["outfile"]), sep = "\t")

## Including gene names into transcript-level analysis

print("Downloading from ensembl.org")
#source("http://bioconductor.org/biocLite.R")
#biocLite("biomaRt")

mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL",
  dataset = "scerevisiae_gene_ensembl",
  host = 'host = "ensembl.org"')
print("2")
t2g <- biomaRt::getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id",
    "external_gene_name"), mart = mart)
print("2.2")
t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id,
  ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
print("3")
so <- sleuth_prep(s2c, target_mapping = t2g)
so <- sleuth_fit(so, ~condition, 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_lrt(so, 'reduced', 'full')
print("4")
pca_plot <- plot_pca(so, color_by = 'condition')
print("Printing PCA plot")
ggplot2::ggsave(filename="data/output/plot_pca.pdf", plot=pca_plot)
plot_group_density(so, use_filtered = TRUE, units = "est_counts",
  trans = "log", grouping = setdiff(colnames(so$sample_to_covariates),
  "sample"), offset = 1)

