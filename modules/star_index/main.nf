#!/usr/bin/env nextflow

process STAR_INDEX {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest'
    publishDir params.outdir, mode: "copy"

    input:
    path(gtf)
    path(ref_genome)

    output:
    path "star", emit: index  //this one from in class

    script:
    """
    mkdir -p star
    STAR --runThreadN $task.cpus \
         --runMode genomeGenerate \
         --genomeDir star \
         --genomeFastaFiles $ref_genome \
         --sjdbGTFfile $gtf \
         --sjdbOverhang 99
    """

    stub:
    """
    mkdir star
    """
}