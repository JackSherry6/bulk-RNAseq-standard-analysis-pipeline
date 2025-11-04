#!/usr/bin/env nextflow

process CONCAT_COUNTS {
    label 'process_low'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode: "copy"

    input:
    path counts

    output:
    path "combined_matrix.csv"

    script:
    """
    concat_counts.py --counts ${counts.join(' ')} -o combined_matrix.csv
    """
    // remember chmod +x bin/concat_counts.py
}