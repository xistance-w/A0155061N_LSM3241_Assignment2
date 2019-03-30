Set up a main directory folder with a "src" folder and place all relevant scripts in it.
Run all scripts from the main directory.
Place relevant fq files in the "data" folder and references in the respective folders in "data/references".

1. setup.sh
2. read_qc.sh
3. align_vc.sh
4. discordant_read.sh
5. soft_clip.sh
6. local_discoradant_read.sh


Notes:
Bowtie2 gives a low MAPQ for reads that do not map uniquely (i.e. maps > 1 area)
