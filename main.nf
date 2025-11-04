include {FASTQC} from './modules/fastqc'
include {PARSE_GTF} from './modules/parse_gtf'
include {STAR_INDEX} from './modules/star_index'
include {STAR_ALIGN} from './modules/star_align'
include {MULTIQC} from './modules/multiqc'
include {VERSE} from './modules/verse'
include {CONCAT_COUNTS} from './modules/concat_counts'

workflow {

    Channel.fromFilePairs(params.reads)
        | set { align_ch }

    Channel.fromFilePairs(params.reads)
        | transpose()
        | set { fastqc_ch }

    FASTQC(fastqc_ch)

    PARSE_GTF(params.gtf)

    STAR_INDEX(params.gtf, params.genome)

    STAR_ALIGN(align_ch, STAR_INDEX.out.index)

    multiqc_ch = FASTQC.out.zip
        .map { it[1] }
        .mix(STAR_ALIGN.out.log)
        .collect()

    MULTIQC(multiqc_ch)

    VERSE(STAR_ALIGN.out.bam, params.gtf)

    CONCAT_COUNTS(VERSE.out.collect())

}