process spades {
    tag "${metadata.sampleName}"

    label 'spades'

    label 'med_cpu'
    label 'med_mem'
    label 'med_time'

    input:
        tuple val(metadata), path(reads1), path(reads2)

    output:
        tuple val(metadata), path("*/scaffolds.fasta"), emit: scaffolds
        tuple val(metadata), path("*/contigs.fasta"), emit: contigs

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
            echo "Hello world!"
            """
        }
}
