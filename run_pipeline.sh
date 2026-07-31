#!/bin/bash
set -eo pipefail

echo "=========================================="
echo " Starting NGS Variant Calling Pipeline"
echo "=========================================="

mkdir -p data results

echo "[0/4] Indexing reference genome..."
bwa index data/ref.fa
samtools faidx data/ref.fa

echo "[1/4] Running Quality Control with FastQC..."
fastqc data/sample_R1.fastq data/sample_R2.fastq -o results/

echo "[2/4] Aligning reads to reference genome with BWA MEM..."
# Aligning as single-end to support small test datasets cleanly
bwa mem -k 5 data/ref.fa data/sample_R1.fastq > results/aligned.sam

echo "[3/4] Converting SAM to Sorted BAM and Indexing..."
samtools view -S -b results/aligned.sam | samtools sort -o results/aligned_sorted.bam
samtools index results/aligned_sorted.bam

echo "[4/4] Calling Variants with BCFtools..."
bcftools mpileup -A -B -Q 0 -f data/ref.fa results/aligned_sorted.bam | bcftools call -c -v --ploidy 1 -Ob -o results/variants.bcf
bcftools view results/variants.bcf > results/final_variants.vcf

echo "=========================================="
echo " Pipeline Finished Successfully!"
echo " Results stored in 'results/final_variants.vcf'"
echo "=========================================="
