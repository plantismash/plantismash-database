# plantiSMASH database

Code pertaining to the plantiSMASH database setup 


## LICENSE 
https://www.gnu.org/licenses/agpl-3.0

## Master plantgeneclusters file

The original plantiSMASH precalculated cluster data are stored per species in
directories such as:

`/local/data/plantismash/plantismash-data/precalc/v2/<species_id>/plantgeneclusters.txt`

where `<species_id>` is something like `Abeliophyllum_distichum_GCA_043235775.1`.

Each `plantgeneclusters.txt` file has the following tab-separated columns:

1. `accession` – sequence accession (e.g. `NC_003070.9`)
2. `description` – sequence description (e.g. `Arabidopsis thaliana chromosome 1 sequence`)
3. `cluster_id` – cluster identifier (e.g. `c1`, `c2`, `c3`)
4. `cluster_class` – predicted BGC class (e.g. `polyketide-alkaloid`, `saccharide`, `cyclopeptide`)
5. `genes` – semicolon-separated list of gene IDs
6. `proteins` – semicolon-separated list of protein accessions

To facilitate downstream analyses, we provide a script to build a single
master table that concatenates all `plantgeneclusters.txt` files and
adds the species ID as the first column.

### Repository layout

- `scripts/build_plantgeneclusters_master.sh` – script that builds the master table
- `data/plantgeneclusters_v2.all.tsv` – concatenated table of all plantiSMASH v2 precalculated clusters

### Rebuilding the master table

By default, the script assumes that the v2 precalc data are stored at:

`/local/data/plantismash/plantismash-data/precalc/v2/`

where each species directory contains a `plantgeneclusters.txt` file.

To rebuild the master table:

```bash
cd /path/to/plantismash-database
./scripts/build_plantgeneclusters_master.sh
```

## Test 

Count how many BGCs 

```
tail -n +2 data/plantgeneclusters_v2.all.tsv | wc -l
``` 

There should be 30426 BGCs in version 2 

## Create a mapping JSON file 

Like the one available on MITE for MIBIG: 
https://github.com/mite-standard/mite_data/blob/dev/mite_data/mibig/mibig_proteins.json


### JSON format

The JSON file (`data/plantismash_v2_clusters.json`) has the following structure:

```json
{
  "Andrographis_paniculata_GCF_009805555.1/#cluster-1": {
    "accession": "NC_003070.9",
    "description": "Arabidopsis thaliana chromosome 1 sequence",
    "cluster_id": "c1",
    "cluster_class": "polyketide-alkaloid",
    "genes": ["AT1G01960", "AT1G01970", "..."],
    "proteins": ["NP_171698.1", "NP_171699.1", "..."]
  },
  "Andrographis_paniculata_GCF_009805555.1/#cluster-2": {
    ...
  }
}

```
The JSON keys correspond to the path and anchor part of the plantiSMASH URL:

```
<species_id>/#cluster-<N>
```

For example, the key: `Andrographis_paniculata_GCF_009805555.1/#cluster-1` 
corresponds to the web page:
`https://plantismash.bioinformatics.nl/precalc/v2/Andrographis_paniculata_GCF_009805555.1/#cluster-1` 

Cluster numbers (cluster-1, cluster-2, etc.) are derived from the numeric
part of the cluster_id field (c1, c2, …).

## Rebuilding the JSON file 

```
cd /path/to/plantismash-database
./scripts/build_cluster_json.py
```