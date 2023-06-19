#!/bin/bash

directory="fastq_files"
output_file="output.csv"

# Initialize arrays to store the sample names and file paths
declare -A samples
declare -A read1_files
declare -A read2_files

# Iterate over the files in the directory
for filepath in "$directory"/*_16S.*.fq.gz; do
    if [[ -f $filepath ]]; then
        filename=$(basename "$filepath")
        sample_name="${filename%%_16S*}"
        read_number="${filename#*_16S.}"
        
        # Remove the .fq.gz extension from the read number
        read_number="${read_number%.fq.gz}"
        
        # Store the sample name and file path in the respective arrays
        samples["$sample_name"]=$sample_name
        if [[ $read_number == "1" ]]; then
            read1_files["$sample_name"]=$filepath
        elif [[ $read_number == "2" ]]; then
            read2_files["$sample_name"]=$filepath
        fi
    fi
done

# Sort the sample names alphabetically
sorted_samples=($(printf '%s\n' "${samples[@]}" | sort))

# Create the CSV file and write the data
echo "sample,fastq_1,fastq_2" > "$output_file"
for sample_name in "${sorted_samples[@]}"; do
    read1_file="${read1_files[$sample_name]}"
    read2_file="${read2_files[$sample_name]}"
    echo "$sample_name,$read1_file,$read2_file" >> "$output_file"
done

echo "CSV file created successfully."
