/**
 * Process to run QUAST. 
 *
 * Perform quality assessment of genome assemblies with QUAST.
 * @see https://quast.sourceforge.net/docs/manual.html
 *
 * @input assemblies the collected assemblies channel containing contigs, scaffolds, assemblies, etc. in fasta format.
 * @input genome the uncompressed reference genome sequence in fasta format.
 * @input annotationsGTF the uncompressed reference annotations in GTF format.
 * @emit report_tsv the TSV formatted report file.
 * @emit out_dir the full output directory.
 */
process quast {
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
        path assemblies
        path genome
        path annotationsGTF

    output:
        path 'quast/report.tsv', emit: report_tsv
        path 'quast',            emit: out_dir

    script:
        String args = new Args(task.ext).buildArgsString()

        """
        quast.py \\
            --threads ${task.cpus} \\
            --output-dir quast \\
            -r ${genome} \\
            --features ${annotationsGTF} \\
            ${assemblies} \\
            ${args}
        """
}
