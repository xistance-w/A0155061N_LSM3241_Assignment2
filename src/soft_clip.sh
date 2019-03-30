set -e

SCRIPT_DIR=$(dirname $(realpath $0))
BASE_DIR=$(dirname $SCRIPT_DIR)

cd ${BASE_DIR}

echo Working in $(pwd)

mkdir results/sam/local results/bam/local

ref_genome=data/references/sacCer3_ty5_6p/sacCer3_ty5_6p.fa

export BOWTIE2_INDEXES=$BASE_DIR/data/references/sacCer3_ty5_6p

for fq1 in data/*_1.fq; do
  SRR=$(basename $fq1 _1.fq)
  echo "Working with $SRR"
  fq1=data/${SRR}_1.fq
  fq2=data/${SRR}_2.fq
  sam=results/sam/local/${SRR}-local.sam
  bam=results/bam/local/${SRR}-local.bam
  sorted_bam=results/bam/local/${SRR}-local-sorted.bam
  bowtie2 -x sacCer3_ty5_6p --local --very-fast -p 4 --no-unal -1 ${fq1} -2 ${fq2} -S ${sam}
  samtools view -S -b ${sam} > $bam
  samtools sort -o ${sorted_bam} $bam
  samtools index ${sorted_bam}
done
