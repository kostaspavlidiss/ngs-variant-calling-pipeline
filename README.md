# Automated NGS Variant Calling Pipeline

An automated, end-to-end Bioinformatics pipeline written in Bash for Next-Generation Sequencing (NGS) data processing, alignment, variant calling, and annotation.

## Pipeline Architecture
1. Quality Control: FastQC
2. Reference Indexing & Alignment: BWA MEM
3. Alignment Processing: Samtools (SAM to sorted BAM conversion, indexing)
4. Variant Calling: BCFtools (mpileup & call)
5. Variant Annotation: BCFtools annotate

## Quick Start
git clone [https://github.com/YOUR_USERNAME/ngs-variant-calling-pipeline.git](https://github.com/YOUR_USERNAME/ngs-variant-calling-pipeline.git)
cd ngs-variant-calling-pipeline
chmod +x run_pipeline.sh
./run_pipeline.sh
