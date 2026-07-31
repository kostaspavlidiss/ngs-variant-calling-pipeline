# Automated NGS Variant Calling Pipeline

A lightweight, automated Bash pipeline for processing paired-end Next-Generation Sequencing (NGS) data, performing genome alignment, quality control, and calling single nucleotide polymorphisms (SNPs) and short insertions/deletions (indels).

## Overview

This pipeline automates the standard secondary analysis workflow for Illumina DNA sequencing data. Starting from raw FASTQ files, it executes quality control, aligns reads against a reference genome, processes binary alignment map (BAM) files, and outputs a Variant Call Format (VCF) file.

### Workflow Steps

1. **Quality Control:** `FastQC` (v0.11+) evaluates raw read quality metrics.
2. **Read Alignment:** `BWA MEM` maps paired-end reads to the reference genome (`hs37d5`).
3. **Alignment Processing:** `samtools` converts SAM to BAM, sorts by genomic coordinates, and indexes the final alignment file.
4. **Variant Calling:** `bcftools mpileup` calculates genotype likelihoods, followed by `bcftools call` for multiallelic variant calling.
5. **VCF Generation:** `bcftools view` filters and formats raw BCF calls into a standardized VCF output.

---

## Directory Structure

```text
ngs-variant-calling-pipeline/
├── data/
│   ├── hs37d5.fa           # Reference genome
│   ├── sample_R1.fastq     # Forward reads
│   └── sample_R2.fastq     # Reverse reads
├── results/                # Output directory (BAM, FastQC reports, VCF)
│   ├── aligned_sorted.bam
│   └── final_variants.vcf
├── run_pipeline.sh         # Main executable script
└── README.md
