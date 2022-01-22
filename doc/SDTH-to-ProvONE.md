### Outline of a Geist progam for generating ProvONE triples from SDTH triples

1. Construct a triple using the `provone:hasSubProgram` predicate relating each sdth:ProgramStep to its containing
sdth:Program. Depend on ProvONE OWL rules automatically assign the type `provone:Program` to each `sdth:Program` and `sdth:ProgramStep` related by `provone:hasSubProgram`. 

2. Associate each program step that produces or consumes dataframes with output or input ports respectively ith the `provone:hasInPort` or `provone:hasOutPort` predicate.  Create new new identifiers for each input and output port and assignm them type `DataframePort` derived from `provone:Port` to distinguish them from ports representing the flow of variables (`sdth:VariablePort`, see 3 below).

3. For each step construct new `sdth:VariablePort` identifiers similarly for each variable in an input or output dataframe that is used or assigned by a program step respectively.

4. Create identifiers for each matching input-output port pair, with type `sdth:DataframeChannel` for channels that carry dataframes and type `sdth:VariableChannel` for channels that carry variables, where both types of channels are derived from `provone:Channel`. Assign the property `provone:connectsTo` to input and output ports to associate them with channels.

5. Assign properties `sdth:hasDataframe` or `sdth:hasVariable` to each port and channel to maintain connection to the corresponding SDTH entities.


