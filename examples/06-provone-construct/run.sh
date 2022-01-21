#!/usr/bin/env bash

RUNNER='../common/run_script_example.sh'
GRAPHER='../common/run_dot_examples.sh'

# *****************************************************************************

bash ${RUNNER} SETUP-1 "CREATE NEW DATASET AND LOAD RULES" << END_SCRIPT

geist destroy --dataset kb --quiet
geist create --dataset kb --quiet --infer owl
geist import --file ../data/provone-rules.ttl
geist import --format jsonld --file ../data/compute-sdth.jsonld

END_SCRIPT

# *****************************************************************************

bash ${RUNNER} E2 "EXPORT LOADED SDTL AND RULES AS N-TRIPLES" << END_SCRIPT

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

bash ${RUNNER} R2 "CONSTRUCT HASSUBPROGRAM TRIPLES" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_subprogram_triples }}
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__

# *****************************************************************************

bash ${RUNNER} R3 "CONSTRUCT DATAFRAME PORTS" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_dataframe_out_ports }}
    {{ construct_dataframe_in_ports }}
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__

# *****************************************************************************

bash ${RUNNER} R4 "CONSTRUCT VARIABLE PORTS" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_variable_out_ports }}
    {{ construct_variable_in_ports }}
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__

# *****************************************************************************

bash ${RUNNER} R5 "CONSTRUCT DATAFRAME CHANNELS" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}
 
    {{ construct_dataframe_channels }}
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__


# *****************************************************************************

bash ${RUNNER} R6 "CONSTRUCT VARIABLE CHANNELS" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}
 
    {{ construct_variable_channels }}
__END_REPORT_TEMPLATE__
) | sort

__END_SCRIPT__


# *****************************************************************************

bash ${RUNNER} R7 "CONSTRUCT ALL PROVONE TRIPLES" << '__END_SCRIPT__'

cp ../data/prefixes.ttl outputs/augment.ttl

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}
 
    {{ construct_subprogram_triples }}
    {{ construct_dataframe_out_ports }}
    {{ construct_dataframe_in_ports }}
    {{ construct_variable_out_ports }}
    {{ construct_variable_in_ports }}
    {{ construct_dataframe_channels }}
    {{ construct_variable_channels }}
__END_REPORT_TEMPLATE__
) | sort >> outputs/augment.ttl

cat outputs/augment.ttl

__END_SCRIPT__

# *****************************************************************************

bash ${RUNNER} LOAD-3 "LOAD PROVONE TRIPLES" << '__END_SCRIPT__'

geist import --file outputs/augment.ttl

__END_SCRIPT__

