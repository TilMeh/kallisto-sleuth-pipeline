rule hisat_build:
	input:
		config["reference"]["genome"] + ".fa"
	output:
		config["hisat2"]["out"] + "/" + config["reference"]["genome"] + ".1.ht2"
	conda: "../envs/ks-env.yaml"
	params:
		index_prefix = config["hisat2"]["out"] + "/" + config["reference"]["genome"]
	shell:
		"hisat2-build -f {input[0]} {params.index_prefix}"


rule hisat_map:
	input:
		config["hisat2"]["out"] + "/" + config["reference"]["genome"] + ".1.ht2",
		config["trim_galore"]["out"] + "/{sample}_1_val_1.fq.gz",
                config["trim_galore"]["out"] + "/{sample}_2_val_2.fq.gz",
		config["fastqc"]["pre_trim"] + "/{sample}.html",
		config["fastqc"]["post_trim"] + "/{sample}.html"
	output:
		config["hisat2"]["out"] + "/{sample}.sam"
	conda: "../envs/ks-env.yaml"
	params:
		index_prefix = config["hisat2"]["out"] + "/" + config["reference"]["genome"]
	shell:
		"hisat2 -q -x {params.index_prefix} -1 {input[1]} -2 {input[2]} -S {output[0]}"
