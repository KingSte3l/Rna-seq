#!/bin/bash
# Define the input directory containing your FASTQ files
input_dir="./"
# Define the output directory for the alignment results
output_dir="./output_dir/"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Iterate through the FASTQ files in the input directory
for bam_file in "$input_dir"/*.bam; do
    #check bam file
   if [ -e "$bam_file" ]; then
       # Create bam file name
       sorted_bam_file="${bam_file%.bam}_sorted.bam"
       # sort the bam file
       sudo samtools sort -@ 14 -o "$output_dir/$sorted_bam_file" "$bam_file"
       echo "sorted $bam_file to $sorted_bam_file"    
    fi
done
