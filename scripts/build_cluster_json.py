#!/usr/bin/env python3
import csv
import json
import sys
from pathlib import Path

# Usage:
#   ./scripts/build_cluster_json.py [input_tsv] [output_json]
#
# Defaults:
#   input_tsv = data/plantgeneclusters_v2.all.tsv
#   output_json = data/plantismash_v2_clusters.json

def main():
    input_tsv = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("data/plantgeneclusters_v2.all.tsv")
    output_json = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("data/plantismash_v2_clusters.json")

    clusters = {}

    with input_tsv.open("r", encoding="utf-8") as f:
        reader = csv.DictReader(f, delimiter="\t")
        for row in reader:
            species_id = row["species_id"]
            cluster_id = row["cluster_id"]    # e.g. c1, c2, c3
            # extract numeric part for URL anchor: c1 -> 1, c10 -> 10
            cluster_num = cluster_id.lstrip("cC")
            key = f"{species_id}/#cluster-{cluster_num}"

            genes = [g for g in row["genes"].split(";") if g]
            proteins = [p for p in row["proteins"].split(";") if p]

            clusters[key] = {
                "accession": row["accession"],
                "description": row["description"],
                "cluster_id": cluster_id,
                "cluster_class": row["cluster_class"],
                "genes": genes,
                "proteins": proteins,
            }

    output_json.parent.mkdir(parents=True, exist_ok=True)
    with output_json.open("w", encoding="utf-8") as out:
        json.dump(clusters, out, indent=2, sort_keys=True)

    print(f"Wrote {len(clusters)} clusters to {output_json}")

if __name__ == "__main__":
    main()