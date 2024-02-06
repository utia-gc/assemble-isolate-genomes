/**
 * Process to run SPAdes. 
 *
 * Perform enome assembly with SPAdes.
 * @see https://github.com/ablab/spades
 *
 * @input reads the reads channel of format [metadata, R1, R2].
 * @emit scaffolds the scaffolds channel of format [metadata, scaffolds] where scaffolds is a file in fasta format.
 * @emit contigs the contigs channel of format [metadata, contigs] where contigs is a file in fasta format.
 * @emit out_dir the full output directory of format [metadata, out_dir].
 */
process spades {
    tag "${metadata.sampleName}"

    label 'spades'

    label 'med_cpu'
    label 'med_mem'
    label 'med_time'

    publishDir(
        path:    "${params.publishDirData}/assemblies",
        mode:    "${params.publishMode}",
        pattern: '*'
    )

    input:
        tuple val(metadata), path(reads1), path(reads2)

    output:
        tuple val(metadata), path("${stemName}_scaffolds.fasta"), emit: scaffolds
        tuple val(metadata), path("${stemName}_contigs.fasta"),   emit: contigs
        tuple val(metadata), path("${stemName}"),                 emit: out_dir

    script:
        stemName = MetadataUtils.buildStemName(metadata)

        String args = new Args(task.ext).buildArgsString()

        if(metadata.readType == 'single') {
            """
            spades.py \\
                --threads ${task.cpus} \\
                -o ${stemName} \\
                -s ${reads1} \\
                ${args}

            ln -s ${stemName}/scaffolds.fasta ${stemName}_scaffolds.fasta
            ln -s ${stemName}/scaffolds.fasta ${stemName}_contigs.fasta
            """
        } else if(metadata.readType == 'paired') {
            """
            spades.py \\
                --threads ${task.cpus} \\
                -o ${stemName} \\
                -1 ${reads1} \\
                -2 ${reads2} \\
                ${args}

            ln -s ${stemName}/scaffolds.fasta ${stemName}_scaffolds.fasta
            ln -s ${stemName}/scaffolds.fasta ${stemName}_contigs.fasta
            """
        }
}
