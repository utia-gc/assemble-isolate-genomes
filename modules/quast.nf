process quast {
    tag "${metadata.sampleName}"

    label 'quast'

    label 'med_cpu'
    label 'med_mem'
    label 'med_time'

    publishDir(
        path:    "${params.publishDirReports}/.assemblies",
        mode:    "${params.publishMode}",
        pattern: '*'
    )

    input:
        tuple val(metadata), path(contigs)
        path genome
        path annotationsGTF

    output:
        tuple val(metadata), path('*/report.tsv'), emit: report_tsv
        tuple val(metadata), path('*'),            emit: out_dir

    script:
        String stemName = MetadataUtils.buildStemName(metadata)

        String args = new Args(task.ext).buildArgsString()

        """
        quast.py \\
            --threads ${task.cpus} \\
            --output-dir ${stemName} \\
            -r ${genome} \\
            --features ${annotationsGTF} \\
            ${contigs} \\
            ${args}
        """
}
