# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.
import pandas as pd

configfile: "config.yaml"

samples = pd.read_table(config["samples"], index_col="sample")

rule all:
	input:
		# Uncomment one of the following lines for desired workflow
		
		# kallisto -> sleuth
		#config["sleuth"]["out"] + "/sleuth_output.tsv"
		# kallisto -> deseq2
		#config["deseq2"]["kal_out"]
		# Hisat2 -> deseq2
		#config["deseq2"]["htseq_out"]
		


include: "rules/sleuth.smk"
include: "rules/deseq2.smk"
include: "rules/htseq-count.smk"
include: "rules/samtools.smk"
include: "rules/hisat2.smk"
include: "rules/trim.smk"
include: "rules/kallisto.smk"
include: "rules/fastqc.smk"
