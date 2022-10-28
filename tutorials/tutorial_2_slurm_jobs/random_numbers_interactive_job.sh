#!/bin/bash

output_dir="interactive_job_output_dir"
mkdir -p $output_dir

# Generate 10000 random numbers and append to a file.
for i in {1..10000}; do
	echo $RANDOM >> ${output_dir}/random_numbers.txt
done

# Sorts random numbers and writes to a new file.
sort ${output_dir}/random_numbers.txt > ${output_dir}/sorted_random_numbers.txt


