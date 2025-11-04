#!/usr/bin/env nextflow

process PARSE_GTF {
    label 'process_low'
    container 'ghcr.io/bf528/biopython:latest'
    publishDir params.outdir

    input:
    path(gtf)

    output:
    path("gene_names.csv")

    script:
    """
    gtf_parser.py -i $gtf -o gene_names.csv
    """

    stub:
    """
    touch gene_names.csv
    """
}