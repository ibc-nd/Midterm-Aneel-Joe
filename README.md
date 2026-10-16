# Introduction to Biocomputing Midterm Project

## Project Purpose

The purpose of this project is to identify candidate pH-resistant methanogenic Archaea from 50 isolated proteomes. Methanogenic potential is evaluated by searching for the McrA protein, while the number of HSP70 matches is used as an indicator of potential stress tolerance.

The pipeline uses reference sequences for both McrA and HSP70 to create multiple sequence alignments, build profile Hidden Markov Models (HMMs), and search each proteome for significant matches. Only proteomes containing significant hits for both genes are retained in the final results.

## Required Software

This project was run on the Notre Dame CRC.

The required bioinformatics programs are:

- MUSCLE — multiple sequence alignment
- HMMER
  - `hmmbuild` — builds profile HMMs
  - `hmmsearch` — searches proteomes using the HMM profiles

On the CRC, these programs are available through the `bio` module: module load bio

## Results

Of the 50 proteomes analyzed, 15 contained significant hits for both McrA and HSP70 and were retained as candidate methanogenic isolates with potential stress resistance.

Proteomes 03, 23, 42, 45, and 50 had the highest combined number of significant hits, with four hits each. Proteomes 19 and 23 had the highest number of McrA hits, with two each, while proteomes 03, 42, 45, and 50 had the highest number of HSP70 hits, with three each.

These results can be used to prioritize isolates for further pH-resistance growth experiments. HSP70 copy number is used here as an indicator of potential stress tolerance, but it does not by itself prove that an isolate is pH resistant.
