#!/bin/bash

# Get the directory where the script is located
script_dir="$(dirname "${BASH_SOURCE[0]}")"

# Create a new folder for MultiQC report in the current directory
multiqc_dir="./multiqc_report"
mkdir -p "$multiqc_dir"

# Define the directory where you want to store the QC results (in the script's directory)
output_dir="$script_dir/qc_results"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"


# Loop through all FASTQ files in the current directory (where the terminal is opened)
for fastq_file in *.fastq.gz; do
    # Check if there are no matching files
    if [ ! -e "$fastq_file" ]; then
        echo "No matching .fastq.gz files found in the current directory."
        exit 1
    fi

    # Extract the file name without the extension
    file_name=$(basename "$fastq_file" .fastq.gz)

    # Run fastqc on the current FASTQ file
    fastqc -o "$output_dir" "$fastq_file"

    # Optional: You can add more QC analysis or processing steps here
    # For example, you could trim, filter, or align the reads.

    # Print a message indicating the completion of QC for the current file
    echo "QC analysis completed for $file_name"
done

# Run MultiQC to generate a report for all QC results in the output directory
# Save the MultiQC report in the new folder (multiqc_dir)
multiqc -o "$multiqc_dir" "$output_dir"

# Optional: You can add additional post-processing steps or analysis here

# Print a message indicating the completion of all QC analyses
echo "All QC analyses completed."

