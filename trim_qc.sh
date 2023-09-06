#!/bin/bash

# Set the input directory containing your FASTQ files

# Set the output directory for the trimmed and quality-controlled files
output_dir="./output/"

# Create the output directory if it doesn't exist
mkdir -p "$trim_output_dir"

# Loop through the FASTQ files in the input directory
for fastq_file in "$input_dir"*.fastq.gz; do
    # Check if the file exists
    if [ -e "$fastq_file" ]; then
        # Extract the file name without extension (e.g., sample)
        base_name="$(basename "$fastq_file" .fastq.gz)"

        # Define the output file name for trimmed FASTQ
        trimmed_fastq="$output_dir${base_name}_trimmed.fastq.gz"

        # Run TrimGalore! with desired options (e.g., specifying quality scores, adapters, etc.)
        trim_galore --quality 20 --length 50 --fastqc --gzip --output_dir "$output_dir" "$fastq_file"

    fi
done

echo "Trimming and quality control completed."

