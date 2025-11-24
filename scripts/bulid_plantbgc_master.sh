#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./scripts/build_plantgeneclusters_master.sh [PRECALC_ROOT] [OUTDIR]
#
# Defaults:
#   PRECALC_ROOT=/local/data/plantismash/plantismash-data/precalc/v2
#   OUTDIR=data

PRECALC_ROOT=${1:-/local/data/plantismash/plantismash-data/precalc/v2}
OUTDIR=${2:-data}

mkdir -p "$OUTDIR"

OUTFILE="$OUTDIR/plantgeneclusters_v2.all.tsv"

echo "Building master plantgeneclusters file from: $PRECALC_ROOT"
echo "Output file: $OUTFILE"

# Header: we add 'species_id' in front of the existing columns
# Columns:
# 1: species_id        (e.g. Abeliophyllum_distichum_GCA_043235775.1)
# 2: accession         (e.g. NC_003070.9)
# 3: description       (full chromosome description)
# 4: cluster_id        (e.g. c1, c2, c3)
# 5: cluster_class     (e.g. polyketide-alkaloid, saccharide, cyclopeptide)
# 6: genes             (semicolon-separated list of gene IDs)
# 7: proteins          (semicolon-separated list of protein accessions)
echo -e "species_id\taccession\tdescription\tcluster_id\tcluster_class\tgenes\tproteins" > "$OUTFILE"

# Find all plantgeneclusters.txt files and concatenate them
# We prefix each line with the species directory name.
find "$PRECALC_ROOT" -mindepth 2 -maxdepth 2 -type f -name "plantgeneclusters.txt" -print0 \
  | sort -z \
  | while IFS= read -r -d '' f; do
        species=$(basename "$(dirname "$f")")
        echo "Adding clusters from $species" >&2
        awk -v s="$species" 'BEGIN{FS=OFS="\t"} {print s,$0}' "$f" >> "$OUTFILE"
    done

echo "Done. Total lines (including header):"
wc -l "$OUTFILE"