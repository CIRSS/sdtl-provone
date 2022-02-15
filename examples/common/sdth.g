

{{ prefix "dcterms"    "http://purl.org/dc/terms/" }}
{{ prefix "prov"       "http://www.w3.org/ns/prov#" }}
{{ prefix "provone"    "http://purl.dataone.org/provone/2015/01/15/ontology#" }}
{{ prefix "rdf"        "http://www.w3.org/1999/02/22-rdf-syntax-ns#" }}
{{ prefix "rdfs"       "http://www.w3.org/2000/01/rdf-schema#" }}
{{ prefix "sdth"       "http://c2metadata.org/sdth#" }}

{{ macro "uri" "URI" '''
        <{{ $URI }}>
    '''
}}

{{ macro "ntriple_print" "Triple" '''
    {{index $Triple 0 | uri}} {{index $Triple 1 | uri}} {{index $Triple 2 | uri}} .
    '''
}}

# Expands to the id of the output port associated with a given step and variable.
{{ macro "var_out_port_id" "StepId" "VariableName" '''
    {{ $StepId }}/variableport/{{ $VariableName }}_out
    '''
}}

# Expands to the id of the input port associated with a given step and variable.
{{ macro "var_in_port_id" "StepId" "VariableName" '''
    {{ $StepId }}/variableport/{{ $VariableName }}_in
    '''
}}

# Expands to the id of the output port associated with a given step and dataframe.
{{ macro "dataframe_out_port_id" "StepId" "DataframeName" '''
    {{ $StepId }}/dataframeport/{{ $DataframeName }}_out
    '''
}}

# Expands to the id of the input port associated with a given step and dataframe.
{{ macro "dataframe_in_port_id" "StepId" "DataframeName" '''
    {{ $StepId }}/dataframeport/{{ $DataframeName }}_in
    '''
}}

# Expands to the id of the dataframe channel in the given workflow with the given index.
# NOTE: Both arguments to this macro must be strings, i.e. ChannelIndex cannot be an integer.
{{ macro "dataframe_channel_id" "WorkflowId" "ChannelIndex" '''
    {{ $WorkflowId }}/dataframechannel/{{ $ChannelIndex }}
    '''
}}

# Expands to the id of the dataframe channel in the given workflow with the given index.
# NOTE: Both arguments to this macro must be strings, i.e. ChannelIndex cannot be an integer.
{{ macro "variable_channel_id" "WorkflowId" "ChannelIndex" '''
    {{ $WorkflowId }}/variablechannel/{{ $ChannelIndex }}
    '''
}}


{{ query "sdth_construct_provone_program_triples" '''
    CONSTRUCT {
        ?program rdf:type provone:Program .
    }
    WHERE {
        {
            ?program rdf:type sdth:Program .
        }
        UNION
        {
            ?program rdf:type sdth:ProgramStep .
        }
    } ORDER BY ?program
'''}}

{{ query "select_sdth_program" '''
    SELECT ?program
    WHERE {
        ?program rdf:type sdth:Program .
    }
'''}}

{{ query "select_provone_workflow" '''
    SELECT ?program
    WHERE {
        ?program rdf:type provone:Workflow .
    }
'''}}

{{ query "select_program_steps" '''
    SELECT ?program ?step
    WHERE {
        ?program sdth:hasProgramStep ?step .
    }
'''}}

{{ query "select_program_sourcecode" "ProgramId" '''
    SELECT ?sourcecode
    WHERE {
        <{{$ProgramId}}> sdth:hasSourceCode ?sourcecode .
    }
'''}}

{{ query "select_provone_programs" "WorkflowId" '''
    SELECT ?program ?name
    WHERE {
        <{{$WorkflowId}}> provone:hasSubProgram ?program .
        ?program dcterms:identifier ?name .
    }
'''}}

{{ query "select_provone_dataframe_channels" "WorkflowId" '''
    SELECT ?source_program_id ?sink_program_id ?source_port_name
    WHERE {
        <{{$WorkflowId}}> provone:hasSubProgram ?source_program_id .
        ?source_program_id provone:hasOutPort ?source_port_id .
        ?source_port_id sdth:hasDataframe ?dataframe_id .
        ?source_port_id provone:connectsTo ?channel_id .
        ?sink_port_id provone:connectsTo ?channel_id .
        ?sink_program_id provone:hasInPort ?sink_port_id .
        ?dataframe_id dcterms:identifier ?source_port_name .
    }
'''}}

{{ query "select_provone_variable_channels" "WorkflowId" '''
    SELECT ?source_program_id ?sink_program_id ?source_port_name
    WHERE {
        <{{$WorkflowId}}> provone:hasSubProgram ?source_program_id .
        ?source_program_id provone:hasOutPort ?source_port_id .
        ?source_port_id sdth:hasVariable ?variable_id .
        ?source_port_id provone:connectsTo ?channel_id .
        ?sink_port_id provone:connectsTo ?channel_id .
        ?sink_program_id provone:hasInPort ?sink_port_id .
        ?variable_id dcterms:identifier ?source_port_name .
    }
'''}}

{{ query "select_dataframe_producers" '''
    SELECT ?step_id ?dataframe_id ?dataframe_name
    WHERE {
        ?step_id sdth:producesDataframe ?dataframe_id .
        ?dataframe_id sdth:hasName ?dataframe_name .
    }
'''}}

{{ query "select_dataframe_consumers" '''
    SELECT ?step_id ?dataframe_id ?dataframe_name
    WHERE {
        ?step_id sdth:consumesDataframe ?dataframe_id .
        ?dataframe_id sdth:hasName ?dataframe_name .
    }
'''}}

{{ query "select_variable_producers" '''
    SELECT ?step_id ?variable_id ?variable_name
    WHERE {
        ?step_id sdth:assignsVariable ?variable_id .
        ?variable_id sdth:hasName ?variable_name .
    }
'''}}

{{ query "select_variable_consumers" '''
    SELECT ?step_id ?variable_id ?variable_name
    WHERE {
        ?step_id sdth:usesVariable ?variable_id .
        ?variable_id sdth:hasName ?variable_name .
    }
'''}}

{{ query "select_dataframe_channels" '''
    SELECT ?workflow_id ?dataframe_name ?producer_step_id ?consumer_step_id
    WHERE {
        ?workflow_id sdth:hasProgramStep ?producer_step_id .
        ?producer_step_id sdth:producesDataframe ?dataframe_id .
        ?consumer_step_id sdth:consumesDataframe ?dataframe_id .
        ?dataframe_id sdth:hasName ?dataframe_name .
    }
'''}}

{{ query "select_variable_channels" '''
    SELECT ?workflow_id ?variable_name ?producer_step_id ?consumer_step_id
    WHERE {
        ?workflow_id sdth:hasProgramStep ?producer_step_id .
        ?producer_step_id sdth:assignsVariable ?variable_id .
        ?consumer_step_id sdth:usesVariable ?variable_id .
        ?variable_id sdth:hasName ?variable_name .
    }
'''}}

{{ macro "construct_dataframe_out_ports" '''
    {{ range $DataframeProducer := (select_dataframe_producers | rows) }}
        {{ with $StepId := (index $DataframeProducer 0) }}
        {{ with $DataframeId := (index $DataframeProducer 1) }}
        {{ with $DataframeName := (index $DataframeProducer 2) }}
        {{ with $PortId := (dataframe_out_port_id $StepId $DataframeName) }}
            {{uri $StepId}} provone:hasOutPort {{uri $PortId}} .
            {{uri $PortId }} sdth:hasDataframe {{uri $DataframeId}} .
        {{ end }}
        {{ end }}
        {{ end }}
        {{ end }}
    {{ end }}
    '''
}}

{{ macro "construct_dataframe_in_ports" '''
    {{ range $DataframeConsumer := (select_dataframe_consumers | rows) }}
        {{ with $StepId := (index $DataframeConsumer 0) }}
        {{ with $DataframeId := (index $DataframeConsumer 1) }}
        {{ with $DataframeName := (index $DataframeConsumer 2) }}
        {{ with $PortId := (dataframe_in_port_id $StepId $DataframeName) }}
            {{uri $StepId }} provone:hasInPort {{uri $PortId}} .
            {{uri $PortId }} sdth:hasDataframe {{uri $DataframeId}} .
        {{ end }}
        {{ end }}
        {{ end }}
        {{ end }}
    {{ end }}
    '''
}}

{{ macro "construct_variable_out_ports" '''
    {{ range $VarProducer := (select_variable_producers | rows) }}  \\
        {{ with $StepId := (index $VarProducer 0) }}                \\
        {{ with $VarId := (index $VarProducer 1) }}                 \\
        {{ with $VarName := (index $VarProducer 2) }}               \\
        {{ with $PortId := (var_out_port_id $StepId $VarName) }}
            {{uri $StepId}} provone:hasOutPort {{uri $PortId}} .
            {{uri $PortId }} sdth:hasVariable {{uri $VarId}} .
        {{ end }}                                                   \\
        {{ end }}                                                   \\
        {{ end }}                                                   \\
        {{ end }}                                                   \\
    {{ end }}                                                       \\
    '''
}}

{{ macro "construct_variable_in_ports" '''
    {{ range $VarConsumer := (select_variable_consumers | rows) }}  \\
        {{ with $StepId := (index $VarConsumer 0) }}                \\
        {{ with $VarId := (index $VarConsumer 1) }}                 \\
        {{ with $VarName := (index $VarConsumer 2) }}               \\
        {{ with $PortId := (var_in_port_id $StepId $VarName) }}     \\
            {{uri $StepId}} provone:hasInPort {{uri $PortId}} .
            {{uri $PortId}} sdth:hasVariable {{uri $VarId}} .
        {{ end }}                                                   \\
        {{ end }}                                                   \\
        {{ end }}                                                   \\
        {{ end }}                                                   \\
    {{ end }}                                                       \\
    '''
}}

{{ macro "construct_dataframe_channels" '''
    {{ range $ChannelIndex, $DataframeChannel := (select_dataframe_channels | rows) }}          \\
        {{ with $WorkflowId := (index $DataframeChannel 0) }}                                   \\
        {{ with $DataframeName := (index $DataframeChannel 1) }}                                \\
        {{ with $OutStepId := (index $DataframeChannel 2) }}                                    \\
        {{ with $InStepId := (index $DataframeChannel 3) }}                                     \\
        {{ with $ChannelId := (dataframe_channel_id $OutStepId (printf "%d" $ChannelIndex)) }}  \\
        {{ with $OutPortId := (dataframe_out_port_id $OutStepId $DataframeName) }}              \\
        {{ with $InPortId := (dataframe_in_port_id $InStepId $DataframeName) }}                 \\
            {{uri $OutPortId}} provone:connectsTo {{uri $ChannelId}} .
            {{uri $InPortId}} provone:connectsTo {{uri $ChannelId}} .
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
    {{ end }}                                                                                   \\
    '''
}}

{{ macro "construct_variable_channels" '''
    {{ range $ChannelIndex, $VariableChannel := (select_variable_channels | rows) }}            \\
        {{ with $WorkflowId := (index $VariableChannel 0) }}                                    \\
        {{ with $VariableName := (index $VariableChannel 1) }}                                  \\
        {{ with $OutStepId := (index $VariableChannel 2) }}                                     \\
        {{ with $InStepId := (index $VariableChannel 3) }}                                      \\
        {{ with $ChannelId := (variable_channel_id $OutStepId (printf "%d" $ChannelIndex)) }}   \\
        {{ with $OutPortId := (var_out_port_id $OutStepId $VariableName) }}                     \\
        {{ with $InPortId := (var_in_port_id $InStepId $VariableName) }}                        \\
            {{uri $OutPortId}} provone:connectsTo {{uri $ChannelId}} .
            {{uri $InPortId}} provone:connectsTo {{uri $ChannelId}} .
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
    {{ end }}                                                                                   \\
    '''
}}

{{ macro "construct_subprogram_triples" '''
    {{ range $ProgramStep := (select_program_steps | rows) }}                                   \\
        {{ with $ProgramId := (index $ProgramStep 0) }}                                         \\
        {{ with $StepId := (index $ProgramStep 1) }}                                            \\
            {{uri $ProgramId}} provone:hasSubProgram {{uri $StepId}} .
        {{ end }}                                                                               \\
        {{ end }}                                                                               \\
    {{ end }}                                                                                   \\
    '''
}}



