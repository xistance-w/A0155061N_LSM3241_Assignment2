set -e

SCRIPT_DIR=$(dirname $(realpath $0))
BASE_DIR=$(dirname $SCRIPT_DIR)

cd ${BASE_DIR}

echo Working in $(pwd)

mkdir results/sam/secondary results/bam/secondary

ref_genome=data/references/sacCer3_ty5_6p/sacCer3_ty5_6p.fa

export BOWTIE2_INDEXES=$BASE_DIR/data/references/sacCer3_ty5_6p

for fq1 in data/*_1.fq; do
  SRR=$(basename $fq1 _1.fq)
  echo "Working with $SRR"
  fq1=data/${SRR}_1.fq
  fq2=data/${SRR}_2.fq
  sam=results/sam/secondary/${SRR}-secondary.sam
  bam=results/bam/secondary/${SRR}-secondary.bam
  sorted_bam=results/bam/secondary/${SRR}-secondary-sorted.bam
  bowtie2 -x sacCer3_ty5_6p -k 3 --local --very-fast -p 4 --no-unal -1 ${fq1} -2 ${fq2} -S ${sam}
  samtools view -S -b ${sam} > $bam
  samtools sort -o ${sorted_bam} $bam
  samtools index ${sorted_bam}
done

echo "Filtering for discordantly aligned reads..."
mkdir results/bam/secondary/filtered

for file in results/bam/secondary/*-secondary-sorted.bam; do
  SRR=$(basename $file -secondary-sorted.bam)
  echo "Working with $SRR"
  sorted_bam=results/bam/secondary/${SRR}-secondary-sorted.bam
  filtered_bam=results/bam/secondary/filtered/${SRR}-secondary-filtered.bam
  flagstat=docs/${SRR}-filtered_secondary_stats.txt
  samtools view -b -F 1038 ${sorted_bam} > $filtered_bam
  echo "Obtaining Statistics ... Saved in $(pwd)/docs"
  samtools flagstat ${filtered_bam} > $flagstat
  echo "Indexing ${SRR} bam file for IGV Analysis ..."
  samtools index ${filtered_bam}
done
