include { QC_Assemblies           } from '../subworkflows/qc_assemblies.nf'
include { QC_Reads                } from '../subworkflows/qc_reads.nf'
include { multiqc as multiqc_full } from "../modules/multiqc.nf"


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
