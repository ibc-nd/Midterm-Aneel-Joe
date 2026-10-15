# Exercise #1 

# Part A:

# From the ref_sequences/ directory, we selected all the hsp70 gene fasta sequences by first compiling them using a for loop

Command: for i in ./hsp70gene_*
> do
> cat $i >> compiled_hsp70.fasta
> done

# This creates a single FASTA file that contains all the hsp70 genes present in our ref_sequences/ directory, which we will then use MUSCLE on to create our multiple sequence alignment 

# Command:

muscle -align compiled_hsp70.fasta -output muscle_aligned_compiled_hsp70.afa

# The output is an aligned FASTA (.afa) file. Each sequence begins with a FASTA header line starting with >, followed by the aligned amino acid sequence. MUSCLE inserts - characters to represent gaps so that homologous positions across the HSP70 proteins line up in the same columns.


# Part B:

# Now we will use hmmbuild to build a profile HMM from the hsp70 multiple sequence alignment we just created to capture position-specific amino acid patterns across the hsp70 family

hmmbuild hsp70_profile.hmm muscle_aligned_compiled_hsp70.afa

# The HMM profile was saved as hsp70_profile.hmm

