

{{ prefix "sdtl"       "https://rdf-vocabulary.ddialliance.org/sdth#" }}
{{ prefix "prov"       "http://www.w3.org/ns/prov#" }}
{{ prefix "provone"    "http://purl.dataone.org/provone/2015/01/15/ontology#" }}
{{ prefix "rdf"        "http://www.w3.org/1999/02/22-rdf-syntax-ns#" }}
{{ prefix "rdfs"       "http://www.w3.org/2000/01/rdf-schema#" }}
{{ prefix "sdth"       "https://rdf-vocabulary.ddialliance.org/sdth#" }}


{{ macro "uri" "URI" '''
        {{ printf "<%s>" $URI }}
    '''
}}

{{ macro "ntriple_print" "Triple" '''
    {{index $Triple 0 | uri}} {{index $Triple 1 | uri}} {{index $Triple 2 | uri}} .
    ''' 
}}

{{ macro "var_out_port_id" "StepName" "VariableName" '''
    {{ printf "%s/variableport/%s_out" $StepName $VariableName }}
    '''
}}

{{ macro "var_in_port_id" "StepName" "VariableName" '''
    {{ printf "%s/variableport/%s_in" $StepName $VariableName }}
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
    SELECT ?program_id ?dataframe_id ?dataframe_name 
    WHERE {
        ?program_id sdth:producesDataframe ?dataframe_id .
        ?dataframe_id sdth:hasName ?dataframe_name .
    }
'''}}

{{ query "select_dataframe_consumers" '''
    SELECT ?program_id ?dataframe_id ?dataframe_name 
    WHERE {
        ?program_id sdth:consumesDataframe ?dataframe_id .
        ?dataframe_id sdth:hasName ?dataframe_name .
    }
'''}}

{{ query "select_variable_producers" '''
    SELECT ?program_id ?variable_id ?variable_name 
    WHERE {
        ?program_id sdth:assignsVariable ?variable_id .
        ?variable_id sdth:hasName ?variable_name .
    }
'''}}

{{ query "select_variable_consumers" '''
    SELECT ?program_id ?variable_id ?variable_name 
    WHERE {
        ?program_id sdth:usesVariable ?variable_id .
        ?variable_id sdth:hasName ?variable_name .
    }
'''}}
