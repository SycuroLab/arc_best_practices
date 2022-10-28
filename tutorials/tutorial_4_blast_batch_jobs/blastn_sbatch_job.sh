#!/bin/bash
#SBATCH --job-name="blastn_sbatch_job"
#SBATCH --partition=cpu2022,synergy,cpu2019,cpu2021
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=14
#SBATCH --time=5:00:00
#SBATCH --mem=60G
#SBATCH --output=blastn_sbatch_job.%A.out
#SBATCH --error=blastn_sbatch_job.%A.err

# Get the conda environment path location from the .bashrc file.
source ~/.bashrc

# Activate the blast conda environment.
conda activate blast_env

# Make blastn output directory.
output_dir="sbatch_job_blastn_output_dir";
mkdir -p $output_dir;

# Make blast nucleotide database.
makeblastdb -in ../blast_databases/cpndb_nr_nut_seq.txt -dbtype nucl -out ${output_dir}/cpndb_nr_nut_seq;

# Run the blastn command.
blastn -query ../fasta_files/cpndb_cart_nut_seq.txt -db ${output_dir}/cpndb_nr_nut_seq -out ${output_dir}/cart_seq_cpndb_nr_nut_seq_blastn.tsv -evalue 1e-05 -max_target_seqs 10 -num_threads 14 -outfmt '6 qseqid qlen sseqid stitle len qstart qend sstart send length evalue bitscore pident qcovs nident mismatch positive gaps qframe sframe'

# Add header to file.
echo "qseqid qlen sseqid stitle len qstart qend sstart send length evalue bitscore pident qcovs nident mismatch positive gaps qframe sframe" | tr ' ' '\t' | cat - ${output_dir}/cart_seq_cpndb_nr_nut_seq_blastn.tsv > ${output_dir}/cart_seq_cpndb_nr_nut_seq_blastn_header.tsv


