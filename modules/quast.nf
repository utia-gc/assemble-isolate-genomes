/**
 * Process to run QUAST. 
 *
 * Perform quality assessment of genome assemblies with QUAST.
 * @see https://quast.sourceforge.net/docs/manual.html
 *
 * @input assemblies the assemblies channel of format [metadata, contigs, scaffolds] where contigs and scaffolds are files in fasta format.
 * @input genome the uncompressed reference genome sequence in fasta format.
 * @input annotationsGTF the uncompressed reference annotations in GTF format.
 * @emit report_tsv the TSV formatted report file of format [metadata, report.tsv].
 * @emit out_dir the full output directory of format [metadata, out_dir].
 */
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
        tuple val(metadata), path(contigs), path(scaffolds)
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
            ${scaffolds} \\
            ${args}
        """
}
