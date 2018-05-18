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
		plot = config["sleuth"]["out"] + "/plot.pdf"
	script:
		"../scripts/sleuth.R"
