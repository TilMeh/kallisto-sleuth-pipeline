rule trim_paired:
	input:
		config["folders"]["data_folder"] + "/{sample}_1.fq.gz",
		config["folders"]["data_folder"] + "/{sample}_2.fq.gz"
	output:
		config["folders"]["trim_folder"] + "/{sample}_1_val_1.fq.gz",
		config["folders"]["trim_folder"] + "/{sample}_2_val_2.fq.gz"
	conda: "../envs/kallisto-sleuth.yaml"
	params:
		trim_folder = config["folders"]["trim_folder"],
		phred_qual = config["trim_galore"]["phred_quality"]
	shell:
		"trim_galore -q {params.phred_qual} {input} -o {params.trim_folder} --paired"

rule trim_single:
	input:
		config["folders"]["data_folder"] + "/{sample}.fq.gz"
	output:
		config["folders"]["data_folder"] + "/{sample}_trimmed.fq.gz"
	conda: "../env/kallisto-sleuth.yaml"
	params:
		trim_folder = config["folders"]["trim_folder"],
		phred_qual = config["trim_galore"]["phred_quality"]
	shell:
		"trim_galore -q {params.phred_qual} {input} -o {params.trim_folder}"

rule trim_single_nogz:
	input:
		config["folders"]["data_folder"] + "/{sample}.fq"
	output:
		config["folders"]["data_folder"] + "/{sample}_trimmed.fq"
	conda: "../env/kallisto-sleuth.yaml"
	params:
		trim_folder = config["folders"]["trim_folder"],
		phred_qual = config["trim_galore"]["phred_quality"]
	shell:
		"trim_galore -q {params.phred_qual} {input} -o {params.trim_folder}"
