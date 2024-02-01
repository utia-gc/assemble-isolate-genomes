include { spades } from '../modules/spades.nf'

/**
 * Workflow to assemble genomes from reads.
 * 
 * @take read the reads channel of format [metadata, R1, R2].
 * @emit contigs the channel with contigs of format [metadata, contigs fasta].
 */
workflow ASSEMBLE_GENOMES {
    take:
        reads

    main:
        spades(reads)

    emit:
        contigs = spades.out.contigs
}
