rule sleuth:
	input:
		expand(config["kallisto"]["out"] + "/{dataset}/abundance.h5", dataset=list(samples.index)),
		expand(config["kallisto"]["out"] + "/{dataset}/abundance.tsv", dataset=list(samples.index)),
		expand(config["kallisto"]["out"] + "/{dataset}/run_info.json", dataset=list(samples.index)),
		config["samples"]
	output:
		config["sleuth"]["out"] + "/sleuth_output.tsv"
	conda: "../envs/ks-env.yaml"
	params:
		sample_tsv = config["samples"],
		kal_dirs = config["kallisto"]["out"],
		outfile = config["sleuth"]["out"] + "/sleuth_output.tsv",
		bs_plot = config["sleuth"]["out"] + "/bootstrap_",
		pca_plot = config["sleuth"]["out"] + "/pca_plot.pdf",
		gdens_plot = config["sleuth"]["out"] + "/gdens_plot.pdf",
		ensembl_data = "scerevisiae_gene_ensembl",
		
	script:
		"../scripts/sleuth.R"
