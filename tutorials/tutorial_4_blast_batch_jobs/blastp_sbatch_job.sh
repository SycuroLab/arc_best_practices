#!/bin/bash
#SBATCH --job-name="blastp_sbatch_job"
#SBATCH --partition=cpu2022,synergy,cpu2019,cpu2021
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=14
#SBATCH --time=5:00:00
#SBATCH --mem=60G
#SBATCH --output=blastp_sbatch_job.%A.out
#SBATCH --error=blastp_sbatch_job.%A.err

# Get the conda environment path location from the .bashrc file.
source ~/.bashrc

# Activate the blast conda environment.
conda activate blast_env

# Make blastp output directory.
output_dir="sbatch_job_blastp_output_dir";
mkdir -p $output_dir;

# Make blast protein database.
makeblastdb -in ../blast_databases/cpndb_nr_ut_seq.txt -dbtype prot -out ${output_dir}/cpndb_nr_ut_seq;

# Run the blastp command.
blastp -query ../fasta_files/cpndb_cart_ut_seq.txt -db ${output_dir}/cpndb_nr_ut_seq -out ${output_dir}/cart_seq_cpndb_nr_ut_seq_blastp.tsv -evalue 1e-05 -max_target_seqs 10 -num_threads 14 -outfmt '6 qseqid qlen sseqid stitle len qstart qend sstart send length evalue bitscore pident ppos qcovs nident mismatch positive gaps qframe sframe'

# Add header to file.
echo "qseqid qlen sseqid stitle len qstart qend sstart send length evalue bitscore pident ppos qcovs nident mismatch positive gaps qframe sframe" | tr ' ' '\t' | cat - ${output_dir}/cart_seq_cpndb_nr_ut_seq_blastp.tsv > ${output_dir}/cart_seq_cpndb_nr_ut_seq_blastp_header.tsv


