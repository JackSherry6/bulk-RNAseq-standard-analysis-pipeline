#!/usr/bin/env nextflow

process VERSE {
    label 'process_low'
    container 'ghcr.io/bf528/verse:latest'
    publishDir params.outdir, mode: "copy"

    input:
    path bam
    path gtf

    output:
    path "${bam.baseName}.exon.txt"

    script:
    """
    verse -a $gtf -t exon -s 1 -o ${bam.baseName} $bam
    """
}