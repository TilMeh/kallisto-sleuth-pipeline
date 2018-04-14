rule kallisto_index:
	input:
		config["reference"] + ".fa"
	output:
		config["reference"] + ".idx"
	conda: "../envs/kallisto-sleuth.yaml"
	shell:
		"kallisto index -i {output[0]} {input[0]}"

rule kallisto_quant:
	input:
		config["reference"] + ".idx",
		config["folders"]["trim_folder"] + "/{sample}_1_val_1.fq.gz",
		config["folders"]["trim_folder"] + "/{sample}_2_val_2.fq.gz"
	output:
		config["folders"]["output_folder"] + "/{sample}/abundance.h5",
		config["folders"]["output_folder"] + "/{sample}/abundance.tsv",
		config["folders"]["output_folder"] + "/{sample}/run_info.json"
	conda: "../envs/kallisto-sleuth.yaml"
	params:
		out_dir = config["folders"]["output_folder"] + "/{sample}",
		bs_samples = config["kallisto"]["bootstrap_samples"]
	shell:
		"kallisto quant -i {input[0]} -o {params.out_dir} -b {params.bs_samples} {input[1]} {input[2]}"
