# chewbbaca-nf
A nextflow pipeline for running [chewBBACA](https://github.com/B-UMMI/chewBBACA) on a set of assemblies.

## Usage

```
nextflow run BCCDC-PHL/chewbbaca-nf \
  --assembly_input </path/to/assemblies> \
  --scheme </path/to/scheme_dir> \
  --outdir </path/to/outdir>
```

See the [chewBBACA documentation](https://github.com/B-UMMI/chewBBACA#vii-adapt-an-external-schema) for instructions on preparing the scheme directory.

The pipeline also supports a 'samplesheet input' mode. Pass a samplesheet.csv file with the headers `ID`, `ASSEMBLY`:

```
nextflow run BCCDC-PHL/mlst-nf \
  --samplesheet_input </path/to/samplesheet.csv> \
  --scheme </path/to/scheme_dir>
  --outdir </path/to/outdir>
```

## Outputs

Outputs for each sample will be written to a separate directory under the output directory, named using the sample ID.

The following output files are produced for each sample.

```
sample-01
├── sample-01_20211202154752_provenance.yml
├── sample-01_chewbbaca_alleles.tsv
├── sample-01_chewbbaca_contigsInfo.tsv
├── sample-01_chewbbaca_statistics.tsv
└── sample-01_quast.csv
```

If the `--versioned_outdir` flag is used, then a sub-directory will be created below each sample, named with the pipeline name and minor version:

```
sample-01
    └── chewbbaca-nf-v0.1-output
	    ├── sample-01_20211202154752_provenance.yml
        ├── sample-01_chewbbaca_alleles.tsv
        ├── sample-01_chewbbaca_contigsInfo.tsv
        ├── sample-01_chewbbaca_statistics.tsv
        └── sample-01_quast.csv
```

This is provided as a way of combining outputs of several different pipelines or re-analysis with future versions of this pipeline:

```
sample-01
    └── chewbbaca-nf-v0.1-output
    │   ├── sample-01_20211202154752_provenance.yml
    │   ├── sample-01_chewbbaca_alleles.tsv
    │   ├── sample-01_chewbbaca_contigsInfo.tsv
    │   ├── sample-01_chewbbaca_statistics.tsv
    │   └── sample-01_quast.csv
    └── chewbbaca-nf-v0.2-output
        ├── sample-01_20220321122138_provenance.yml
        ├── sample-01_chewbbaca_alleles.tsv
        ├── sample-01_chewbbaca_contigsInfo.tsv
        ├── sample-01_chewbbaca_statistics.tsv
        └── sample-01_quast.csv
```




### Provenance
Each analysis will create a `provenance.yml` file for each sample. The filename of the `provenance.yml` file includes
a timestamp with format `YYYYMMDDHHMMSS` to ensure that a unique file will be produced if a sample is re-analyzed and outputs
are stored to the same directory.

```yml
- pipeline_name: BCCDC-PHL/chewbbaca-nf
  pipeline_version: 0.1.0
- timestamp_analysis_start: 2021-12-02T15:46:38.472211
- input_filename: sample-01.fa
  input_path: /absolute/path/to/sample-01.fa
  sha256: ddd3a297d54841994e021829201ca86e6c83d62c1b57b035bb69bd4d5f9ae279
- process_name: quast
  tools:
    - tool_name: quast
      tool_version: 5.0.2
- process_name: chewbbaca
  tools:
    - tool_name: chewbbaca
      tool_version: 2.8.5
```
