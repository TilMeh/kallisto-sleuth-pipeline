library("DESeq2")
#library("apeglm")

# Prepare colData
samples <- read.table(file.path(snakemake@config["samples"]), sep = "\t", header = TRUE)

# Prepare countData
col_names <- samples$sample
print("Reading abu_files")
abu_files <- file.path(snakemake@params["out_folder"], col_names, "abundance.tsv")
row_names <- read.table(abu_files[1], sep="\t", header=TRUE)$target_id

combined_counts <- read.table(abu_files[1], sep="\t", header = TRUE)[, c("target_id", "est_counts")]
combined_counts$est_counts <- round(combined_counts$est_counts)
for(i in 2:length(abu_files)){
	temp_counts <- read.table(abu_files[i], sep="\t", header = TRUE)[, c("target_id", "est_counts")]
	temp_counts$est_counts <- round(temp_counts$est_counts)
	combined_counts <- merge(combined_counts, temp_counts, by = "target_id", all = TRUE)
}
combined_counts <- combined_counts[2:(length(abu_files) + 1)]
colnames(combined_counts) <- col_names
rownames(combined_counts) <- row_names

dds <- DESeqDataSetFromMatrix(countData = combined_counts, colData = samples, design=~condition)
dds <- DESeq(dds, fitType="mean")
res <- results(dds, name = resultsNames(dds)[2])
#resLFC <- lfcShrink(dds, coeff=2, type="apeglm")
write.table(res, file.path(snakemake@output))

png(file.path(paste(snakemake@params["plot_ma"], ".png"), sep=""))
plotMA(res, ylim = c(-3,3))
dev.off()

png(file.path(paste(snakemake@params["plot_counts"], ".png", sep="")))
plotCounts(dds, gene=which.min(res$padj), intgroup="condition")
dev.off()


#png(file.path(paste(snakemake@params["plot_ma"], "_lfc.png", sep="")))
#plotMA(resLFC, ylim = c(-3,3))
#dev.off()
