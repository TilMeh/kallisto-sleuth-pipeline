rule deseq2_kallisto:
	input:
		expand(config["kallisto"]["out"] + "/{dataset}/abundance.h5", dataset=list(samples.index)),
                expand(config["kallisto"]["out"] + "/{dataset}/abundance.tsv", dataset=list(samples.index)),
                expand(config["kallisto"]["out"] + "/{dataset}/run_info.json", dataset=list(samples.index)),
                config["samples"]
	output:
		config["deseq2"]["kal_out"]
	conda: "../envs/deseq2-env.yaml"
	params:
		out_folder = config["kallisto"]["out"],
		plot_ma = config["deseq2"]["plot_ma"],
		plot_counts = config["deseq2"]["plot_counts"]
	script:
		"../scripts/deseq_kallisto.R"

rule deseq2_htseq:
	input:
		expand(config["htseq-count"]["out"] + "/{sample}.counts", sample=list(samples.index))
	output:
		config["deseq2"]["htseq_out"]
	conda: "../envs/deseq2-env.yaml"
	params:
		count_dir = config["htseq-count"]["out"],
		samples = config["samples"],
		plot_ma = config["deseq2"]["plot_ma"],
		plot_counts = config["deseq2"]["plot_counts"]
	script:
		"../scripts/deseq_htseq-count.R"
