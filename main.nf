#!/usr/bin/env nextflow

/*
################
params
################
*/


params.saveBy = 'copy'


Channel.fromFilePairs("./*_{R1,R2}.p.fastq")
        .into { ch_in_rdanalyzer }


/*
###############
RD-Analyzer
###############
*/


process rdAnalyzer {
    container 'abhi18av/rdanalyzer'
    publishDir 'results/rdAnalyzer', mode: params.saveBy

    input:
    set genomeFileName, file(genomeReads) from ch_in_rdanalyzer

    output:
    tuple path("""${genomeName}.result"""), path("""${genomeName}.depth""") into ch_out_rdanalyzer


    script:
    genomeName = genomeFileName.toString().split("\\_")[0]

    """
    python  /RD-Analyzer/RD-Analyzer.py  -o ./${genomeName} ${genomeReads[0]} ${genomeReads[1]}
    """
}



/*
#==============================================
# extra
#==============================================
*/
