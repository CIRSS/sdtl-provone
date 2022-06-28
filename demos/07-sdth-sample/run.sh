#!/usr/bin/env bash

# *****************************************************************************

bash_cell SETUP-1 << END_CELL

# CREATE NEW DATASET AND LOAD RULES

geist destroy --dataset kb --quiet
geist create --dataset kb --quiet --infer owl
geist import --file ../data/provone-rules.ttl
geist import --format ttl --file ../samples/compute_simple/sdth_output.ttl

END_CELL

# *****************************************************************************

bash_cell E2 << END_CELL

# EXPORT LOADED SDTL AND RULES AS N-TRIPLES

geist export --format nt --sort

END_CELL

# *****************************************************************************

bash_cell R1 << '__END_CELL__'

# CONSTRUCT PROVONE PROGRAMS

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

bash_cell R2 << '__END_CELL__'

# CONSTRUCT HASSUBPROGRAM TRIPLES

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_subprogram_triples }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__

# *****************************************************************************

bash_cell R3 << '__END_CELL__'

# CONSTRUCT DATAFRAME PORTS

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_dataframe_out_ports }}
    {{ construct_dataframe_in_ports }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__

# *****************************************************************************

bash_cell R4 << '__END_CELL__'

# CONSTRUCT VARIABLE PORTS

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_variable_out_ports }}
    {{ construct_variable_in_ports }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__

# *****************************************************************************

bash_cell R5 << '__END_CELL__'

# CONSTRUCT DATAFRAME CHANNELS

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_dataframe_channels }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__


# *****************************************************************************

bash_cell R6 << '__END_CELL__'

# CONSTRUCT VARIABLE CHANNELS

(
geist report << '__END_REPORT_TEMPLATE__'
    {{{ {{ include "../common/sdth.g" }} }}}

    {{ construct_variable_channels }}
__END_REPORT_TEMPLATE__
) | sort

__END_CELL__


# *****************************************************************************

bash_cell R7 << '__END_CELL__'

# CONSTRUCT ALL PROVONE TRIPLES

cp ../data/prefixes.ttl products/augment.ttl

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
) | sort >> products/augment.ttl

cat products/augment.ttl

__END_CELL__

# *****************************************************************************

bash_cell LOAD-3 << '__END_CELL__'

# LOAD PROVONE TRIPLES

geist import --file products/augment.ttl

__END_CELL__

# *****************************************************************************

bash_cell E3 << END_CELL

# EXPORT UPDATED DATASET AS N-TRIPLES

geist export --format nt --sort

END_CELL

# *****************************************************************************

bash_dot_cell GRAPH-1 << '__END_CELL__'

# DATAFRAME FLOW THROUGH PROVONE PROGRAMS

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

bash_dot_cell GRAPH-2 << '__END_CELL__'

# VARIABLE FLOW THROUGH PROVONE PROGRAMS

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

