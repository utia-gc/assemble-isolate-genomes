include { quast } from '../modules/quast.nf'

/**
 * Subworkflow to perform QC on genome assemblies.
 * 
 * @take contigs the channel with contigs of format [metadata, contigs fasta].
 * @take genome the uncompressed reference genome sequence in fasta format.
 * @take annotationsGTF the uncompressed reference annotations in GTF format.
 */
workflow QC_Assemblies {
    take:
        contigs
        genome
        annotationsGTF

    main:
        quast(
            contigs,
            genome,
            annotationsGTF
        )
}
