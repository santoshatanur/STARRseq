# STARRseq
Pipeline to analyze STARR-seq data

# Description 

This pipeline is to analyze STARR-seq data. It involves multiple steps that are explained below. Data for testing the tool is provided in the demo data folder. It also requires the following software.

1. Samtools
2. Bedtools

Input file: STARR-seq reads mapped to reference genome (bam file)

## Convert bam file to bedpe format

````
samtools sort -n -T  <TMP file> -O BAM  <input BAM file> | bedtools bamtobed -bedpe -i stdin | awk '$8>=10' | sort -k 1,1 -k 2,2n -k 3,3n > <output bedpe file>

For example


````

## Extract proper pairs from bedpe and convert the file to bed format

```
awk '$1==$4' <bedpe file> | cut -f 1-2,6-10 | sort -k 1,1 -k 2,2n -k 3,3n > <output bed file>

For example


```

## Find overlap with oligo coordinates

````
intersectBed -a <bed file with oligo coordinates> -b <bed file> -F 1.00 -wao >  <overlap bed file>

For example


````

## Count unique UMIs mapped to each oligo region in RNA samples 

````
perl countUMI.pl <fastq file> <overlap bed file> > <RNA count file>

For example


````

## Get DNA counts

````
cut -f 4 <overlap bed file> | uniq -c | awk -v OFS="\t" '{print $2,$1}' > <DNA count file>

For example


````
## Normalise readpair counts to 1,000,000 reads (TPM)

To convert raw tag counts to the TPM normalised tag counts 

````
perl TPMnormalise.pl <raw count file> > <TPM normalised count file>

For example


````

## Normalise RNA counts to DNA counts

A tool to filter TC based on TPM and the number of samples. For example, to extract the TCs with one TPM expression in at least three samples. 

````
perl DNAnormalise.pl <TPM normalised DNA count file> <TPM normalised RNA count file> > <DNA normalised count file>

For example


````

## Merge REF and ALT files 

````
perl mergeDNAnorm.pl <REF DNA normalised count file>  <ALT DNA normalised count file> > < REF + ALT DNA normalised count file>

For example


````

## Perform statistics using Mann-Whitney U test

````
python manwit.py < REF + ALT DNA normalised count file> > <stats file>

For example


````

## Perform per oligo statistics using Mann-Whitney U test and T-test

````
python manwitRow.py < REF + ALT DNA normalised count file> > <per oligo stats file>

For example


````
