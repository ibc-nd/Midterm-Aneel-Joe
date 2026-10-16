# Exercise 2

# Part A:

# Using hmmsearch to search our hsp70 profile HMM against the first proteome (proteome_01.fasta) from the proteomes/ directory and saving the tabular results with --tblout

hmmsearch --tblout proteome_01_hsp70_results.txt hsp70_profile.hmm ../../bioinformatics_project_canvas/proteomes/proteome_01.fasta

# The output containing the table of hits is saved as proteome_01_hsp70_results.txt

# Part B:

# Examining the significant hits (E-value < 0.001)

grep -v "^#" proteome_01_hsp70_results.txt | awk '$5 < 0.001' | wc -l

# Output: 4

# So we have 4 significant hsp70 hits in proteome_01.fasta, with E-values of 3.7e-298, 7.2e-129, 4.5e-12, and 3.2e-09, all of which are smaller than 0.001.

# Part C:

# The E-value (Expectation value) is a statistical parameter used in sequence alignment tools to measure the number of sequence matches we expect to find purely by chance in a database of a given size. A lower E-value means the match is less likely to have occurred by chance and is therefore more likely to represent a true match (to the hsp70 profile in our case). We use a threshold such as E-value < 0.001 to filter out weaker matches and retain only those considered statistically significant.
