#!/usr/bin/env bash

# *****************************************************************************

run_cell SETUP-1 "CREATE NEW DATASET AND LOAD RULES" << END_CELL

geist destroy --dataset kb --quiet
geist create --dataset kb --quiet --infer owl
geist import --file ../data/provone-rules.ttl
geist import --format jsonld --file ../data/compute-sdth.jsonld

END_CELL

# *****************************************************************************

run_cell E2 "EXPORT LOADED SDTL AND RULES AS N-TRIPLES" << END_CELL

geist export --format nt --sort

END_CELL

# *****************************************************************************

run_cell R1 "CONSTRUCT PROVONE PROGRAMS" << '__END_CELL__'

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

__END_CELL__

# *****************************************************************************

run_cell R2 "CONSTRUCT HASSUBPROGRAM TRIPLES" << '__END_CELL__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_subprogram_triples }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__

# *****************************************************************************

run_cell R3 "CONSTRUCT DATAFRAME PORTS" << '__END_CELL__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_dataframe_out_ports }}
    {{ construct_dataframe_in_ports }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__

# *****************************************************************************

run_cell R4 "CONSTRUCT VARIABLE PORTS" << '__END_CELL__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_variable_out_ports }}
    {{ construct_variable_in_ports }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__

# *****************************************************************************

run_cell R5 "CONSTRUCT DATAFRAME CHANNELS" << '__END_CELL__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_dataframe_channels }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__


# *****************************************************************************

run_cell R6 "CONSTRUCT VARIABLE CHANNELS" << '__END_CELL__'

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_variable_channels }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__


# *****************************************************************************

run_cell R7 "CONSTRUCT ALL PROVONE TRIPLES" << '__END_CELL__'

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

__END_CELL__

# *****************************************************************************

run_cell LOAD-3 "LOAD PROVONE TRIPLES" << '__END_CELL__'

geist import --file outputs/augment.ttl

__END_CELL__

# *****************************************************************************

run_cell E3  "EXPORT UPDATED DATASET AS N-TRIPLES" << END_CELL

geist export --format nt --sort

END_CELL

# *****************************************************************************

run_dot_cell GRAPH-1 "DATAFRAME FLOW THROUGH PROVONE PROGRAMS" \
    << '__END_CELL__'

geist report << '__END_REPORT_TEMPLATE__'

    {{{
        {{ include "../common/graphviz.g" }}
        {{ include "../common/sdtl.g" }}
        {{ include "../common/sdth.g" }}
    }}}

    {{ gv_graph "provone_workflow" }}

    {{ gv_title "Dataframe Flow Through ProvONE Programs" }}

    {{ gv_cluster "program_graph" }}

    # program nodes
    {{ sdtl_program_node_style }}
    node[width=8]
    {{ with $WorkflowId := select_provone_workflow | value }}                               \\

        {{ range $Program := (select_provone_programs $WorkflowId | rows ) }}               \\
            {{ with $ProgramId := (index $Program 0) }}                                     \\
            {{ with $SourceCode := (select_program_sourcecode $ProgramId | value ) }}       \\
                {{ gv_labeled_node $ProgramId $SourceCode }}
            {{ end }}                                                                       \\
            {{ end }}                                                                       \\
        {{ end }}                                                                           \\

        # dataframe channels
        {{ range $Channel := (select_provone_dataframe_channels $WorkflowId | rows) }}      \\
            {{ gv_labeled_edge (index $Channel 0) (index $Channel 1) (index $Channel 2) }}
        {{ end }}                                                                           \\
                                                                                            \\
    {{ end }}                                                                               \\
                                                                                            \\
    {{ gv_cluster_end }}

    {{ gv_end }}                                                                            \\

__END_REPORT_TEMPLATE__

__END_CELL__


# *****************************************************************************

run_dot_cell GRAPH-2 "VARIABLE FLOW THROUGH PROVONE PROGRAMS" \
    << '__END_CELL__'

geist report << '__END_REPORT_TEMPLATE__'

    {{{
        {{ include "../common/graphviz.g" }}
        {{ include "../common/sdtl.g" }}
        {{ include "../common/sdth.g" }}
    }}}

    {{ gv_graph "provone_workflow" }}

    {{ gv_title "Variable Flow Through ProvONE Programs" }}

    {{ gv_cluster "program_graph" }}

    # program nodes
    {{ sdtl_program_node_style }}
    node[width=8]
    {{ with $WorkflowId := select_provone_workflow | value }}                               \\

        {{ range $Program := (select_provone_programs $WorkflowId | rows ) }}               \\
            {{ with $ProgramId := (index $Program 0) }}                                     \\
            {{ with $SourceCode := (select_program_sourcecode $ProgramId | value ) }}       \\
                {{ gv_labeled_node $ProgramId $SourceCode }}
            {{ end }}                                                                       \\
            {{ end }}                                                                       \\
        {{ end }}                                                                           \\

        # dataframe channels
        {{ range $Channel := (select_provone_variable_channels $WorkflowId | rows) }}       \\
            {{ gv_labeled_edge (index $Channel 0) (index $Channel 1) (index $Channel 2) }}
        {{ end }}                                                                           \\
                                                                                            \\
    {{ end }}                                                                               \\
                                                                                            \\
    {{ gv_cluster_end }}

    {{ gv_end }}                                                                            \\

__END_REPORT_TEMPLATE__

__END_CELL__

