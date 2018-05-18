library("DESeq2")
directory <- file.path(snakemake@params["count_dir"])
sampleFiles <- list.files(directory)
samples <- read.table(file.path(snakemake@params["samples"]), sep="\t", header = TRUE)
samples <- samples[order(samples$sample),]
sampleTable <- data.frame(sampleName = sampleFiles, filename = sampleFiles, condition = samples$condition)
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable, directory = directory, design = ~ condition)
ddsHTSeq <- DESeq(ddsHTSeq)
res <- results(ddsHTSeq, name=resultsNames(ddsHTSeq)[2])
write.table(res, file.path(snakemake@output))

png(file.path(snakemake@params["plot_ma"] + ".png"))
plotMA(res, ylim = c(-3,3))
dev.off()

png(file.path(snakemake@params["plot_counts"]))
plotCounts(dds, gene=which.min(res$padj), intgroup="condition")
dev.off()
