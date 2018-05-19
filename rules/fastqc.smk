rule fastqc_pre_trim:
	input:
		config["data_folder"] + "/{sample}.fq.gz"
	output: 
		html = config["fastqc"]["pre_trim"] + "/{sample.html}",
		zip = config["fastqc"]["pre_trim"] + "/{sample}.zip"
	params: ""
	wrapper:
		"0.23.1/bio/fastqc"

rule fastqc_post_trim:
	input:
		config["trim_galore"]["out"] + "/{sample}_1_val_1.fq.gz"
	output: 
		html = config["fastqc"]["post_trim"] + "/{sample}.html",
		zip = config["fastqc"]["post_trim"] + "/{sample}.zip"
	params: ""
	wrapper:
		"0.23.1/bio/fastqc"
