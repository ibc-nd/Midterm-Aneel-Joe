Midterm Assignment
Aneel Al Fatayri
Joseph Mura
10/16/2026


Exercise #1

Part A:

From the ref_sequences/ directory, we selected all the hsp70 gene fasta sequences by first compiling them using a for loop

Command: for i in ./hsp70gene_*
> do
> cat $i >> compiled_hsp70.fasta
> done

This creates a single FASTA file that contains all the hsp70 genes present in our ref_sequences/ directory, which we will then use MUSCLE on to create our multiple sequence alignment 

Command: muscle -align compiled_hsp70.fasta -output muscle_aligned_compiled_hsp70.afa

The output is an aligned FASTA (.afa) file. Each sequence begins with a FASTA header line starting with >, followed by the aligned amino acid sequence. MUSCLE inserts - characters to represent gaps so that homologous positions across the HSP70 proteins line up in the same columns.

Part B:

Now we will use hmmbuild to build a profile HMM from the hsp70 multiple sequence alignment we just created to capture position-specific amino acid patterns across the HSP70 family

Command: hmmbuild hsp70_profile.hmm muscle_aligned_compiled_hsp70.afa

The HMM profile was saved as hsp70_profile.hmm


Exercise #2

Part A:

Using hmmsearch to search our hsp70 profile HMM against the first proteome (proteome_01.fasta) from the proteomes/ directory and saving the tabular results with --tblout

Command: hmmsearch --tblout proteome_01_hsp70_results.txt hsp70_profile.hmm ../../bioinformatics_project_canvas/proteomes/proteome_01.fasta

The output containing the table of hits is saved as proteome_01_hsp70_results.txt

Part B:

Examining the significant hits (E-value < 0.001)

Command: grep -v "^#" proteome_01_hsp70_results.txt | awk '$5 < 0.001' | wc -l
Output: 4

So we have 4 significant hsp70 hits in proteome_01.fasta, with E-values of 3.7e-298, 7.2e-129, 4.5e-12, and 3.2e-09, all of which are smaller than 0.001.

Part C:

The E-value (Expectation value) is a statistical parameter used in sequence alignment tools to measure the number of sequence matches we expect to find purely by chance in a database of a given size. A lower E-value means the match is less likely to have occurred by chance and is therefore more likely to represent a true match (to the hsp70 profile in our case). We use a threshold such as E-value < 0.001 to filter out weaker matches and retain only those considered statistically significant.

Exercise #3

From the ref_sequences/ directory, we selected all the mcrA gene fasta sequences by first compiling them using a for loop

Command: for i in ./mcrAgene_*
> do
> cat $i >> compiled_mcra.fasta
> done

This creates a single FASTA file that contains all the mcrA genes present in our ref_sequences/ directory, which we will then use as our first argument when running the script we wrote for this exercise. Did the same for the hsp70 genes.

In our exercises/exercise03/ directory, we will create our bash script run_pipeline.sh

Command: nano run_pipeline.sh

Where our script will contain the following:

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


We then save this script by hitting Ctrl+O followed by Ctrl+X to exit.

Inside our exercise03 directory we make a new directory called test_proteomes/ which will house our first five proteomes which we will test our script on for exercise #3. We copied the first five fasta proteomes into our new directory using the command below:

Command: cp $(ls proteome_*.fasta | head -n 5) ../../exercises/exercise03/test_proteomes/

Now we can run our script using our two compiled reference FASTA files and this smaller directory containing the first five proteomes:

Command: bash run_pipeline.sh compiled_mcra.fasta compiled_hsp70.fasta test_proteomes

The results obtained from running our script on the first five proteomes are saved to pipeline_results.csv, which includes only proteomes with at least one significant hit for both McrA and hsp70.

Command: cat pipeline_results.csv
Output: 
proteome,mcrA_hits,hsp70_hits
proteome_03,1,3
proteome_05,1,2

Exercise #4

Part A: 

Command: bash run_pipeline.sh ../exercise03/compiled_mcra.fasta ../exercise03/compiled_hsp70.fasta ../../bioinformatics_project_canvas/proteomes/

Part B: 

Command: $ cat pipeline_results.csv

Output: proteome,mcrA_hits,hsp70_hits
proteome_03,1,3
proteome_05,1,2
proteome_07,1,2
proteome_15,1,1
proteome_16,1,1
proteome_19,2,1
proteome_23,2,2
proteome_24,1,2
proteome_38,1,1
proteome_39,1,1
proteome_42,1,3
proteome_44,1,1
proteome_45,1,3
proteome_48,1,1
proteome_50,1,3

Among the proteomes retained in pipeline_results.csv, proteomes 03, 23, 42, 45, and 50 had the most combined significant hits, with 4 hits each. Proteomes 19 and 23 had the highest number of McrA hits, with 2 each, while proteomes 03, 42, 45, and 50 had the highest number of hsp70 hits, with 3 each. The fewest combined hits among the filtered candidates occurred in proteomes 15, 16, 38, 39, 44, and 48, which each had 1 McrA hit and 1 hsp70 hit, for 2 total hits. The remaining 35 proteomes were excluded from the filtered results because they lacked a significant hit for at least one of the two genes of interest.

Part C: 

The mcrA gene encodes the alpha subunit of methyl-coenzyme M reductase (MCR) which is the key rate-limiting enzyme that catalyzes the final step of methane production in methanogens and is an important genetic biomarker. Any isolated proteome with at least one mcrA hit is a methanogen, and isolates with no hits are non-methanogenic organisms. The hsp70 gene is a “molecular chaperone” involved in protein biogenesis and protects cells from damage. The proteomes with hsp70 hits like 3, 42, 45, and 50 have greater heat/acid-shock response capacity which makes them prime candidates for pH-resistant growth experiments. Therefore, the variation in hit counts can help answer which isolates are the strongest candidates for pH-resistant methanogens by identifying proteomes with evidence of methanogenic potential through McrA and then comparing the relative number of hsp70 copies among those candidates. In this way, the differences in hit counts allow us to prioritize isolates for follow-up growth experiments, although hsp70 copy number alone does not prove pH resistance.

Question 5:

Part A: 

Pairwise alignment is useful for quick, direct comparisons when using a single query sequence to search for similar sequences. It is very fast, works well for identifying closely related homologs, and tools such as the web version of BLAST require little setup. We would use a pairwise search when we have one sequence of interest and want to quickly find sequences that are very similar to it. In contrast, profile-based searching uses a multiple sequence alignment of a gene family to build a profile that represents patterns shared across the entire family. It requires more setup because the reference sequences must first be aligned (using MUSCLE) and then used to build the profile, but it is more sensitive for detecting divergent homologs. We would use a profile-based search when we have several related reference sequences and want to search whole proteomes for members of that gene family, especially when the target sequences may have accumulated more variation.

Part B: 

Building an HMM profile from a multiple sequence alignment is more sensitive than using a single-sequence BLAST query because the HMM captures position-specific patterns across an entire gene family rather than relying on just one reference sequence. The alignment shows which amino acid positions are highly conserved and which positions naturally vary, and the HMM uses those differences to assign probabilities across the sequence. Profile HMMs can also account for insertions and deletions, which helps them recognize related sequences that have changed over evolutionary time. Because the search is based on the shared characteristics of many homologous sequences, an HMM can detect more divergent family members that a single-sequence query might miss.

GitHub repository HTTPS URL: https://github.com/ibc-nd/Midterm-Aneel-Joe.git
