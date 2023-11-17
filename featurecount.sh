!/bin/bash
# Define the input directory containing your FASTQ files
input_dir="./"
# Define the output directory for the alignment results
output_dir="./output_dir/"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# create an array to store bam files
bam_files=("$input_dir"/*_sorted.bam)
    #check bam file
   if [${#bam_files[@]} -eq 0]; then
        echo "NO BAM FILES WERE FOUND IN $input_dir"
        exit 1
   fi
     #print list of bam files
   for bam_file in "${bam_files[@]}";do
       echo "$bam_file"
   done
     #run feature count 
       sudo featureCounts -p -T 4 -a annotation.gtf -o "$output_dir/$counts.txt" "${bam_files[@]}"


