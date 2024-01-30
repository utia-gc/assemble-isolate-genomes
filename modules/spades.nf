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
        tuple val(metadata), path('*/scaffolds.fasta'), emit: scaffolds
        tuple val(metadata), path('*/contigs.fasta'),   emit: contigs
        tuple val(metadata), path('*'),                 emit: out_dir

    script:
        String stemName = MetadataUtils.buildStemName(metadata)

        String args = new Args(task.ext).buildArgsString()

        if(metadata.readType == 'single') {
            """
            spades.py \\
                --threads ${task.cpus} \\
                -o ${stemName} \\
                -s ${reads1} \\
                ${args}
            """
        } else if(metadata.readType == 'paired') {
            """
            spades.py \\
                --threads ${task.cpus} \\
                -o ${stemName} \\
                -1 ${reads1} \\
                -2 ${reads2} \\
                ${args}
            """
        }
}
