process unicycler {
    tag "${stemName}"

    label 'unicycler'

    label 'big_cpu'
    label 'big_mem'
    label 'big_time'

    input:
        tuple val(metadata), path(reads1), path(reads2)

    output:
        tuple val(metadata), path("${stemName}_assembly.fasta"), emit: assembly_fasta

    script:
        stemName = MetadataUtils.buildStemName(metadata)

        String args = new Args(task.ext).buildArgsString()

        if(metadata.readType == 'single') {
            """
            unicycler \\
                --unpaired ${reads1} \\
                --out ${stemName} \\
                --threads ${task.cpus} \\
                ${args}

            ln -s ${stemName}/assembly.fasta ${stemName}_assembly.fasta
            """
        } else if(metadata.readType == 'paired') {
            """
            unicycler \\
                --short1 ${reads1} \\
                --short2 ${reads2} \\
                --out ${stemName} \\
                --threads ${task.cpus} \\
                ${args}

            ln -s ${stemName}/assembly.fasta ${stemName}_assembly.fasta
            """
        }
}
