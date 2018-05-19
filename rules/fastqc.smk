rule fastqc_pre_trim_paired:
	input:
		config["data_folder"] + "/{sample}_1.fq.gz",
		config["data_folder"] + "/{sample}_2.fq.gz"
	output: 
		config["fastqc"]["pre_trim"] + "/{sample}_1_fastqc.html",
		config["fastqc"]["pre_trim"] + "/{sample}_1_fastqc.zip",
		config["fastqc"]["pre_trim"] + "/{sample}_2_fastqc.html",
		config["fastqc"]["pre_trim"] + "/{sample}_2_fastqc.zip"
	conda: "../envs/ks-env.yaml"
	params: 
		outdir = config["fastqc"]["pre_trim"]
	shell:
		"fastqc --quiet --outdir {params.outdir} {input[0]} {input[1]}"

rule fastqc_post_trim_paired:
	input:
		config["trim_galore"]["out"] + "/{sample}_1_val_1.fq.gz",
		config["trim_galore"]["out"] + "/{sample}_2_val_2.fq.gz"
	output: 
		config["fastqc"]["post_trim"] + "/{sample}_1_val_1_fastqc.html",
		config["fastqc"]["post_trim"] + "/{sample}_1_val_1_fastqc.zip",
		config["fastqc"]["post_trim"] + "/{sample}_2_val_2_fastqc.html",
		config["fastqc"]["post_trim"] + "/{sample}_2_val_2_fastqc.zip"
	conda: "../envs/ks-env.yaml"
	params:
		outdir = config["fastqc"]["post_trim"]
	shell:
		"fastqc --quiet --outdir {params.outdir} {input[0]} {input[1]}"
