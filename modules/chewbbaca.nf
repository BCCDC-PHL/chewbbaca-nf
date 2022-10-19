process chewbbaca_allelecall {

    tag { sample_id }

    publishDir params.versioned_outdir ? "${params.outdir}/${sample_id}/${params.pipeline_short_name}-v${params.pipeline_minor_version}-output" : "${params.outdir}/${sample_id}", mode: 'copy', pattern: "${sample_id}_chewbbaca*.tsv"

    input:
    tuple val(sample_id), path(assembly), path(scheme)

    output:
    tuple val(sample_id), path("${sample_id}_chewbbaca_alleles.tsv"),        emit: alleles
    tuple val(sample_id), path("${sample_id}_chewbbaca_contigsInfo.tsv"),    emit: contigs_info
        tuple val(sample_id), path("${sample_id}_chewbbaca_statistics.tsv"), emit: stats
    tuple val(sample_id), path("${sample_id}_chewbbaca_provenance.yml"),     emit: provenance
    
    script:
    """
    printf -- "- process_name: chewbbaca\\n"                                  >> ${sample_id}_chewbbaca_provenance.yml
    printf -- "  tools:\\n"                                                   >> ${sample_id}_chewbbaca_provenance.yml
    printf -- "    - tool_name: chewbbaca\\n"                                 >> ${sample_id}_chewbbaca_provenance.yml
    printf -- "      tool_version: \$(chewie --version | cut -d ' ' -f 2)\\n" >> ${sample_id}_chewbbaca_provenance.yml

    mkdir input
    pushd input
    ln -s ../\$(basename ${assembly}) .
    popd

    chewie \
      AlleleCall \
      --cpu ${task.cpus} \
      --input-files input \
      --schema-directory ${scheme} \
      --output-directory output

    mv output/results*/results_alleles.tsv ${sample_id}_chewbbaca_alleles.tsv
    mv output/results*/results_contigsInfo.tsv ${sample_id}_chewbbaca_contigsInfo.tsv
    mv output/results*/results_statistics.tsv ${sample_id}_chewbbaca_statistics.tsv
    """
}
