include { spades } from '../modules/spades.nf'

/**
 * Workflow to assemble genomes from reads.
 * 
 * @take read the reads channel of format [metadata, R1, R2].
 * @emit contigs the contigs channel of format [metadata, contigs] where contigs is a file in fasta format.
 * @emit scaffolds the scaffolds channel of format [metadata, scaffolds] where scaffolds is a file in fasta format.
 */
workflow ASSEMBLE_GENOMES {
    take:
        reads

    main:
        switch( Tools.Assemble.valueOf(params.tools.assemble.toUpperCase()) ) {
            case Tools.Assemble.SPADES:
                spades(reads)
                ch_contigs   = spades.out.contigs
                ch_scaffolds = spades.out.scaffolds
                break
        }

    emit:
        contigs   = ch_contigs
        scaffolds = ch_scaffolds
}
