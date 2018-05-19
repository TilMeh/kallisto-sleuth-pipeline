rule kallisto_index:
	input:
		config["reference"]["genome"] + ".fa"
	output:
		config["reference"]["genome"] + ".idx"
	conda: "../envs/ks-env.yaml"
	shell:
		"kallisto index -i {output[0]} {input[0]}"

rule kallisto_quant_paired:
	input:
		config["reference"]["genome"] + ".idx",
		config["trim_galore"]["out"] + "/{sample}_1_val_1.fq.gz",
		config["trim_galore"]["out"] + "/{sample}_2_val_2.fq.gz",
		config["fastqc"][pre_trim] + "/{sample}.html",
		config["fastqc"][post_trim] + "/{sample}.html"
	output:
		config["kallisto"]["out"] + "/{sample}/abundance.h5",
		config["kallisto"]["out"] + "/{sample}/abundance.tsv",
		config["kallisto"]["out"] + "/{sample}/run_info.json"
	conda: "../envs/ks-env.yaml"
	params:
		out_dir = config["kallisto"]["out"] + "/{sample}",
		bs_samples = config["kallisto"]["bootstrap_samples"]
	shell:
		"kallisto quant -i {input[0]} -o {params.out_dir} -b {params.bs_samples} {input[1]} {input[2]}"

rule kallisto_quant_single:
	input:
		config["reference"]["genome"] + ".idx",
		config["trim_galore"]["out"] + "/{sample}_trimmed.fq.gz"
	output:
		config["kallisto"]["out"] + "/{sample}/abundance.h5",
		config["kallisto"]["out"] + "/{sample}/abundance.tsv",
		config["kallisto"]["out"] + "/{sample}/run_info.json"
	conda: "../envs/ks-env.yaml"
	params:
		out_dir = config["kallisto"]["out"] + "/{sample}",
		bs_samples = config["kallisto"]["bootstrap_samples"],
		avg_length = config["kallisto"]["avg_frag_len"],
		std_devi = config["kallisto"]["std_dev"]
	shell:
		"kallisto quant -i {input[0]} -o {params.out_dir} --single -l {params.avg_length} -s {params.std_devi} {input[1]}"

