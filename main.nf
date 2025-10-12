{\rtf1\ansi\ansicpg1252\cocoartf2865
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs28 \cf0 \expnd0\expndtw0\kerning0
#!/usr/bin/env nextflow\
\
include \{ STAR_INDEX; STAR_ALIGN; FEATURE_COUNTS \} from './process.nf'\
\
//files \
fasta_file = file('Files/Mus_musculus.GRCm38.dna_rm.chr19.fa')\
gtf_file = file('Files/Mus_musculus.GRCm38.88.chr19.gtf')\
control_file_1 = file('Files/control.mate_1.fq.gz')\
control_file_2 = file('Files/control.mate_2.fq.gz')\
\
// workflow\
workflow \{\
\
    STAR_INDEX(fasta_file, gtf_file)\
    STAR_ALIGN(STAR_INDEX.out, control_file_1, control_file_2)\
    FEATURE_COUNTS(STAR_ALIGN.out, gtf_file)\
\}}