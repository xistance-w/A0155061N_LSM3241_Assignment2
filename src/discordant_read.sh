set -e

SCRIPT_DIR=$(dirname $(realpath $0))
BASE_DIR=$(dirname $SCRIPT_DIR)

cd ${BASE_DIR}

echo "Working in $(pwd) ..."

echo "Filtering for discordantly aligned reads..."
mkdir results/bam/filtered

for file in results/bam/*-sorted.bam; do
  SRR=$(basename $file -sorted.bam)
  echo "Working with $SRR"
  sorted_bam=results/bam/${SRR}-sorted.bam
  filtered_bam=results/bam/filtered/${SRR}-filtered.bam
  flagstat=docs/${SRR}-filtered_stats.txt
  samtools view -b -F 1294 ${sorted_bam} > $filtered_bam
  echo "Obtaining Statistics ... Saved in $(pwd)/docs"
  samtools flagstat ${filtered_bam} > $flagstat
  echo "Indexing ${SRR} bam file for IGV Analysis ..."
  samtools index ${filtered_bam}
done
