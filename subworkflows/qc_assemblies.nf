include { quast } from '../modules/quast.nf'

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

        quast(
            ch_contigs_collection,
            ch_scaffolds_collection,
            genome,
            annotationsGTF
        )
}
