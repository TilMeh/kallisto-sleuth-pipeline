# kallisto-sleuth-pipeline

### Quickstart

* Install Miniconda3 (!Not anaconda - there are some dependencies conflicts)
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh
```

* Install Bioconda and the required packages
```
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
conda install kallisto r-sleuth trim-galore
```

* Clone Repository (or update it with `git pull`)
```
git clone https://github.com/TilMeh/kallisto-sleuth-pipeline.git
```
* Adjust config file
```
cd kallisto-sleuth-pipeline
nano config.yaml # or vim or your favorite text editor
```
* Run it!
```
cd kallisto-sleuth-pipeline
snakemake --use-conda --cores `nproc`
```
