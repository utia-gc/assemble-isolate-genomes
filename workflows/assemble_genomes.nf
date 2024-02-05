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
        spades(reads)

    emit:
        contigs   = spades.out.contigs
        scaffolds = spades.out.scaffolds
}
