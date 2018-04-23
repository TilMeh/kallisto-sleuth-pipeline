import subprocess
from os import remove
from numpy import std

avg_len = -1
std_dev = -1.0


# Returns the average length of all reads in the sample
def avg_read_len(sample):
	filter_str = "NR%4 == 2 {lengths[length($0)]++} END {for(l in lengths) {print l, lengths[l]}}"
	cmd_args = ["awk", filter_str, sample]
	proc = subprocess.Popen(cmd_args, stdout=subprocess.PIPE)
	return int(proc.stdout.read().decode().rstrip('\n'))

# Returns the standard deviation of all reads lengths in the sample
def std_dev_read_length(sample):
	filter_str = "NR%4 == 2 {print length($0)}"
	cmd_args = ["awk", filter_str, sample]
	proc = subprocess.Popen(cmd_args, subprocess.PIPE)
	output = proc.stdout.read().decode()
	lengths = []
	for x in output:
		if(x):
			lengths.append(int(x))
	return std(lengths)
	


rule kallisto_index:
	input:
		config["reference"] + ".fa"
	output:
		config["reference"] + ".idx"
	conda: "../envs/kallisto-sleuth.yaml"
	shell:
		"kallisto index -i {output[0]} {input[0]}"

rule kallisto_quant_paired:
	input:
		config["reference"] + ".idx",
		config["folders"]["trim_folder"] + "/{sample}_1_val_1.fq.gz",
		config["folders"]["trim_folder"] + "/{sample}_2_val_2.fq.gz"
	output:
		config["folders"]["output_folder"] + "/{sample}/abundance.h5",
		config["folders"]["output_folder"] + "/{sample}/abundance.tsv",
		config["folders"]["output_folder"] + "/{sample}/run_info.json"
	conda: "../envs/kallisto-sleuth.yaml"
	params:
		out_dir = config["folders"]["output_folder"] + "/{sample}",
		bs_samples = config["kallisto"]["bootstrap_samples"],
		single = lambda wildcards: config["kallisto"]["single"]
	shell:
		"kallisto quant -i {input[0]} -o {params.out_dir} -b {params.bs_samples} {params.single} {input[1]} {input[2]}"

rule kallisto_qs_prep:
	input:
		rules.gunzip_trimmed.output
	output:
		config["folders"]["data_folder"] + "/{sample}.prep"
	conda: "../envs/kallisto-sleuth.yaml"
	run:
		avg_len = avg_read_len({input[0]})
		std_dev = std_dev_read_length({input[0]})
		with open("{output[0]}", "w") as f:
			f.write(avg_len + " " + std_dev)

rule kallisto_quant_single:
	input:
		config["reference"] + ".idx",
		# config["folders"]["trim_folder"] + "/{sample}_trimmed.fq.gz"
		rules.kallisto_qs_prep.output
	output:
		config["folders"]["output_folder"] + "/{sample}/abundance.h5",
		config["folders"]["output_folder"] + "/{sample}/abundance.tsv",
		config["folders"]["output_folder"] + "/{sample}/run_info.json"
	conda: "../envs/kallisto-sleuth.yaml"
	params:
		out_dir = config["folders"]["output_folder"] + "/{sample}",
		bs_samples = config["kallisto"]["bootstrap_samples"],
		# Trying to set params via custom function
		avg_len = avg_len,
		std_dev = std_dev
	shell:
		"kallisto quant -i {input[0]} -o {params.out_dir} -b {params.bs_samples} --single -l {params.avg_len} -s {params.std_dev} {input[1]}.gz"

