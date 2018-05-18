rule count:
	input:
		config["reference"]["gff"],
		config["samtools"]["out"] + "/{sample}_sorted.sam"
	output:
		config["htseq-count"]["out"] + "/{sample}.counts"
	conda: "../envs/ks-env.yaml"
	params:
		stranded = config["htseq-count"]["stranded"],
		type = config["htseq-count"]["type"],
		gene_id = config["htseq-count"]["gene_id"]
	shell:
		"htseq-count -s {params.stranded} -t {params.type} -i {params.gene_id} {input[1]} {input[0]} 1> {output[0]}"
