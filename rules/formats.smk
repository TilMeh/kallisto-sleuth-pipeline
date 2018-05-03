rule shorten_fa:
	input:
		config["folders"]["data_folder"] + "/{sample}.fasta"
	output:
		config["folders"]["data_folder"] + "/{sample}.fa.gz"
	conda: "../envs/ks-env.yaml"
	params:
		shortened = config["folders"]["data_folder"] + "/{sample}.fa"
	shell:
		"mv {input[0]} {params.shortened} & gzip -c {params.shortened} > {output[0]}"

rule shorten_fa_gz:
	input:
		config["folders"]["data_folder"] + "/{sample}.fasta.gz"
	output:
		config["folders"]["data_folder"] + "/{sample}.fa.gz"
	conda: "../envs/ks-env.yaml"
	shell:
		"mv {input[0]} {output[0]}"

rule shorten_fq:
	input:
		config["folders"]["data_folder"] + "/{sample}.fastq"
	output:
		config["folders"]["data_folder"] + "/{sample}.fq.gz"
	conda: "../envs/ks-env.yaml"
	params:
		shortened = config["folders"]["data_folder"] + "/{sample}.fq"
	shell:
		"mv {input[0]} {params.shortened} & gzip -c {params.shortened} > {output[0]}"

rule shorten_fq_gz:
	input:
		config["folders"]["data_folder"] + "/{sample}.fastq.gz"
	output:
		config["folders"]["data_folder"] + "/{sample}.fq.gz"
	conda: "../envs/ks-env.yaml"
	shell:
		"mv {input[0]} {output[0]}"

rule gunzip_trimmed:
	input:
		config["folders"]["trim_folder"] + "/{sample}_trimmed.fq.gz"
	output:
		config["folders"]["trim_folder"] + "/{sample}_trimmed.fq"
	conda: "../envs/ks-env.yaml"
	shell:
		"gzip -cd {input} > {output}"
