include { spades    } from '../modules/spades.nf'
include { unicycler } from '../modules/unicycler.nf'

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
                ch_contigs    = spades.out.contigs
                ch_scaffolds  = spades.out.scaffolds
                ch_assemblies = Channel.empty()
                break

            case Tools.Assemble.UNICYCLER:
                unicycler(reads)
                ch_contigs    = Channel.empty()
                ch_scaffolds  = Channel.empty()
                ch_assemblies = unicycler.out.assembly_fasta
                break
        }

    emit:
        contigs    = ch_contigs
        scaffolds  = ch_scaffolds
        assemblies = ch_assemblies
}
