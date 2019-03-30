set -e

topdir=$(pwd)
echo Working in $(pwd)
echo Creating relevant directories...
mkdir docs results results/orphaned data data/references data/references/genome data/references/transposon data/references/sacCer3_ty5_6p
mkdir -p results/sam results/bam results/bcf results/vcf
