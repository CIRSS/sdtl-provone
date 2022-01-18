#!/usr/bin/env bash

RUNNER='../common/run_script_example.sh'
GRAPHER='../common/run_dot_examples.sh'

# *****************************************************************************

bash ${RUNNER} SETUP "IMPORT SDTL AS JSON-LD" << END_SCRIPT

geist destroy --dataset kb --quiet
geist create --dataset kb --quiet 
geist import --format jsonld --file ../data/compute-sdth.jsonld

END_SCRIPT

# *****************************************************************************

bash ${RUNNER} E1 "EXPORT ORIGINAL SDTL AS N-TRIPLES" << END_SCRIPT

geist export --format nt --sort

END_SCRIPT

# *****************************************************************************

bash ${RUNNER} R1 "CONSTRUCT PROVONE PROGRAMS" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'

    {{{
        {{ include "../common/sdth.g" }}
    }}}
                                                                                        \\
    {{ range $T := (sdth_construct_provone_program_triples | rows) }}                   \\
        {{ ntriple_print $T }}
    {{ end }}                                                                           \
                                                                                        \\
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__

# *****************************************************************************

bash ${RUNNER} R2 "CONSTRUCT PROVONE HASSUBPROGRAM TRIPLES" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'

    {{{
        {{ include "../common/sdth.g" }}
    }}}
                                                                                        \\
    {{ range $Program := select_sdth_program | vector }}                                \\
        {{ range $Step := (select_sdth_program_steps $Program | vector) }}              \\
            {{uri $Program}} provone:hasSubProgram {{uri $Step}} .
        {{ end }}
    {{ end }}
                                                                                        \\
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__

# *****************************************************************************

bash ${RUNNER} R3 "CONSTRUCT DATAFRAME PORTS" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'

    {{{
        {{ include "../common/sdth.g" }}
    }}}
                                                                                                                            \\
    {{ range $DataframeProducer := (select_dataframe_producers | rows) }}                                                   \\
        {{ with $StepName := (index $DataframeProducer 0) }}                                                                \\
            {{uri $StepName}} provone:hasOutputPort <{{ $StepName }}/dataframeport/{{ index $DataframeProducer 2 }}_out> .
        {{ end }}                                                                                                           \\
    {{ end }}                                                                                                               \\

    {{ range $DataframeConsumer := (select_dataframe_consumers | rows) }}                                                   \\
        {{ with $StepName := (index $DataframeConsumer 0) }}                                                                \\
            {{uri $StepName }} provone:hasInputPort <{{ $StepName }}/dataframeport/{{ index $DataframeConsumer 2 }}_in> .
        {{ end }}                                                                                                           \\
    {{ end }}                                                                                                               \\
                                                                                                                            \\
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__

# *****************************************************************************

bash ${RUNNER} R3 "CONSTRUCT VARIABLE PORTS" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'

    {{{
        {{ include "../common/sdth.g" }}
    }}}
                                                                        \\
    {{ range $VarProducer := (select_variable_producers | rows) }}      \\
        {{ with $StepName := (index $VarProducer 0) }}                  \\                   
        {{ with $VarId := (index $VarProducer 1) }}                     \\
        {{ with $VarName := (index $VarProducer 2) }}                   \\
        {{ with $PortId := (var_out_port_id $StepName $VarName) }}      \\
            {{uri $StepName}} provone:hasOutputPort {{uri $PortId}} .  
            {{uri $PortId }} sdth:hasVariable {{uri $VarId}} .
        {{ end }}                                                       \\
        {{ end }}                                                       \\
        {{ end }}                                                       \\
        {{ end }}                                                       \\
    {{ end }}                                                           \\

    {{ range $VarConsumer := (select_variable_consumers | rows) }}      \\
        {{ with $StepName := (index $VarConsumer 0) }}                  \\
        {{ with $VarId := (index $VarConsumer 1) }}                     \\
        {{ with $VarName := (index $VarConsumer 2) }}                   \\
        {{ with $PortId := (var_in_port_id $StepName $VarName) }}       \\
            {{uri $StepName}} provone:hasInputPort {{uri $PortId}} .  
            {{uri $PortId}} sdth:hasVariable {{uri $VarId}} .
        {{ end }}                                                       \\
        {{ end }}                                                       \\
        {{ end }}                                                       \\
        {{ end }}                                                       \\
    {{ end }}                                                           \\
                                                                        \\
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__

# *****************************************************************************

