# `utia-gc/assemble-isolate-genomes`

[![nf-test](https://img.shields.io/badge/tested_with-nf--test-337ab7.svg)](https://code.askimed.com/nf-test)
[![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

:book:[Full documentation on GitHub Pages]:book:

## Introduction

`utia-gc/assemble-isolate-genomes` is a [Nextflow](https://www.nextflow.io/) pipeline for base NGS analysis.
While `utia-gc/assemble-isolate-genomes` can be run on any platform supported by Nextflow, it is developed for use in HPC environments and specifically [ISAAC Next Generation] at the University of Tennessee, Knoxville.

### Pipeline overview

```mermaid
flowchart LR
    %% list all the input files
    samplesheet>"Samplesheet"]
    genome_fasta>"
        Genome
        FASTA
    "]
    annotations_gtf>"
        Annotations
        GTF
    "]

    %% list all the internal Nextflow channels
    raw_reads[("
        Raw
        reads
    ")]
    prealign_reads[("
        Prealign
        reads
    ")]
    trim_log[("
        Trim
        log
    ")]
    contigs[("
        Contigs
    ")]

    %% list all the Nextflow processes
    fastp{"fastp"}
    cutadapt{"cutadapt"}
    fastqc{"FastQC"}
    spades{"SPAdes"}
    quast{"QUAST"}
    
    %% list all subgraphs for Nextflow subworkflows/workflows with options
    subgraph inputs["Input Files"]
    samplesheet
    genome_fasta
    annotations_gtf
    end
    subgraph trim_reads["Trim Reads"]
    fastp
    cutadapt
    end
    subgraph assemble_genomes["Assemble genomes"]
    spades
    end
    subgraph publish_reports["Publish Reports"]
    reads_mqc
    full_mqc
    assembly_reports
    end
    subgraph publish_data["Publish Data"]
    assemblies
    end

    %% list all the published reports files
    reads_mqc((("
        Reads
        MultiQC
    ")))
    full_mqc((("
        Full MultiQC
    ")))
    assembly_reports((("
        Assembly reports
    ")))

    %% list all the published data files
    assemblies[["
        Assemblies
    "]]

    %% reads processing workflow
    samplesheet --> raw_reads
    raw_reads --- trim_reads --> prealign_reads

    %% reads QC workflow
    raw_reads --- fastqc --x reads_mqc
    prealign_reads --- fastqc --x reads_mqc
    trim_reads --> trim_log --x reads_mqc

    %% genome assembly workflow
    prealign_reads --- assemble_genomes --> contigs
    assemble_genomes --x assemblies

    %% genome assembly QC workflow
    genome_fasta --- quast
    annotations_gtf --- quast
    contigs --- quast --x assembly_reports

    %% Full MultiQC
    reads_mqc --x full_mqc
```

## Quick start

### Prerequisites

1. Any POSIX compatible system (e.g. Linux, OS X, etc) with internet access

   - Run on Windows with [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/). WSL2 highly recommended.

2. [Nextflow](https://www.nextflow.io/) version >= 21.04

   - See [Nextflow Get started](https://www.nextflow.io/docs/latest/getstarted.html#) for prerequisites and instructions on installing and updating Nextflow.

3. [Singularity](https://sylabs.io)

### Get or update `utia-gc/assemble-isolate-genomes`

1. Download or update `utia-gc/assemble-isolate-genomes`:

    ```bash
    nextflow pull utia-gc/assemble-isolate-genomes
    ```

2. Show project info:

    ```bash
    nextflow info utia-gc/assemble-isolate-genomes
    ```

### Test `utia-gc/assemble-isolate-genomes`

1. Check that `utia-gc/assemble-isolate-genomes` works on your system:

   - `-profile nf_test` uses preconfigured test parameters to run `utia-gc/assemble-isolate-genomes` in full on a small test dataset stored in a remote GitHub repository.
   - Because these test files are stored in a remote repository, internet access is required to run the test.
   - For more information, see the `profiles` section of the [nextflow config file](nextflow.config).

   ```bash
   nextflow run utia-gc/assemble-isolate-genomes \
      -revision main \
      -profile nf_test
   ```

> [!IMPORTANT]
> In accordance with best practices for reproducible analysis, always use the `-revision` option in `nextflow run` to specify a tagged and/or released version of the pipeline.

### Run `utia-gc/assemble-isolate-genomes`

TODO

[Full documentation on GitHub Pages]: https://utia-gc.github.io/assemble-isolate-genomes/
