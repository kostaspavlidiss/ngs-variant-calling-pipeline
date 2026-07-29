#!/bin/bash
set -e

# Μονοπάτια & Αρχεία
BASE_DIR="/home/drpav/analysis"
FASTQ_DIR="$BASE_DIR/fastq"
REF_DIR="$BASE_DIR/ref"
ALIGNED_DIR="$BASE_DIR/aligned"
VCF_DIR="$BASE_DIR/vcf"
FASTQC_DIR="$BASE_DIR/fastqc"

SAMPLE="HG00119"
REF="$REF_DIR/hs37d5.fa"
R1="$FASTQ_DIR/${SAMPLE}_1.fastq.gz"
R2="$FASTQ_DIR/${SAMPLE}_2.fastq.gz"

echo "=== [1/5] Δημιουργία Φακέλων ==="
mkdir -p $ALIGNED_DIR $VCF_DIR $FASTQC_DIR

echo "=== [2/5] Quality Control (FastQC) ==="
fastqc --outdir $FASTQC_DIR $R1 $R2

echo "=== [3/5] Alignment (BWA MEM -> Sorted BAM) ==="
bwa mem -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tPL:ILLUMINA" $REF $R1 $R2 | \
  samtools view -bS - | \
  samtools sort -o $ALIGNED_DIR/${SAMPLE}.sorted.bam

samtools index $ALIGNED_DIR/${SAMPLE}.sorted.bam

echo "=== [4/5] Variant Calling (BCFtools) ==="
bcftools mpileup -f $REF $ALIGNED_DIR/${SAMPLE}.sorted.bam | \
  bcftools call -mv -Ob -o $VCF_DIR/${SAMPLE}.bcf

bcftools view $VCF_DIR/${SAMPLE}.bcf > $VCF_DIR/${SAMPLE}.vcf

echo "=== [5/5] Variant Annotation (BCFtools Annotate) ==="
bcftools annotate \
  --set-id 'VAR_%CHROM_%POS' \
  $VCF_DIR/${SAMPLE}.vcf \
  -O v -o $VCF_DIR/${SAMPLE}.ann.vcf

echo "=========================================="
echo " SUCCESS! Όλα τα αποτελέσματα είναι έτοιμα στο: $BASE_DIR"
echo "=========================================="
