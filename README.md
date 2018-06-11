# kallisto-sleuth-pipeline

### Quickstart

* Install Miniconda3 (!Not anaconda - there are some dependencies conflicts)
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh
```
* Clone Repository (or update it with `git pull`)
```
git clone https://github.com/TilMeh/kallisto-sleuth-pipeline.git
```
* Adjust Snakefile
```
cd kallisto-sleuth-pipeline
nano Snakefile # or vim or your favorite text editor
```
* Adjust config file
```
nano config.yaml # or vim or your favorite text editor
```
* Run it!
```
snakemake --use-conda --cores `nproc`
```

### Configurations

#### Sample description

You need to provide a file that describes your samples by one sample per row with two columns. Columns are separated by tabs.

The first column has to have the header "sample" and contains the prefix of the sample's file name (i.e. without file extensions).

The second column has to have the header "condition" and contains the sample's condition.

Example:
```
sample  condition
SRRABC  treated
SRRXYZ  untreated
...
```

#### Snakefile

Aside from quality control and trimming, the pipeline offers three different ways to generate your DEG results:
* kallisto -> sleuth
* kallisto -> DESeq2
* HISAT2 -> samtools -> htseq-count -> DESeq2

Simply uncomment one of the lines starting with "config" in the Snakefile's "rule all" to choose that particular workflow.

#### Configuration file

In the config.yaml file, you can configure your chosen workflow.
* "samples", "data_folder" and "reference" parameters need to be set.
* tool-specific parameters need to be set if your particular workflow uses that tool.
* FastQC and Trim Galore! are always used.
