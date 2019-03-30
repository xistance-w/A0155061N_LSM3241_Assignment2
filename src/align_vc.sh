set -e

SCRIPT_DIR=$(dirname $(realpath $0))
BASE_DIR=$(dirname $SCRIPT_DIR)

cd ${BASE_DIR}

echo Working in $(pwd)

echo "Creating Combined Reference..."
cat data/references/genome/sacCer3.fa data/references/transposon/ty5_6p.fa > data/references/sacCer3_ty5_6p/sacCer3_ty5_6p.fa

ref_genome=data/references/sacCer3_ty5_6p/sacCer3_ty5_6p.fa

export BOWTIE2_INDEXES=$BASE_DIR/data/references/sacCer3_ty5_6p

echo "Building index of sacCer3_ty5_6p..."

bowtie2-build $ref_genome data/references/sacCer3_ty5_6p/sacCer3_ty5_6p

for fq1 in data/*_1.fq; do
  SRR=$(basename $fq1 _1.fq)
  echo "Working with $SRR"
  fq1=data/${SRR}_1.fq
  fq2=data/${SRR}_2.fq
  sam=results/sam/${SRR}.sam
  bam=results/bam/${SRR}.bam
  sorted_bam=results/bam/${SRR}-sorted.bam
  raw_bcf=results/bcf/${SRR}_raw.bcf
  variants=results/vcf/${SRR}_variants.vcf
  final_variants=results/vcf/${SRR}_final_variants.vcf
  bowtie2 -x sacCer3_ty5_6p --very-fast -p 4 --no-unal -1 ${fq1} -2 ${fq2} -S ${sam}
  samtools view -S -b ${sam} > $bam
  samtools sort -o ${sorted_bam} $bam
  samtools index ${sorted_bam}
  bcftools mpileup -O b -o $raw_bcf -f $ref_genome $sorted_bam
  bcftools call --ploidy 1 -m -v -o $variants $raw_bcf
  vcfutils.pl varFilter $variants > $final_variants

done
