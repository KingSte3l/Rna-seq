# Rna-seq (Transcriptome ) analysis
The manual pipeline for  rna seq analysis using linux.  
.......................................................................................<br>
we start by downloading datasets from ftp client ie.<br> ENA (european nucleotide archive).<br>
## Downloading datasets using wget
`wget-c link`<br>
## FASTQC REPORT
fastqc report helps us quality check the files we are about to analyze, and helps us decide weather to analyse the file or it contains adaptor.
content which needs to be trimmed etc.<br>
`fastqc filename`<br>
## Multiqc
multiqc is used to simplify the fastqc report and print all the fastqc reports at once ie gives a summary of fastqc reports at once.<br>
`multiqc .`<br>
>multiqc needs to be installed.<br>
https://github.com/KingSte3l/Rna-seq/blob/627b3a8449fc0e8fe2e9b33c670a89ba5c13294c/fastqc.sh <br>
## Trimming
the files anylsed using fastqc provides us with options based on the report wether to analyze further or trim it to maintain better quality.
we provide fasta file with adaptor content to be removed.<br>
>if your results are satisfying skip this step .<br>

`java -jar "trimmomatic_jar" PE -threads 6 "$forward_file" "reverse_file" "$output_forward" /dev/null ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15
MINLEN:36`<br>
## Alignment
alignment refers to the process of comparing and matching sequences of nucleotides or amino acids to identify similarities, differences, and patterns within genomes or specific regions of DNA/RNA.<br>
`bwa mem -t6 "index_file" "forward_file.gz" "reverse_file.gz" > "output_file.sam"`<br>
https://github.com/KingSte3l/Rna-seq/blob/ff40d5a273e39552ff04d616d7b039d213540eb4/alignment.sh<br>
## Samtools(conversion)
### sam to bam
SAM (Sequence Alignment/Map) and BAM (Binary Alignment/Map) are file formats commonly used in genomics to store aligned sequence data. SAM is a human-readable format, while BAM is its binary equivalent, which is more efficient for storage and processing.<br>
`samtools view -@ 6 -sb input.sam -o output.bam`<br>
### bam to sorted bam
Optionally, sort the BAM file: If you want to sort the resulting BAM file<br>
`samtools sort output.bam -o output.sorted.bam`<br>
## feature counts
Subread package is necessary for generating feature counts<br>
A annotation file is necessary normally a GTF file<br>
primary purpose of featue count is to count the number of sequence reads that align to or overlap with specific genomic features, such as genes, exons, transcripts, or other defined regions of interest.<br>

`featureCounts -a annotation_file.gtf -o counts.txt -T <number_of_threads> sorted1.bam sorted2.bam sorted3.bam ...`<br>

>further analysis is possible using r programming.<br>

https://github.com/KingSte3l/Rna-seq/blob/14ab3c81584e28523ee176923c7cae6fec0dd4b7/Deseqnew.R
