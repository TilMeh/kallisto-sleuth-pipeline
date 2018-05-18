rule trim_paired:
	input:
		config["data_folder"] + "/{sample}_1.fq.gz",
		config["data_folder"] + "/{sample}_2.fq.gz"
	output:
		config["trim_galore"]["out"] + "/{sample}_1_val_1.fq.gz",
		config["trim_galore"]["out"] + "/{sample}_2_val_2.fq.gz"
	conda: "../envs/ks-env.yaml"
	params:
		trim_folder = config["trim_galore"]["out"],
		phred_qual = config["trim_galore"]["phred_quality"]
	shell:
		"trim_galore -q {params.phred_qual} {input} -o {params.trim_folder} --paired"

rule trim_single:
	input:
		config["data_folder"] + "/{sample}.fq.gz"
	output:
		config["trim_galore"]["out"] + "/{sample}_trimmed.fq.gz"
	conda: "../envs/ks-env.yaml"
	params:
		trim_folder = config["trim_galore"]["out"],
		phred_qual = config["trim_galore"]["phred_quality"]
	shell:
		"trim_galore -q {params.phred_qual} {input} -o {params.trim_folder}"
