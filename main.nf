/*
---------------------------------------------------------------------
    utia-gc/ngs
---------------------------------------------------------------------
https://github.com/utia-gc/ngs
*/

nextflow.enable.dsl=2

/*
---------------------------------------------------------------------
    RUN MAIN WORKFLOW
---------------------------------------------------------------------
*/

include { CHECK_QUALITY  } from "./workflows/check_quality.nf"
include { PREPARE_INPUTS } from "./workflows/prepare_inputs.nf"
include { PROCESS_READS  } from "./workflows/process_reads.nf"
include { quast          } from './modules/quast.nf'
include { spades         } from './modules/spades.nf'

/*
---------------------------------------------------------------------
    CHECK FOR REQUIRED PARAMETERS
---------------------------------------------------------------------
*/
PipelineValidator.validateRequiredParams(params, log)

workflow {
    PREPARE_INPUTS(
        file(params.samplesheet),
        file(params.genome),
        file(params.annotations)
    )
    ch_reads_raw    = PREPARE_INPUTS.out.samples
    ch_reads_raw.dump(tag: "ch_reads_raw")
    ch_genome       = PREPARE_INPUTS.out.genome
    ch_genome_index = PREPARE_INPUTS.out.genome_index
    ch_annotations  = PREPARE_INPUTS.out.annotations

    PROCESS_READS(ch_reads_raw)
    ch_reads_pre_align = PROCESS_READS.out.reads_pre_align
    ch_trim_log        = PROCESS_READS.out.trim_log

    spades(ch_reads_pre_align)

    quast(
        spades.out.contigs,
        ch_genome,
        ch_annotations
    )

    CHECK_QUALITY(
        ch_reads_raw,
        ch_reads_pre_align,
        ch_trim_log
    )
}
