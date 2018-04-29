import subprocess
from os import remove
import numpy as np

avg_len = -1
std_dev = -1.0


# Returns the average length of all reads in the sample
def avg_read_len(sample):
	f = open(sample + ".avg_temp", "w")
	filter_str = "NR%4 == 2 {lengths[length($0)]++} END {for(l in lengths) {print l}}"
	cmd_args = ["awk", filter_str, sample]
	proc = subprocess.run(cmd_args, stdout=f)
	f.close()
	f = open(sample + ".avg_temp", "r")
	lines = f.readlines()
	f.close()
	lens = []
	for line in lines:
		lens.append(line.rstrip('\n'))
	lensarray = np.array(lens).astype(np.int_)
	remove(sample + ".avg_temp")
	return int(np.average(lensarray))

# Returns the standard deviation of all reads lengths in the sample
def std_dev_read_length(sample):
	f = open(sample + ".dev_temp", "w")
	filter_str = "NR%4 == 2 {print length($0)}"
	cmd_args = ["awk", filter_str, sample]
	proc = subprocess.run(cmd_args, stdout=f)
	f.close()
	print("opening " + sample + ".temp in read mode")
	t = open(sample + ".dev_temp", "r")
	lines = t.readlines()
	print("Read " + str(len(lines)) + " lines")
	lengths = []
	for line in lines:
		lengths.append(int(line.rstrip('\n')))
	f.close()
	remove(sample + ".dev_temp")
	return np.std(lengths)
	


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
	# conda: "../envs/kallisto-sleuth.yaml"
	run:
		avg_len = avg_read_len(input[0])
		std_dev = std_dev_read_length(input[0])
		with open(output[0], "w") as f:
			f.write(str(avg_len) + " " + str(std_dev))

rule kallisto_quant_single:
	input:
		config["reference"] + ".idx",
		config["folders"]["trim_folder"] + "/{sample}_trimmed.fq.gz"
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

