# Rna-seq
the pipeline for  rna seq analysis using linux.  
.......................................................................................<br>
we start by downloading datasets from ftp client ie.<br> ENA (european nucleotide archive).<br>
## Downloading datasets using wget
`wget-c link`<br>
## FASTQC REPORT
fastqc report helps us quality check the files we are about to analyze, and helps us decide weather to analyse the file or it contains adaptor.
content which needs to be trimmed etc.<br>
`fastqc filename`<br>
## multiqc
multiqc is used to simplify the fastqc report and print all the fastqc reports at once ie gives a summary of fastqc reports at once.<br>
`multiqc .`<br>
>multiqc needs to be installed.<br>
## trimming
the files anylsed using fastqc provides us with options based on the report wether to analyze further or trim it to maintain better quality.
we provide fasta file with adaptor content to be removed.<br>
>if your results are satisfying skip this step .<br>
`java -jar "trimmomatic_jar" PE -threads 6 "$forward_file" "reverse_file" "$output_forward" /dev/null ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15
MINLEN:36`<br>
