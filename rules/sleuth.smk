rule sleuth:
	input:
		expand(config["folders"]["output_folder"] + "/{dataset}/abundance.h5", dataset=list(samples.index)),
		expand(config["folders"]["output_folder"] + "/{dataset}/abundance.tsv", dataset=list(samples.index)),
		expand(config["folders"]["output_folder"] + "/{dataset}/run_info.json", dataset=list(samples.index)),
		config["sleuth"]["sample_condition"]
	output:
		config["folders"]["output_folder"] + "/sleuth_output.tsv"
	conda: "../envs/ks-env.yaml"
	params:
		sample_tsv = config["samples"],
		kal_dirs = config["folders"]["output_folder"],
		sample_condition = config["sleuth"]["sample_condition"],
		outfile = config["folders"]["output_folder"] + "/sleuth_output.tsv"
	script:
		"../scripts/sleuth.R"
