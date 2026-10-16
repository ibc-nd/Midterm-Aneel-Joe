# Exercise #4

# Part A: Using the run_pipeline.sh script from exercise 3 to run it on all proteomes rather than just the first five 

bash run_pipeline.sh ../exercise03/compiled_mcra.fasta ../exercise03/compiled_hsp70.fasta ../../bioinformatics_project_canvas/proteomes/

# Part B: 

cat pipeline_results.csv

# Output: proteome,mcrA_hits,hsp70_hits
# proteome_03,1,3
# proteome_05,1,2
# proteome_07,1,2
# proteome_15,1,1
# proteome_16,1,1
# proteome_19,2,1
# proteome_23,2,2
# proteome_24,1,2
# proteome_38,1,1
# proteome_39,1,1
# proteome_42,1,3
# proteome_44,1,1
# proteome_45,1,3
# proteome_48,1,1
# proteome_50,1,3

# Among the proteomes retained in pipeline_results.csv, proteomes 03, 23, 42, 45, and 50 had the most combined significant hits, with 4 hits each. Proteomes 19 and 23 had the highest number of McrA hits, with 2 each, while proteomes 03, 42, 45, and 50 had the highest number of hsp70 hits, with 3 each. The fewest combined hits among the filtered candidates occurred in proteomes 15, 16, 38, 39, 44, and 48, which each had 1 McrA hit and 1 hsp70 hit, for 2 total hits. The remaining 35 proteomes were excluded from the filtered results because they lacked a significant hit for at least one of the two genes of interest.

# Part C: 

# The mcrA gene encodes the alpha subunit of methyl-coenzyme M reductase (MCR) which is the key rate-limiting enzyme that catalyzes the final step of methane production in methanogens and is an important genetic biomarker. Any isolated proteome with at least one mcrA hit is a methanogen, and isolates with no hits are non-methanogenic organisms. The hsp70 gene is a “molecular chaperone” involved in protein biogenesis and protects cells from damage. The proteomes with hsp70 hits like 3, 42, 45, and 50 have greater heat/acid-shock response capacity which makes them prime candidates for pH-resistant growth experiments. Therefore, the variation in hit counts can help answer which isolates are the strongest candidates for pH-resistant methanogens by identifying proteomes with evidence of methanogenic potential through McrA and then comparing the relative number of hsp70 copies among those candidates. In this way, the differences in hit counts allow us to prioritize isolates for follow-up growth experiments, although hsp70 copy number alone does not prove pH resistance.
