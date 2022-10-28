#!/bin/bash
#SBATCH --job-name="random_numbers_sbatch_job"
#SBATCH --partition=lattice,parallel,cpu2013,cpu2022,synergy,cpu2019,cpu2021
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=1G
#SBATCH --output=random_numbers_sbatch_job.%A.out
#SBATCH --error=random_numbers_sbatch_job.%A.err

output_dir="sbatch_job_output_dir"
mkdir -p $output_dir

# Generate 10000 random numbers and append to a file.
for i in {1..10000}; do
	echo $RANDOM >> ${output_dir}/random_numbers.txt
done

# Sorts random numbers and writes to a new file.
sort ${output_dir}/random_numbers.txt > ${output_dir}/sorted_random_numbers.txt


