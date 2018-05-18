rule sort:
	input:
		config["hisat2"]["out"] + "/{sample}.sam"
	output:
		config["samtools"]["out"] + "/{sample}_sorted.sam"
	conda: "../envs/ks-env.yaml"
	params:
		reference = config["reference"]["genome"] + ".fa"
	shell:
		"samtools sort -n -o {output[0]} --reference {params.reference} {input[0]}"
