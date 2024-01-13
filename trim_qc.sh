#!/bin/bash

# Set the input directory containing your FASTQ files

# Set the output directory for the trimmed and quality-controlled files
output_dir="./output/"


# Loop through the FASTQ files in the input directory
for forward_file in "$input_dir"*_1.fastq.gz; do
      # Extract the file name without extension (e.g., sample)
      base_name="$(basename "$forward_file" _1.fastq.gz)"
      reverse_file=${base_name}_2.fastq.gz

      # Run TrimGalore! with desired options (e.g., specifying quality scores, adapters, etc.)
      trim_galore --paired "$forward_file" "$reverse_file" --quality 20  --output_dir "$output_dir" 

done

echo "Trimming and quality control completed."

