set -e

topdir=$(pwd)
mkdir docs
cd results/orphaned/
mkdir -p fastqc

echo "Running FastQC ..."
fastqc ../../data/*.fq -o fastqc

cd fastqc

echo "Unzipping ..."
for filename in *.zip
  do
    unzip $filename
  done

echo "Saving summary ..."
cat */summary.txt > ${topdir}/docs/fastqc-orphaned-summaries.txt
