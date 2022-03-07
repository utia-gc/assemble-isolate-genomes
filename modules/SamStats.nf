/*
Author : Trevor F. Freeman <trvrfreeman@gmail.com>
Date   : 2022-02-27
Purpose: Nextflow module
*/

process SamStats {
    tag "${metadata.sampleName}"

    container 'quay.io/biocontainers/samtools:1.15--h1170115_1'

    publishDir "${params.baseDirData}/align/stats", mode: 'copy', pattern: '*.txt'

    input:
        tuple val(metadata), path(bam), path(bai), val(toolIDs)

    output:
        path '*_sST.txt', emit: sST
        path '*_sIX-idxstat.txt', emit: sIX
        val toolIDs, emit: tools

    script:
        // update toolID and set suffix
        toolIDsST = toolIDs
        toolIDsST += 'sST'
        suffixsST = toolIDsST ? "__${toolIDsST.join('_')}" : ''

        toolIDsIX = toolIDs
        toolIDsIX += 'sIX-idxstat'
        suffixsIX = toolIDsIX ? "__${toolIDsIX.join('_')}" : ''

        toolIDs += ['sST', 'sIX-idxstat']


        """
        samtools stats ${bam} > ${metadata.sampleName}${suffixsST}.txt
        samtools idxstats ${bam} > ${metadata.sampleName}${suffixsIX}.txt
        """
}
