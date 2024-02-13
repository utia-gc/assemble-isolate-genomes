include { multiqc as multiqc_assemblies } from '../modules/multiqc.nf'
include { quast                         } from '../modules/quast.nf'

/**
 * Subworkflow to perform QC on genome assemblies.
 * 
 * @take contigs the contigs channel of format [metadata, contigs] where contigs is a file in fasta format.
 * @take scaffolds the scaffolds channel of format [metadata, scaffolds] where scaffolds is a file in fasta format.
 * @take genome the uncompressed reference genome sequence in fasta format.
 * @take annotationsGTF the uncompressed reference annotations in GTF format.
 */
workflow QC_Assemblies {
    take:
        contigs
        scaffolds
        assemblies
        genome
        annotationsGTF

    main:
        // collect all contigs files without metadata
        contigs
            .map { metadata, contigs ->
                contigs
            }
            .collect( sort: true )
            .set { ch_contigs_collection }

        // collect all scaffolds files without metadata
        scaffolds
            .map { metadata, scaffolds ->
                scaffolds
            }
            .collect( sort: true )
            .set { ch_scaffolds_collection }

        // collect all assemblies files without metadata
        assemblies
            .map { metadata, assemblies ->
                assemblies
            }
            .collect( sort: true )
            .set { ch_assemblies_collection }

        // collect all the contigs, scaffolds, assemblies together
        ch_assemblies = Channel.empty()
            .concat(ch_contigs_collection)
            .concat(ch_scaffolds_collection)
            .concat(ch_assemblies_collection)
            .collect( sort: true )

        quast(
            ch_assemblies,
            genome,
            annotationsGTF
        )

        ch_multiqc_assemblies = Channel.empty()
            .concat(quast.out.report_tsv)
            .collect( sort: true )

        multiqc_assemblies(
            ch_multiqc_assemblies,
            file("${projectDir}/assets/multiqc_config.yaml"),
            'assemblies'
        )

        emit:
            multiqc = ch_multiqc_assemblies
}
