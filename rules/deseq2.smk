rule deseq2:
	input:
		expand(config["folders"]["output_folder"] + "/{dataset}/abundance.h5", dataset=list(samples.index)),
                expand(config["folders"]["output_folder"] + "/{dataset}/abundance.tsv", dataset=list(samples.index)),
                expand(config["folders"]["output_folder"] + "/{dataset}/run_info.json", dataset=list(samples.index)),
                config["samples"]
	output:
		config["deseq2"]["results"]
	conda: "../envs/deseq2-env.yaml"
	params:
		out_folder = config["folders"]["output_folder"]
	script:
		"../scripts/deseq_kallisto.R"
