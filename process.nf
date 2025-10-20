#!/usr/bin/env nextflow

process STAR_INDEX {

	input:
	path fasta_file
	path gtf_file

	output:
	path 'Files/genome_index'// into genome_index_ch

	publishDir "results/genome_index", mode: "copy"

    script:
	"""
	STAR --runThreadN 4 --runMode genomeGenerate --genomeDir Files/genome_index --genomeFastaFiles ${fasta_file} --sjdbGTFfile ${gtf_file}
	"""

}

process STAR_ALIGN {

	input:
	path genome_index_ch
	path control_file_1
	path control_file_2

	output:
	path '*Files/alignment_*.bam'// into bam_ch

	publishDir "results/alignment", mode: "copy"

	script:
	"""
    STAR --runThreadN 4 --genomeDir ${genome_index_ch} --readFilesIn ${control_file_1} ${control_file_2} --outFileNamePrefix Files/alignment_ --outSAMtype BAM SortedByCoordinate --readFilesCommand zcat
    """

}

process FEATURE_COUNTS {

	input:
    path bam_files
    path gtf_file

    output:
    path 'featureCounts_counts.txt'
    
    publishDir "results", mode: "copy"

    script:
    """
    featureCounts \
      -T 4 \
      -p --countReadPairs \
      -a ${gtf_file} \
      -o featureCounts_counts.txt \
      ${bam_files}
    """

}