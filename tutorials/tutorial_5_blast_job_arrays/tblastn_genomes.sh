!/bin/bash
#SBATCH --job-name="tblastn_genomes_job_array"
#SBATCH --partition=cpu2022,synergy,cpu2019,cpu2021
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=14
#SBATCH --time=1-00:00:00
#SBATCH --mem=60G
#SBATCH --array=1-6%6
#SBATCH --output=tblastn_genomes_job_array.%A_%a.out
#SBATCH --error=tblastn_genomes_job_array.%A_%a.err

# Get the bashrc information for conda.
source ~/.bashrc

# Activate the blast conda environment.
conda activate blast_env

# The number of cpus for blast.
blast_num_threads=14

# The list of genome assembly files.
list="genome_fasta_file_list.txt"

# The genome assembly fasta database file.
IFS=$'\n' array=($(<$list))
genome_file=${array[$SLURM_ARRAY_TASK_ID-1]}

genome_filename=$(basename $genome_file)

genome_id=$(echo $genome_filename | sed 's/\.fa//g')

# The output directory.
output_dir="genome_tblastn_output_dir/${genome_id}"
mkdir -p $output_dir

# Make blast nucleotide database.
makeblastdb -in ${genome_file} -dbtype nucl -out ${output_dir}/${genome_id}

# Run the blastn command.
tblastn -query ../fasta_files/cpndb_cart_ut_seq.txt -db ${output_dir}/${genome_id} -out ${output_dir}/cpndb_cart_ut_seq_${genome_id}_tblastn.tsv -evalue 1e-05 -max_target_seqs 10 -num_threads ${blast_num_threads} -outfmt '6 qseqid qlen sseqid stitle len qstart qend sstart send length evalue bitscore pident ppos qcovs nident mismatch positive gaps qframe sframe'

# Add header to file.
echo "qseqid qlen sseqid stitle len qstart qend sstart send length evalue bitscore pident ppos qcovs nident mismatch positive gaps qframe sframe" | tr ' ' '\t' | cat - ${output_dir}/cpndb_cart_ut_seq_${genome_id}_blastn.tsv > ${output_dir}/cpndb_cart_ut_seq_${genome_id}_tblastn_header.tsv

