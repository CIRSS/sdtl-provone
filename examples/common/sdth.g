

{{ prefix "sdtl"       "https://rdf-vocabulary.ddialliance.org/sdth#" }}
{{ prefix "prov"       "http://www.w3.org/ns/prov#" }}
{{ prefix "provone"    "http://purl.dataone.org/provone/2015/01/15/ontology#" }}
{{ prefix "rdf"        "http://www.w3.org/1999/02/22-rdf-syntax-ns#" }}
{{ prefix "rdfs"       "http://www.w3.org/2000/01/rdf-schema#" }}
{{ prefix "sdth"       "https://rdf-vocabulary.ddialliance.org/sdth#" }}

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

{{ query "select_sdth_program_steps" "ProgramID" '''
    SELECT ?step
    WHERE {
        <{{$ProgramID}}> sdth:hasProgramStep ?step .
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
