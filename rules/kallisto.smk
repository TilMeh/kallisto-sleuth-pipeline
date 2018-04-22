import subprocess
from os import remove
from numpy import std


# To process fq files with awk, they need  to be unzipped
def gunzip(wildcards, sample):
	cmd_args = ["gzip", "-d", sample]
	subprocess.run(cmd_args)

# Returns the average length of all reads in the sample
def avg_read_length(wildcards, sample):
	gunzip(wildcards, sample)
	filter_str = "NR%4 == 2 {lengths[length($0)]++} END {for(l in lengths) {print l, lengths[l]}}"
	cmd_args = ["awk", filter_str, sample[:-3]]
	proc = subprocess.Popen(cmd_args, stdout=subprocess.PIPE)
	remove(sample[:-3])
	return int(proc.stdout.read().decode().rstrip('\n'))

# Returns the standard deviation of all reads lengths in the sample
def std_dev_read_length(wildcards, sample):
	gunzip(wildcards, sample)
	filter_str = "NR%4 == 2 {print length($0)}"
	cmd_args = ["awk", filter_str, sample[:-3]]
	proc = subprocess.Popen(cmd_args, subprocess.PIPE)
	output = proc.stdout.read().decode()
	lengths = []
	for x in output:
		if(x):
			lengths.append(int(x))
	remove(sample[:-3])
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
		bs_samples = config["kallisto"]["bootstrap_samples"]
		single = ""
		if config["kallisto"]["single"] == "yes":
			single = "--single"
	shell:
		"kallisto quant -i {input[0]} -o {params.out_dir} -b {params.bs_samples} {params.single} {input[1]} {input[2]}"

rule kallisto_quant_single:
	input:
		config["reference"] + ".idx",
		config["folders"]["trim_folder"] + "/{sample}_trimmed.fq.gz"
	output:
		config["folders"]["output_folder"] + "/{sample}/abundance.h5",
		config["folders"]["output_folder"] + "/{sample}/abundance.tsv",
		config["folders"]["output_folder"] + "/{sample}/run_info.json"
	conda: "../envs/kallisto-sleuth.yaml"
	params:
		out_dir = config["folders"]["output_folder"] + "/{sample}",
		bs_samples = config["kallisto"]["bootstrap_samples"],
		# Hoping it's possible to set params via function
		avg_len = avg_read_len(wildcards, {input[0]})
		std_dev = std_dev_read_length(wildcards, {input[0]})
	shell:
		"kallisto quant -i {input[0]} -o {params.out_dir} -b {params.bs_samples} --single -l {params.avg_len} -s {params.std_dev} {input[1]} {input[2]}"
	
