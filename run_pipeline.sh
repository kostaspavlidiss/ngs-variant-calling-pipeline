#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eo pipefail

echo "=========================================="
echo " Starting NGS Variant Calling Pipeline "
echo "=========================================="

# Define directories & reference files
DATA_DIR="data"
RESULTS_DIR="results"
REF="data/hs37d5.fa"

# Step 1: Quality Control
echo "[1/5] Running Quality Control with FastQC..."
fastqc data/*.fastq -o $RESULTS_DIR/

# Step 2: Alignment
echo "[2/5] Aligning reads to reference genome with BWA MEM..."
bwa mem -t 4 $REF data/sample_R1.fastq data/sample_R2.fastq > $RESULTS_DIR/aligned.sam

# Step 3: SAM to Sorted BAM
echo "[3/5] Converting and sorting SAM to BAM..."
samtools view -bS $RESULTS_DIR/aligned.sam | samtools sort -o $RESULTS_DIR/aligned_sorted.bam
samtools index $RESULTS_DIR/aligned_sorted.bam

# Step 4: Variant Calling
echo "[4/5] Calling variants with BCFtools..."
bcftools mpileup -f $REF $RESULTS_DIR/aligned_sorted.bam | bcftools call -mv -Ob -o $RESULTS_DIR/raw_variants.bcf

# Step 5: Annotation & VCF output
echo "[5/5] Generating final annotated VCF file..."
bcftools view $RESULTS_DIR/raw_variants.bcf > $RESULTS_DIR/final_variants.vcf

echo "=========================================="
echo " Pipeline Finished Successfully! "
echo " Final output: $RESULTS_DIR/final_variants.vcf"
echo "=========================================="
