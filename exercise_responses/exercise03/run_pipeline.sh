#!/bin/bash

# Usage: bash run_pipeline.sh compiled_mcra.fasta compiled_hsp70.fasta ../../bioinformatics_project_canvas/proteomes
#
# This script:
# 1. Separately aligns the McrA and hsp70 reference sequences with MUSCLE
# 2. Builds an HMM profile for each gene
# 3. Searches every proteome with both HMM profiles
# 4. Counts significant hits with E-value < 0.001
# 5. Creates pipeline_results.csv containing only proteomes
#    that have at least one significant hit for BOTH genes

set -e

# Make sure three arguments were provided
if [ "$#" -ne 3 ]; then
    echo "Usage: bash run_pipeline.sh <mcrA_reference.fasta> <hsp70_reference.fasta> <proteome_directory>"
    exit 1
fi

# Store the arguments as variables
mcra_ref="$1"
hsp70_ref="$2"
proteome_dir="$3"

# Check that the input files and directory exist
ls "$mcra_ref" "$hsp70_ref" "$proteome_dir" > /dev/null

# Load MUSCLE and HMMER on the CRC
module load bio

# Step 1: Create multiple sequence alignments
muscle -align "$mcra_ref" -output muscle_aligned_compiled_mcra.afa
muscle -align "$hsp70_ref" -output muscle_aligned_compiled_hsp70.afa

# Step 2: Build HMM profiles
hmmbuild mcra_profile.hmm muscle_aligned_compiled_mcra.afa
hmmbuild hsp70_profile.hmm muscle_aligned_compiled_hsp70.afa

# Create the results file and add the header
echo "proteome,mcrA_hits,hsp70_hits" > pipeline_results.csv

# Step 3: Search every proteome
for proteome in "$proteome_dir"/*.fasta
do
    # Get the proteome name without the path or .fasta extension
    name=$(basename "$proteome" .fasta)

    # Search for McrA
    hmmsearch --tblout mcra_results.txt mcra_profile.hmm "$proteome" > /dev/null

    # Count significant McrA hits
    mcra_hits=$(grep -v "^#" mcra_results.txt | awk '$5 < 0.001' | wc -l)

    # Search for HSP70
    hmmsearch --tblout hsp70_results.txt hsp70_profile.hmm "$proteome" > /dev/null

    # Count significant HSP70 hits
    hsp70_hits=$(grep -v "^#" hsp70_results.txt | awk '$5 < 0.001' | wc -l)

    # Only save proteomes that have hits for BOTH genes
    if [ "$mcra_hits" -gt 0 ] && [ "$hsp70_hits" -gt 0 ]; then
        echo "$name,$mcra_hits,$hsp70_hits" >> pipeline_results.csv
    fi
done

echo "Pipeline complete."
echo "Results saved to pipeline_results.csv"
