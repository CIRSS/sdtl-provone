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

bash ${RUNNER} R2 "CONSTRUCT HASSUBPROGRAM TRIPLES" << '__END_SCRIPT__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ has_subprogram_triples }}
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
