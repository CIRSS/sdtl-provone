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
            <{{$Program}}> provone:hasSubProgram <{{$Step}}> .
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
            <{{ $StepName }}> provone:hasOutputPort <{{ $StepName }}/dataframeport/{{ index $DataframeProducer 2 }}_out> .
        {{ end }}                                                                                                           \\
    {{ end }}                                                                                                               \\

    {{ range $DataframeConsumer := (select_dataframe_consumers | rows) }}                                                   \\
        {{ with $StepName := (index $DataframeConsumer 0) }}                                                                \\
            <{{ $StepName }}> provone:hasInputPort <{{ $StepName }}/dataframeport/{{ index $DataframeConsumer 2 }}_in> .
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
    {{ range $VariableProducer := (select_variable_producers | rows) }}                                                     \\
        {{ with $StepName := (index $VariableProducer 0) }}                                                                 \\                   
        {{ with $VariableId := (index $VariableProducer 1) }}                                                               \\
        {{ with $VariableName := (index $VariableProducer 2) }}                                                             \\
        {{ with $VariablePortId := (printf "%s/variableport/%s_out" $StepName $VariableName ) }}                            \\
            <{{ $StepName }}> provone:hasOutputPort <{{ $VariablePortId }}> .  
            <{{ $VariablePortId }}> sdth:hasVariable <{{ $VariableId }}> .
        {{ end }}                                                                                                           \\
        {{ end }}                                                                                                           \\
        {{ end }}                                                                                                           \\
        {{ end }}                                                                                                           \\
    {{ end }}                                                                                                               \\

    {{ range $VariableConsumer := (select_variable_consumers | rows) }}                                                     \\
        {{ with $StepName := (index $VariableConsumer 0) }}                                                                 \\
        {{ with $VariableId := (index $VariableConsumer 1) }}                                                               \\
        {{ with $VariableName := (index $VariableConsumer 2) }}                                                             \\
        {{ with $VariablePortId := (printf "%s/variableport/%s_in" $StepName $VariableName ) }}                             \\
            <{{ $StepName }}> provone:hasInputPort <{{ $VariablePortId }}> .  
            <{{ $VariablePortId }}> sdth:hasVariable <{{ $VariableId }}> .
        {{ end }}                                                                                                           \\
        {{ end }}                                                                                                           \\
        {{ end }}                                                                                                           \\
        {{ end }}                                                                                                           \\
    {{ end }}                                                                                                               \\
                                                                                                                            \\
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__

# *****************************************************************************

