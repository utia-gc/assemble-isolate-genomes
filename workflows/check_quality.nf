include { QC_Assemblies           } from '../subworkflows/qc_assemblies.nf'
include { QC_Reads                } from '../subworkflows/qc_reads.nf'
include { multiqc as multiqc_full } from "../modules/multiqc.nf"

/**
 * Workflow to perform all QC checks.
 *
 * No channels are emmitted because this is intended to be the end of the road for any QC that happens.
 *
 * @take reads_raw the raw reads channel of format [metadata, R1, R2].
 * @take reads_prealign the prealigned reads channel of format [metadata, R1, R2].
 * @take trim_log the log or summary file from the reads trimming tool that can be used as input for MultiQC.
 * @take contigs the channel with contigs of format [metadata, contigs fasta].
 * @take genome the uncompressed reference genome sequence in fasta format.
 * @take annotationsGTF the uncompressed reference annotations in GTF format.
 */
workflow CHECK_QUALITY {
    take:
        reads_raw
        reads_prealign
        trim_log
        contigs
        genome
        annotationsGTF

    main:
        QC_Reads(
            reads_raw,
            reads_prealign,
            trim_log
        )
        ch_multiqc_reads = QC_Reads.out.multiqc

        QC_Assemblies(
            contigs,
            genome,
            annotationsGTF
        )

        ch_multiqc_full = Channel.empty()
            .concat(ch_multiqc_reads)
            .collect( sort: true )
        multiqc_full(
            ch_multiqc_full,
            file("${projectDir}/assets/multiqc_config.yaml"),
            params.projectTitle
        )
}
