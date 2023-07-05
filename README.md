# STARRseq
Pipeline to analyze STARR-seq data

# Description 

This pipeline is to analyze STARR-seq data. It involves multiple steps that are explained below. Data for testing the tool is provided in the demo data folder. It also requires the following software.

1. Samtools
2. Bedtools

Input file: STARR-seq reads mapped to reference genome (bam file)


## Convert bam file to bedpe format

Convert the bam files that contain reads from REF and ALT alleles 

````
samtools sort -n -T  <TMP file> -O BAM  <input BAM file> | bedtools bamtobed -bedpe -i stdin | awk '$8>=10' | sort -k 1,1 -k 2,2n -k 3,3n > <output bedpe file>

For example

samtools sort -n -T test_ALT_DNA -O bam  /demodata/test_ALT_DNA.bam  | bedtools bamtobed -bedpe -i stdin | awk '$8>=10' | sort -k 1,1 -k 2,2n -k 3,3n > /demodata/output/test_ALT_DNA.bed
samtools sort -n -T test_REF_DNA -O bam  /demodata/test_REF_DNA.bam  | bedtools bamtobed -bedpe -i stdin | awk '$8>=10' | sort -k 1,1 -k 2,2n -k 3,3n > /demodata/output/test_REF_DNA.bed
samtools sort -n -T test_ALT_RNA -O bam  /demodata/test_ALT_RNA.bam  | bedtools bamtobed -bedpe -i stdin | awk '$8>=10' | sort -k 1,1 -k 2,2n -k 3,3n > /demodata/output/test_ALT_RNA.bed
samtools sort -n -T test_REF_RNA -O bam  /demodata/test_REF_RNA.bam  | bedtools bamtobed -bedpe -i stdin | awk '$8>=10' | sort -k 1,1 -k 2,2n -k 3,3n > /demodata/output/test_REF_RNA.bed

````

## Extract proper pairs from bedpe and convert the file to bed format

```
awk '$1==$4' <bedpe file> | cut -f 1-2,6-10 | sort -k 1,1 -k 2,2n -k 3,3n > <output bed file>

For example

awk '$1==$4' /demodata/output/test_ALT_DNA.bed | cut -f 1-2,6-10 | sort -k 1,1 -k 2,2n -k 3,3n > /demodata/output/test_ALT_DNA_PP.bed
awk '$1==$4' /demodata/output/test_REF_DNA.bed | cut -f 1-2,6-10 | sort -k 1,1 -k 2,2n -k 3,3n > /demodata/output/test_REF_DNA_PP.bed
awk '$1==$4' /demodata/output/test_ALT_RNA.bed | cut -f 1-2,6-10 | sort -k 1,1 -k 2,2n -k 3,3n > /demodata/output/test_ALT_RNA_PP.bed
awk '$1==$4' /demodata/output/test_REF_RNA.bed | cut -f 1-2,6-10 | sort -k 1,1 -k 2,2n -k 3,3n > /demodata/output/test_REF_RNA_PP.bed

```

## Find overlap with oligo coordinates

````
intersectBed -a <bed file with oligo coordinates> -b <bed file> -F 1.00 -wao >  <overlap bed file>

For example

intersectBed -a /demodata/reference/Mut.bed -b /demodata/output/test_ALT_DNA_PP.bed -F 1.00 -wao >  /demodata/output/test_ALT_DNA_PP_ov.bed
intersectBed -a /demodata/reference/Mut.bed -b /demodata/output/test_ALT_RNA_PP.bed -F 1.00 -wao >  /demodata/output/test_ALT_RNA_PP_ov.bed
intersectBed -a /demodata/reference/WT.bed -b /demodata/output/test_REF_DNA_PP.bed -F 1.00 -wao >  /demodata/output/test_REF_DNA_PP_ov.bed
intersectBed -a /demodata/reference/WT.bed -b /demodata/output/test_REF_RNA_PP.bed -F 1.00 -wao >  /demodata/output/test_REF_RNA_PP_ov.bed

````

## Count unique UMIs mapped to each oligo region in RNA samples 

````
perl countUMI.pl <fastq file> <overlap bed file> > <RNA count file>

For example

perl countUMI.pl /demodata/UMI/test_index.fastq /demodata/output/test_ALT_RNA_PP_ov.bed > /demodata/output/test_ALT_RNA_counts.txt
perl countUMI.pl /demodata/UMI/test_index.fastq /demodata/output/test_REF_RNA_PP_ov.bed > /demodata/output/test_REF_RNA_counts.txt

````

## Get DNA counts

````
cut -f 4 <overlap bed file> | uniq -c | awk -v OFS="\t" '{print $2,$1}' > <DNA count file>

For example

cut -f 4 /demodata/output/test_ALT_DNA_PP_ov.bed | uniq -c | awk -v OFS="\t" '{print $2,$1}' > /demodata/output/test_ALT_DNA_counts.txt
cut -f 4 /demodata/output/test_REF_DNA_PP_ov.bed | uniq -c | awk -v OFS="\t" '{print $2,$1}' > /demodata/output/test_REF_DNA_counts.txt

````
## Normalise readpair counts to 1,000,000 reads (TPM)

To convert raw tag counts to the TPM normalised tag counts 

````
perl TPMnormalise.pl <raw count file> > <TPM normalised count file>

For example

perl TPMnormalise.pl /demodata/output/test_ALT_DNA_counts.txt > /demodata/output/test_ALT_DNA_counts_TPM.txt
perl TPMnormalise.pl /demodata/output/test_REF_DNA_counts.txt > /demodata/output/test_REF_DNA_counts_TPM.txt
perl TPMnormalise.pl /demodata/output/test_ALT_RNA_counts.txt > /demodata/output/test_ALT_RNA_counts_TPM.txt
perl TPMnormalise.pl /demodata/output/test_REF_RNA_counts.txt > /demodata/output/test_REF_RNA_counts_TPM.txt

````

## Normalise RNA counts to DNA counts

````
perl DNAnormalise.pl <TPM normalised DNA count file> <TPM normalised RNA count file> > <DNA normalised count file>

For example

perl DNAnormalise.pl /demodata/output/test_ALT_DNA_counts_TPM.txt /demodata/output/test_ALT_RNA_counts_TPM.txt > /demodata/output/test_ALT_RNA_counts_TPM_DNAnorm.txt
perl DNAnormalise.pl /demodata/output/test_REF_DNA_counts_TPM.txt /demodata/output/test_REF_RNA_counts_TPM.txt > /demodata/output/test_REF_RNA_counts_TPM_DNAnorm.txt

````

## Merge REF and ALT files 

````
perl mergeDNAnorm.pl <REF DNA normalised count file>  <ALT DNA normalised count file> > < REF + ALT DNA normalised count file>

For example

perl mergeDNAnorm.pl /demodata/output/test_REF_RNA_counts_TPM_DNAnorm.txt /demodata/output/test_ALT_RNA_counts_TPM_DNAnorm.txt > /demodata/output/test_REFALT_RNA_counts_TPM_DNAnorm.txt

````

## Perform statistics using Mann-Whitney U test

````
python manwit.py < REF + ALT DNA normalised count file> > <stats file>

For example

python manwit.py /demodata/output/test_REFALT_RNA_counts_TPM_DNAnorm.txt > /demodata/output/test_stats.txt

````

## Perform per oligo statistics using Mann-Whitney U test and T-test

````
python manwitRow.py < REF + ALT DNA normalised count file> > <per oligo stats file>

For example

python manwitRow.py /demodata/output/test_REFALT_RNA_counts_TPM_DNAnorm.txt > /demodata/output/test_stats_row.txt
````
