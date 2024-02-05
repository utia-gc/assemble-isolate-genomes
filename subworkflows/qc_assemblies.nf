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
        // merge contigs and scaffolds into an assemblies channel
        contigs
            .join( scaffolds )
            .set { ch_assemblies }

        quast(
            ch_assemblies,
            genome,
            annotationsGTF
        )
}
