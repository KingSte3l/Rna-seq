
# Define the input directory containing your FASTQ files

# Define the output directory for the alignment results
output_dir="./output/"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Iterate through the FASTQ files in the input directory
for file in ./*fastq.gz; do
    # Check if the file exists
    if [ -e "$file" ]; then
        # Extract the file name (e.g., srr_1.fastqc)
        file_name=$(basename "$file")

        # Extract the sample name (e.g., srr_1)
        sample_name="${file_name%%.*}"

        # Perform BWA alignment for the paired-end files
        bwa mem -t 4 "./reference.fa" "${sample_name}.fastq.gz"  > "${output_dir}${sample_name}.sam"


    fi
done

echo "Alignment completed."

