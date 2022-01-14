### Outline of a Geist progam for generating ProvONE triples from SDTH triples

1. Assign the type `provone:Program` to each `sdth:Program` and `sdth:ProgramStep`. 
(There is no need to create new identifiers because subjects/objects can have any number of types.)

2. For each program step that produces or consumes dataframes create new identifiers for output and input ports respectively, assign to them a new type derived from `provone:Port`, `DataframePort`,  to distinguish them from ports representing the flow of variables (`VariablePort`, see 3 below), and construct a new triple for each port with the `provone:hasInputPort` or `provone:hasOuputPort` predicate. 

3. Construct new `VariablePort` identifiers similarly for each variable in an input or output dataframe for each step.

4. Create identifiers for each matching input-output port pair, with type `DataframeChannel` for channels that carry dataframes and type `VariableChannel` for channels that carry variables, where both types of channels are derived from `provone:Channel`.

5. Assign properties `hasDataframe` or `hasVariable` to each port and channel to maintain connection to the corresponding SDTH entities.

### Notes

- We weed an RDF namespace for the subtypes of the provone classes and properties.
