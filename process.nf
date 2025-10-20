// this markup should not be visible in a nf file - MB
{\rtf1\ansi\ansicpg1252\cocoartf2865
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
// the shebang is not needed in the process nf files
\f0\fs24 \cf0 #!/usr/bin/env nextflow\
\
process STAR_INDEX \{\
\
	input:\
	path fasta_file\
	path gtf_file\
\
	output:\
	path 'Files/genome_index'// into genome_index_ch\
\
	publishDir "results/genome_index", mode: "copy"\
\
    script:\
	"""\
	STAR --runThreadN 4 --runMode genomeGenerate --genomeDir Files/genome_index --genomeFastaFiles $\{fasta_file\} --sjdbGTFfile $\{gtf_file\}\
	"""\
\
\}\
\
process STAR_ALIGN \{\
\
	input:\
	path genome_index_ch\
	path control_file_1\
	path control_file_2\
\
	output:\
	path '*Files/alignment_*.bam'// into bam_ch\
\
	publishDir "results/alignment", mode: "copy"\
\
	script:\
	"""\
    STAR --runThreadN 4 --genomeDir $\{genome_index_ch\} --readFilesIn $\{control_file_1\} $\{control_file_2\} --outFileNamePrefix Files/alignment_ --outSAMtype BAM SortedByCoordinate --readFilesCommand zcat\
    """\
\
\}\
\
process FEATURE_COUNTS \{\
\
	input:\
    path bam_files\
    path gtf_file\
\
    output:\
    path 'featureCounts_counts.txt'\
    \
    publishDir "results", mode: "copy"\
\
    script:\
    """\
    featureCounts \\\
      -T 4 \\\
      -p --countReadPairs \\\
      -a $\{gtf_file\} \\\
      -o featureCounts_counts.txt \\\
      $\{bam_files\}\
    """\
\
\}}