#!/usr/bin/env nextflow

include { STAR_INDEX; STAR_ALIGN; FEATURE_COUNTS } from './process.nf'

//files 
fasta_file = file('Files/Mus_musculus.GRCm38.dna_rm.chr19.fa')
gtf_file = file('Files/Mus_musculus.GRCm38.88.chr19.gtf')
control_file_1 = file('Files/control.mate_1.fq.gz')
control_file_2 = file('Files/control.mate_2.fq.gz')

// workflow
workflow {

    STAR_INDEX(fasta_file, gtf_file)
    // Define the output that was emitted and use that in the process - MB
    // STAR_ALIGN(STAR_INDEX.out.genome_index_ch, control_file_1, control_file_2)
    STAR_ALIGN(STAR_INDEX.out, control_file_1, control_file_2)
    // Same here
    // FEATURE_COUNTS(STAR_ALIGN.out.bam_ch, gtf_file)
    FEATURE_COUNTS(STAR_ALIGN.out, gtf_file)
}
