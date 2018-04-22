rule shorten_fa:
	input:
		config["folders"]["data_folder"] + "/{raw}.fasta"
	output:
		config["folders"]["data_folder"] + "/{raw}.fa.gz"
	conda: "../envs/kallisto-sleuth.yaml"
	params:
		shortened = config["folders"]["data_folder"] + "/{raw}.fa"
	shell:
		"mv {input[0]} {params.shortened} & gzip -c {params.shortened} > {output[0]}"

rule shorten_fa_gz:
	input:
		config["folders"]["data_folder"] + "/{raw}.fasta.gz"
	output:
		config["folders"]["data_folder"] + "/{raw}.fa.gz"
	conda: "../envs/kallisto-sleuth.yaml"
	shell:
		"mv {input[0]} {output[0]}"

rule shorten_fq:
	input:
		config["folders"]["data_folder"] + "/{raw}.fastq"
	output:
		config["folders"]["data_folder"] + "/{raw}.fq.gz"
	conda: "../envs/kallisto-sleuth.yaml"
	params:
		shortened = config["folders"]["data_folder"] + "/{raw}.fq"
	shell:
		"mv {input[0]} {params.shortened} & gzip -c {params.shortened} > {output[0]}"

rule shorten_fq_gz:
	input:
		config["folders"]["data_folder"] + "/{raw}.fastq.gz"
	output:
		config["folders"]["data_folder"] + "/{raw}.fq.gz"
	conda: "../envs/kallisto-sleuth.yaml"
	shell:
		"mv {input[0]} {output[0]}"
