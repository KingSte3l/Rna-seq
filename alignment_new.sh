# this is paired read files
# Define the input directory containing your FASTQ files

# Define the output directory for the alignment results
output_dir="./output/"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Iterate through the FASTQ files in the input directory
for forward_file in ./*_1.fastq.gz; do
    # Check if the file exists
    if [ -e "$forward_file" ]; then
        # Extract the file name (e.g., srr_1.fastqc)
        sample_name="${forward_file%%_*}"

        # reverse fastq file (e.g., srr_2)
        reverse_file="${sample_name}_2.fastq.gz"

        # Perform BWA alignment for the paired-end files
        bwa mem -t 4 "./reference.fa" "$forward_file" "$reverse_file"  > "${output_dir}${sample_name}.sam"


    fi
done

echo "Alignment completed."

