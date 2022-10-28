#!/bin/bash
#SBATCH --job-name="random_numbers_job_array"
#SBATCH --partition=lattice,parallel,cpu2013,cpu2022,synergy,cpu2019,cpu2021
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=1G
#SBATCH --array=1-20%5
#SBATCH --output=random_numbers_job_array.%A.out
#SBATCH --error=random_numbers_job_array.%A.err

array_id=$SLURM_ARRAY_TASK_ID

output_dir="job_array_output_dir/job_array${array_id}"
mkdir -p $output_dir

# Generate 10000 random numbers and append to a file.
for i in {1..10000}; do
	echo $RANDOM >> ${output_dir}/random_numbers.txt
done

# Sorts random numbers and writes to a new file.
sort ${output_dir}/random_numbers.txt > ${output_dir}/sorted_random_numbers.txt


